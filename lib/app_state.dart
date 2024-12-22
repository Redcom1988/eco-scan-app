import 'package:flutter/material.dart';

class MyAppState extends ChangeNotifier {
  int selectedIndex = 0;

  void setIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}

class MyAdminAppState extends ChangeNotifier {
  int selectedIndexAdmin = 0;

  void setIndexAdmin(int index) {
    selectedIndexAdmin = index;
    notifyListeners();
  }
}
