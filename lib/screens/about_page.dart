import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About KulturaQuest')),
      body: const Center(child: Text('Para sa  ')), //TUNGKOL SATEN PRE
    );
  }
}
