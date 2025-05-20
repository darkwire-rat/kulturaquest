import 'package:flutter/material.dart';
import 'home_tab.dart';
import 'quizzes_tab.dart';
import 'achievements_tab.dart';
import 'profile_tab.dart';
import 'puzzles_tab.dart';

class MainScreen extends StatefulWidget {
  final int? initialTab;
  
  const MainScreen({super.key, this.initialTab});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    // Use initialTab if provided, otherwise default to 0 (Home tab)
    _currentIndex = widget.initialTab ?? 0;
  }

  // List of pages corresponding to each bottom navigation item.
  final List<Widget> _pages = const [
    HomeTab(), // Home
    QuizzesTab(), // Quizzes
    AchievementsTab(), // Achievements
    ProfileTab(), // Profile
    PuzzlesTab(), // Puzzles
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body displays the currently selected page.
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: const Color(0xFFF5EFE0), // Parchment/vintage paper color
        selectedItemColor: const Color(0xFF8B4513), // Saddle brown - historic wood color
        unselectedItemColor: const Color(0xFF5F4B32), // Lighter brown for unselected items
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            label: 'Quizzes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Achievements',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.extension,
            ), // Using extension as a placeholder for puzzles
            label: 'Puzzles',
          ),
        ],
      ),
    );
  }
}
