import 'package:flutter/material.dart';

class ColorPalette {
  static const Color primaryColor = Color(0xFF27A4F2);
  static const Color secondColor = Color(0xFF6EC2F7);
  static const Color yellowColor = Color(0xFFFFD27B);

  static const Color dividerColor = Color(0xFFB0DFFC);
  static const Color text1Color = Colors.black;
  static const Color subTitleColor = Color(0xFF529FD9);
  static const Color backgroundScaffoldColor = Color(0xFFF2F2F2);
}

class Gradients {
  static const Gradient defaultGradientBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomLeft,
    colors: [
      ColorPalette.secondColor,
      ColorPalette.primaryColor,
    ],
  );
}


class _GradientButton extends StatelessWidget {
  const _GradientButton({
    Key? key,
    required this.label,
    required this.onTap,
    this.icon,
    this.padding = const EdgeInsets.symmetric(vertical: 12),
  }) : super(key: key);

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        decoration: BoxDecoration(
          gradient: Gradients.defaultGradientBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: padding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: Colors.white),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  const _OutlineButton({
    Key? key,
    required this.label,
    required this.onTap,
    this.padding = const EdgeInsets.symmetric(vertical: 12),
  }) : super(key: key);

  final String label;
  final VoidCallback onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: padding,
        foregroundColor: Colors.black87,
        side: const BorderSide(color: ColorPalette.dividerColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onTap,
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}



// ignore: unused_element
Future<double?> _showChangeRadiusDialog(
  BuildContext context, {
  required double currentKm,
}) {
  final controller =
      TextEditingController(text: currentKm.toStringAsFixed(0));

  return showDialog<double>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: ColorPalette.secondColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.tune,
                        color: ColorPalette.primaryColor, size: 26),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Đổi bán kính (km)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: ColorPalette.primaryColor,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Ví dụ: 15',
                  suffixText: 'km',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _OutlineButton(
                      label: 'Hủy',
                      onTap: () => Navigator.of(ctx).pop(null),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _GradientButton(
                      label: 'Lưu',
                      icon: Icons.save_outlined,
                      onTap: () {
                        final v = double.tryParse(
                          controller.text.trim().replaceAll(',', '.'),
                        );
                        if (v == null || v <= 0) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            const SnackBar(
                              content: Text('Vui lòng nhập số km hợp lệ.'),
                            ),
                          );
                          return;
                        }
                        Navigator.of(ctx).pop(v);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
