import 'package:flutter/material.dart';
import 'package:travelogue_mobile/model/tour/tour_model.dart';

class TourSearchDelegate extends SearchDelegate<TourModel?> {
  final List<TourModel> data;
  TourSearchDelegate(this.data);

  @override
  String get searchFieldLabel => 'Tìm tour theo tên';

  @override
  ThemeData appBarTheme(BuildContext context) {
    final t = Theme.of(context);
    return t.copyWith(
      appBarTheme: t.appBarTheme.copyWith(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.black54),
      ),
      textTheme: t.textTheme.apply(bodyColor: Colors.black),
      scaffoldBackgroundColor: Colors.white,
    );
  }

  List<TourModel> _filter(String q) {
    final s = q.trim().toLowerCase();
    if (s.isEmpty) return data;
    return data.where((t) {
      final name = (t.name ?? '').toLowerCase();
      final desc = (t.description ?? '').toLowerCase();
      return name.contains(s) || desc.contains(s);
    }).toList();
  }

  @override
  Widget buildSuggestions(BuildContext context) => _buildList();
  @override
  Widget buildResults(BuildContext context) => _buildList();

  Widget _buildList() {
    final items = _filter(query);
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final tour = items[i];
        final img = (tour.medias.isNotEmpty ? tour.medias.first.mediaUrl : null) ?? '';
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: img.isNotEmpty
                ? Image.network(img, width: 54, height: 54, fit: BoxFit.cover)
                : Container(width: 54, height: 54, color: Colors.black12),
          ),
          title: _highlight(tour.name ?? '', query),
          subtitle: Text(
            tour.description ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => close(context, tour),
        );
      },
    );
  }


  Widget _highlight(String text, String needle) {
    if (needle.isEmpty) return Text(text, style: const TextStyle(fontWeight: FontWeight.w700));
    final lower = text.toLowerCase();
    final n = needle.toLowerCase();
    final idx = lower.indexOf(n);
    if (idx < 0) return Text(text, style: const TextStyle(fontWeight: FontWeight.w700));
    return RichText(
      text: TextSpan(style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700), children: [
        TextSpan(text: text.substring(0, idx)),
        TextSpan(text: text.substring(idx, idx + needle.length), style: const TextStyle(backgroundColor: Color(0xFFFFF59D))),
        TextSpan(text: text.substring(idx + needle.length)),
      ]),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
        if (query.isNotEmpty)
          IconButton(icon: const Icon(Icons.close), onPressed: () => query = ''),
      ];

  @override
  Widget? buildLeading(BuildContext context) =>
      IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, null));
}
