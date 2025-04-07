import 'package:flutter/material.dart';
import 'screens/language_selection_screen.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KulturaQuest',
      theme: ThemeData(primarySwatch: Colors.orange),
      initialRoute: '/language',
      routes: {
        '/language': (context) => const LanguageSelectionScreen(),
        '/main':
            (context) =>
                const MainScreen(), // MainScreen holds the bottom nav bar with HomeTab etc.
      },
    );
  }
}
