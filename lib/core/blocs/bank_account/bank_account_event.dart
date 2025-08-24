import 'package:equatable/equatable.dart';
import 'package:travelogue_mobile/model/bank_account/bank_account_model.dart';

abstract class BankAccountEvent extends Equatable {
  const BankAccountEvent();

  @override
  List<Object?> get props => [];
}

class GetBankAccountsEvent extends BankAccountEvent {
  final String? userId;
  const GetBankAccountsEvent({this.userId});
}

class CreateBankAccountEvent extends BankAccountEvent {
  final CreateBankAccountModel model;
  const CreateBankAccountEvent(this.model);
}

class UpdateBankAccountEvent extends BankAccountEvent {
  final String bankAccountId;
  final UpdateBankAccountModel model;
  const UpdateBankAccountEvent({
    required this.bankAccountId,
    required this.model,
  });

  @override
  List<Object?> get props => [bankAccountId, model];
}
