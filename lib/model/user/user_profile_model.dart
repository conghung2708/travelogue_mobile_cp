import 'dart:convert';

class UserProfileModel {
  final String id;
  final String? email;
  final String? userName;                 
  final String? fullName;
  final String? avatarUrl;
  final List<String> roles;              
  final int? sex;                         
  final String? address;
  final bool? emailConfirmed;          
  final String? phoneNumber;
  final bool? phoneNumberConfirmed;      
  final DateTime? createdTime;
  final DateTime? lastUpdatedTime;
  final String? createdBy;
  final String? createdByName;
  final String? lastUpdatedBy;
  final String? lastUpdatedByName;

  const UserProfileModel({
    required this.id,
    this.email,
    this.userName,
    this.fullName,
    this.avatarUrl,
    this.roles = const [],
    this.sex,
    this.address,
    this.emailConfirmed,
    this.phoneNumber,
    this.phoneNumberConfirmed,
    this.createdTime,
    this.lastUpdatedTime,
    this.createdBy,
    this.createdByName,
    this.lastUpdatedBy,
    this.lastUpdatedByName,
  });

  UserProfileModel copyWith({
    String? id,
    String? email,
    String? userName,
    String? fullName,
    String? avatarUrl,
    List<String>? roles,
    int? sex,
    String? address,
    bool? emailConfirmed,
    String? phoneNumber,
    bool? phoneNumberConfirmed,
    DateTime? createdTime,
    DateTime? lastUpdatedTime,
    String? createdBy,
    String? createdByName,
    String? lastUpdatedBy,
    String? lastUpdatedByName,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      roles: roles ?? this.roles,
      sex: sex ?? this.sex,
      address: address ?? this.address,
      emailConfirmed: emailConfirmed ?? this.emailConfirmed,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      phoneNumberConfirmed: phoneNumberConfirmed ?? this.phoneNumberConfirmed,
      createdTime: createdTime ?? this.createdTime,
      lastUpdatedTime: lastUpdatedTime ?? this.lastUpdatedTime,
      createdBy: createdBy ?? this.createdBy,
      createdByName: createdByName ?? this.createdByName,
      lastUpdatedBy: lastUpdatedBy ?? this.lastUpdatedBy,
      lastUpdatedByName: lastUpdatedByName ?? this.lastUpdatedByName,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
        'userName': userName,
        'fullName': fullName,
        'avatarUrl': avatarUrl,
        'roles': roles,
        'sex': sex,
        'address': address,
        'emailConfirmed': emailConfirmed,
        'phoneNumber': phoneNumber,
        'phoneNumberConfirmed': phoneNumberConfirmed,
        'createdTime': createdTime?.toIso8601String(),
        'lastUpdatedTime': lastUpdatedTime?.toIso8601String(),
        'createdBy': createdBy,
        'createdByName': createdByName,
        'lastUpdatedBy': lastUpdatedBy,
        'lastUpdatedByName': lastUpdatedByName,
      };

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    List<String> parseRoles(dynamic v) {
      if (v is List) return v.map((e) => e.toString()).toList();
      return const <String>[];
    }

    DateTime? parseDt(dynamic v) {
      if (v == null) return null;
      final s = v.toString();
      return DateTime.tryParse(s);
    }

    return UserProfileModel(
      id: map['id']?.toString() ?? '',
      email: map['email']?.toString(),
      userName: (map['userName'] ?? map['username'])?.toString(),
      fullName: map['fullName']?.toString(),
      avatarUrl: map['avatarUrl']?.toString(),
      roles: parseRoles(map['roles']),
      sex: map['sex'] is num ? (map['sex'] as num).toInt() : int.tryParse('${map['sex']}'),
      address: map['address']?.toString(),
      emailConfirmed: map['emailConfirmed'] as bool?,
      phoneNumber: map['phoneNumber']?.toString(),
      phoneNumberConfirmed: map['phoneNumberConfirmed'] as bool?,
      createdTime: parseDt(map['createdTime']),
      lastUpdatedTime: parseDt(map['lastUpdatedTime']),
      createdBy: map['createdBy']?.toString(),
      createdByName: map['createdByName']?.toString(),
      lastUpdatedBy: map['lastUpdatedBy']?.toString(),
      lastUpdatedByName: map['lastUpdatedByName']?.toString(),
    );
  }

  String toJson() => json.encode(toMap());
  factory UserProfileModel.fromJson(String source) =>
      UserProfileModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UserProfileModel(id: $id, email: $email, userName: $userName, roles: $roles)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          userName == other.userName &&
          fullName == other.fullName &&
          avatarUrl == other.avatarUrl &&
          sex == other.sex &&
          address == other.address &&
          emailConfirmed == other.emailConfirmed &&
          phoneNumber == other.phoneNumber &&
          phoneNumberConfirmed == other.phoneNumberConfirmed &&
          createdTime == other.createdTime &&
          lastUpdatedTime == other.lastUpdatedTime &&
          createdBy == other.createdBy &&
          createdByName == other.createdByName &&
          lastUpdatedBy == other.lastUpdatedBy &&
          lastUpdatedByName == other.lastUpdatedByName &&
          _listEquals(roles, other.roles);

  @override
  int get hashCode =>
      id.hashCode ^
      (email?.hashCode ?? 0) ^
      (userName?.hashCode ?? 0) ^
      (fullName?.hashCode ?? 0) ^
      (avatarUrl?.hashCode ?? 0) ^
      roles.hashCode ^
      (sex?.hashCode ?? 0) ^
      (address?.hashCode ?? 0) ^
      (emailConfirmed?.hashCode ?? 0) ^
      (phoneNumber?.hashCode ?? 0) ^
      (phoneNumberConfirmed?.hashCode ?? 0) ^
      (createdTime?.hashCode ?? 0) ^
      (lastUpdatedTime?.hashCode ?? 0) ^
      (createdBy?.hashCode ?? 0) ^
      (createdByName?.hashCode ?? 0) ^
      (lastUpdatedBy?.hashCode ?? 0) ^
      (lastUpdatedByName?.hashCode ?? 0);
}

bool _listEquals<T>(List<T> a, List<T> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
