import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp/services/auth_Services.dart';
import 'package:fyp/services/feedback_Api_Service.dart';
import 'package:fyp/utils/constant/colors.dart';
import 'package:fyp/utils/widgets/build_buttons.dart';
import 'package:fyp/utils/widgets/build_toast.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController feedbackController = TextEditingController();
  final AuthService _authService = AuthService();
  bool loading = false;
  String apiStatus = '';

  // Test API connection
  Future<void> testApiConnection() async {
    setState(() {
      loading = true;
      apiStatus = 'Testing connection to API...';
    });

    try {
      final result = await FeedbackService.testApiConnection();
      setState(() {
        apiStatus = result;
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> submitFeedback() async {
    if (feedbackController.text.trim().isEmpty) {
      BuildToast.toastMessages("Please enter your feedback!");
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      Map<String, dynamic>? currentUserData = await _authService
          .getCurrentUserData();

      if (currentUserData == null) {
        BuildToast.toastMessages("User not logged in!");
        return;
      }

      String userId = currentUserData['uid'];

      bool success = await FeedbackService.submitFeedback(
        userId: userId,
        message: feedbackController.text.trim(),
      );

      if (success) {
        BuildToast.toastMessages("Feedback submitted successfully!");
        feedbackController.clear();
      } else {
        BuildToast.toastMessages(
          "Failed to submit feedback. Please try again!",
        );
      }
    } catch (e) {
      BuildToast.toastMessages("An error occurred. Please try again!");
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Feedback',
          style: GoogleFonts.lora(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // API Test Button
            ElevatedButton.icon(
              onPressed: testApiConnection,
              icon: Icon(Icons.wifi, color: Colors.white),
              label: Text(
                'Test API Connection',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),

            SizedBox(height: 16),

            // API Status Display
            if (apiStatus.isNotEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  apiStatus,
                  style: GoogleFonts.lora(fontSize: 12, color: Colors.black87),
                ),
              ),

            SizedBox(height: 20),

            Text(
              "Give your valuable feedback....!",
              style: GoogleFonts.lora(
                color: AppColors.primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: 20),
              width: double.infinity,
              child: TextField(
                maxLines: 7,
                controller: feedbackController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Enter your feedback......",
                  hintStyle: GoogleFonts.lora(
                    color: AppColors.primaryColor.withOpacity(0.5),
                  ),
                  prefixIcon: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      CupertinoIcons.pencil_circle,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.primaryColor,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppColors.primaryColor,
                      width: 2,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 15,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            BuildContainer(
              borderColor: Theme.of(context).scaffoldBackgroundColor,
              backgroundColor: AppColors.primaryColor,
              textColor: Colors.white,
              loading: loading,
              text: "Submit Feedback",
              onTap: submitFeedback,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    feedbackController.dispose();
    super.dispose();
  }
}
