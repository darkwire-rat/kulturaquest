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
      body: Container(
        width: double.infinity,
        color: Colors.grey[100],
        child: Center(
          child: FutureBuilder<User?>(
            future: Future.value(FirebaseAuth.instance.currentUser),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              final user = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.blue[100],
                            child: Icon(Icons.person, size: 50, color: Colors.blue[700]),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            user.email ?? 'No email',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.lock_reset_rounded),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () async {
                                try {
                                  await FirebaseAuth.instance.sendPasswordResetEmail(email: user.email!);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Password reset email sent!')),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Failed to send reset email: \\${e.toString()}')),
                                  );
                                }
                              },
                              label: const Text('Reset Password', style: TextStyle(fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 200,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.logout, color: Colors.redAccent),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                        side: const BorderSide(color: Colors.redAccent, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => _signOut(context),
                      label: const Text('Log Out', style: TextStyle(fontSize: 16, color: Colors.redAccent)),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
