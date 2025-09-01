import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/Views/reset_password_screen.dart';
import 'package:fyp/Views/signup_screen.dart';
import 'package:fyp/services/auth_services.dart';
import 'package:fyp/utils/constant/colors.dart';
import 'package:fyp/utils/widgets/build_buttons.dart';
import 'package:fyp/utils/widgets/build_password_feild.dart';
import 'package:fyp/utils/widgets/build_textFeild.dart';
import 'package:fyp/utils/widgets/build_toast.dart';
import 'package:fyp/utils/widgets/navigationbar_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
    });
    try {
      final result = await AuthService().signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!result.user.emailVerified) {
        BuildToast.toastMessages('Please verify your email before logging in.');
        return;
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NavigationbarScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password';
          break;
        case 'invalid-email':
          errorMessage = 'Email is invalid';
          break;
        default:
          errorMessage = 'Login failed. Please try again.';
      }
      BuildToast.toastMessages(errorMessage);
    } catch (e) {
      BuildToast.toastMessages('An unexpected error occurred');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor.withOpacity(0.9),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          padding: const EdgeInsets.all(18.0),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: Theme.of(context).cardColor, width: 1.0),
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
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 140,
                    width: 140,
                    child: Lottie.asset(
                      'assets/login.json',
                      fit: BoxFit.contain,
                      repeat: true,
                      animate: true,
                    ),
                  ),
                  Text(
                    "Login",
                    style: GoogleFonts.lora(
                      fontSize: 24,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  BuildTextfield(
                    hintText: "Enter your email",
                    controller: _emailController,
                    icon: Icons.email,
                    validatorType: 'email',
                  ),
                  const SizedBox(height: 16),
                  BuildPasswordTextfield(
                    hintText: "Enter your Password",
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        "Forget Password? ",
                        style: GoogleFonts.lora(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResetPasswordScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Reset Password!",
                          style: GoogleFonts.lora(
                            fontSize: 16,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  BuildContainer(
                    borderColor: Theme.of(context).scaffoldBackgroundColor,
                    backgroundColor: AppColors.primaryColor,
                    textColor: Colors.white,
                    loading: loading,
                    text: "Login",
                    onTap: () {
                      signIn();
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: GoogleFonts.lora(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "SignUp",
                          style: GoogleFonts.lora(
                            fontSize: 16,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
