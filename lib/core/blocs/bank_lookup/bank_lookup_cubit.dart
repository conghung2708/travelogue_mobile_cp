// lib/core/blocs/bank_lookup/bank_lookup_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travelogue_mobile/core/repository/bank_lookup_repository.dart';
import 'package:travelogue_mobile/model/bank_account/bank_lookup_models.dart';



part 'bank_lookup_state.dart';

class BankLookupCubit extends Cubit<BankLookupState> {
  final BankLookupRepository repository;
  BankLookupCubit(this.repository) : super(BankLookupState.initial());

  Future<void> loadBanks() async {
    emit(state.copyWith(isLoadingBanks: true, error: null));
    try {
      final banks = await repository.listBanks();
      emit(state.copyWith(isLoadingBanks: false, banks: banks));
    } catch (e) {
      emit(state.copyWith(isLoadingBanks: false, error: e.toString()));
    }
  }

  Future<void> verify({required String bankCode, required String account}) async {
    emit(state.copyWith(isVerifying: true, verifyError: null, ownerName: null));
    try {
      final ownerName = await repository.verifyAccount(
        bankCode: bankCode,
        accountNumber: account,
      );
      emit(state.copyWith(isVerifying: false, ownerName: ownerName));
    } catch (e) {
      emit(state.copyWith(isVerifying: false, verifyError: e.toString()));
    }
  }

  void clearVerify() => emit(state.copyWith(ownerName: null, verifyError: null));
}
