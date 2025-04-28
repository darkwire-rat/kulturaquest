import 'package:flutter/material.dart';

class MindanaoScreen extends StatelessWidget {
  const MindanaoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mindanao')),
      body: const Center(
        child: Text('Welcome to Mindanao!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
