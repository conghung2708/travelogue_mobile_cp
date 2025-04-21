import 'dart:convert';

class MediaModel {
  String? mediaUrl;
  String? fileName;
  String? fileType;
  bool? isThumbnail;
  int? sizeInBytes;
  String? createdTime;
  MediaModel({
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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mediaUrl': mediaUrl,
      'fileName': fileName,
      'fileType': fileType,
      'isThumbnail': isThumbnail,
      'sizeInBytes': sizeInBytes,
      'createdTime': createdTime,
    };
  }

  factory MediaModel.fromMap(Map<String, dynamic> map) {
    return MediaModel(
      mediaUrl: map['mediaUrl']?.toString(),
      fileName: map['fileName']?.toString(),
      fileType: map['fileType']?.toString(),
      isThumbnail:
          map['isThumbnail'] != null ? map['isThumbnail'] as bool : null,
      sizeInBytes:
          map['sizeInBytes'] != null ? map['sizeInBytes'] as int : null,
      createdTime: map['createdTime']?.toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory MediaModel.fromJson(String source) =>
      MediaModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Medias(mediaUrl: $mediaUrl, fileName: $fileName, fileType: $fileType, isThumbnail: $isThumbnail, sizeInBytes: $sizeInBytes, createdTime: $createdTime)';
  }

  @override
  bool operator ==(covariant MediaModel other) {
    if (identical(this, other)) {
      return true;
    }

    return other.mediaUrl == mediaUrl &&
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
