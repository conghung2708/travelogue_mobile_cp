// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  String? verificationToken;
  String? refreshTokens;
  String? userId;
  String? username;
  String? fullName;
  String? email;
  bool? isEmailVerified;
  UserModel({
    this.verificationToken,
    this.refreshTokens,
    this.userId,
    this.username,
    this.fullName,
    this.email,
    this.isEmailVerified,
  });

  UserModel copyWith({
    String? verificationToken,
    String? refreshTokens,
    String? userId,
    String? username,
    String? fullName,
    String? email,
    bool? isEmailVerified,
  }) {
    return UserModel(
      verificationToken: verificationToken ?? this.verificationToken,
      refreshTokens: refreshTokens ?? this.refreshTokens,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'verificationToken': verificationToken,
      'refreshTokens': refreshTokens,
      'userId': userId,
      'username': username,
      'fullName': fullName,
      'email': email,
      'isEmailVerified': isEmailVerified,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      verificationToken: map['verificationToken'] != null
          ? map['verificationToken'] as String
          : null,
      refreshTokens:
          map['refreshTokens'] != null ? map['refreshTokens'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      fullName: map['fullName'] != null ? map['fullName'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      isEmailVerified: map['isEmailVerified'] != null
          ? map['isEmailVerified'] as bool
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(verificationToken: $verificationToken, refreshTokens: $refreshTokens, userId: $userId, username: $username, fullName: $fullName, email: $email, isEmailVerified: $isEmailVerified)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) {
      return true;
    }

    return other.verificationToken == verificationToken &&
        other.refreshTokens == refreshTokens &&
        other.userId == userId &&
        other.username == username &&
        other.fullName == fullName &&
        other.email == email &&
        other.isEmailVerified == isEmailVerified;
  }

  @override
  int get hashCode {
    return verificationToken.hashCode ^
        refreshTokens.hashCode ^
        userId.hashCode ^
        username.hashCode ^
        fullName.hashCode ^
        email.hashCode ^
        isEmailVerified.hashCode;
  }
}
