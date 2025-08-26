import 'package:equatable/equatable.dart';
import 'package:travelogue_mobile/model/wallet/withdrawal_request_model.dart';

abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletSuccess extends WalletState {}


class WalletFailure extends WalletState {
  final String error;

  const WalletFailure(this.error);

  @override
  List<Object?> get props => [error];
}


class WalletListLoaded extends WalletState {
  final List<WithdrawalRequestModel> items;

  const WalletListLoaded(this.items);

  @override
  List<Object?> get props => [items];
}
