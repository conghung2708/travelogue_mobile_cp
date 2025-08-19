import 'package:equatable/equatable.dart';
import 'package:travelogue_mobile/model/refund_request/refund_create_model.dart';
import 'package:travelogue_mobile/model/refund_request/refund_request_model.dart';

abstract class RefundState extends Equatable {
  const RefundState();

  @override
  List<Object?> get props => [];
}

class RefundInitial extends RefundState {}

class RefundLoading extends RefundState {}

class RefundSuccess extends RefundState {}

class RefundFailure extends RefundState {
  final String error;

  const RefundFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// Khi load danh sách refund thành công
class RefundListLoaded extends RefundState {
  final List<RefundRequestModel> refunds;

  const RefundListLoaded(this.refunds);

  @override
  List<Object?> get props => [refunds];
}

// Khi load danh sách refund thất bại
class RefundListLoadFailure extends RefundState {
  final String error;

  const RefundListLoadFailure(this.error);

  @override
  List<Object?> get props => [error];
}
