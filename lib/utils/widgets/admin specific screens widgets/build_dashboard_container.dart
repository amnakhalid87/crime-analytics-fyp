import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fyp/utils/constant/colors.dart';

Widget buildDashboardContainer(
  BuildContext context, {
  required String iconPath,
  required String text,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          transform: Matrix4.identity()..scale(1.0),
          child: Container(
            width: 100,
            height: 100,
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
            child: Center(
              child: Image.asset(
                iconPath,
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          text,
          style: GoogleFonts.lora(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
