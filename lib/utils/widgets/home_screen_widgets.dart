// lib/widgets/custom_widgets.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildActionButton({
  required IconData icon,
  required Color color,
  required String label,
}) {
  return Column(
    children: [
      Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 28),
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: GoogleFonts.lora(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
      ),
    ],
  );
}

Widget buildStatCard({
  required String value,
  required Color color,
  required String label,
}) {
  return Column(
    children: [
      Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.3), width: 2),
        ),
        child: Center(
          child: Text(
            value,
            style: GoogleFonts.lora(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: GoogleFonts.lora(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
      ),
    ],
  );
}
