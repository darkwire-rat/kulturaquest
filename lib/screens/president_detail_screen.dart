import 'package:flutter/material.dart';

class PresidentDetailScreen extends StatelessWidget {
  final String name;
  final String imagePath;

  const PresidentDetailScreen({
    super.key,
    required this.name,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    // Hardcoded info based on president name
    String biography = '';

    if (name == "Emilio Aguinaldo") {
      biography =
          "Emilio Aguinaldo (1869–1964) was a Filipino revolutionary leader and military commander who fought for independence against Spain and later against the United States. "
          "He declared Philippine independence on June 12, 1898 and served as the first President of the Philippines.";
    } else {
      biography = 'Biography or information about $name will be shown here.';
    }

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset(imagePath, height: 150),
            const SizedBox(height: 20),
            Text(
              biography,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
