import 'package:flutter/material.dart';
import 'package:fyp/Views/Admin%20Screens/detailed_crime_report_Screen.dart';
import 'package:fyp/Views/Admin%20Screens/review_feedback_Screen.dart';
import 'package:fyp/Views/map_screen.dart';
import 'package:fyp/utils/widgets/admin%20specific%20screens%20widgets/build_dashboard_container.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fyp/utils/constant/colors.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
          style: GoogleFonts.lora(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                buildDashboardContainer(
                  context,
                  iconPath: 'assets/icon5.png',
                  text: 'Review Feedback',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewFeedbackScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 24),
            Row(
              children: [
                buildDashboardContainer(
                  context,
                  iconPath: 'assets/icon1.png',
                  text: 'Predict Safety',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapScreen()),
                    );
                  },
                ),
                const SizedBox(height: 24),
                buildDashboardContainer(
                  context,
                  iconPath: 'assets/icon4.png',
                  text: 'Crime Reports',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailedCrimeReportScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
