import 'package:flutter/material.dart';
import 'package:fyp/utils/constant/colors.dart';
import 'package:fyp/utils/widgets/validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fyp/Provider/password_visibility_provider.dart';

class BuildPasswordTextfield extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isConfirmPassword;
  final String? originalPassword;

  const BuildPasswordTextfield({
    super.key,
    required this.hintText,
    required this.controller,
    this.isConfirmPassword = false,
    this.originalPassword,
  });

  String? _getValidator(String? value) {
    if (isConfirmPassword) {
      return TextValidators.validateConfirmPassword(value, originalPassword!);
    }
    return TextValidators.validatePassword(value);
  }

  @override
  Widget build(BuildContext context) {
    final passwordVisibilityProvider = Provider.of<PasswordVisibilityProvider>(
      context,
    );

    return TextFormField(
      controller: controller,
      obscureText: !passwordVisibilityProvider.isPasswordVisible,
      validator: _getValidator,
      style: GoogleFonts.lora(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.black.withOpacity(0.5),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        prefixIcon: GestureDetector(
          onTap: passwordVisibilityProvider.togglePasswordVisibility,
          child: Icon(
            passwordVisibilityProvider.isPasswordVisible
                ? Icons.visibility_off
                : Icons.visibility,
            color: AppColors.primaryColor,
            size: 20,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
      ),
    );
  }
}
