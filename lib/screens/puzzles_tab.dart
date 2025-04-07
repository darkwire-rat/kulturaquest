import 'package:flutter/material.dart';

class PuzzlesTab extends StatelessWidget {
  const PuzzlesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Puzzles')),
      body: const Center(child: Text('This is the Puzzles screen')),
    );
  }
}
