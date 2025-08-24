import 'dart:io';

abstract class MediaEvent {}

class UploadMultipleCertsEvent extends MediaEvent {
  final List<File> files;
  UploadMultipleCertsEvent(this.files);
}

class UploadMultipleImagesEvent extends MediaEvent {
  final List<File> files;
  UploadMultipleImagesEvent(this.files);
}
