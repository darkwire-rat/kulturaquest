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
import 'screens/traditions_quiz_screen.dart';
import 'screens/history_quiz_screen.dart';
import 'screens/luzon_screen.dart';
import 'screens/visayas_screen.dart';
import 'screens/mindanao_screen.dart';
import 'screens/category_detail_screen.dart';
import 'screens/achievements_screen.dart';

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
        '/': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          if (args != null && args.containsKey('initialTab')) {
            return MainScreen(initialTab: args['initialTab']);
          }
          return const LanguageSelectionScreen();
        },
        '/luzon': (context) => const LuzonScreen(),
        '/visayas': (context) => const VisayasScreen(),
        '/mindanao': (context) => const MindanaoScreen(),
        '/achievements': (context) => const AchievementsScreen(),
        '/category': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return CategoryDetailScreen(category: args['category']);
        },
        '/traditions': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return TraditionsQuizScreen(region: args?['region']);
        },
        '/history': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return HistoryQuizScreen(region: args?['region']);
        },
        '/main': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return MainScreen(initialTab: args?['initialTab']);
        },
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
        '/president_quiz': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return PresidentQuizScreen(
            presidentName: args['presidentName'],
            quizTitle: args['quizTitle'],
          );
        },
      },
    );
  }
}
