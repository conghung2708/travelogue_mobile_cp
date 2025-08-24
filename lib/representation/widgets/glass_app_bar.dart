// lib/widgets/glass_app_bar.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GlassAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions = const [],
    this.bottom,
    this.blur = 18,
    this.backgroundOpacity = .72,
    this.centerTitle = false,
    this.leading,
    this.automaticallyImplyLeading,
  });

  /// Tiêu đề lớn (đậm, canh trái mặc định)
  final String title;

  /// Dòng mô tả nhỏ (tuỳ chọn)
  final String? subtitle;

  /// Actions mặc định của AppBar
  final List<Widget> actions;

  /// Bottom (tab/filter…) nếu có
  final PreferredSizeWidget? bottom;

  /// Mức blur nền kính
  final double blur;

  /// Độ trong suốt nền kính
  final double backgroundOpacity;

  /// Có canh giữa title không (mặc định false — canh trái đẹp hơn)
  final bool centerTitle;

  /// Leading custom (nếu null sẽ tự hiển thị nút back dạng glass khi có thể pop)
  final Widget? leading;

  /// Ghi đè logic hiển thị leading tự động
  final bool? automaticallyImplyLeading;

  @override
  Size get preferredSize {
    final base = 64.0 + (subtitle != null ? 4.0 : 0.0);
    return Size.fromHeight(base + (bottom?.preferredSize.height ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    // Nền kính
    final Color bg = (isDark ? const Color(0xFF0B0F1A) : Colors.white)
        .withOpacity(backgroundOpacity);

    // Viền/line đáy
    final Color borderColor =
        (isDark ? Colors.white : Colors.black).withOpacity(.08);

    // Tự động show nút back nếu có thể pop
    final bool canPop = Navigator.maybeOf(context)?.canPop() == true;
    final bool showAutoBack = (automaticallyImplyLeading ?? true) &&
        leading == null &&
        canPop;

    final Widget? effectiveLeading =
        leading ?? (showAutoBack ? _GlassBackButton(onTap: () => Navigator.pop(context)) : null);

    return ClipRRect(
      // Không bo góc AppBar để khớp safe area, chỉ glass bên trong
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: AppBar(
          systemOverlayStyle: isDark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          elevation: 0,
          backgroundColor: bg,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          toolbarHeight: preferredSize.height - (bottom?.preferredSize.height ?? 0),
          centerTitle: centerTitle,
          titleSpacing: centerTitle ? 0 : 12,
          leadingWidth: 56,
          leading: effectiveLeading,
          actions: actions,
          bottom: bottom,
          flexibleSpace: DecoratedBox(
            decoration: BoxDecoration(
              // lớp “ánh sáng” nhẹ theo chiều dọc để nhìn có chiều sâu
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [
                        Colors.white.withOpacity(.04),
                        Colors.white.withOpacity(.02),
                        Colors.white.withOpacity(.00),
                      ]
                    : [
                        Colors.white.withOpacity(.35),
                        Colors.white.withOpacity(.18),
                        Colors.white.withOpacity(.00),
                      ],
              ),
              border: Border(
                bottom: BorderSide(color: borderColor, width: 1),
              ),
            ),
          ),
          title: _TitleBlock(
            title: title,
            subtitle: subtitle,
            isDark: isDark,
            center: centerTitle,
          ),
        ),
      ),
    );
  }
}

/* ---------- Title block (đậm, gọn) ---------- */
class _TitleBlock extends StatelessWidget {
  const _TitleBlock({
    required this.title,
    required this.isDark,
    required this.center,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final bool isDark;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final colorPrimary = isDark ? Colors.white : const Color(0xFF0B1B3F);
    final colorSub = isDark ? Colors.white70 : Colors.black.withOpacity(.62);

    final titleWidget = Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: colorPrimary,
        fontWeight: FontWeight.w900,
        fontSize: 18,
        letterSpacing: .2,
        height: 1.1,
      ),
    );

    if (subtitle == null) {
      return Align(
        alignment: center ? Alignment.center : Alignment.centerLeft,
        child: titleWidget,
      );
    }

    return Align(
      alignment: center ? Alignment.center : Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          titleWidget,
          const SizedBox(height: 2),
          Text(
            subtitle!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colorSub,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              letterSpacing: .1,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

/* ---------- Glass back button tròn ---------- */
class _GlassBackButton extends StatelessWidget {
  const _GlassBackButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          height: 36,
          width: 36,
          decoration: BoxDecoration(
            color: (isDark ? Colors.white : Colors.black).withOpacity(.08),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: (isDark ? Colors.white : Colors.black).withOpacity(.12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: isDark ? Colors.white : const Color(0xFF0B1B3F),
          ),
        ),
      ),
    );
  }
}
