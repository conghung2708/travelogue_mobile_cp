import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelogue_mobile/core/blocs/bank_account/bank_account_event.dart';
import 'package:travelogue_mobile/core/blocs/bank_account/bank_account_state.dart';
import 'package:travelogue_mobile/core/repository/bank_account_repository.dart';

class BankAccountBloc extends Bloc<BankAccountEvent, BankAccountState> {
  final BankAccountRepository repository;

  BankAccountBloc(this.repository) : super(BankAccountInitial()) {
    on<GetBankAccountsEvent>(_onGetBankAccounts);
    on<CreateBankAccountEvent>(_onCreateBankAccount);
    on<UpdateBankAccountEvent>(_onUpdateBankAccount);
  }

  Future<void> _onGetBankAccounts(
    GetBankAccountsEvent event,
    Emitter<BankAccountState> emit,
  ) async {
    emit(BankAccountLoading());
    try {
      final accounts =
          await repository.getBankAccounts(userId: event.userId);
      emit(BankAccountListSuccess(accounts));
    } catch (e) {
      emit(BankAccountFailure(e.toString()));
    }
  }

  Future<void> _onCreateBankAccount(
    CreateBankAccountEvent event,
    Emitter<BankAccountState> emit,
  ) async {
    emit(BankAccountLoading());
    final error = await repository.createBankAccount(event.model);
    if (error == null) {
      emit(BankAccountCreateSuccess());
    } else {
      emit(BankAccountFailure(error));
    }
  }

  Future<void> _onUpdateBankAccount(
    UpdateBankAccountEvent event,
    Emitter<BankAccountState> emit,
  ) async {
    emit(BankAccountLoading());
    final error = await repository.updateBankAccount(
      bankAccountId: event.bankAccountId,
      model: event.model,
    );
    if (error == null) {
      emit(BankAccountUpdateSuccess());
    } else {
      emit(BankAccountFailure(error));
    }
  }
}
