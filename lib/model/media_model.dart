import 'dart:convert';

class MediaModel {
  final String? mediaUrl;
  final String? fileName;
  final String? fileType;
  final bool? isThumbnail;
  final int? sizeInBytes;
  final String? createdTime;

  const MediaModel({
    this.mediaUrl,
    this.fileName,
    this.fileType,
    this.isThumbnail,
    this.sizeInBytes,
    this.createdTime,
  });

  MediaModel copyWith({
    String? mediaUrl,
    String? fileName,
    String? fileType,
    bool? isThumbnail,
    int? sizeInBytes,
    String? createdTime,
  }) {
    return MediaModel(
      mediaUrl: mediaUrl ?? this.mediaUrl,
      fileName: fileName ?? this.fileName,
      fileType: fileType ?? this.fileType,
      isThumbnail: isThumbnail ?? this.isThumbnail,
      sizeInBytes: sizeInBytes ?? this.sizeInBytes,
      createdTime: createdTime ?? this.createdTime,
    );
  }

  /// parse từ Map JSON
  factory MediaModel.fromMap(Map<String, dynamic> map) {
    return MediaModel(
      mediaUrl: map['mediaUrl']?.toString(),
      fileName: map['fileName']?.toString(),
      fileType: map['fileType']?.toString(),
      isThumbnail: map['isThumbnail'] as bool?,
      sizeInBytes: (map['sizeInBytes'] as num?)?.toInt(),
      createdTime: map['createdTime']?.toString(),
    );
  }

  /// chuẩn: fromJson nhận Map
  factory MediaModel.fromJson(Map<String, dynamic> json) =>
      MediaModel.fromMap(json);

  Map<String, dynamic> toMap() {
    return {
      'mediaUrl': mediaUrl,
      'fileName': fileName,
      'fileType': fileType,
      'isThumbnail': isThumbnail,
      'sizeInBytes': sizeInBytes,
      'createdTime': createdTime,
    };
  }

  Map<String, dynamic> toJson() => toMap();

  String toJsonString() => json.encode(toMap());

  @override
  String toString() {
    return 'MediaModel(mediaUrl: $mediaUrl, fileName: $fileName, fileType: $fileType, '
        'isThumbnail: $isThumbnail, sizeInBytes: $sizeInBytes, createdTime: $createdTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MediaModel &&
        other.mediaUrl == mediaUrl &&
        other.fileName == fileName &&
        other.fileType == fileType &&
        other.isThumbnail == isThumbnail &&
        other.sizeInBytes == sizeInBytes &&
        other.createdTime == createdTime;
  }

  @override
  int get hashCode {
    return mediaUrl.hashCode ^
        fileName.hashCode ^
        fileType.hashCode ^
        isThumbnail.hashCode ^
        sizeInBytes.hashCode ^
        createdTime.hashCode;
  }
}
