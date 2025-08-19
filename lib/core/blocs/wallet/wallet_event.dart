// lib/core/blocs/wallet/wallet_event.dart
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
