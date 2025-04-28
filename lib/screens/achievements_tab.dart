import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AchievementsTab extends StatelessWidget {
  const AchievementsTab({super.key});

  Future<Map<String, dynamic>> getUserAchievements() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      return doc.data()?['achievements'] ?? {};
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Achievements')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getUserAchievements(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final achievements = snapshot.data ?? {};

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Your Achievements',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // 🎯 First Quiz Completed
              Card(
                elevation: 4,
                child: ListTile(
                  leading: const Icon(Icons.emoji_events, size: 40),
                  title: const Text('First Quiz Completed!'),
                  subtitle: const Text('Completed your first quiz.'),
                  trailing: Icon(
                    achievements['firstQuizCompleted'] == true
                        ? Icons.check_circle
                        : Icons.lock,
                    color:
                        achievements['firstQuizCompleted'] == true
                            ? Colors.green
                            : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // 🎯 Perfect Score
              Card(
                elevation: 4,
                child: ListTile(
                  leading: const Icon(Icons.star, size: 40),
                  title: const Text('Perfect Score!'),
                  subtitle: const Text('Achieved a perfect score in a quiz.'),
                  trailing: Icon(
                    achievements['perfectScore'] == true
                        ? Icons.check_circle
                        : Icons.lock,
                    color:
                        achievements['perfectScore'] == true
                            ? Colors.green
                            : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // 🎯 Quiz Master (still locked, future goal)
              Card(
                elevation: 4,
                child: ListTile(
                  leading: const Icon(Icons.verified, size: 40),
                  title: const Text('Quiz Master!'),
                  subtitle: const Text('Completed 5 quizzes.'),
                  trailing: const Icon(Icons.lock, color: Colors.grey),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
