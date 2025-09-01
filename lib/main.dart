import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fyp/Views/splash_screen.dart';
import 'package:fyp/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:fyp/Provider/onBoarding_provider.dart';
import 'package:fyp/Provider/password_visibility_provider.dart';
import 'package:fyp/utils/constant/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const CrimeApp());
}

class CrimeApp extends StatelessWidget {
  const CrimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => PasswordVisibilityProvider()),
      ],
      child: MaterialApp(
        title: 'Crime Analytics',
        debugShowCheckedModeBanner: false,
        theme: AppThemes.lightTheme,
        home: SplashScreen(),
      ),
    );
  }
}
