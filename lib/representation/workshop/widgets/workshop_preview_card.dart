import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/blocs/workshop/workshop_bloc.dart';
import 'package:travelogue_mobile/representation/workshop/screens/workshop_detail_screen.dart';

class WorkshopPreviewCard extends StatelessWidget {
  final dynamic workshop;

  const WorkshopPreviewCard({super.key, required this.workshop});

  @override
  Widget build(BuildContext context) {
    String _s(dynamic v) => v == null ? '' : v.toString();

    final id = _pick<String>(() => workshop.id as String?, 'id');
    final name = _pick<String>(() => workshop.name as String?, 'name');
    final description =
        _pick<String>(() => workshop.description as String?, 'description');

    final List tickets = _pickList<Map<String, dynamic>>(
      () => (workshop.ticketTypes as List?)?.cast(),
      'ticketTypes',
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.handyman_outlined),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _s(name),
                  style:
                      TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          if (_s(description).isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(_s(description)),
          ],
          if (tickets.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text('Loại vé',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.sp)),
            const SizedBox(height: 8),
            ...tickets.map((t) => _TicketTile(ticket: t)).toList(),
          ],
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: (id == null || id.isEmpty)
                  ? null
                  : () => _goToDetail(context, id),
              icon: const Icon(Icons.chevron_right_rounded),
              label: const Text('Xem chi tiết workshop'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  T? _pick<T>(T? Function() getFromModel, String key) {
    try {
      final v = getFromModel();
      if (v != null) return v;
    } catch (_) {}
    if (workshop is Map) {
      final raw = (workshop as Map)[key];
      if (raw is T) return raw;
      if (raw != null) return raw as T?;
    }
    return null;
  }

  List<E> _pickList<E>(List<E>? Function() getFromModel, String key) {
    try {
      final v = getFromModel();
      if (v != null) return v.whereType<E>().toList();
    } catch (_) {}
    if (workshop is Map) {
      final raw = (workshop as Map)[key];
      if (raw is List) return raw.whereType<E>().toList();
    }
    return <E>[];
  }

  void _goToDetail(BuildContext context, String workshopId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<WorkshopBloc>(),
          child: WorkshopDetailScreen(
            workshopId: workshopId,
            // hideScheduleTab: true,
            // hideIntroTab: false,
          ),
        ),
      ),
    );
  }
}

class _TicketTile extends StatelessWidget {
  final dynamic ticket;
  const _TicketTile({required this.ticket});

  String _money(num? v) {
    if (v == null) return '--';
    final s = v.toStringAsFixed(0);
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      buf.write(s[s.length - 1 - i]);
      if (i % 3 == 2 && i != s.length - 1) buf.write(' ');
    }
    return '${buf.toString().split('').reversed.join()} đ';
  }

  @override
  Widget build(BuildContext context) {
    String name = '';
    num? price;
    int? dur;

    try {
      // model
      final m = ticket as dynamic;
      name = m.name?.toString() ?? '';
      final p = m.price;
      price = p is num ? p : num.tryParse(p?.toString() ?? '');
      final d = m.durationMinutes;
      dur = d is num ? d.toInt() : int.tryParse(d?.toString() ?? '');
    } catch (_) {
      // map
      final map = ticket as Map<String, dynamic>;
      name = map['name']?.toString() ?? '';
      final p = map['price'];
      price = p is num ? p : num.tryParse(p?.toString() ?? '');
      final d = map['durationMinutes'];
      dur = d is num ? d.toInt() : int.tryParse(d?.toString() ?? '');
    }

    final pieces = <String>[
      if (name.isNotEmpty) name,
      if (dur != null && dur! > 0) "${dur!}'",
      if (price != null) _money(price),
    ];

    return Row(
      children: [
        const Icon(Icons.confirmation_number_outlined, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(pieces.join(' • '))),
      ],
    );
  }
}
