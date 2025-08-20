// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:sizer/sizer.dart';
// import 'package:travelogue_mobile/model/booking/booking_participant_model.dart';
// import 'package:travelogue_mobile/model/booking/create_booking_tour_model.dart';

// class BookingContactParticipantsSheet extends StatefulWidget {
//   final String tourId;
//   final String scheduledId;
//   final int initAdults;
//   final int initChildren;
//   final String? prefillName;
//   final String? prefillEmail;
//   final String? prefillPhone;
//   final String? prefillAddress;

//   const BookingContactParticipantsSheet({
//     super.key,
//     required this.tourId,
//     required this.scheduledId,
//     required this.initAdults,
//     required this.initChildren,
//     this.prefillName,
//     this.prefillEmail,
//     this.prefillPhone,
//     this.prefillAddress,
//   });

//   @override
//   State<BookingContactParticipantsSheet> createState() =>
//       BookingContactParticipantsSheetState();
// }

// class BookingContactParticipantsSheetState
//     extends State<BookingContactParticipantsSheet> {
//   final _formKey = GlobalKey<FormState>();

//   late final TextEditingController _nameCtl;
//   late final TextEditingController _emailCtl;
//   late final TextEditingController _phoneCtl;
//   late final TextEditingController _addrCtl;

//   final List<BookingParticipantModel> _rows = [];

//   @override
//   void initState() {
//     super.initState();
//     _nameCtl  = TextEditingController(text: widget.prefillName ?? '');
//     _emailCtl = TextEditingController(text: widget.prefillEmail ?? '');
//     _phoneCtl = TextEditingController(text: widget.prefillPhone ?? '');
//     _addrCtl  = TextEditingController(text: widget.prefillAddress ?? '');

//     for (int i = 0; i < widget.initAdults; i++) {
//       _rows.add(BookingParticipantModel(
//         type: 1, fullName: '', gender: 1, dateOfBirth: DateTime(1990, 1, 1),
//       ));
//     }
//     for (int i = 0; i < widget.initChildren; i++) {
//       _rows.add(BookingParticipantModel(
//         type: 2, fullName: '', gender: 0, dateOfBirth: DateTime(2015, 1, 1),
//       ));
//     }
//   }

//   @override
//   void dispose() {
//     _nameCtl.dispose();
//     _emailCtl.dispose();
//     _phoneCtl.dispose();
//     _addrCtl.dispose();
//     super.dispose();
//   }

//   Future<void> _pickDob(int index) async {
//     final now = DateTime.now();
//     final init = _rows[index].dateOfBirth;
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: init.isAfter(now) ? DateTime(now.year - 18, now.month, now.day) : init,
//       firstDate: DateTime(now.year - 100),
//       lastDate: now,
//       helpText: 'Chọn ngày sinh',
//       locale: const Locale('vi', 'VN'),
//     );
//     if (picked != null) {
//       setState(() {
//         _rows[index] = BookingParticipantModel(
//           type: _rows[index].type,
//           fullName: _rows[index].fullName,
//           gender: _rows[index].gender,
//           dateOfBirth: picked,
//         );
//       });
//     }
//   }

//   bool _validateParticipants() {
//     final now = DateTime.now();
//     if (_rows.isEmpty) return false;
//     for (final p in _rows) {
//       if (p.fullName.trim().isEmpty) return false;
//       if (p.gender != 0 && p.gender != 1) return false;
//       if (p.type != 1 && p.type != 2) return false;
//       if (p.dateOfBirth.isAfter(now)) return false;
//     }
//     return true;
//   }

//   void _onSubmit() {
//     if (!_formKey.currentState!.validate()) return;
//     if (!_validateParticipants()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Vui lòng kiểm tra thông tin hành khách.')),
//       );
//       return;
//     }

//     final payload = CreateBookingTourModel(
//       tourId: widget.tourId,
//       scheduledId: widget.scheduledId,
//       promotionCode: null,
//       contactName: _nameCtl.text.trim(),
//       contactEmail: _emailCtl.text.trim(),
//       contactPhone: _phoneCtl.text.trim(),
//       contactAddress: _addrCtl.text.trim(),
//       participants: _rows,
//     );

//     Navigator.of(context).pop(payload);
//   }

//   String _genderText(int g) => g == 0 ? 'Nữ' : 'Nam';
//   String _typeText(int t) => t == 1 ? 'Người lớn' : 'Trẻ em';

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//         top: 2.h, left: 4.w, right: 4.w,
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               width: 12.w, height: 0.7.h, margin: EdgeInsets.only(bottom: 1.5.h),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade300, borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             Text('Thông tin liên hệ & Hành khách',
//                 style: TextStyle(fontSize: 14.5.sp, fontWeight: FontWeight.w700)),
//             SizedBox(height: 2.h),

//             Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   // Contact
//                   Container(
//                     padding: EdgeInsets.all(3.w),
//                     decoration: BoxDecoration(
//                       color: Colors.blue.withOpacity(0.06),
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.blue.withOpacity(0.15)),
//                     ),
//                     child: Column(
//                       children: [
//                         _LabeledField(
//                           label: 'Họ và tên',
//                           controller: _nameCtl,
//                           keyboardType: TextInputType.name,
//                           validator: (v) => (v == null || v.trim().isEmpty) ? 'Nhập họ và tên' : null,
//                         ),
//                         SizedBox(height: 1.h),
//                         _LabeledField(
//                           label: 'Email',
//                           controller: _emailCtl,
//                           keyboardType: TextInputType.emailAddress,
//                           validator: (v) {
//                             if (v == null || v.trim().isEmpty) return 'Nhập email';
//                             final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim());
//                             return ok ? null : 'Email không hợp lệ';
//                           },
//                         ),
//                         SizedBox(height: 1.h),
//                         _LabeledField(
//                           label: 'Số điện thoại',
//                           controller: _phoneCtl,
//                           keyboardType: TextInputType.phone,
//                           validator: (v) => (v == null || v.trim().length < 8) ? 'SĐT không hợp lệ' : null,
//                         ),
//                         SizedBox(height: 1.h),
//                         _LabeledField(
//                           label: 'Địa chỉ',
//                           controller: _addrCtl,
//                           keyboardType: TextInputType.streetAddress,
//                           validator: (v) => (v == null || v.trim().isEmpty) ? 'Nhập địa chỉ' : null,
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 2.h),

