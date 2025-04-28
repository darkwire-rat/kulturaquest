import 'package:flutter/material.dart';

class LuzonScreen extends StatelessWidget {
  const LuzonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Luzon')),
      body: const Center(
        child: Text('Welcome to Luzon!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
