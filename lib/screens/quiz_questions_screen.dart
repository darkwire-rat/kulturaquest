import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuizQuestionsScreen extends StatefulWidget {
  const QuizQuestionsScreen({super.key});

  @override
  State<QuizQuestionsScreen> createState() => _QuizQuestionsScreenState();
}

class _QuizQuestionsScreenState extends State<QuizQuestionsScreen> {
  final List<Map<String, Object>> questions = [
    {
      'question': 'When did Emilio Aguinaldo declare Philippine Independence?',
      'choices': [
        'June 12, 1898',
        'July 4, 1946',
        'August 30, 1896',
        'December 30, 1898',
      ],
      'answer': 'June 12, 1898',
    },
    {
      'question': 'Where was Emilio Aguinaldo born?',
      'choices': ['Manila', 'Kawit, Cavite', 'Malolos, Bulacan', 'Cebu City'],
      'answer': 'Kawit, Cavite',
    },
    {
      'question':
          'What was Emilio Aguinaldo\'s title during the Philippine Revolution?',
      'choices': [
        'General',
        'President',
        'Commander-in-Chief',
        'First Supremo',
      ],
      'answer': 'President',
    },
    {
      'question': 'Who captured Emilio Aguinaldo in 1901?',
      'choices': [
        'Andres Bonifacio',
        'Antonio Luna',
        'American Forces',
        'Japanese Army',
      ],
      'answer': 'American Forces',
    },
    {
      'question': 'In which town did Aguinaldo surrender to American forces?',
      'choices': [
        'Palanan, Isabela',
        'Kawit, Cavite',
        'Balangiga, Samar',
        'Manila',
      ],
      'answer': 'Palanan, Isabela',
    },
  ];

  int currentQuestionIndex = 0;
  int score = 0; // 🎯 Tracking score

  // Saving function to Firestore
  Future<void> saveQuizAchievement(int score, int totalQuestions) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'achievements': {
          'firstQuizCompleted': true,
          'perfectScore': score == totalQuestions,
        },
      }, SetOptions(merge: true));
    }
  }

  void _answerQuestion(String selectedChoice) {
    bool isCorrect =
        selectedChoice == questions[currentQuestionIndex]['answer'];

    if (isCorrect) {
      setState(() {
        score++;
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCorrect ? 'Correct!' : 'Wrong!'),
        duration: const Duration(seconds: 1),
      ),
    );

    Future.delayed(const Duration(seconds: 1), () async {
      if (currentQuestionIndex < questions.length - 1) {
        setState(() {
          currentQuestionIndex++;
        });
      } else {
        // 🎯 Quiz finished
        await saveQuizAchievement(
          score,
          questions.length,
        ); // ✅ Save to Firestore

        if (score == questions.length) {
          // 🏆 Special Perfect Score Popup
          showDialog(
            context: context,
            builder:
                (_) => AlertDialog(
                  title: const Text('🏆 Perfect Score!'),
                  content: const Text(
                    'Congratulations! You answered all questions correctly!',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context); // Back to main screen
                      },
                      child: const Text('Awesome!'),
                    ),
                  ],
                ),
          );
        } else {
          // Normal Quiz Completed Popup
          showDialog(
            context: context,
            builder:
                (_) => AlertDialog(
                  title: const Text('Quiz Completed!'),
                  content: Text(
                    'You scored $score out of ${questions.length}!',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context); // Back to main screen
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz on Emilio Aguinaldo'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Score: $score',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${currentQuestionIndex + 1} of ${questions.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              currentQuestion['question'] as String,
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 30),
            ...(currentQuestion['choices'] as List<String>).map((choice) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  onPressed: () => _answerQuestion(choice),
                  child: Text(choice),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
