import 'package:flutter/material.dart';
import 'package:diacritic/diacritic.dart';
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

  String _norm(String s) => removeDiacritics(s).toLowerCase();

  List<TourModel> _filter(String q) {
    final s = _norm(q.trim());
    if (s.isEmpty) return data;

    return data.where((t) {
      final name = _norm(t.name ?? '');
      final desc = _norm(t.description ?? '');
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
          title: _highlightAccentsAware(tour.name ?? '', query),
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

  Widget _highlightAccentsAware(String text, String needle) {
    final baseStyle = const TextStyle(color: Colors.black, fontWeight: FontWeight.w700);

    if (needle.isEmpty) return Text(text, style: baseStyle);

    final nText = _norm(text);
    final nNeedle = _norm(needle);
    final start = nText.indexOf(nNeedle);
    if (start < 0) return Text(text, style: baseStyle);

    int origStart = -1;
    int origEnd = -1;
    int cum = 0; 

    for (int i = 0; i < text.length; i++) {
      final normalizedChar = _norm(text[i]); 
      final nextCum = cum + normalizedChar.length;

      if (origStart == -1 && nextCum > start) {
        origStart = i;
      }
      if (origEnd == -1 && nextCum >= start + nNeedle.length) {
        origEnd = i + 1;
        break;
      }
      cum = nextCum;
    }


    origStart = (origStart < 0) ? 0 : origStart;
    origEnd = (origEnd < 0 || origEnd > text.length) ? text.length : origEnd;

    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: [
          if (origStart > 0) TextSpan(text: text.substring(0, origStart)),
          TextSpan(
            text: text.substring(origStart, origEnd),
            style: const TextStyle(backgroundColor: Color(0xFFFFF59D)),
          ),
          if (origEnd < text.length) TextSpan(text: text.substring(origEnd)),
        ],
      ),
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
