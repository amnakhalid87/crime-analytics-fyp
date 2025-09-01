import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fyp/utils/constant/colors.dart';
import 'package:fyp/utils/textStrings/text_strings.dart';

class ChicagoLawsScreen extends StatefulWidget {
  const ChicagoLawsScreen({super.key});

  @override
  State<ChicagoLawsScreen> createState() => _ChicagoLawsScreenState();
}

class _ChicagoLawsScreenState extends State<ChicagoLawsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          TextStrings.chicagoLawsMainTitle,
          style: GoogleFonts.lora(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(4, (index) {
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
                  child: ExpansionTile(
                    title: Text(
                      TextStrings.chicagoLawsTitles[index],
                      style: GoogleFonts.lora(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    iconColor: AppColors.primaryColor,
                    collapsedIconColor: AppColors.primaryColor,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          TextStrings.chicagoLawsContents[index],
                          style: GoogleFonts.lora(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[800],
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
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
