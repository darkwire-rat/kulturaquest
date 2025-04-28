import 'package:flutter/material.dart';

class VisayasScreen extends StatelessWidget {
  const VisayasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Visayas')),
      body: const Center(
        child: Text('Welcome to Visayas!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
