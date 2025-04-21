import 'package:flutter/material.dart';

class MonthState extends ChangeNotifier {
  int selectedMonthId = 0;

  void updateMonthId(int selectedMonthId) {
    this.selectedMonthId = selectedMonthId;
    notifyListeners();
  }
}