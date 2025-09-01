import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/Views/login_screen.dart';
import 'package:fyp/services/auth_services.dart';
import 'package:fyp/utils/constant/colors.dart';
import 'package:fyp/utils/widgets/build_buttons.dart';
import 'package:fyp/utils/widgets/build_password_feild.dart';
import 'package:fyp/utils/widgets/build_textFeild.dart';
import 'package:fyp/utils/widgets/build_toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:fyp/utils/widgets/navigationbar_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isChecked = true;
  bool loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
    });
    try {
      User? user = await AuthService().signUpWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _nameController.text.trim(),
      );

      if (user != null) {
        // Check if email is verified
        await user.reload();
        user = FirebaseAuth.instance.currentUser;
        if (user!.emailVerified) {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => NavigationbarScreen()),
            );
          }
        } else {
          BuildToast.toastMessages(
            'Verification email sent. Please check your inbox or spam folder.',
          );
        }

        // Clear text fields
        _emailController.clear();
        _nameController.clear();
        _passwordController.clear();
        _confirmpasswordController.clear();
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'Password is too weak';
          break;
        case 'invalid-email':
          errorMessage = 'Email is invalid';
          break;
        case 'email-already-in-use':
          errorMessage = 'Email is already registered';
          break;
        default:
          errorMessage = 'Registration failed. Please try again.';
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
                      'assets/signup.json',
                      fit: BoxFit.contain,
                      repeat: true,
                      animate: true,
                    ),
                  ),
                  Text(
                    "SignUp",
                    style: GoogleFonts.lora(
                      fontSize: 24,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  BuildTextfield(
                    hintText: "Enter your name",
                    controller: _nameController,
                    icon: Icons.person,
                    validatorType: 'name',
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
                    hintText: "Create a Password",
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 16),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _passwordController,
                    builder: (context, value, child) {
                      return BuildPasswordTextfield(
                        hintText: "Confirm Password",
                        controller: _confirmpasswordController,
                        isConfirmPassword: true,
                        originalPassword: _passwordController.text,
                      );
                    },
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value ?? true;
                          });
                        },
                        activeColor: AppColors.secondarybtn,
                        checkColor: Colors.white,
                        side: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2.0,
                        ),
                      ),
                      Text(
                        "Remember me",
                        style: GoogleFonts.lora(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  BuildContainer(
                    borderColor: Theme.of(context).scaffoldBackgroundColor,
                    backgroundColor: AppColors.primaryColor,
                    textColor: Colors.white,
                    loading: loading,
                    text: "SignUp",
                    onTap: () {
                      signUp();
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        "Already had an account? ",
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
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Login",
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
