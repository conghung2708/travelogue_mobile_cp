// lib/features/tour/presentation/widgets/person_counter_row.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PersonCounterRow extends StatelessWidget {
  final String label;
  final int value;
  final bool isAdult;
  final double unitPrice;
  final ValueChanged<int> onChanged;
  final bool Function() canAdd;
  final VoidCallback onLimit;

  const PersonCounterRow({
    super.key,
    required this.label,
    required this.value,
    required this.isAdult,
    required this.unitPrice,
    required this.onChanged,
    required this.canAdd,
    required this.onLimit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // label + price
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$label – ${unitPrice.toStringAsFixed(0)}đ',
                  style: TextStyle(fontSize: 14.sp, color: Colors.white)),
              SizedBox(height: 0.5.h),
              Text(isAdult ? '(Từ 12 tuổi trở lên)' : '(Từ 1 đến dưới 12 tuổi)',
                  style: TextStyle(fontSize: 13.sp, color: Colors.white70, fontStyle: FontStyle.italic)),
            ],
          ),

          // counter
          Row(
            children: [
              _roundIconButton(
                Icons.remove,
                ((isAdult && value > 1) || (!isAdult && value > 0))
                    ? () => onChanged(value - 1)
                    : null,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Text('$value', style: TextStyle(fontSize: 15.sp, color: Colors.white)),
              ),
              _roundIconButton(
                Icons.add,
                canAdd()
                    ? () => onChanged(value + 1)
                    : () => onLimit(),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _roundIconButton(IconData icon, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: onTap != null ? Colors.white.withOpacity(0.15) : Colors.grey.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
