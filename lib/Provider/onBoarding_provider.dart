import 'package:flutter/material.dart';

class OnboardingProvider extends ChangeNotifier {
  final PageController pageController = PageController();
  int _currentPage = 0;
  int get currentPage => _currentPage;
  void updatePage() {
    if (_currentPage < 3) {
      _currentPage++;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
