import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travelogue_mobile/core/repository/user_repository.dart';
import 'package:travelogue_mobile/model/user/tour_guide_request_model.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UserInitial()) {
    on<SendTourGuideRequestEvent>(_onSendTourGuideRequest);
  }

  Future<void> _onSendTourGuideRequest(
      SendTourGuideRequestEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final success = await userRepository.sendTourGuideRequest(
        TourGuideRequestModel(
          introduction: event.introduction,
          price: event.price,
          certifications: event.certifications,
        ),
      );

      if (success) {
        emit(TourGuideRequestSuccess());
      } else {
        emit(const TourGuideRequestFailure('Gửi yêu cầu thất bại.'));
      }
    } catch (e) {
      emit(TourGuideRequestFailure(e.toString()));
    }
  }
}
