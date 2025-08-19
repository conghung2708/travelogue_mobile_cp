class BankAccountModel {
  final String? id;
  final String? bankName;
  final String? bankAccountNumber;
  final String? bankOwnerName;
  final bool? isDefault;

  BankAccountModel({
    this.id,
    this.bankName,
    this.bankAccountNumber,
    this.bankOwnerName,
    this.isDefault,
  });

  factory BankAccountModel.fromJson(Map<String, dynamic> json) {
    return BankAccountModel(
      id: json['id']?.toString(),
      bankName: json['bankName']?.toString(),
      bankAccountNumber: json['bankAccountNumber']?.toString(),
      bankOwnerName: json['bankOwnerName']?.toString(),
      isDefault: json['isDefault'] as bool?,
    );
  }
}

class CreateBankAccountModel {
  final String bankName;
  final String bankAccountNumber;
  final String bankOwnerName;
  final bool isDefault;

  CreateBankAccountModel({
    required this.bankName,
    required this.bankAccountNumber,
    required this.bankOwnerName,
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() => {
        "bankName": bankName,
        "bankAccountNumber": bankAccountNumber,
        "bankOwnerName": bankOwnerName,
        "isDefault": isDefault,
      };
}

class UpdateBankAccountModel {
  final String? bankName;
  final String? bankAccountNumber;
  final String? bankOwnerName;
  final bool? isDefault;

  UpdateBankAccountModel({
    this.bankName,
    this.bankAccountNumber,
    this.bankOwnerName,
    this.isDefault,
  });

  Map<String, dynamic> toJson() {
    return {
      if (bankName != null) 'bankName': bankName,
      if (bankAccountNumber != null) 'bankAccountNumber': bankAccountNumber,
      if (bankOwnerName != null) 'bankOwnerName': bankOwnerName,
      if (isDefault != null) 'isDefault': isDefault,
    };
  }
  
}

