abstract class MediaState {}
class MediaInitial extends MediaState {}
class MediaUploading extends MediaState {}
class MediaUploadSuccess extends MediaState {
  final List<String> urls;
  MediaUploadSuccess(this.urls);
}
class MediaUploadFailure extends MediaState {
  final String error;
  MediaUploadFailure(this.error);
}
