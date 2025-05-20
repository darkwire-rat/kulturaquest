import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'category_detail_screen.dart';
import 'heroes_screen.dart';
import 'traditions_quiz_screen.dart';
import 'history_quiz_screen.dart';
import 'dart:math' as math;

class QuizzesTab extends StatelessWidget {
  const QuizzesTab({super.key});

  void _handleCategoryTap(BuildContext context, String category) {
    if (category == 'Presidents') {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => CategoryDetailScreen(category: category),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.easeInOutCubic;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(position: animation.drive(tween), child: child);
          },
        ),
      );
    } else if (category == 'Heroes') {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HeroesScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.easeInOutCubic;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(position: animation.drive(tween), child: child);
          },
        ),
      );
    } else if (category == 'Traditions') {
      // Show dialog to choose region or random
      showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Choose a Region'),
            children: [
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, 'Luzon'),
                child: const Text('Luzon Traditions'),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, 'Visayas'),
                child: const Text('Visayas Traditions'),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, 'Mindanao'),
                child: const Text('Mindanao Traditions'),
              ),
              const Divider(),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, 'Random'),
                child: const Text('Random Traditions Quiz'),
              ),
            ],
          );
        },
      ).then((selected) {
        if (selected != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TraditionsQuizScreen(
                region: selected == 'Random' ? null : selected,
                isRandom: selected == 'Random',
              ),
            ),
          );
        }
      });
    } else if (category == 'History') {
      // Show dialog to choose region or random
      showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Choose a Region'),
            children: [
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, 'Luzon'),
                child: const Text('Luzon History'),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, 'Visayas'),
                child: const Text('Visayas History'),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, 'Mindanao'),
                child: const Text('Mindanao History'),
              ),
              const Divider(),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, 'Random'),
                child: const Text('Random History Quiz'),
              ),
            ],
          );
        },
      ).then((selected) {
        if (selected != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HistoryQuizScreen(
                region: selected == 'Random' ? null : selected,
                isRandom: selected == 'Random',
              ),
            ),
          );
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$category Quiz Coming Soon!'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'name': 'History', 
        'image': 'assets/images/history.jpg',
        'gradient': [Colors.indigo, Colors.purple],
        'icon': Icons.history_rounded,
      },
      {
        'name': 'Heroes', 
        'image': 'assets/images/heroes.jpg',
        'gradient': [Colors.red, Colors.orange],
        'icon': Icons.military_tech_rounded,
      },
      {
        'name': 'Presidents', 
        'image': 'assets/images/16pres.jpg',
        'gradient': [Colors.blue, Colors.teal],
        'icon': Icons.person_outline_rounded,
      },
      {
        'name': 'Traditions', 
        'image': 'assets/images/trad.jpg',
        'gradient': [Colors.green, Colors.lightGreen],
        'icon': Icons.celebration_rounded,
      },
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: const Color(0xFF0A0E21),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0E21),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 180,
              pinned: true,
              backgroundColor: const Color(0xFF0A0E21),
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Quiz Categories',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                centerTitle: true,
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF1D1E33).withOpacity(0.8),
                        const Color(0xFF0A0E21).withOpacity(0.1),
                      ],
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            const Color(0xFF0A0E21).withOpacity(0.9),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.9,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final category = categories[index];
                    return _buildCategoryCard(context, category);
                  },
                  childCount: categories.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, Map<String, dynamic> category) {
    return GestureDetector(
      onTap: () => _handleCategoryTap(context, category['name']),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Stack(
          children: [
            // Background with gradient and image
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: (category['gradient'] as List<Color>)
                      .map((color) => color.withOpacity(0.9))
                      .toList(),
                ),
                boxShadow: [
                  BoxShadow(
                    color: (category['gradient'][0] as Color).withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    // Background image with overlay
                    Positioned.fill(
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.5),
                          BlendMode.darken,
                        ),
                        child: Image.asset(
                          category['image'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Gradient overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Icon
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              category['icon'],
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Title
                          Text(
                            category['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Subtitle
                          const Text(
                            'Test your knowledge',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Particles effect
                    ...List.generate(
                      8,
                      (index) => Positioned(
                        left: math.Random().nextDouble() * 200,
                        top: math.Random().nextDouble() * 200,
                        child: Container(
                          width: 2,
                          height: 2,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Hover effect
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => _handleCategoryTap(context, category['name']),
                  splashColor: Colors.white.withOpacity(0.2),
                  highlightColor: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
