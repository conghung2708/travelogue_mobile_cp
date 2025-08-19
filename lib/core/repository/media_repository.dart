// core/repository/media_repository.dart
import 'dart:io' show File;
import 'package:dio/dio.dart' as diox;
import 'package:travelogue_mobile/core/constants/endpoints.dart';
import 'package:travelogue_mobile/core/repository/base_repository.dart';

class MediaRepository {
  final BaseRepository _base = BaseRepository();

  /// Upload nhiều chứng chỉ: field name bắt buộc = `certifications`
  Future<List<String>> uploadMultipleCertifications(List<File> files) async {
    if (files.isEmpty) {
      print('[❌] Danh sách files rỗng');
      throw ArgumentError('Danh sách files rỗng');
    }

    print('[📤] Upload ${files.length} chứng chỉ → ${Endpoints.uploadMultipleCertifications} (field="certifications")');

    final form = diox.FormData();

    // Lặp với cùng key 'certifications' cho mỗi file (array multipart)
    for (final f in files) {
      final filename = f.path.split('/').last;
      form.files.add(MapEntry(
        'certifications',
        await diox.MultipartFile.fromFile(
          f.path,
          filename: filename,
        ),
      ));
    }

    print('[ℹ️] FormData files count: ${form.files.length} (key="certifications")');

    final res = await _base.postFormData(
      Endpoints.uploadMultipleCertifications,
      form,
    );

    print('[📥] Status: ${res.statusCode}');
    print('[📥] Data: ${res.data}');

    // Hỗ trợ cả data/Data; message/message viết hoa thường
    final root = res.data;
    final data = (root is Map) ? (root['data'] ?? root['Data']) : null;

    if (res.statusCode == 200 && data != null) {
      return _extractUrls(data);
    }

    throw Exception('Upload thất bại: ${res.statusCode} ${res.data}');
  }

  List<String> _extractUrls(dynamic data) {
    // Swagger trả: { "data": [ "http://...pdf", ... ] }
    if (data is List) {
      final urls = <String>[];
      for (final item in data) {
        if (item is String) {
          urls.add(item);
        } else if (item is Map) {
          final u = (item['url'] ?? item['URL'] ?? item['path'] ?? item['location'])?.toString();
          if (u != null) urls.add(u);
        }
      }
      print('[✅] Upload thành công: ${urls.length} URL');
      return urls;
    }

    // Trường hợp khác (ít gặp): { urls: [...] }
    if (data is Map && data['urls'] is List) {
      final urls = (data['urls'] as List).map((e) => e.toString()).toList();
      print('[✅] Upload thành công: ${urls.length} URL');
      return urls;
    }

    print('[⚠️] Định dạng data không khớp kỳ vọng: $data');
    return const <String>[];
  }
}
