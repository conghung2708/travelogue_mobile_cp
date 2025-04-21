import 'dart:convert';

class SocialModel {
  final String fullName;
  final String? facebookId;
  final String? googleId;
  final String? appleId;
  final String? email;
  SocialModel({
    required this.fullName,
    this.facebookId,
    this.googleId,
    this.appleId,
    this.email,
  });

  SocialModel copyWith({
    String? fullName,
    String? email,
    String? facebookId,
    String? googleId,
    String? appleId,
  }) {
    return SocialModel(
      fullName: fullName ?? this.fullName,
      facebookId: facebookId ?? this.facebookId,
      googleId: googleId ?? this.googleId,
      appleId: appleId ?? this.appleId,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, String> result = {
      'fullname': fullName,
    };

    if (email != null) {
      result['email'] = email!;
    }

    if (googleId != null) {
      result['googleID'] = googleId!;
    }

    if (appleId != null) {
      result['appleID'] = appleId!;
    }

    if (facebookId != null) {
      result['facebookID'] = facebookId!;
    }

    return result;
  }

  factory SocialModel.fromMap(Map<String, dynamic> map) {
    return SocialModel(
      fullName: map['fullName'] ?? '',
      facebookId: map['facebookId'],
      googleId: map['googleId'],
      appleId: map['appleId'],
      email: map['email'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SocialModel.fromJson(String source) =>
      SocialModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SocialModel(fullName: $fullName, facebookId: $facebookId, googleId: $googleId, appleId: $appleId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is SocialModel &&
        other.fullName == fullName &&
        other.facebookId == facebookId &&
        other.googleId == googleId &&
        other.email == email &&
        other.appleId == appleId;
  }

  @override
  int get hashCode {
    return fullName.hashCode ^
        facebookId.hashCode ^
        googleId.hashCode ^
        email.hashCode ^
        appleId.hashCode;
  }
}
