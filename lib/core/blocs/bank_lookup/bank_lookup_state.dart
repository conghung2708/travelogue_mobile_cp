// lib/core/blocs/bank_lookup/bank_lookup_state.dart
part of 'bank_lookup_cubit.dart';

class BankLookupState extends Equatable {
  final bool isLoadingBanks;
  final List<BankLookupItem> banks;
  final String? error;

  final bool isVerifying;
  final String? ownerName;
  final String? verifyError;

  const BankLookupState({
    required this.isLoadingBanks,
    required this.banks,
    this.error,
    required this.isVerifying,
    this.ownerName,
    this.verifyError,
  });

  factory BankLookupState.initial() => const BankLookupState(
        isLoadingBanks: false,
        banks: [],
        isVerifying: false,
      );

  BankLookupState copyWith({
    bool? isLoadingBanks,
    List<BankLookupItem>? banks, 
    String? error,
    bool? isVerifying,
    String? ownerName,
    String? verifyError,
  }) {
    return BankLookupState(
      isLoadingBanks: isLoadingBanks ?? this.isLoadingBanks,
      banks: banks ?? this.banks,
      error: error,
      isVerifying: isVerifying ?? this.isVerifying,
      ownerName: ownerName,
      verifyError: verifyError,
    );
  }

  @override
  List<Object?> get props =>
      [isLoadingBanks, banks, error, isVerifying, ownerName, verifyError];
}
