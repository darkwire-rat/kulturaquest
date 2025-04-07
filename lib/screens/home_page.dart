import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KulturaQuest')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // A placeholder for the map or puzzle
            Expanded(
              flex: 2,
              child: Center(
                child: Image.asset(
                  'assets/images/map_placeholder.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Quizzes / Categories / Achievements
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Category buttons or list
                  ElevatedButton(
                    onPressed: () {
                      // Future: Navigate to a quiz screen or show puzzle
                    },
                    child: const Text('Start Puzzle'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Future: Navigate to quizzes
                    },
                    child: const Text('Quizzes'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Future: Navigate to achievements
                    },
                    child: const Text('Achievements'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
