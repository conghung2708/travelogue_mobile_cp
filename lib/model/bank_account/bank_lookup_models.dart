class BankLookupItem {
  final String code;
  final String name;
  final String shortName;
  final String? logo;

  BankLookupItem({
    required this.code,
    required this.name,
    required this.shortName,
    this.logo,
  });

  factory BankLookupItem.fromJson(Map<String, dynamic> json) {
    return BankLookupItem(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      shortName: json['shortName'] ?? json['short_name'] ?? '',
      logo: json['logo_url'],
    );
  }
}
