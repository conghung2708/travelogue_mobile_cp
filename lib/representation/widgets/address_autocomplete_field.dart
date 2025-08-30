// lib/representation/common/address_autocomplete_field.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:travelogue_mobile/core/services/vietmap_search_service.dart';

class AddressAutocompleteField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final bool Function(String)? validator;
  final void Function(String)? onSelected;

  const AddressAutocompleteField({
    Key? key,
    required this.controller,
    this.hintText = 'Nhập địa chỉ',
    this.labelText,
    this.validator,
    this.onSelected,
  }) : super(key: key);

  @override
  State<AddressAutocompleteField> createState() =>
      _AddressAutocompleteFieldState();
}

class _AddressAutocompleteFieldState extends State<AddressAutocompleteField> {
  final _focusNode = FocusNode();
  final _link = LayerLink();
  OverlayEntry? _entry;
  Timer? _deb;
  List<String> _sugs = [];
  bool _loading = false;
  String? _err;

  bool _looksSearchable(String q) {
    final t = q.trim();
    if (t.length < 2) return false;
    return RegExp(r'[A-Za-zÀ-ỹ0-9]', caseSensitive: false).hasMatch(t);
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocus);
    widget.controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    _deb?.cancel();
    _remove();
    _focusNode.removeListener(_onFocus);
    widget.controller.removeListener(_onChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocus() {
    if (_focusNode.hasFocus) {
      final q = widget.controller.text.trim();
      if (_looksSearchable(q)) _fetch(q);
    } else {
      _remove();
      _validate();
    }
  }

  void _onChanged() {
    _deb?.cancel();
    _deb = Timer(const Duration(milliseconds: 300), () {
      if (!_focusNode.hasFocus) return;
      final q = widget.controller.text;
      if (!_looksSearchable(q)) {
        _sugs = [];
        _remove();
        setState(() {});
        return;
      }
      _fetch(q.trim());
    });
  }

  Future<void> _fetch(String q) async {
    setState(() => _loading = true);
    final res = await VietmapSearchService.autocompleteTayNinh(q);
    _sugs = res;
    _loading = false;

    if (_sugs.isNotEmpty && _focusNode.hasFocus) {
      _show();
    } else {
      _remove();
    }
    setState(() {});
  }

  void _show() {
    _remove();
    final overlay = Overlay.of(context, rootOverlay: true);
    _entry = OverlayEntry(
      builder: (ctx) {
        final box = context.findRenderObject() as RenderBox?;
        final size = box?.size ?? Size.zero;
        return Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: _link,
            offset: Offset(0, size.height + 6),
            showWhenUnlinked: false,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 260),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  itemCount: _sugs.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final s = _sugs[i];
                    return ListTile(
                      dense: true,
                      leading: const Icon(Icons.place_outlined),
                      title: Text(s, style: const TextStyle(fontSize: 14)),
                      onTap: () {
                        widget.controller.text = s;
                        widget.controller.selection =
                            TextSelection.collapsed(offset: s.length);
                        widget.onSelected?.call(s);
                        _remove();
                        FocusScope.of(context).unfocus();
                        _validate();
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
    overlay?.insert(_entry!);
  }

  void _remove() {
    _entry?.remove();
    _entry = null;
  }

  void _validate() {
    if (widget.validator != null) {
      final ok = widget.validator!(widget.controller.text.trim());
      setState(() => _err = ok ? null : 'Địa chỉ phải thuộc Tây Ninh');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          labelText: widget.labelText ?? 'Địa chỉ (Tây Ninh)',
          hintText: widget.hintText,
          prefixIcon: const Icon(Icons.place_rounded),
          suffixIcon: _loading
              ? const Padding(
                  padding: EdgeInsets.all(10),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : (_err == null
                  ? const Icon(Icons.verified_rounded, color: Colors.green)
                  : const Icon(Icons.error_outline_rounded,
                      color: Colors.redAccent)),
          errorText: _err,
          filled: true,
          fillColor: const Color(0xFFF7FAFF),
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _validate(),
      ),
    );
  }
}
