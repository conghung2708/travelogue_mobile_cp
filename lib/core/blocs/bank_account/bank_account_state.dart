import 'package:equatable/equatable.dart';
import 'package:travelogue_mobile/model/bank_account/bank_account_model.dart';

abstract class BankAccountState extends Equatable {
  const BankAccountState();

  @override
  List<Object?> get props => [];
}

class BankAccountInitial extends BankAccountState {}

class BankAccountLoading extends BankAccountState {}

class BankAccountListSuccess extends BankAccountState {
  final List<BankAccountModel> accounts;
  const BankAccountListSuccess(this.accounts);

  @override
  List<Object?> get props => [accounts];
}

class BankAccountCreateSuccess extends BankAccountState {}


class BankAccountUpdateSuccess extends BankAccountState {}

class BankAccountFailure extends BankAccountState {
  final String message;
  const BankAccountFailure(this.message);

  @override
  List<Object?> get props => [message];
}
