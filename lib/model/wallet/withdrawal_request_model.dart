// lib/model/wallet/withdrawal_request_model.dart
class WithdrawalRequestModel {
  final String id;
  final int amount;
  final int status;
  final String statusText;
  final DateTime requestTime; 
  final BankAccountMini? bankAccount;

  WithdrawalRequestModel({
    required this.id,
    required this.amount,
    required this.status,
    required this.statusText,
    required this.requestTime,      
    this.bankAccount,
  });

  factory WithdrawalRequestModel.fromJson(Map<String, dynamic> json) {
    final num? amountNum = json['amount'] as num?;
    final String? timeRaw =
        json['requestTime']?.toString() ?? json['createdTime']?.toString();

    return WithdrawalRequestModel(
      id: json['id']?.toString() ?? '',
      amount: amountNum?.round() ?? 0,
      status: json['status'] is int
          ? json['status'] as int
          : int.tryParse('${json['status']}') ?? 0,
      statusText: json['statusText']?.toString() ?? '',
      requestTime: DateTime.tryParse(timeRaw ?? '') 
          ?? DateTime.fromMillisecondsSinceEpoch(0), 
      bankAccount: (json['bankAccount'] is Map<String, dynamic>)
          ? BankAccountMini.fromJson(json['bankAccount'] as Map<String, dynamic>)
          : null,
    );
  }
}

class BankAccountMini {
  final String? bankName;
  final String? bankAccountNumber;
  final String? bankOwnerName;

  BankAccountMini({this.bankName, this.bankAccountNumber, this.bankOwnerName});

  factory BankAccountMini.fromJson(Map<String, dynamic> json) {
    return BankAccountMini(
      bankName: json['bankName']?.toString(),
      bankAccountNumber: json['bankAccountNumber']?.toString(),
      bankOwnerName: json['bankOwnerName']?.toString(),
    );
  }
}
