import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:characters/characters.dart';

import 'package:travelogue_mobile/core/repository/home_repository.dart';
import 'package:travelogue_mobile/model/chatbot/location_dto.dart';
import 'package:travelogue_mobile/model/location_model.dart';
import 'package:travelogue_mobile/model/chatbot/location_mapper.dart';

class ChatbotService {
  final HomeRepository homeRepository;
  final String openAiApiKey;

  List<LocationDto> _cache = [];
  bool _loaded = false;

  ChatbotService({
    required this.homeRepository,
    required this.openAiApiKey,
  });

  Future<void> _ensureLoaded() async {
    if (_loaded) return;
    final list = await homeRepository.getAllLocation();
    print('📡 Loaded ${list.length} locations từ BE');
    _cache = list.map((LocationModel m) => m.toDto()).toList();
    _loaded = true;
  }

  String _strip(String input) {
    const Map<String, String> map = {
      'à':'a','á':'a','ả':'a','ã':'a','ạ':'a','ă':'a','ắ':'a','ằ':'a','ẳ':'a','ẵ':'a','ặ':'a',
      'â':'a','ấ':'a','ầ':'a','ẩ':'a','ẫ':'a','ậ':'a','đ':'d',
      'è':'e','é':'e','ẻ':'e','ẽ':'e','ẹ':'e','ê':'e','ế':'e','ề':'e','ể':'e','ễ':'e','ệ':'e',
      'ì':'i','í':'i','ỉ':'i','ĩ':'i','ị':'i',
      'ò':'o','ó':'o','ỏ':'o','õ':'o','ọ':'o','ô':'o','ố':'o','ồ':'o','ổ':'o','ỗ':'o','ộ':'o',
      'ơ':'o','ớ':'o','ờ':'o','ở':'o','ỡ':'o','ợ':'o',
      'ù':'u','ú':'u','ủ':'u','ũ':'u','ụ':'u','ư':'u','ứ':'u','ừ':'u','ử':'u','ữ':'u','ự':'u',
      'ỳ':'y','ý':'y','ỷ':'y','ỹ':'y','ỵ':'y',
    };
    final lower = input.toLowerCase();
    final buf = StringBuffer();
    for (final ch in lower.characters) {
      buf.write(map[ch] ?? ch);
    }
    return buf.toString().replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  bool _containsAny(String normalized, Set<String> vocab) {
    for (final k in vocab) {
      if (normalized.contains(k)) return true;
    }
    return false;
  }

  // ---------- Guard: ngoài hệ thống ----------
  static const _banned = {
    // Thời tiết/khí hậu
    'thời tiết','nhiệt độ','mưa','nắng','bão','dự báo',
    // Tài chính
    'tỷ giá','giá vàng','bitcoin','chứng khoán','coin','crypto','cổ phiếu','lãi suất',
    // Tin tức/chính trị/xã hội
    'tin tức','chính trị','xã hội','chiến tranh','biểu tình',
    // Thể thao/giải trí
    'bóng đá','world cup','euro','tennis','esports','anime','phim','ca sĩ','idol','showbiz',
    // Giáo dục/y tế
    'điểm thi','thi đại học','bài tập','thuốc','bệnh',
    // Mua sắm
    'giảm giá','khuyến mãi','mua ở đâu','đặt hàng','ship','tiki','shopee','lazada',
  };

  static const _whitelist = {
    'địa điểm','điểm đến','tham quan','du lịch','tour','lộ trình','lịch trình',
    'giờ mở','giờ đóng','mở cửa','đóng cửa','địa chỉ','bản đồ','tọa độ',
    'giá vé','phí vào cổng','ăn gì','quán ăn','đặc sản','nhà hàng','khách sạn',
    'tây ninh','cao đài','bà đen','mộc bài','trảng bàng','tân biên','gò dầu',
  };

  bool _outOfDomain(String q, {required bool hasHits}) {
    // Nếu đã có hits từ dữ liệu → coi là trong hệ thống
    if (hasHits) return false;

    final s = _strip(q);
    final bannedAll = _banned.map((e) => _strip(e)).toSet();
    final whiteAll  = _whitelist.map((e) => _strip(e)).toSet();

    final bannedHit = _containsAny(s, bannedAll);
    final whiteHit  = _containsAny(s, whiteAll);

    if (bannedHit && !whiteHit) return true;

    // Không có dữ liệu phù hợp + không rõ intent → coi là ngoài hệ thống
    return true;
  }

  // ---------- Search nội bộ ----------
  List<LocationDto> _search(String q) {
    final nq = q.toLowerCase().trim();
    return _cache.where((x) {
      final hay = [
        x.name, x.description, x.address, x.category, x.districtName
      ].join(' ').toLowerCase();
      return hay.contains(nq);
    }).toList();
  }

  List<LocationDto> _onlyTayNinh() {
    return _cache.where((x) {
      final dn = x.districtName.toLowerCase();
      final ad = x.address.toLowerCase();
      return dn.contains('tây ninh') || ad.contains('tây ninh');
    }).toList();
  }

  // ---------- Prompt ----------
  static const _SYS = '''
Bạn là chatbot du lịch của Travelogue.
CHỈ trả lời dựa trên CONTEXT (dưới đây là dữ liệu từ hệ thống).
Nếu câu hỏi không liên quan hoặc thông tin không có trong CONTEXT,
trả nguyên văn: "Không nằm trong hệ thống." Không thêm gì khác.
Nếu người dùng xin "tất cả địa điểm", liệt kê gạch đầu dòng:
- Tên – Địa chỉ – (Giờ mở: HH:mm, Giờ đóng: HH:mm)
''';

  // ---------- Hỏi đáp ----------
  Future<String> ask(String question) async {
    await _ensureLoaded();

    final qLower = question.toLowerCase();
    final askAll = qLower.contains('tất cả') && qLower.contains('địa điểm');

    final hits = askAll ? _onlyTayNinh() : _search(question);
    final hasHits = hits.isNotEmpty;

    // Guard ngoài hệ thống + log nhánh return sớm
    if (_outOfDomain(question, hasHits: hasHits)) {
      print('⛔ Out-of-domain → không gọi OpenAI | Q="$question" | hasHits=$hasHits');
      return 'Không nằm trong hệ thống.';
    }
    if (!hasHits) {
      print('🔎 Không tìm thấy hits trong dữ liệu → không gọi OpenAI.');
      return 'Không nằm trong hệ thống.';
    }

    final ctx = hits.take(40).map((e) => e.forContext()).toList();

    final messages = [
      {"role": "system", "content": _SYS},
      {"role": "user", "content": "CONTEXT:\n${jsonEncode(ctx)}\n\nCÂU HỎI: $question"}
    ];

    // Gọi OpenAI (in log bằng print + preview body)
    try {
      print('➡️ Gọi OpenAI chat.completions…');
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $openAiApiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "gpt-4o-mini",
          "temperature": 0.2,
          "max_tokens": 700,
          "messages": messages
        }),
      );

