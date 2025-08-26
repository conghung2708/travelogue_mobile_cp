// lib/features/tour/presentation/widgets/participants_editor.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/model/booking/booking_participant_model.dart';

class ParticipantsEditor extends StatelessWidget {
  final List<BookingParticipantModel> rows;
  final VoidCallback onChanged;
  final void Function(int index) onRemove;
  final VoidCallback onAdd;
  final void Function(int index) onPickDob;

  const ParticipantsEditor({
    super.key,
    required this.rows,
    required this.onChanged,
    required this.onRemove,
    required this.onAdd,
    required this.onPickDob,
  });

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd/MM/yyyy');

    final glass = BoxDecoration(
      color: Colors.white.withOpacity(0.08),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Colors.white.withOpacity(0.15)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 10,
          offset: const Offset(0, 6),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Text(
              'Hành khách',
              style: TextStyle(
                fontSize: 14.5.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 2.w),
            _CounterTag(count: rows.length),
            const Spacer(),
            _AddButton(onPressed: onAdd),
          ],
        ),
        SizedBox(height: 1.2.h),

        // List
        ListView.separated(
          itemCount: rows.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (_, __) => SizedBox(height: 1.2.h),
          itemBuilder: (context, i) {
            final p = rows[i];

            return Container(
              decoration: glass,
              padding: EdgeInsets.all(3.6.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row with index + delete
                  Row(
                    children: [
                      _AvatarIndex(index: i + 1),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          p.fullName.isEmpty
                              ? 'Hành khách ${i + 1}'
                              : p.fullName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Xoá',
                        onPressed: () => onRemove(i),
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.2.h),

                  // Họ tên
                  TextFormField(
                    initialValue: p.fullName,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    decoration: _decor(
                      context,
                      label: 'Họ tên',
                      prefix: Icons.person_outline_rounded,
                    ),
                    onChanged: (v) {
                      rows[i] = BookingParticipantModel(
                        type: p.type,
                        fullName: v,
                        gender: p.gender,
                        dateOfBirth: p.dateOfBirth,
                      );
                      onChanged();
                    },
                  ),
                  SizedBox(height: 1.2.h),

                  // Dropdowns: Giới tính + Đối tượng
                  Row(
                    children: [
                      // Giới tính
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: p.gender,
                          isExpanded: true,
                          dropdownColor: Colors.black87,
                          style: const TextStyle(color: Colors.white),
                          iconEnabledColor: Colors.white70,
                          decoration: _decor(
                            context,
                            label: 'Giới tính',
                            prefix: Icons.wc_rounded,
                          ).copyWith(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(value: 2, child: Text('Nữ')),
                            DropdownMenuItem(value: 1, child: Text('Nam')),
                          ],
                          // Hiển thị rút gọn khi đã chọn
                          selectedItemBuilder: (ctx) => const [
                            Text('Nữ',
                                overflow: TextOverflow.ellipsis, maxLines: 1),
                            Text('Nam',
                                overflow: TextOverflow.ellipsis, maxLines: 1),
                          ],
                          onChanged: (val) {
                            if (val == null) return;
                            rows[i] = BookingParticipantModel(
                              type: p.type,
                              fullName: p.fullName,
                              gender: val,
                              dateOfBirth: p.dateOfBirth,
                            );
                            onChanged();
                          },
                        ),
                      ),
                      SizedBox(width: 3.w),

                      // Đối tượng
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: p.type,
                          isExpanded: true,
                          dropdownColor: Colors.black87,
                          style: const TextStyle(color: Colors.white),
                          iconEnabledColor: Colors.white70,
                          decoration: _decor(
                            context,
                            label: 'Đối tượng',
                            prefix: Icons.badge_outlined,
                          ).copyWith(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                                value: 1, child: Text('Người lớn')),
                            DropdownMenuItem(value: 2, child: Text('Trẻ em')),
                          ],
                          selectedItemBuilder: (ctx) => const [
                            Text('Người lớn',
                                overflow: TextOverflow.ellipsis, maxLines: 1),
                            Text('Trẻ em',
                                overflow: TextOverflow.ellipsis, maxLines: 1),
                          ],
                          onChanged: (val) {
                            if (val == null) return;

                            final now = DateTime.now();
                            var newDob = p.dateOfBirth;
                            final age = _ageFromDob(p.dateOfBirth);

                            if (val == 2) {
                              // Trẻ em: 5–11
                              if (age < 5 || age > 11) {
                                newDob = DateTime(
                                    now.year - 8, now.month, now.day); // ~8 tuổi
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Đã điều chỉnh ngày sinh về ${df.format(newDob)} để phù hợp Trẻ em (5–11).',
                                    ),
                                  ),
                                );
                              }
                            } else {
                              // Người lớn: ≥12
                              if (age < 12) {
                                newDob = DateTime(now.year - 18, now.month,
                                    now.day); // ~18 tuổi
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Người lớn yêu cầu từ 12 tuổi trở lên. Đã điều chỉnh ngày sinh.',
                                    ),
                                  ),
                                );
                              }
                            }

                            rows[i] = BookingParticipantModel(
                              type: val,
                              fullName: p.fullName,
                              gender: p.gender,
                              dateOfBirth: newDob,
                            );
                            onChanged();
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.2.h),

                  // Ngày sinh
                  InkWell(
                    onTap: () => onPickDob(i),
                    borderRadius: BorderRadius.circular(12),
                    child: InputDecorator(
                      decoration: _decor(
                        context,
                        label: 'Ngày sinh',
                        prefix: Icons.event,
                      ).copyWith(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                    
                            child: Text(
                              df.format(p.dateOfBirth),
                              style: const TextStyle(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const Icon(Icons.edit_calendar_rounded,
                              color: Colors.white70, size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

 
  InputDecoration _decor(
    BuildContext context, {
    required String label,
    IconData? prefix,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon:
          prefix == null ? null : Icon(prefix, color: Colors.white70, size: 18),
      isDense: true,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10), // ★
      filled: true,
      fillColor: Colors.white.withOpacity(0.06),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.25)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.55)),
      ),
    );
  }
}



class _CounterTag extends StatelessWidget {
  final int count;
  const _CounterTag({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.4.w, vertical: 0.6.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.people_outline, color: Colors.white70, size: 16),
          SizedBox(width: 1.6.w),
          Text('$count', style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _AddButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.person_add_alt_1_rounded),
      label: const Text('Thêm'),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: Colors.white,
        backgroundColor: Colors.lightBlueAccent.withOpacity(0.35),
        padding: EdgeInsets.symmetric(horizontal: 3.6.w, vertical: 1.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _AvatarIndex extends StatelessWidget {
  final int index;
  const _AvatarIndex({required this.index});
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: Colors.white.withOpacity(0.18),
      child: Text(
        '$index',
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
    );
  }
}

/* ========= Helpers ========= */

int _ageFromDob(DateTime dob) {
  final now = DateTime.now();
  int age = now.year - dob.year;
  if (now.month < dob.month ||
      (now.month == dob.month && now.day < dob.day)) {
    age--;
  }
  return age;
}
