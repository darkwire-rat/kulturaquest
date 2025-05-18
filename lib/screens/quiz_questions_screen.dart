import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class QuizQuestionsScreen extends StatefulWidget {
  final String? presidentName;
  final bool isRandom;

  const QuizQuestionsScreen({Key? key, this.presidentName, this.isRandom = false}) : super(key: key);

  @override
  State<QuizQuestionsScreen> createState() => _QuizQuestionsScreenState();
}

class _QuizQuestionsScreenState extends State<QuizQuestionsScreen> {
  Future<void> generateAndPrintCertificate(String userName, String achievement) async {
    final pdf = pw.Document();
    
    // Initialize logo image
    final ByteData logoData = await rootBundle.load('assets/images/kul.png');
    final Uint8List logoBytes = logoData.buffer.asUint8List();
    final logoImage = pw.MemoryImage(logoBytes);
    
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
          return pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColor.fromInt(0xFF1976D2), width: 4),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            padding: const pw.EdgeInsets.all(40),
            child: pw.Stack(
              children: [
                // Watermark
                pw.Positioned.fill(
                  child: pw.Opacity(
                    opacity: 0.1,
                    child: pw.Center(
                      child: pw.Image(
                        logoImage,
                        width: 300,
                        height: 300,
                        fit: pw.BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                
                // Main Content
                pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    // Logo
                    pw.Image(
                      logoImage,
                      width: 120,
                      height: 120,
                      fit: pw.BoxFit.contain,
                    ),
                    pw.SizedBox(height: 20),
                    
                    // Header
                    pw.Text(
                      'CERTIFICATE OF ACHIEVEMENT',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromInt(0xFF1976D2),
                        letterSpacing: 2,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                    
                    pw.Divider(
                      color: PdfColor.fromInt(0xFF1976D2),
                      thickness: 1,
                      height: 40,
                    ),
                    
                    // Presented to
                    pw.Text(
                      'This certificate is proudly presented to',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontStyle: pw.FontStyle.italic,
                      ),
                    ),
                    pw.SizedBox(height: 20),
                    
                    // User's name
                    pw.Text(
                      userName.toUpperCase(),
                      style: pw.TextStyle(
                        fontSize: 28,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromInt(0xFF1976D2),
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                    
                    pw.SizedBox(height: 20),
                    
                    // Achievement
                    pw.Text(
                      'For successfully completing the $achievement',
                      style: pw.TextStyle(fontSize: 16),
                      textAlign: pw.TextAlign.center,
                    ),
                    
                    pw.SizedBox(height: 40),
                    
                    // Signature and date
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        // Signature line
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Container(
                              width: 200,
                              height: 1,
                              color: PdfColors.black,
                              margin: const pw.EdgeInsets.only(bottom: 5),
                            ),
                            pw.Text(
                              'KulturaQuest Team',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(
                              'Date: ${DateTime.now().toLocal().toString().split(' ')[0]}',
                              style: pw.TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        
                        // Seal/Stamp
                        pw.Container(
                          width: 80,
                          height: 80,
                          decoration: pw.BoxDecoration(
                            shape: pw.BoxShape.circle,
                            border: pw.Border.all(color: PdfColors.red, width: 2),
                          ),
                          child: pw.Center(
                            child: pw.Text(
                              'SEAL',
                              style: pw.TextStyle(
                                color: PdfColors.red,
                                fontSize: 10,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
    
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
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
  }

  Widget _buildCompletionDialog(String title, String message, bool isPerfectScore) {
    return Dialog(
      backgroundColor: const Color(0xFF1D1E33),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: isPerfectScore ? Colors.amber.withOpacity(0.5) : Colors.blueAccent.withOpacity(0.5),
          width: 2,
        ),
      ),
      elevation: 20,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1D1E33),
              const Color(0xFF0A0E21),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Trophy or medal for perfect score
            if (isPerfectScore)
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.amber.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: Colors.amber,
                  size: 60,
                ),
              )
            else
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.blueAccent.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.blueAccent,
                  size: 50,
                ),
              ),
            const SizedBox(height: 24),
            // Title
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // Message
            Text(
              message,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Close button
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.white.withOpacity(0.2)),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // Certificate button
                ElevatedButton(
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    String userName = user?.displayName ?? user?.email ?? 'User';
                    Navigator.pop(context);
                    await generateAndPrintCertificate(
                      userName,
                      isPerfectScore 
                          ? 'Perfect Score! ${score}/${questions.length}' 
                          : 'Score: $score/${questions.length}',
                    );
                    // After generating certificate, go back to quiz list
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPerfectScore ? Colors.amber : Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    shadowColor: (isPerfectScore ? Colors.amber : Colors.blueAccent).withOpacity(0.5),
                  ),
                  child: Text(
                    'Get Certificate',
                    style: TextStyle(
                      color: isPerfectScore ? Colors.black87 : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentQuestionIndex];
    final progress = (currentQuestionIndex + 1) / questions.length;
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: const Color(0xFF0A0E21),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: const Color(0xFF0A0E21),
        body: Stack(
          children: [
            // Background gradient
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1D1E33), Color(0xFF0A0E21)],
                ),
              ),
            ),
            // Decorative elements
            Positioned(
              right: -100,
              top: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              left: -50,
              bottom: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purple.withOpacity(0.1),
                ),
              ),
            ),
            // Main content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App bar with score
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.2)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 24),
                              const SizedBox(width: 8),
                              Text(
                                'Score: $score',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Progress indicator
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Question ${currentQuestionIndex + 1}/${questions.length}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${(progress * 100).toInt()}%',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            backgroundColor: Colors.white.withOpacity(0.1),
                            color: const Color(0xFF00E5FF),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.blueAccent.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Question card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Question ${currentQuestionIndex + 1}',
                              style: const TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            currentQuestion['question'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Options
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: (currentQuestion['choices'] as List<String>).length,
                        itemBuilder: (context, idx) {
                          final choice = (currentQuestion['choices'] as List<String>)[idx];
                          final isCorrectAnswer = choice == currentQuestion['answer'];
                          final isSelected = choice == selectedChoice;
                          
                          Color? cardColor;
                          Color? borderColor;
                          IconData? icon;
                          Color? iconColor;
                          
                          if (isAnswered) {
                            if (isCorrectAnswer) {
                              cardColor = Colors.green.withOpacity(0.1);
                              borderColor = Colors.green.withOpacity(0.5);
                              icon = Icons.check_circle_rounded;
                              iconColor = Colors.greenAccent;
                            } else if (isSelected) {
                              cardColor = Colors.red.withOpacity(0.1);
                              borderColor = Colors.red.withOpacity(0.5);
                              icon = Icons.cancel_rounded;
                              iconColor = Colors.redAccent;
                            } else {
                              cardColor = Colors.white.withOpacity(0.05);
                              borderColor = Colors.white.withOpacity(0.1);
                            }
                          } else {
                            cardColor = Colors.white.withOpacity(0.05);
                            borderColor = Colors.white.withOpacity(0.1);
                          }
                          
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: isAnswered ? null : () => _answerQuestion(choice),
                                borderRadius: BorderRadius.circular(16),
                                splashColor: Colors.white.withOpacity(0.1),
                                highlightColor: Colors.transparent,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected && !isAnswered 
                                          ? Colors.blueAccent.withOpacity(0.8) 
                                          : borderColor!,
                                      width: isSelected && !isAnswered ? 2 : 1,
                                    ),
                                    boxShadow: [
                                      if (isSelected && !isAnswered)
                                        BoxShadow(
                                          color: Colors.blueAccent.withOpacity(0.3),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      // Option letter
                                      Container(
                                        width: 36,
                                        height: 36,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: isAnswered
                                              ? (isCorrectAnswer 
                                                  ? Colors.green.withOpacity(0.2) 
                                                  : isSelected 
                                                      ? Colors.red.withOpacity(0.2) 
                                                      : Colors.white.withOpacity(0.1))
                                              : (isSelected 
                                                  ? Colors.blueAccent.withOpacity(0.2) 
                                                  : Colors.white.withOpacity(0.1)),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          String.fromCharCode(65 + idx), // A, B, C, D
                                          style: TextStyle(
                                            color: isAnswered
                                                ? (isCorrectAnswer 
                                                    ? Colors.greenAccent 
                                                    : isSelected 
                                                        ? Colors.redAccent 
                                                        : Colors.white70)
                                                : (isSelected 
                                                    ? Colors.blueAccent 
                                                    : Colors.white70),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      // Option text
                                      Expanded(
                                        child: Text(
                                          choice,
                                          style: TextStyle(
                                            color: isAnswered
                                                ? (isCorrectAnswer 
                                                    ? Colors.greenAccent 
                                                    : isSelected 
                                                        ? Colors.redAccent 
                                                        : Colors.white70)
                                                : Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                      // Icon indicator
                                      if (isAnswered && icon != null)
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8),
                                          child: Icon(
                                            icon,
                                            color: iconColor,
                                            size: 24,
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
                    // Next button or completion indicator
                    if (isAnswered)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 16),
                        child: ElevatedButton(
                          onPressed: () {
                            if (currentQuestionIndex < questions.length - 1) {
                              setState(() {
                                currentQuestionIndex++;
                                selectedChoice = null;
                                isCorrect = null;
                                isAnswered = false;
                              });
                            } else {
                              // Quiz completed
                              saveQuizAchievement(score, questions.length);
                              if (score == questions.length) {
                                showDialog(
                                  context: context,
                                  builder: (_) => _buildCompletionDialog(
                                    '🏆 Perfect Score!',
                                    'Congratulations! You answered all questions correctly!',
                                    true,
                                  ),
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (_) => _buildCompletionDialog(
                                    'Quiz Completed!',
                                    'You scored $score out of ${questions.length}!',
                                    false,
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 5,
                            shadowColor: Colors.blueAccent.withOpacity(0.5),
                          ),
                          child: Text(
                            currentQuestionIndex < questions.length - 1 ? 'Next Question' : 'See Results',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
