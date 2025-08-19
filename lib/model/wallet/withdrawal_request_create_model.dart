class WithdrawalRequestCreateModel {
  final double amount;
  final String bankAccountId;
  final String? note; // cho phép null

  WithdrawalRequestCreateModel({
    required this.amount,
    required this.bankAccountId,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'bankAccountId': bankAccountId,
      if (note != null && note!.isNotEmpty) 'note': note,
    };
  }
}
