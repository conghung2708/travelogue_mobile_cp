import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelogue_mobile/core/blocs/media/media_event.dart';
import 'package:travelogue_mobile/core/blocs/media/media_state.dart';
import 'package:travelogue_mobile/core/repository/media_repository.dart';

class MediaBloc extends Bloc<MediaEvent, MediaState> {
  final MediaRepository repository;

  MediaBloc(this.repository) : super(MediaInitial()) {
    on<UploadMultipleCertsEvent>(_onUploadCerts);
    on<UploadMultipleImagesEvent>(_onUploadImages);
  }

  Future<void> _onUploadCerts(
    UploadMultipleCertsEvent event,
    Emitter<MediaState> emit,
  ) async {
    emit(MediaUploading());
    try {
      final urls = await repository.uploadMultipleCertifications(event.files);
      emit(MediaUploadSuccess(urls));
    } catch (e) {
      emit(MediaUploadFailure(_prettyErr(e)));
    }
  }

  Future<void> _onUploadImages(
    UploadMultipleImagesEvent event,
    Emitter<MediaState> emit,
  ) async {
    emit(MediaUploading());
    try {
      final urls = await repository.uploadMultipleImages(event.files);
      emit(MediaUploadSuccess(urls));
    } catch (e) {
      emit(MediaUploadFailure(_prettyErr(e)));
    }
  }

  String _prettyErr(Object e) {
    final s = e.toString();

    return s.startsWith('Exception: ') ? s.substring('Exception: '.length) : s;
  }
}
class MediaUploadBloc extends MediaBloc {
  MediaUploadBloc() : super(MediaRepository());
}
