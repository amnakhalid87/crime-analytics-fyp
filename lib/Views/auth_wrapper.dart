import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/Views/boarding_screen.dart';
import 'package:fyp/Views/signup_screen.dart';
import 'package:fyp/utils/widgets/navigationbar_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final StreamController<User?> _userController =
      StreamController<User?>.broadcast();
  Timer? _verificationTimer;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _userController.add(user);
    });

    _startVerificationCheck();
  }

  void _startVerificationCheck() {
    _verificationTimer?.cancel();
    _verificationTimer = Timer.periodic(const Duration(seconds: 3), (
      timer,
    ) async {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.reload();
        user = FirebaseAuth.instance.currentUser;
        _userController.add(
          user,
        ); // Update the stream with the latest user state
      }
    });
  }

  @override
  void dispose() {
    _verificationTimer?.cancel();
    _userController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _userController.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Something went wrong!')),
          );
        }

        final User? user = snapshot.data;

        if (user == null) {
          return const BoardingScreen();
        }

        if (!user.emailVerified) {
          return const SignupScreen();
        }

        return const NavigationbarScreen();
      },
    );
  }
}
