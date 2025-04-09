import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'language_selection_screen.dart'; // Import this if you're navigating back there

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    // Navigate to LanguageSelectionScreen (or SignIn screen depending on your flow)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LanguageSelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('This is the Profile screen'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _signOut(context),
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
