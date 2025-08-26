import 'package:equatable/equatable.dart';
import 'package:travelogue_mobile/model/wallet/withdrawal_request_create_model.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}


class SendWithdrawalRequestEvent extends WalletEvent {
  final WithdrawalRequestCreateModel model;

  const SendWithdrawalRequestEvent(this.model);

  @override
  List<Object?> get props => [model];
}


class LoadMyWithdrawalRequestsEvent extends WalletEvent {
  final int? status;     
  final DateTime? fromDate;
  final DateTime? toDate;

  const LoadMyWithdrawalRequestsEvent({this.status, this.fromDate, this.toDate});

  @override
  List<Object?> get props => [status, fromDate, toDate];
}
