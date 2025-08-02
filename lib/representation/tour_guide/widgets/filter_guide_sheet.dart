import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/model/tour_guide/tour_guide_filter_model.dart';
import 'package:travelogue_mobile/core/constants/color_constants.dart';

class FilterGuideSheet extends StatefulWidget {
  final void Function(TourGuideFilterModel) onApplyFilter;

  const FilterGuideSheet({super.key, required this.onApplyFilter});

  @override
  State<FilterGuideSheet> createState() => _FilterGuideSheetState();
}

class _FilterGuideSheetState extends State<FilterGuideSheet> {
  final TextEditingController _nameController = TextEditingController();
  int? selectedGender;
  DateTime? startDate;
  DateTime? endDate;
  double minPrice = 0;
  double maxPrice = 1000000;
  int minRating = 0;
  int maxRating = 5;

  Future<void> _selectDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: (startDate != null && endDate != null)
          ? DateTimeRange(start: startDate!, end: endDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
    }
  }

  void _applyFilter() {
    final name = _nameController.text.trim();
    debugPrint("🔍 Đang lọc với tên: $name");

    final filter = TourGuideFilterModel(
      userName: _nameController.text.trim().isEmpty
          ? null
          : _nameController.text.trim(),
      gender: selectedGender,
      startDate: startDate,
      endDate: endDate,
      minPrice: minPrice,
      maxPrice: maxPrice,
      minRating: minRating,
      maxRating: maxRating,
    );

    widget.onApplyFilter(filter);
    Navigator.pop(context);
  }

  void _resetFilter() {
    setState(() {
      _nameController.clear();
      selectedGender = null;
      startDate = null;
      endDate = null;
      minPrice = 0;
      maxPrice = 1000000;
      minRating = 1;
      maxRating = 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color mainColor = ColorPalette.primaryColor;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.98),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 22,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
          5.w, 3.h, 5.w, MediaQuery.of(context).viewInsets.bottom + 3.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 0.7.h,
                width: 12.w,
                margin: EdgeInsets.only(bottom: 2.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            Center(
              child: Text(
                "🎯 Tìm kiếm Hướng Dẫn Viên phù hợp",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: mainColor,
                  letterSpacing: 0.1,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            _section(
              "Tên hướng dẫn viên",
              FontAwesomeIcons.user,
              _textField(_nameController, "Nhập tên hướng dẫn viên..."),
            ),
            _divider(),
            _section(
              "Giới tính",
              FontAwesomeIcons.venusMars,
              _genderChips(mainColor),
            ),
            _divider(),
            _section(
              "Thời gian",
              FontAwesomeIcons.calendar,
              _datePicker(mainColor),
            ),
            _divider(),
            // Giá ngoài slider, nâng giao diện
            Padding(
              padding: EdgeInsets.only(bottom: 0.5.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(FontAwesomeIcons.wallet,
                          color: mainColor, size: 17.sp),
                      SizedBox(width: 2.w),
                      Text(
                        "Khoảng giá (VNĐ)",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  _filterCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
             
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 0.8.h),
                              decoration: BoxDecoration(
                                color: mainColor.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "${_formatMoneyVn(minPrice)}đ",
                                style: TextStyle(
                                  color: mainColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                            Expanded(
                                child: Divider(
                                    thickness: 1,
                                    color: Colors.grey.shade200,
                                    indent: 2.w,
                                    endIndent: 2.w)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 0.8.h),
                              decoration: BoxDecoration(
                                color: mainColor.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "${_formatMoneyVn(maxPrice)}đ",
                                style: TextStyle(
                                  color: mainColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.2.h),
                        _rangeSlider(
                          minPrice,
                          maxPrice,
                          0,
                          1000000,
                          (range) {
                            setState(() {
                              minPrice = range.start;
                              maxPrice = range.end;
                            });
                          },
                          isMoney: true,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Chọn mức giá phù hợp ngân sách của bạn',
                          style: TextStyle(
                            fontSize: 10.5.sp,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _divider(),
            Padding(
              padding: EdgeInsets.only(bottom: 0.5.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(FontAwesomeIcons.star,
                          color: mainColor, size: 17.sp),
                      SizedBox(width: 2.w),
                      Text(
                        "Đánh giá (sao)",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  _filterCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 0.7.h),
                              decoration: BoxDecoration(
                                color: mainColor.withOpacity(0.09),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "$minRating ⭐",
                                style: TextStyle(
                                  color: mainColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                            Expanded(
                                child: Divider(
                                    thickness: 1,
                                    color: Colors.grey.shade200,
                                    indent: 2.w,
                                    endIndent: 2.w)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 0.7.h),
                              decoration: BoxDecoration(
                                color: mainColor.withOpacity(0.09),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "$maxRating ⭐",
                                style: TextStyle(
                                  color: mainColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.1.h),
                        _rangeSlider(
                          minRating.toDouble(),
                          maxRating.toDouble(),
                          0,
                          5,
                          (range) {
                            setState(() {
                              minRating = range.start.round();
                              maxRating = range.end.round();
                            });
                          },
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Ưu tiên hướng dẫn viên có nhiều sao đánh giá',
                          style: TextStyle(
                            fontSize: 10.5.sp,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.7.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _resetFilter,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey.shade600,
                  ),
                  child: const Text("Đặt lại bộ lọc"),
                ),
                _gradientButton(mainColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, IconData icon, Widget child) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: ColorPalette.primaryColor, size: 17.sp),
              SizedBox(width: 2.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          _filterCard(child: child),
        ],
      ),
    );
  }

  Widget _divider() => Divider(
        thickness: 1,
        color: Colors.grey.shade200,
        height: 2.2.h,
      );

  Widget _filterCard({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(3.3.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _textField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      style:
          const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(FontAwesomeIcons.search, color: Colors.grey.shade400),
        hintStyle:
            TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w500),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: EdgeInsets.symmetric(vertical: 1.2.h, horizontal: 2.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _genderChips(Color mainColor) {
    final genders = [
      {"label": "Nam", "icon": FontAwesomeIcons.mars},
      {"label": "Nữ", "icon": FontAwesomeIcons.venus},
    ];
    return Wrap(
      spacing: 4.w,
      children: List.generate(genders.length, (index) {
        final bool isSelected = selectedGender == index;
        return ChoiceChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                genders[index]['icon'] as IconData,
                size: 17,
                color: isSelected ? Colors.white : mainColor,
              ),
              const SizedBox(width: 5),
              Text(
                genders[index]['label'] as String,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          selected: isSelected,
          onSelected: (val) =>
              setState(() => selectedGender = val ? index : null),
          selectedColor: mainColor,
          backgroundColor: Colors.grey.shade100,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: isSelected ? 3 : 0,
          shadowColor: Colors.black26,
          showCheckmark: false,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.3.h),
        );
      }),
    );
  }

  Widget _datePicker(Color mainColor) {
    return InkWell(
      onTap: _selectDateRange,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade100,
        ),
        child: Row(
          children: [
            Icon(FontAwesomeIcons.calendar, color: mainColor),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                (startDate != null && endDate != null)
                    ? "${DateFormat('dd/MM/yyyy').format(startDate!)} → ${DateFormat('dd/MM/yyyy').format(endDate!)}"
                    : "Chọn khoảng ngày...",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.black45),
          ],
        ),
      ),
    );
  }

  Widget _rangeSlider(
    double start,
    double end,
    double min,
    double max,
    void Function(RangeValues) onChanged, {
    bool isMoney = false,
  }) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 13),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 22),
      ),
      child: RangeSlider(
        values: RangeValues(start, end),
        min: min,
        max: max,
        divisions: ((max - min) / ((max - min) > 100 ? 10000 : 1)).floor(),
        labels: RangeLabels(
          isMoney ? _formatMoneyVn(start) : "${start.toInt()}",
          isMoney ? _formatMoneyVn(end) : "${end.toInt()}",
        ),
        activeColor: ColorPalette.primaryColor,
        inactiveColor: Colors.grey.shade300,
        onChanged: onChanged,
      ),
    );
  }

  Widget _gradientButton(Color mainColor) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: Gradients.defaultGradientBackground,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: mainColor.withOpacity(0.22),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 1.5.h),
          textStyle: TextStyle(
              fontSize: 12.sp, fontWeight: FontWeight.bold, letterSpacing: 0.2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 0,
        ),
        onPressed: _applyFilter,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(FontAwesomeIcons.filter, size: 19),
            SizedBox(width: 2.w),
            Text("Áp dụng bộ lọc"),
          ],
        ),
      ),
    );
  }

  String _formatMoneyVn(double value) {
    final format = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '',
      decimalDigits: 0,
    );
    return format.format(value).trim();
  }
}
