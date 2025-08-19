// lib/core/network/api_result.dart
typedef Json = Map<String, dynamic>;

class ApiResult<T> {
  final bool ok;
  final T? data;
  final String? message;
  final int? statusCode;
  final dynamic raw;

  const ApiResult._({
    required this.ok,
    this.data,
    this.message,
    this.statusCode,
    this.raw,
  });

  factory ApiResult.success(T data, {int? statusCode, dynamic raw}) {
    return ApiResult._(ok: true, data: data, statusCode: statusCode, raw: raw);
  }

  factory ApiResult.fail(String? message, {int? statusCode, dynamic raw}) {
    return ApiResult._(ok: false, message: message, statusCode: statusCode, raw: raw);
  }

  /// Map tiện lợi, chỉ chạy khi ok == true
  ApiResult<R> map<R>(R Function(T value) convert) {
    if (!ok || data == null) {
      return ApiResult<R>._(
        ok: false,
        message: message,
        statusCode: statusCode,
        raw: raw,
      );
    }
    return ApiResult<R>.success(convert(data as T), statusCode: statusCode, raw: raw);
  }

  /// Fold để xử lý gọn trên UI
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(String? message, int? statusCode) onError,
  }) {
    if (ok && data != null) return onSuccess(data as T);
    return onError(message, statusCode);
  }
}