      print('🔌 OpenAI status: ${res.statusCode}');
      final previewLen = min(500, res.body.length);
      print('📦 OpenAI body (preview $previewLen): ${res.body.substring(0, previewLen)}');

      // Fallback nếu API lỗi
      if (res.statusCode != 200) {
        if (askAll) {
          final lines = ctx.map((e) =>
            "- ${e['name']} – ${e['address']} (Giờ mở: ${e['openTime']}, đóng: ${e['closeTime']})");
          return lines.join('\n');
        }
        return 'Không nằm trong hệ thống.';
      }

      final data = jsonDecode(res.body);
      final content = (data['choices']?[0]?['message']?['content'] ?? '').toString().trim();

      if (content.isEmpty || content.toLowerCase().contains('không nằm trong hệ thống')) {
        if (askAll) {
          final lines = ctx.map((e) =>
            "- ${e['name']} – ${e['address']} (Giờ mở: ${e['openTime']}, đóng: ${e['closeTime']})");
          return lines.join('\n');
        }
        return 'Không nằm trong hệ thống.';
      }
      return content;
    } catch (e) {
      print('❌ Lỗi khi gọi OpenAI: $e');
      if (askAll) {
        final lines = ctx.map((e) =>
          "- ${e['name']} – ${e['address']} (Giờ mở: ${e['openTime']}, đóng: ${e['closeTime']})");
        return lines.join('\n');
      }
      return 'Không nằm trong hệ thống.';
    }
  }
}
