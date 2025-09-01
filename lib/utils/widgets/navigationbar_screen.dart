import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp/Views/map_screen.dart';
import 'package:fyp/Views/crime_statistics_screen.dart';
import 'package:fyp/Views/feedback_screen.dart';
import 'package:fyp/Views/home_screen.dart';
import 'package:fyp/utils/constant/colors.dart';

class NavigationbarScreen extends StatefulWidget {
  const NavigationbarScreen({super.key});

  @override
  State<NavigationbarScreen> createState() => _NavigationbarScreenState();
}

class _NavigationbarScreenState extends State<NavigationbarScreen> {
  int index = 0;
  final items = [
    Icon(CupertinoIcons.house_fill, size: 22, color: Colors.white),
    Icon(Icons.map_outlined, size: 22, color: Colors.white),
    Icon(CupertinoIcons.square_pencil_fill, size: 22, color: Colors.white),
    Icon(Icons.bar_chart, size: 22, color: Colors.white),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        items: items,
        index: index,
        onTap: (selectedIndex) {
          setState(() {
            index = selectedIndex;
          });
        },
        color: AppColors.primaryColor,
        backgroundColor: Colors.transparent,
        animationDuration: Duration(milliseconds: 300),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: getSelectedWidget(index: index),
      ),
    );
  }

  Widget getSelectedWidget({required int index}) {
    switch (index) {
      case 0:
        return HomeScreen();
      case 1:
        return MapScreen();
      case 2:
        return FeedbackScreen();
      case 3:
        return CrimeStatisticsScreen();
      default:
        return HomeScreen();
    }
  }
}
