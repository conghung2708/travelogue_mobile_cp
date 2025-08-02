import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GradientFolderIcon extends StatelessWidget {
  final VoidCallback? onTap;

  const GradientFolderIcon({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        width: 11.w, 
        height: 11.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Color(0xFF41C3F6),
              Color(0xFF1DA1F2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.2),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            Icons.folder_copy_outlined,
            color: Colors.white,
            size: 6.w, 
          ),
        ),
      ),
    );
  }
}