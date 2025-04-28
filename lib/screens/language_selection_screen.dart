import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'sign_in_screen.dart';
import 'main_screen.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  void _handleLanguageSelection(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // If the user is already signed in, go straight to the main app screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    } else {
      // If not signed in, direct to sign-in screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignInScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // KulturaQuest Logo
              Image.asset('assets/images/kul.png', height: 120),
              const SizedBox(height: 20),

              // Welcome Message
              const Text(
                'Welcome to KulturaQuest',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

              // English Button
              ElevatedButton(
                onPressed: () => _handleLanguageSelection(context),
                child: const Text('English'),
              ),
              const SizedBox(height: 10),

              // Tagalog Button
              ElevatedButton(
                onPressed: () => _handleLanguageSelection(context),
                child: const Text('Tagalog'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
