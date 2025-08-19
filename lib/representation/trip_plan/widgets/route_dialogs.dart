import 'package:flutter/material.dart';

class RouteDialogs {
  // ===== THEME CONSTANTS =====
  static const Color _kBlue = Color(0xFF1565C0); // primary
  static const Color _kBlueLight = Color(0xFFE3F2FD); // buttons / chips bg
  static const Color _kBlueSurface = Color(0xFFEEF6FF); // panels

  static ButtonStyle _tonalBlueButton(BuildContext context) =>
      ElevatedButton.styleFrom(
        backgroundColor: _kBlueLight,
        foregroundColor: _kBlue,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      );

  static Widget _dialogAction(
    BuildContext context,
    String label, {
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: _tonalBlueButton(context).copyWith(
        backgroundColor:
            WidgetStatePropertyAll(isPrimary ? _kBlue : _kBlueLight),
        foregroundColor:
            WidgetStatePropertyAll(isPrimary ? Colors.white : _kBlue),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  static Theme _wrapDialog(BuildContext context, Widget child) {
    final base = Theme.of(context);
    return Theme(
      data: base.copyWith(
        dialogTheme: DialogTheme(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          titleTextStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: _kBlue,
          ),
          contentTextStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade800,
            height: 1.4,
          ),
        ),
      ),
      child: child,
    );
  }

  // ===================== PUBLIC APIs (LOGIC UNCHANGED) =====================
  static Future<int?> askStayMinutes(BuildContext context) async {
    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final controller = TextEditingController();
        final viewInsets = MediaQuery.of(ctx).viewInsets.bottom;

        Widget quickBtn(int m) => ElevatedButton(
              style: _tonalBlueButton(ctx),
              onPressed: () => Navigator.pop(ctx, m),
              child: Text('$m phút', style: const TextStyle(fontWeight: FontWeight.w600)),
            );

        return Padding(
          padding: EdgeInsets.only(bottom: viewInsets),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.timer, color: _kBlue),
                        SizedBox(width: 8),
                        Text('Bạn muốn ở đây bao lâu?',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _kBlue)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: _kBlueSurface,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            for (final m in const [30, 60, 90, 120]) quickBtn(m),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Hoặc nhập số phút',
                        hintText: 'Ví dụ: 75',
                        filled: true,
                        fillColor: _kBlueSurface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.edit, color: _kBlue),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: _tonalBlueButton(ctx).copyWith(
                          backgroundColor: const WidgetStatePropertyAll(_kBlue),
                          foregroundColor: const WidgetStatePropertyAll(Colors.white),
                        ),
                        onPressed: () {
                          final v = int.tryParse(controller.text.trim());
                          Navigator.pop(ctx, (v == null || v <= 0) ? null : v);
                        },
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Xác nhận', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<bool> showFirstStopDialog({
    required BuildContext context,
    required String placeName,
    required DateTime arrival,
    required DateTime depart,
    required int stayMinutes,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) {
            return _wrapDialog(
              ctx,
              AlertDialog(
                titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                title: Row(children: const [
                  Icon(Icons.flag_circle, color: _kBlue), SizedBox(width: 8), Text('Xác nhận điểm đầu tiên')]),
                content: _infoPanel([
                  _titleText(placeName),
                  const SizedBox(height: 10),
                  _rowIconText(Icons.login, 'Đến: ${_fmtTime(arrival)}'),
                  const SizedBox(height: 6),
                  _rowIconText(Icons.logout, 'Rời: ${_fmtTime(depart)} (${_fmtDurationMinutes(stayMinutes)})'),
                ]),
                actions: [
                  _dialogAction(ctx, 'Huỷ', onPressed: () => Navigator.pop(ctx, false)),
                  _dialogAction(ctx, 'Thêm', isPrimary: true, onPressed: () => Navigator.pop(ctx, true)),
                ],
              ),
            );
          },
        ) ??
        false;
  }

  static Future<bool> showRouteSummaryDialog({
    required BuildContext context,
    required String placeName,
    required double distanceKm,
    required int travelMinutes,
    required DateTime arrival,
    required DateTime depart,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) {
            return _wrapDialog(
              ctx,
              AlertDialog(
                titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                title: Row(children: const [
                  Icon(Icons.route, color: _kBlue), SizedBox(width: 8), Text('Xác nhận lộ trình')]),
                content: _infoPanel([
                  _titleText(placeName),
                  const SizedBox(height: 10),
                  _rowIconText(Icons.timeline, '${distanceKm.toStringAsFixed(1)} km • ${_fmtDurationMinutes(travelMinutes)}'),
                  const SizedBox(height: 10),
                  _rowIconText(Icons.login, 'Đến: ${_fmtTime(arrival)}'),
                  const SizedBox(height: 6),
                  _rowIconText(Icons.logout, 'Rời: ${_fmtTime(depart)}'),
                ]),
                actions: [
                  _dialogAction(ctx, 'Huỷ', onPressed: () => Navigator.pop(ctx, false)),
                  _dialogAction(ctx, 'Thêm', isPrimary: true, onPressed: () => Navigator.pop(ctx, true)),
                ],
              ),
            );
          },
        ) ??
        false;
  }

  // ===================== SMALL UI HELPERS =====================
  static Widget _infoPanel(List<Widget> children) => DecoratedBox(
        decoration: BoxDecoration(
          color: _kBlueSurface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(padding: const EdgeInsets.all(12), child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        )),
      );

  static Widget _titleText(String text) => Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: _kBlue),
      );

  static Widget _rowIconText(IconData icon, String text) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: _kBlue), const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      );

  // ===================== PURE FORMATTERS (UNCHANGED) =====================
  static String _fmtTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}'
          .toString();

  static String _fmtDurationMinutes(int minutes) {
    if (minutes < 60) return '$minutes phút';
    final h = minutes ~/ 60, m = minutes % 60;
    return m == 0 ? '$h giờ' : '$h giờ $m phút';
  }
}
