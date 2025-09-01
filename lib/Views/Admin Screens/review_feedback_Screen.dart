import 'package:flutter/material.dart';
import 'package:fyp/services/feedback_Api_Service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fyp/utils/constant/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp/utils/widgets/build_toast.dart';

class ReviewFeedbackScreen extends StatefulWidget {
  const ReviewFeedbackScreen({super.key});

  @override
  State<ReviewFeedbackScreen> createState() => _ReviewFeedbackScreenState();
}

class _ReviewFeedbackScreenState extends State<ReviewFeedbackScreen> {
  List<Map<String, dynamic>> feedbackItems = [];
  bool isLoading = true;
  String errorMessage = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    loadFeedback();
  }

  Future<void> loadFeedback() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      List<Map<String, dynamic>> feedback =
          await FeedbackService.getAllFeedback();

      // Agar feedback empty hai to return
      if (feedback.isEmpty) {
        setState(() {
          feedbackItems = [];
          isLoading = false;
        });
        return;
      }

      for (int i = 0; i < feedback.length; i++) {
        String userId = feedback[i]['user_id'];
        try {
          DocumentSnapshot userDoc = await _firestore
              .collection('users')
              .doc(userId)
              .get();

          if (userDoc.exists) {
            Map<String, dynamic> userData =
                userDoc.data() as Map<String, dynamic>;
            feedback[i]['user_name'] = userData['name'] ?? 'Unknown User';
          } else {
            feedback[i]['user_name'] = 'Unknown User';
          }
        } catch (e) {
          feedback[i]['user_name'] = 'Unknown User';
        }
      }

      setState(() {
        feedbackItems = feedback;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error loading feedback: $e';
      });
      BuildToast.toastMessages('Error loading feedback: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Review Feedback',
          style: GoogleFonts.lora(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              loadFeedback();
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            )
          : errorMessage.isNotEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Error Loading Feedback',
                    style: GoogleFonts.lora(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lora(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: loadFeedback,
                    child: Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            )
          : feedbackItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.feedback_outlined,
                    size: 64,
                    color: AppColors.primaryColor.withOpacity(0.5),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No feedback available',
                    style: GoogleFonts.lora(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Feedback will appear here once submitted',
                    style: GoogleFonts.lora(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              color: AppColors.primaryColor,
              onRefresh: loadFeedback,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Feedback: ${feedbackItems.length}',
                        style: GoogleFonts.lora(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(height: 16),
                      ...feedbackItems.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(
                                color: Theme.of(context).cardColor,
                                width: 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 16.0,
                                  offset: const Offset(0, 4),
                                  spreadRadius: 0,
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 8.0,
                                  offset: const Offset(0, 1),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.account_circle,
                                      color: AppColors.primaryColor,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        item['user_name']?.toString() ??
                                            'Unknown User',
                                        style: GoogleFonts.lora(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '#${item['id']?.toString() ?? ''}',
                                      style: GoogleFonts.lora(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.grey[200]!,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    item['message']?.toString() ?? 'No message',
                                    style: GoogleFonts.lora(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black87,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
