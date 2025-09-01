import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fyp/utils/constant/colors.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    cardColor: Color(0xffE7E7E7),
    scaffoldBackgroundColor: Colors.white,
    primaryColor: AppColors.primaryColor,
    iconTheme: const IconThemeData(color: Colors.white54),
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.inter(
        color: AppColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: GoogleFonts.inter(
        color: AppColors.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      bodySmall: GoogleFonts.inter(
        color: AppColors.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      titleLarge: GoogleFonts.inter(
        color: AppColors.textPrimary,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: GoogleFonts.inter(
        color: AppColors.textPrimary,
        fontSize: 12,
        fontWeight: FontWeight.w300,
      ),
      headlineLarge: GoogleFonts.inter(
        color: AppColors.textPrimary,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: GoogleFonts.inter(
        color: AppColors.textPrimary,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primarybtn,
        foregroundColor: Colors.white,
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
