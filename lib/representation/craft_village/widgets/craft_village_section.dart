import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:travelogue_mobile/core/blocs/workshop/workshop_bloc.dart';
import 'package:travelogue_mobile/representation/workshop/screens/workshop_detail_screen.dart';

class CraftVillageSection extends StatelessWidget {
  final String title;
  final IconData? icon;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  const CraftVillageSection({
    super.key,
    required this.title,
    this.icon,
    required this.children,
    this.padding,
  });

  factory CraftVillageSection.fromCraftVillage({
    Key? key,
    required dynamic craftVillage,
    String title = 'Thông tin làng nghề',
    IconData icon = Icons.info_outline,
    EdgeInsetsGeometry? padding,
  }) {
    T? _pick<T>(dynamic src, T? Function() getFromModel, String mapKey) {
      try {
        final v = getFromModel();
        if (v != null) return v;
      } catch (_) {}
      if (src is Map) {
        final raw = src[mapKey];
        if (raw is T) return raw;
        if (raw != null) return raw as T?;
      }
      return null;
    }

    String _str(dynamic v) => (v == null) ? '' : v.toString();

    final phone = _str(_pick<String>(craftVillage, () => (craftVillage as dynamic).phoneNumber as String?, 'phoneNumber'));
    final email = _str(_pick<String>(craftVillage, () => (craftVillage as dynamic).email as String?, 'email'));
    final website = _str(_pick<String>(craftVillage, () => (craftVillage as dynamic).website as String?, 'website'));
    final signatureProduct = _str(_pick<String>(craftVillage, () => (craftVillage as dynamic).signatureProduct as String?, 'signatureProduct'));
    final yearsOfHistory = _pick<num>(craftVillage, () => (craftVillage as dynamic).yearsOfHistory as num?, 'yearsOfHistory');
    final workshopsAvailable = _pick<bool>(craftVillage, () => (craftVillage as dynamic).workshopsAvailable as bool?, 'workshopsAvailable') == true;
    final isRecognizedByUnesco = _pick<bool>(craftVillage, () => (craftVillage as dynamic).isRecognizedByUnesco as bool?, 'isRecognizedByUnesco') == true;

    final items = <Widget>[
      CraftInfoRow(icon: Icons.phone, label: 'Điện thoại:', value: phone),
      CraftInfoRow(icon: Icons.email, label: 'Email:', value: email),
      CraftInfoRow(icon: Icons.public, label: 'Website:', value: website),
      CraftInfoRow(icon: Icons.work, label: 'Sản phẩm đặc trưng:', value: signatureProduct),
      if (yearsOfHistory != null)
        CraftInfoRow(icon: Icons.history_edu, label: 'Số năm lịch sử:', value: '${yearsOfHistory.toInt()} năm'),
      CraftInfoRow(icon: Icons.school_outlined, label: 'Có workshop:', value: workshopsAvailable ? 'Có' : 'Không'),
      CraftInfoRow(icon: Icons.verified_outlined, label: 'UNESCO công nhận:', value: isRecognizedByUnesco ? 'Có' : 'Không'),
    ];

    return CraftVillageSection(
      key: key,
      title: title,
      icon: icon,
      children: [
        _SectionCard(
          icon: icon,
          title: title,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _withSpacing(items, gap: 8),
          ),
        ),
      ],
      padding: padding,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(vertical: 1.2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  static List<Widget> _withSpacing(List<Widget> items, {double gap = 8}) {
    final out = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      out.add(items[i]);
      if (i != items.length - 1) out.add(SizedBox(height: gap));
    }
    return out;
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Widget child;
  const _SectionCard({required this.title, required this.child, this.icon});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12.withOpacity(.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
        builder: (_, t, child) => Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 8),
            child: child,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              if (icon != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: Gradients.defaultGradientBackground, // 🌈
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.white, size: 18),
                ),
              if (icon != null) const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 14.5.sp, fontWeight: FontWeight.w900),
                ),
              ),
            ]),
            SizedBox(height: .8.h),
            child,
          ],
        ),
      ),
    );
  }
}

class CraftInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const CraftInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  bool get _isPhone => RegExp(r'^\+?\d[\d\s\-().]{3,}$').hasMatch(value.trim());
  bool get _isEmail => RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value.trim());
  bool get _isUrl {
    final v = value.trim();
    return v.startsWith('http://') || v.startsWith('https://') ||
        RegExp(r'^[\w\-]+\.[\w\-.]+(/.*)?$').hasMatch(v);
  }

  Uri? get _launchUri {
    final v = value.trim();
    if (_isPhone) return Uri(scheme: 'tel', path: v.replaceAll(' ', ''));
    if (_isEmail) return Uri(scheme: 'mailto', path: v);
    if (_isUrl)   return v.startsWith('http') ? Uri.tryParse(v) : Uri.tryParse('https://$v');
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (value.trim().isEmpty) return const SizedBox.shrink();
    final clickable = _launchUri != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: clickable
            ? () async {
                final ok = await launchUrl(_launchUri!, mode: LaunchMode.externalApplication);
                if (!ok && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Không thể mở liên kết'), behavior: SnackBarBehavior.floating, duration: Duration(seconds: 1)),
                  );
                }
              }
            : null,
        onLongPress: () async {
          await Clipboard.setData(ClipboardData(text: value));
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đã sao chép'), behavior: SnackBarBehavior.floating, duration: Duration(seconds: 1)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 18, color: Colors.blueGrey),
              const SizedBox(width: 10),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black87, height: 1.35),
                    children: [
                      TextSpan(text: '$label ', style: const TextStyle(fontWeight: FontWeight.w800)),
                      TextSpan(text: value),
                    ],
                  ),
                ),
              ),
              if (clickable) ...[
                const SizedBox(width: 6),
                Icon(Icons.open_in_new_rounded, size: 16, color: Theme.of(context).hintColor),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class WorkshopPreviewCard extends StatelessWidget {
  final dynamic workshop;

  const WorkshopPreviewCard({super.key, required this.workshop});

  @override
  Widget build(BuildContext context) {
    String _s(dynamic v) => v == null ? '' : v.toString();

    final id = _pick<String>(() => workshop.id as String?, 'id');
    final name = _pick<String>(() => workshop.name as String?, 'name');
    final description = _pick<String>(() => workshop.description as String?, 'description');
    final List tickets = _pickList<dynamic>(() => (workshop.ticketTypes as List?)?.cast(), 'ticketTypes');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12.withOpacity(.06)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 16, offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.handyman_outlined),
            const SizedBox(width: 8),
            Expanded(child: Text(_s(name), style: TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.w900))),
          ]),
          if (_s(description).isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(_s(description), style: const TextStyle(height: 1.4)),
          ],

          if (tickets.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text('Loại vé', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16.sp)),
            const SizedBox(height: 8),
            ...tickets.map((t) => _TicketTile(ticket: t)).toList(),
          ],

          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: _GradientButton(
              onPressed: (id == null || id.isEmpty) ? null : () => _goToDetail(context, id),
              child: Row(mainAxisSize: MainAxisSize.min, children: const [
                Text('Xem chi tiết workshop'),
                SizedBox(width: 8),
                Icon(Icons.chevron_right_rounded, color: Colors.white),
              ]),
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
          child: WorkshopDetailScreen(workshopId: workshopId),
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
      final m = ticket as dynamic;
      name = m.name?.toString() ?? '';
      final p = m.price;
      price = p is num ? p : num.tryParse(p?.toString() ?? '');
      final d = m.durationMinutes;
      dur = d is num ? d.toInt() : int.tryParse(d?.toString() ?? '');
    } catch (_) {
      final map = ticket as Map<String, dynamic>;
      name = map['name']?.toString() ?? '';
      final p = map['price'];
      price = p is num ? p : num.tryParse(p?.toString() ?? '');
      final d = map['durationMinutes'];
      dur = d is num ? d.toInt() : int.tryParse(d?.toString() ?? '');
    }

    final pieces = <String>[
      if (name.isNotEmpty) name,
      if (dur != null && dur > 0) "${dur}'",
      if (price != null) _money(price),
    ];

    return Row(
      children: [
        const Icon(Icons.confirmation_number_outlined, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(pieces.join(' • '), style: const TextStyle(fontWeight: FontWeight.w600))),
      ],
    );
  }
}


class _GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius; 

  const _GradientButton({
    required this.onPressed,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)), 
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: enabled ? Gradients.defaultGradientBackground : null,
        color: enabled ? null : Colors.grey.shade300,
        borderRadius: borderRadius,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onPressed,
          borderRadius: borderRadius, 
          child: Padding(
            padding: padding,
            child: DefaultTextStyle(
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}
