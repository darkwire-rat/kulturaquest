import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'screens/language_selection_screen.dart';
import 'screens/main_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/heroes_screen.dart';
import 'screens/hero_quiz_screen.dart';
import 'screens/president_detail_screen.dart';
import 'screens/president_quiz_screen.dart';
import 'screens/stories_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KulturaQuest',
      theme: ThemeData(primarySwatch: Colors.orange),
      initialRoute: '/',
      routes: {
        '/': (context) => const LanguageSelectionScreen(),
        '/main': (context) => const MainScreen(),
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/heroes': (context) => const HeroesScreen(),
        '/presidents': (context) => const MainScreen(),
        '/hero_quiz': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return HeroQuizScreen(
            heroName: args['heroName'],
            quizTitle: args['quizTitle'],
          );
        },
        '/president_detail': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return PresidentDetailScreen(
            name: args['name'],
            imagePath: args['imagePath'],
            term: args['term'],
          );
        },
        '/stories': (context) => const StoriesScreen(),
      },
    );
  }
}
