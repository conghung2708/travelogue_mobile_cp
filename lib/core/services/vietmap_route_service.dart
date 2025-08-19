import 'dart:convert';
import 'package:http/http.dart' as http;

class VietmapRouteResult {
  final int distanceMeters;   
  final int durationSeconds;  
  VietmapRouteResult({
    required this.distanceMeters,
    required this.durationSeconds,
  });
}

class VietmapRouteService {
  final String apiKey;
  VietmapRouteService({required this.apiKey});

  Future<VietmapRouteResult> routeMotorcycle({
    required double fromLat,
    required double fromLng,
    required double toLat,
    required double toLng,
    String vehicle = 'motorcycle',
  }) async {
    final query = StringBuffer()
      ..write('api-version=1.1')
      ..write('&apikey=$apiKey')
      ..write('&vehicle=$vehicle')
      ..write('&points_encoded=false');

    query.write('&point=$fromLat,$fromLng');
    query.write('&point=$toLat,$toLng');

    final uri = Uri.parse('https://maps.vietmap.vn/api/route?$query');

 
    print('[VietmapRoute] GET $uri');

    final resp = await http.get(uri);

    print('[VietmapRoute] statusCode=${resp.statusCode}');
    if (resp.body.length < 500) {
      print('[VietmapRoute] body=${resp.body}');
    } else {
      print('[VietmapRoute] body=${resp.body.substring(0, 500)}...');
    }

    if (resp.statusCode != 200) {
      throw Exception('Route API error ${resp.statusCode}');
    }

    final data = jsonDecode(resp.body);
    print('[VietmapRoute] decodedType=${data.runtimeType} keys=${data is Map ? data.keys : 'n/a'}');

    int distanceMeters = 0;
    int durationSeconds = 0;

    if (data is Map && data['paths'] is List && (data['paths'] as List).isNotEmpty) {
      final p = (data['paths'] as List).first;
      print('[VietmapRoute] using paths: $p');
      final d = (p['distance'] as num?)?.toDouble();
      final tMs = (p['time'] as num?)?.toDouble();
      distanceMeters = d != null ? d.round() : 0;
      durationSeconds = tMs != null ? (tMs / 1000).round() : 0;
    } else if (data is Map && data['routes'] is List && (data['routes'] as List).isNotEmpty) {
      final r = (data['routes'] as List).first;
      print('[VietmapRoute] using routes: $r');
      final d = (r['distance'] as num?)?.toDouble();
      final tSec = (r['duration'] as num?)?.toDouble();
      distanceMeters = d != null ? d.round() : 0;
      durationSeconds = tSec != null ? tSec.round() : 0;
    } else {
      final d = (data['distance'] as num?)?.toDouble();
      final t = (data['duration'] as num?)?.toDouble();
      if (d != null && t != null) {
        print('[VietmapRoute] using root fields: distance=$d duration=$t');
        distanceMeters = d.round();
        durationSeconds = t.round();
      } else {
        print('[VietmapRoute][ERR] Cannot parse distance/duration from: $data');
        throw Exception('Không parse được distance/duration từ Route API.');
      }
    }

    print('[VietmapRoute] => distance=$distanceMeters m, duration=$durationSeconds s');

    return VietmapRouteResult(
      distanceMeters: distanceMeters,
      durationSeconds: durationSeconds,
    );
  }

  Future<List<double?>> matrixDistanceKm({
    required double anchorLat,
    required double anchorLng,
    required List<List<double>> targetsLatLng,
    String vehicle = 'motorcycle',
  }) async {
    final points = <String>[
      '$anchorLat,$anchorLng',
      ...targetsLatLng.map((e) => '${e[0]},${e[1]}'),
    ];
    final destIdx = List.generate(targetsLatLng.length, (i) => i + 1).join(';');

    final query = StringBuffer()
      ..write('api-version=1.1')
      ..write('&apikey=$apiKey')
      ..write('&vehicle=$vehicle')
      ..write('&points_encoded=false')
      ..write('&annotation=distance')
      ..write('&sources=0')
      ..write('&destinations=${destIdx.isEmpty ? 'all' : destIdx}');

    for (final p in points) {
      query.write('&point=$p');
    }

    final uri = Uri.parse('https://maps.vietmap.vn/api/matrix?$query');

    
    print('[VietmapMatrix] GET $uri');

    final resp = await http.get(uri);

  
    print('[VietmapMatrix] statusCode=${resp.statusCode}');
    if (resp.body.length < 500) {
      print('[VietmapMatrix] body=${resp.body}');
    } else {
      print('[VietmapMatrix] body=${resp.body.substring(0, 500)}...');
    }

    if (resp.statusCode != 200) {
      throw Exception('Matrix API error ${resp.statusCode}');
    }

    final json = jsonDecode(resp.body);
    final distances = (json['distances'] as List?) ?? (json['matrix'] as List?);

    if (distances == null || distances.isEmpty) {
      print('[VietmapMatrix][WARN] No distances found.');
      return List<double?>.filled(targetsLatLng.length, null);
    }

    final row0 = distances.first as List;
    print('[VietmapMatrix] row0=$row0');

    return row0.map<double?>((d) {
      if (d == null) return null;
      final meters = (d as num).toDouble();
      if (meters.isNaN) return null;
      return meters / 1000.0;
    }).toList(growable: false);
  }
}