//                   Row(
//                     children: [
//                       Text('Hành khách', style: TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.w700)),
//                       const Spacer(),
//                       IconButton(
//                         tooltip: 'Thêm hành khách',
//                         onPressed: () {
//                           setState(() {
//                             _rows.add(BookingParticipantModel(
//                               type: 1, fullName: '', gender: 1, dateOfBirth: DateTime(1990, 1, 1),
//                             ));
//                           });
//                         },
//                         icon: const Icon(Icons.person_add_alt_1_rounded),
//                       ),
//                     ],
//                   ),

//                   ListView.builder(
//                     itemCount: _rows.length,
//                     physics: const NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     itemBuilder: (context, i) {
//                       final p = _rows[i];
//                       final dob = DateFormat('dd/MM/yyyy').format(p.dateOfBirth);
//                       return Card(
//                         margin: EdgeInsets.only(bottom: 1.h),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                         elevation: 0,
//                         color: Colors.grey.withOpacity(0.06),
//                         child: Padding(
//                           padding: EdgeInsets.all(3.w),
//                           child: Column(
//                             children: [
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: TextFormField(
//                                       initialValue: p.fullName,
//                                       decoration: const InputDecoration(
//                                         labelText: 'Họ tên',
//                                         border: OutlineInputBorder(),
//                                         isDense: true,
//                                       ),
//                                       onChanged: (v) {
//                                         _rows[i] = BookingParticipantModel(
//                                           type: p.type, fullName: v, gender: p.gender, dateOfBirth: p.dateOfBirth,
//                                         );
//                                       },
//                                       validator: (v) =>
//                                           (v == null || v.trim().isEmpty) ? 'Nhập họ tên' : null,
//                                     ),
//                                   ),
//                                   SizedBox(width: 2.w),
//                                   IconButton(
//                                     tooltip: 'Xoá',
//                                     onPressed: () => setState(() => _rows.removeAt(i)),
//                                     icon: const Icon(Icons.delete_outline_rounded),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 1.h),
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: DropdownButtonFormField<int>(
//                                       decoration: const InputDecoration(
//                                         labelText: 'Giới tính',
//                                         border: OutlineInputBorder(),
//                                         isDense: true,
//                                       ),
//                                       value: p.gender,
//                                       items: const [
//                                         DropdownMenuItem(value: 0, child: Text('Nữ')),
//                                         DropdownMenuItem(value: 1, child: Text('Nam')),
//                                       ],
//                                       onChanged: (val) {
//                                         if (val == null) return;
//                                         setState(() {
//                                           _rows[i] = BookingParticipantModel(
//                                             type: p.type, fullName: p.fullName, gender: val, dateOfBirth: p.dateOfBirth,
//                                           );
//                                         });
//                                       },
//                                     ),
//                                   ),
//                                   SizedBox(width: 2.w),
//                                   Expanded(
//                                     child: DropdownButtonFormField<int>(
//                                       decoration: const InputDecoration(
//                                         labelText: 'Loại',
//                                         border: OutlineInputBorder(),
//                                         isDense: true,
//                                       ),
//                                       value: p.type,
//                                       items: const [
//                                         DropdownMenuItem(value: 1, child: Text('Người lớn')),
//                                         DropdownMenuItem(value: 2, child: Text('Trẻ em')),
//                                       ],
//                                       onChanged: (val) {
//                                         if (val == null) return;
//                                         setState(() {
//                                           _rows[i] = BookingParticipantModel(
//                                             type: val, fullName: p.fullName, gender: p.gender, dateOfBirth: p.dateOfBirth,
//                                           );
//                                         });
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 1.h),
//                               InkWell(
//                                 onTap: () => _pickDob(i),
//                                 child: InputDecorator(
//                                   decoration: const InputDecoration(
//                                     labelText: 'Ngày sinh',
//                                     border: OutlineInputBorder(),
//                                     isDense: true,
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       const Icon(Icons.event, size: 18),
//                                       SizedBox(width: 2.w),
//                                       Text(dob),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),

//                   SizedBox(height: 2.h),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton.icon(
//                       onPressed: _onSubmit,
//                       icon: const Icon(Icons.check_circle_outline_rounded),
//                       label: const Text('Xác nhận thông tin'),
//                       style: ElevatedButton.styleFrom(
//                         padding: EdgeInsets.symmetric(vertical: 1.6.h),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _LabeledField extends StatelessWidget {
//   final String label;
//   final TextEditingController controller;
//   final TextInputType keyboardType;
//   final String? Function(String?)? validator;
//   const _LabeledField({
//     required this.label,
//     required this.controller,
//     required this.keyboardType,
//     this.validator,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       decoration: const InputDecoration(
//         border: OutlineInputBorder(),
//         isDense: true,
//       ).copyWith(labelText: label),
//       validator: validator,
//     );
//   }
// }
