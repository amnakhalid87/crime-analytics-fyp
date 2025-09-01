import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fyp/utils/constant/colors.dart';
import 'package:fyp/utils/widgets/validators.dart';

class BuildTextfield extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final IconData icon;
  final String validatorType;

  const BuildTextfield({
    super.key,
    required this.hintText,
    required this.controller,
    required this.icon,
    required this.validatorType,
  });

  String? _getValidator(String? value) {
    switch (validatorType) {
      case 'name':
        return TextValidators.validateName(value);
      case 'email':
        return TextValidators.validateEmail(value);

      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: _getValidator,
      style: GoogleFonts.lora(
        color: Colors.black87,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.lora(color: Colors.grey[500], fontSize: 14),
        prefixIcon: Icon(icon, color: AppColors.primaryColor),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
      ),
    );
  }
}
