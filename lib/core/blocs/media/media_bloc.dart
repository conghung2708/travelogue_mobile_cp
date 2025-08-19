import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelogue_mobile/core/blocs/media/media_event.dart';
import 'package:travelogue_mobile/core/blocs/media/media_state.dart';
import 'package:travelogue_mobile/core/repository/media_repository.dart';

class MediaBloc extends Bloc<MediaEvent, MediaState> {
  final MediaRepository repository;
  MediaBloc(this.repository) : super(MediaInitial()) {
    on<UploadMultipleCertsEvent>((event, emit) async {
      emit(MediaUploading());
      try {
        final urls = await repository.uploadMultipleCertifications(event.files);
        emit(MediaUploadSuccess(urls));
      } catch (e) {
        emit(MediaUploadFailure(e.toString()));
      }
    });
  }
}

// Factory for AppBloc usage
class MediaUploadBloc extends MediaBloc {
  MediaUploadBloc() : super(MediaRepository());
}
