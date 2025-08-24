// lib/core/network/error_parser.dart

String? pickErrorMessage(dynamic body) {
  if (body == null) {
    return null;
  }
  try {
    if (body is Map<String, dynamic>) {
      // data.message
      final data = body['data'];
      if (data is Map && data['message'] != null) return data['message'].toString();

      // message
      if (body['message'] != null) return body['message'].toString();

      // error / error.message
      final err = body['error'];
      if (err is Map && err['message'] != null) return err['message'].toString();
      if (err != null && err is! Map) return err.toString();

      // errors: List<String> | Map<String, List<String>>
      final errors = body['errors'];
      if (errors is List && errors.isNotEmpty) {
        return errors.map((e) => e.toString()).join('\n');
      }
      if (errors is Map && errors.isNotEmpty) {
        final parts = <String>[];
        errors.forEach((k, v) {
          if (v is List && v.isNotEmpty) {
            parts.add('$k: ${v.join(', ')}');
          } else {
            parts.add('$k: $v');
          }
        });
        if (parts.isNotEmpty) return parts.join('\n');
      }

      // detail
      if (body['detail'] != null) return body['detail'].toString();
    }

    return body.toString();
  } catch (_) {
    return null;
  }
}
