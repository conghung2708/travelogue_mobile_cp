// core/blocs/user/user_bloc.dart
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:travelogue_mobile/core/repository/user_repository.dart';
import 'package:travelogue_mobile/model/user/tour_guide_request_model.dart';
import 'package:travelogue_mobile/model/user/user_profile_model.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UserInitial()) {
    on<SendTourGuideRequestEvent>(_onSendTourGuideRequest);
    on<GetUserByIdEvent>(_onGetUserById);

    // 🔶 NEW
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
    on<UpdateAvatarEvent>(_onUpdateAvatar);
  }

  Future<void> _onSendTourGuideRequest(
    SendTourGuideRequestEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final ok = await userRepository.sendTourGuideRequest(
        TourGuideRequestModel(
          introduction: event.introduction,
          price: event.price,
          certifications: event.certifications,
        ),
      );
      ok ? emit(TourGuideRequestSuccess())
         : emit(const TourGuideRequestFailure('Gửi yêu cầu thất bại.'));
    } catch (e) {
      emit(TourGuideRequestFailure(e.toString()));
    }
  }

  Future<void> _onGetUserById(
    GetUserByIdEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(GetUserByIdLoading());
    try {
      final user = await userRepository.getUserById(event.id);
      user != null
          ? emit(GetUserByIdSuccess(user))
          : emit(const GetUserByIdFailure('Không tìm thấy người dùng.'));
    } catch (e) {
      emit(GetUserByIdFailure(e.toString()));
    }
  }

  // 🔶 NEW: PUT /api/user/{id}
  Future<void> _onUpdateUserProfile(
    UpdateUserProfileEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UpdateUserProfileLoading());
    try {
      final user = await userRepository.updateUserProfile(
        id: event.id,
        phoneNumber: event.phoneNumber,
        fullName: event.fullName,
        address: event.address,
      );
      user != null
          ? emit(UpdateUserProfileSuccess(user))
          : emit(const UpdateUserProfileFailure('Cập nhật thất bại.'));
    } catch (e) {
      emit(UpdateUserProfileFailure(e.toString()));
    }
  }

  // 🔶 NEW: PUT /api/user/update-avatar
  Future<void> _onUpdateAvatar(
    UpdateAvatarEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UpdateAvatarLoading());
    try {
      final url = await userRepository.updateAvatar(event.file);
      url != null
          ? emit(UpdateAvatarSuccess(url))
          : emit(const UpdateAvatarFailure('Cập nhật ảnh đại diện thất bại.'));
    } catch (e) {
      emit(UpdateAvatarFailure(e.toString()));
    }
  }
}
