// lib/features/tour/presentation/widgets/chip_pill.dart
import 'package:flutter/material.dart';

enum ChipTone { primary, neutral }

class ChipPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final ChipTone tone;
  const ChipPill({
    super.key,
    required this.icon,
    required this.label,
    this.tone = ChipTone.primary,
  });

  @override
  Widget build(BuildContext context) {
    final bg = tone == ChipTone.primary ? const Color(0xFFEFF6FF) : const Color(0xFFF3F4F6);
    final fg = tone == ChipTone.primary ? const Color(0xFF2563EB) : const Color(0xFF374151);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: fg.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 12, color: fg, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
