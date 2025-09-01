import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/Views/login_screen.dart';
import 'package:fyp/utils/constant/colors.dart';
import 'package:fyp/utils/widgets/build_buttons.dart';
import 'package:fyp/utils/widgets/build_textFeild.dart';
import 'package:fyp/utils/widgets/build_toast.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    bool loading = false;
    reset() async {
      if (formKey.currentState!.validate()) {
        loading = true;

        FirebaseAuth.instance;
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailController.text)
            .then((value) {
              loading = false;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            })
            .onError((error, stackTrace) {
              BuildToast.toastMessages(error.toString());
            });
      }
    }

    return Scaffold(
      backgroundColor: AppColors.primaryColor.withOpacity(0.9),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: const Color(0xFFE5E5E5), width: 1.0),
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
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Reset Password",
                  style: GoogleFonts.lora(
                    fontSize: 24,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                BuildTextfield(
                  hintText: "Enter your email",
                  controller: emailController,
                  icon: Icons.email,
                  validatorType: 'email',
                ),

                const SizedBox(height: 16),

                BuildContainer(
                  borderColor: Colors.black,
                  backgroundColor: AppColors.primaryColor,
                  textColor: Colors.white,
                  text: "Reset Password!",
                  loading: loading,
                  onTap: () {
                    reset();
                  },
                ),

                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
