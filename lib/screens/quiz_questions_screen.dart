import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class QuizQuestionsScreen extends StatefulWidget {
  const QuizQuestionsScreen({super.key});

  @override
  State<QuizQuestionsScreen> createState() => _QuizQuestionsScreenState();
}

class _QuizQuestionsScreenState extends State<QuizQuestionsScreen> {
  Future<void> generateAndPrintCertificate(String userName, String achievement) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Container(
            width: 500,
            height: 350,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.blue, width: 4),
              borderRadius: pw.BorderRadius.circular(16),
            ),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  'Certificate of Achievement',
                  style: pw.TextStyle(fontSize: 32, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Presented to',
                  style: pw.TextStyle(fontSize: 18),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  userName,
                  style: pw.TextStyle(fontSize: 26, fontWeight: pw.FontWeight.bold, color: PdfColors.blue),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'For: ' + achievement,
                  style: pw.TextStyle(fontSize: 18),
                ),
                pw.SizedBox(height: 30),
                pw.Text(
                  'Date: ' + DateTime.now().toLocal().toString().split(' ')[0],
                  style: pw.TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

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
  String? selectedChoice;
  bool? isCorrect;
  bool isAnswered = false;

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

  void _answerQuestion(String choice) {
    if (isAnswered) return;
    setState(() {
      selectedChoice = choice;
      isCorrect = choice == questions[currentQuestionIndex]['answer'];
      isAnswered = true;
      if (isCorrect!) score++;
    });
    Future.delayed(const Duration(milliseconds: 1200), () async {
      if (currentQuestionIndex < questions.length - 1) {
        setState(() {
          currentQuestionIndex++;
          selectedChoice = null;
          isCorrect = null;
          isAnswered = false;
        });
      } else {
        await saveQuizAchievement(score, questions.length);
        if (score == questions.length) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('🏆 Perfect Score!'),
              content: const Text('Congratulations! You answered all questions correctly!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('Awesome!'),
                ),
              ],
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Quiz Completed!'),
              content: Text('You scored $score out of ${questions.length}!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
                TextButton(
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    String userName = user?.displayName ?? user?.email ?? 'User';
                    await generateAndPrintCertificate(
                      userName,
                      'Quiz Completed: $score out of ${questions.length}',
                    );
                  },
                  child: const Text('Download Certificate'),
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
        backgroundColor: Colors.blueAccent,
        elevation: 2,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                const Icon(Icons.emoji_events, color: Colors.amber, size: 24),
                const SizedBox(width: 6),
                Text(
                  'Score: $score',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  minHeight: 10,
                  value: (currentQuestionIndex + 1) / questions.length,
                  backgroundColor: Colors.grey[300],
                  color: Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Question ${currentQuestionIndex + 1} of ${questions.length}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      currentQuestion['question'] as String,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            Expanded(
              child: ListView.builder(
                itemCount: (currentQuestion['choices'] as List<String>).length,
                itemBuilder: (context, idx) {
                  final choice = (currentQuestion['choices'] as List<String>)[idx];
                  Color? cardColor;
                  IconData? icon;
                  if (isAnswered) {
                    if (choice == currentQuestion['answer']) {
                      cardColor = Colors.green[100];
                      icon = Icons.check_circle;
                    } else if (choice == selectedChoice) {
                      cardColor = Colors.red[100];
                      icon = Icons.cancel;
                    } else {
                      cardColor = Colors.white;
                    }
                  } else {
                    cardColor = Colors.white;
                  }
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: isAnswered ? null : () => _answerQuestion(choice),
                      child: Card(
                        elevation: selectedChoice == choice ? 6 : 2,
                        color: cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: selectedChoice == choice
                              ? BorderSide(color: Colors.blueAccent, width: 2)
                              : BorderSide(color: Colors.grey[300]!, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
                          child: Row(
                            children: [
                              if (isAnswered && icon != null)
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Icon(icon, color: icon == Icons.check_circle ? Colors.green : Colors.red, size: 28),
                                ),
                              Expanded(
                                child: Text(
                                  choice,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: isAnswered
                                        ? (choice == currentQuestion['answer']
                                            ? Colors.green[900]
                                            : (choice == selectedChoice ? Colors.red[900] : Colors.black87))
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
