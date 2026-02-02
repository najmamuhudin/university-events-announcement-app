import 'package:flutter/material.dart';

class NavigationProvider with ChangeNotifier {
  int _currentIndex = 0;

  bool _isDrawerOpen = false;

  int get currentIndex => _currentIndex;
  bool get isDrawerOpen => _isDrawerOpen;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void setDrawerOpen(bool isOpen) {
    _isDrawerOpen = isOpen;
    notifyListeners();
  }

  void toggleDrawer() {
    _isDrawerOpen = !_isDrawerOpen;
    notifyListeners();
  }
}
