import 'dart:convert';

class UserModel {
  // Core
  String? id;
  String? email;
  String? userName;
  String? fullName;
  String? avatarUrl;

  // Flags / status
  bool? emailConfirmed;
  bool? phoneNumberConfirmed;
  bool? isEmailVerified;

  // Contact
  String? phoneNumber;
  String? address;

  // Others
  List<String>? roles;
  num? userWalletAmount;
  int? sex;

  // Audit
  DateTime? createdTime;
  DateTime? lastUpdatedTime;
  String? createdBy;
  String? createdByName;
  String? lastUpdatedBy;
  String? lastUpdatedByName;

  String? verificationToken;
  String? refreshTokens;

  String? get username => userName;

  UserModel({
    this.id,
    this.email,
    this.userName,
    this.fullName,
    this.avatarUrl,
    this.emailConfirmed,
    this.phoneNumber,
    this.phoneNumberConfirmed,
    this.isEmailVerified,
    this.roles,
    this.userWalletAmount,
    this.sex,
    this.address,
    this.createdTime,
    this.lastUpdatedTime,
    this.createdBy,
    this.createdByName,
    this.lastUpdatedBy,
    this.lastUpdatedByName,
    this.verificationToken,
    this.refreshTokens,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    String? fullName,
    String? avatarUrl,
    bool? emailConfirmed,
    String? phoneNumber,
    bool? phoneNumberConfirmed,
    bool? isEmailVerified,
    List<String>? roles,
    num? userWalletAmount,
    int? sex,
    String? address,
    DateTime? createdTime,
    DateTime? lastUpdatedTime,
    String? createdBy,
    String? createdByName,
    String? lastUpdatedBy,
    String? lastUpdatedByName,
    String? verificationToken,
    String? refreshTokens,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      emailConfirmed: emailConfirmed ?? this.emailConfirmed,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      phoneNumberConfirmed: phoneNumberConfirmed ?? this.phoneNumberConfirmed,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      roles: roles ?? this.roles,
      userWalletAmount: userWalletAmount ?? this.userWalletAmount,
      sex: sex ?? this.sex,
      address: address ?? this.address,
      createdTime: createdTime ?? this.createdTime,
      lastUpdatedTime: lastUpdatedTime ?? this.lastUpdatedTime,
      createdBy: createdBy ?? this.createdBy,
      createdByName: createdByName ?? this.createdByName,
      lastUpdatedBy: lastUpdatedBy ?? this.lastUpdatedBy,
      lastUpdatedByName: lastUpdatedByName ?? this.lastUpdatedByName,
      verificationToken: verificationToken ?? this.verificationToken,
      refreshTokens: refreshTokens ?? this.refreshTokens,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    List<String>? _roles;
    final rolesRaw = map['roles'];
    if (rolesRaw is List) {
      _roles = rolesRaw.whereType<String>().toList();
    }

    DateTime? _dt(String? s) {
      if (s == null || s.isEmpty) return null;
      try {
        return DateTime.parse(s);
      } catch (_) {
        return null;
      }
    }

    return UserModel(
      id: (map['id'] ?? map['userId'])?.toString(),
      email: map['email']?.toString(),
      userName: (map['userName'] ?? map['username'])?.toString(),
      fullName: map['fullName']?.toString(),
      avatarUrl: map['avatarUrl']?.toString(),
      emailConfirmed: map['emailConfirmed'] as bool?,
      phoneNumber: map['phoneNumber']?.toString(),
      phoneNumberConfirmed: map['phoneNumberConfirmed'] as bool?,
      isEmailVerified: map['isEmailVerified'] as bool?,
      roles: _roles,
      userWalletAmount: map['userWalletAmount'] is num
          ? map['userWalletAmount'] as num
          : (map['userWalletAmount'] == null
              ? null
              : num.tryParse(map['userWalletAmount'].toString())),
      sex: map['sex'] is int
          ? map['sex'] as int
          : (map['sex'] == null ? null : int.tryParse(map['sex'].toString())),
      address: map['address']?.toString(),
      createdTime: _dt(map['createdTime']?.toString()),
      lastUpdatedTime: _dt(map['lastUpdatedTime']?.toString()),
      createdBy: map['createdBy']?.toString(),
      createdByName: map['createdByName']?.toString(),
      lastUpdatedBy: map['lastUpdatedBy']?.toString(),
      lastUpdatedByName: map['lastUpdatedByName']?.toString(),
      verificationToken: map['verificationToken']?.toString(),
      refreshTokens: map['refreshTokens']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    String? _fmt(DateTime? d) => d?.toIso8601String();

    return {
      'id': id,
      'email': email,
      'userName': userName,
      'fullName': fullName,
      'avatarUrl': avatarUrl,
      'emailConfirmed': emailConfirmed,
      'phoneNumber': phoneNumber,
      'phoneNumberConfirmed': phoneNumberConfirmed,
      'isEmailVerified': isEmailVerified,
      'roles': roles,
      'userWalletAmount': userWalletAmount,
      'sex': sex,
      'address': address,
      'createdTime': _fmt(createdTime),
      'lastUpdatedTime': _fmt(lastUpdatedTime),
      'createdBy': createdBy,
      'createdByName': createdByName,
      'lastUpdatedBy': lastUpdatedBy,
      'lastUpdatedByName': lastUpdatedByName,
      'verificationToken': verificationToken,
      'refreshTokens': refreshTokens,
    };
  }

  factory UserModel.fromApiResponse(Map<String, dynamic> resp) {
    final data = resp['data'];
    if (data is Map<String, dynamic>) {
      return UserModel.fromMap(data);
    }

    if (resp.isNotEmpty) return UserModel.fromMap(resp);
    return UserModel();
  }

  String toJson() => json.encode(toMap());
  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  bool get hasName => (fullName != null && fullName!.isNotEmpty);
  bool get hasEmail => (email != null && email!.isNotEmpty);

  @override
  String toString() =>
      'UserModel(id: $id, email: $email, userName: $userName, fullName: $fullName)';
}
