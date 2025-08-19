class BankLookupItem {
  final String code;
  final String name;
  final String? shortName;
  final String? logoUrl;
  final String? iconUrl;

  BankLookupItem({
    required this.code,
    required this.name,
    this.shortName,
    this.logoUrl,
    this.iconUrl,
  });

  factory BankLookupItem.fromJson(Map<String, dynamic> j) => BankLookupItem(
        code: j['code']?.toString() ?? '',
        name: j['name']?.toString() ?? '',
        shortName: j['short_name']?.toString(),
        logoUrl: j['logo_url']?.toString(),
        iconUrl: j['icon_url']?.toString(),
      );
}
