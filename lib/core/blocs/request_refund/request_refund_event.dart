import 'package:equatable/equatable.dart';
import 'package:travelogue_mobile/model/refund_request/refund_create_model.dart';

abstract class RefundEvent extends Equatable {
  const RefundEvent();

  @override
  List<Object?> get props => [];
}


class SendRefundRequestEvent extends RefundEvent {
  final RefundCreateModel model;

  const SendRefundRequestEvent(this.model);

  @override
  List<Object?> get props => [model];
}


class LoadUserRefundRequestsEvent extends RefundEvent {
  final DateTime? fromDate;
  final DateTime? toDate;
  final int? status;

  const LoadUserRefundRequestsEvent({
    this.fromDate,
    this.toDate,
    this.status,
  });

  @override
  List<Object?> get props => [fromDate, toDate, status];
}


class LoadRefundRequestDetailEvent extends RefundEvent {
  final String refundRequestId;

  const LoadRefundRequestDetailEvent(this.refundRequestId);

  @override
  List<Object?> get props => [refundRequestId];
}
