import 'package:flutter/material.dart';

class QuizzesTab extends StatelessWidget {
  const QuizzesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quizzes')),
      body: const Center(child: Text('This is the Quizzes screen')),
    );
  }
}
