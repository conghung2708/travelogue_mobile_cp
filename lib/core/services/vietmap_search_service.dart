
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:travelogue_mobile/core/config/app_env.dart';



class VietmapSearchService {

  static const double _tnLat = 11.312; 
  static const double _tnLon = 106.098;

  static const double _minLat = 10.90;
  static const double _maxLat = 11.70;
  static const double _minLon = 105.95;
  static const double _maxLon = 106.85;

  static Future<List<String>> autocompleteTayNinh(String rawQuery) async {
    final q = _prepareQuery(rawQuery);
    if (!_looksSearchable(q) || AppEnv.vietmapKey.isEmpty) return [];

    final r1 = await http.get(_urlV11(q), headers: {'Accept': 'application/json'});
    var list = _parseAndFilterTayNinh(r1, tag: 'v1.1+bounded');
    if (list.isNotEmpty) return list;
    final r2 = await http.get(_urlV3(q), headers: {'Accept': 'application/json'});
    list = _parseAndFilterTayNinh(r2, tag: 'v3+bounded');
    return list;
  }

  static Uri _urlV11(String query) {
    final params = <String, String>{
      'api-version': '1.1',
      'apikey': AppEnv.vietmapKey,
      'text': query,
      'layers': 'address,street,venue,locality',
      'focus.point.lat': '$_tnLat',
      'focus.point.lon': '$_tnLon',
      'boundary.circle.lat': '$_tnLat',
      'boundary.circle.lon': '$_tnLon',
      'boundary.circle.radius': '45', 
      'boundary.rect.min_lat': '$_minLat',
      'boundary.rect.max_lat': '$_maxLat',
      'boundary.rect.min_lon': '$_minLon',
      'boundary.rect.max_lon': '$_maxLon',
    };

    final sb = StringBuffer('https://maps.vietmap.vn/api/autocomplete?');
    sb.writeAll(
      params.entries.map((e) =>
          '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}'),
      '&',
    );
    return Uri.parse(sb.toString());
  }

  static Uri _urlV3(String query) {
    final params = <String, String>{
      'apikey': AppEnv.vietmapKey,
      'text': query,
      'layers': 'address,street,venue,locality',
      'focus.point.lat': '$_tnLat',
      'focus.point.lon': '$_tnLon',
      'boundary.circle.lat': '$_tnLat',
      'boundary.circle.lon': '$_tnLon',
      'boundary.circle.radius': '45',
      'boundary.rect.min_lat': '$_minLat',
      'boundary.rect.max_lat': '$_maxLat',
      'boundary.rect.min_lon': '$_minLon',
      'boundary.rect.max_lon': '$_maxLon',
    };

    final sb = StringBuffer('https://maps.vietmap.vn/api/autocomplete/v3?');
    sb.writeAll(
      params.entries.map((e) =>
          '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}'),
      '&',
    );
    return Uri.parse(sb.toString());
  }


  static List<String> _parseAndFilterTayNinh(http.Response res, {required String tag}) {
 
    // ignore: avoid_print
    print('VM[$tag] status=${res.statusCode}');
    if (res.statusCode != 200) {
      // ignore: avoid_print
      print('VM[$tag] body=${res.body}');
      return [];
    }

    dynamic data;
    try {
      data = json.decode(res.body);
    } catch (_) {
      return [];
    }

    final kept = <String>[];

    void take(dynamic item) {
      if (item is! Map) return;

      final props = (item['properties'] is Map) ? item['properties'] as Map : item;

      final display = (_asString(props['display']) ??
              _asString(props['full_address']) ??
              _asString(props['label']) ??
              _asString(props['name']) ??
              '')
          .trim();

      final provinceLike = _asString(props['province']) ??
          _asString(props['region']) ??
          _asString(props['state']) ??
          _asString(props['city']) ??
          _asString(props['county']) ??
          _asString(props['provinceName']) ??
          '';

      List? coords;
      if (item['geometry'] is Map && (item['geometry']['coordinates'] is List)) {
        coords = (item['geometry']['coordinates'] as List);
      }

      final latlonOk = () {
        if (coords == null || coords.length < 2) return true; 
        final lon = (coords[0] as num?)?.toDouble();
        final lat = (coords[1] as num?)?.toDouble();
        if (lon == null || lat == null) return true;
        return lat >= _minLat && lat <= _maxLat && lon >= _minLon && lon <= _maxLon;
      }();

      final inTayNinhByProp = isInTayNinh(provinceLike) || isInTayNinh(display);

      if (display.isNotEmpty && inTayNinhByProp && latlonOk) {
        kept.add(display);
      }
    }

    if (data is Map && data['features'] is List) {
      for (final f in (data['features'] as List)) take(f);
    } else if (data is Map && data['items'] is List) {
      for (final f in (data['items'] as List)) take(f);
    } else if (data is List) {
      for (final f in data) take(f);
    }

    // ignore: avoid_print
    print('VM[$tag] kept=${kept.length}');
    return kept.toSet().toList();
  }


  static bool isInTayNinh(String? s) {
    if (s == null) return false;
    final t = _stripDiacritics(s).toLowerCase();
    return t.contains('tay ninh'); 
  }

  static String? _asString(dynamic v) => v is String ? v : null;

  static String _prepareQuery(String q) {
    final t = q.trim();
    final onlyDigits = RegExp(r'^\d+$').hasMatch(t);
    return onlyDigits ? '$t tay ninh' : t;
  }

  static bool _looksSearchable(String q) {
    final t = q.trim();
    if (t.length < 2) return false;
    return RegExp(r'[A-Za-zÀ-ỹ0-9]', caseSensitive: false).hasMatch(t);
  }


  static String _stripDiacritics(String s) {
    const pairs = <List<String>>[
      ['[àáạảãâầấậẩẫăằắặẳẵ]', 'a'], ['[ÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴ]', 'A'],
      ['[èéẹẻẽêềếệểễ]', 'e'], ['[ÈÉẸẺẼÊỀẾỆỂỄ]', 'E'],
      ['[ìíịỉĩ]', 'i'], ['[ÌÍỊỈĨ]', 'I'],
      ['[òóọỏõôồốộổỗơờớợởỡ]', 'o'], ['[ÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠ]', 'O'],
      ['[ùúụủũưừứựửữ]', 'u'], ['[ÙÚỤỦŨƯỪỨỰỬỮ]', 'U'],
      ['[ỳýỵỷỹ]', 'y'], ['[ỲÝỴỶỸ]', 'Y'],
      ['đ', 'd'], ['Đ', 'D'],
    ];
    var out = s;
    for (final p in pairs) { out = out.replaceAll(RegExp(p[0]), p[1]); }
    return out;
  }
}
