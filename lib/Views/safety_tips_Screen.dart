import 'package:flutter/material.dart';
import 'package:fyp/utils/constant/colors.dart';
import 'package:fyp/utils/textStrings/text_strings.dart';
import 'package:google_fonts/google_fonts.dart';

class SafetyTipsScreen extends StatefulWidget {
  const SafetyTipsScreen({Key? key}) : super(key: key);

  @override
  State<SafetyTipsScreen> createState() => _SafetyTipsScreenState();
}

class _SafetyTipsScreenState extends State<SafetyTipsScreen> {
  bool isEnglish = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "Safety Tips",
          style: GoogleFonts.lora(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.language, color: Colors.white),
            tooltip: 'Toggle Language',
            onPressed: () {
              setState(() {
                isEnglish = !isEnglish;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(5, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEnglish
                                  ? TextStrings.safetyTipsTitles[index][0]
                                  : TextStrings.safetyTipsTitles[index][1],
                              style: GoogleFonts.lora(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isEnglish
                                  ? TextStrings.safetyTipsContents[index][0]
                                  : TextStrings.safetyTipsContents[index][1],
                              style: GoogleFonts.lora(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[800],
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
