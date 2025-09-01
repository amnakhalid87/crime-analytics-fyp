import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildContainer extends StatelessWidget {
  final Color borderColor;
  final Color backgroundColor;
  final Color textColor;
  final String text;
  final VoidCallback? onTap;
  final bool loading;

  const BuildContainer({
    super.key,
    required this.borderColor,
    required this.backgroundColor,
    required this.textColor,
    required this.text,
    this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: loading
              ? const CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                )
              : Text(
                  text,
                  style: GoogleFonts.lora(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
