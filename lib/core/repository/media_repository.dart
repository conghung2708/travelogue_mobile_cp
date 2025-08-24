// core/repository/media_repository.dart
import 'dart:io' show File;
import 'package:dio/dio.dart' as diox;
import 'package:travelogue_mobile/core/constants/endpoints.dart';
import 'package:travelogue_mobile/core/repository/base_repository.dart';

class MediaRepository {
  final BaseRepository _base = BaseRepository();

  /// Upload nhiều chứng chỉ: field name bắt buộc = `certifications`
  Future<List<String>> uploadMultipleCertifications(List<File> files) async {
    return _uploadMany(
      files: files,
      endpoint: Endpoints.uploadMultipleCertifications,
      fieldName: 'certifications',
      logLabel: 'certifications',
    );
  }

  /// Upload nhiều ảnh: field name bắt buộc = `images` (theo Swagger)
  Future<List<String>> uploadMultipleImages(List<File> files) async {
    return _uploadMany(
      files: files,
      endpoint: Endpoints.uploadMultipleImages,
      fieldName: 'images',
      logLabel: 'images',
    );
  }

  /// Core uploader: tái sử dụng cho mọi field/endpoint
  Future<List<String>> _uploadMany({
    required List<File> files,
    required String endpoint,
    required String fieldName,
    required String logLabel,
  }) async {
    if (files.isEmpty) {
      throw ArgumentError('Danh sách files rỗng');
    }

    // Bạn có thể thêm các validate khác nếu muốn:
    // - size limit
    // - mime-type

    print('[📤] Upload ${files.length} $logLabel → $endpoint (field="$fieldName")');

    final form = diox.FormData();

    // Dạng array multipart: lặp lại cùng 1 key nhiều lần
    for (final f in files) {
      final filename = f.path.split('/').last;
      form.files.add(MapEntry(
        fieldName,
        await diox.MultipartFile.fromFile(
          f.path,
          filename: filename,
        ),
      ));
    }

    print('[ℹ️] FormData files count: ${form.files.length} (key="$fieldName")');

    final res = await _base.postFormData(endpoint, form);

    print('[📥] Status: ${res.statusCode}');
    print('[📥] Data: ${res.data}');

    final root = res.data;
    final data = (root is Map) ? (root['data'] ?? root['Data']) : null;

    if (res.statusCode == 200 && data != null) {
      return _extractUrls(data);
    }

    // fallback: đôi khi API trả trực tiếp array top-level
    if (res.statusCode == 200 && root is List) {
      return _extractUrls(root);
    }

    throw Exception('Upload thất bại: ${res.statusCode} ${res.data}');
  }

  List<String> _extractUrls(dynamic data) {
    // Phổ biến: data là List<String> hoặc List<Map>
    if (data is List) {
      final urls = <String>[];
      for (final item in data) {
        if (item is String) {
          urls.add(item);
        } else if (item is Map) {
          final u = (item['url'] ??
                  item['URL'] ??
                  item['path'] ??
                  item['location'] ??
                  item['Location'])
              ?.toString();
          if (u != null) urls.add(u);
        }
      }
      print('[✅] Upload thành công: ${urls.length} URL');
      return urls;
    }

    // Ít gặp: { urls: [...] }
    if (data is Map && data['urls'] is List) {
      final urls = (data['urls'] as List).map((e) => e.toString()).toList();
      print('[✅] Upload thành công: ${urls.length} URL');
      return urls;
    }

    print('[⚠️] Định dạng data không khớp kỳ vọng: $data');
    return const <String>[];
  }
}
