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
      _showRegionDialog(context, 'Traditions');
    } else if (category == 'History') {
      _showRegionDialog(context, 'History');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$category Quiz Coming Soon!'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: const Color(0xFF8B4513),
        ),
      );
    }
  }

  void _showRegionDialog(BuildContext context, String category) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          backgroundColor: const Color(0xFFF0E6D2), // Parchment color
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choose a Region',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF5F4B32),
                    fontFamily: 'Serif',
                  ),
                ),
                const SizedBox(height: 8),
                // Decorative divider
                Container(
                  height: 2,
                  width: 60,
                  color: const Color(0xFFD2B48C), // Tan color
                ),
                const SizedBox(height: 20),
                // Luzon option with blue accent
                _buildRegionOption(
                  context,
                  'Luzon',
                  category,
                  Colors.blue[700]!,
                  Icons.location_on,
                ),
                const SizedBox(height: 12),
                // Visayas option with yellow/amber accent
                _buildRegionOption(
                  context,
                  'Visayas',
                  category,
                  Colors.amber[700]!,
                  Icons.location_on,
                ),
                const SizedBox(height: 12),
                // Mindanao option with red accent
                _buildRegionOption(
                  context,
                  'Mindanao',
                  category,
                  Colors.red[700]!,
                  Icons.location_on,
                ),
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFD2B48C)),
                const SizedBox(height: 16),
                // Random option
                _buildRegionOption(
                  context,
                  'Random',
                  category,
                  const Color(0xFF8B4513), // Saddle brown
                  Icons.shuffle,
                ),
              ],
            ),
          ),
        );
      },
    ).then((selected) {
      if (selected != null) {
        if (category == 'History') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HistoryQuizScreen(
                region: selected == 'Random' ? null : selected,
                isRandom: selected == 'Random',
              ),
            ),
          );
        } else if (category == 'Traditions') {
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
      }
    });
  }

  Widget _buildRegionOption(BuildContext context, String region, String category, Color accentColor, IconData icon) {
    final String label = region == 'Random' ? 'Random $category Quiz' : '$region $category';

    return InkWell(
      onTap: () => Navigator.pop(context, region),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: accentColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accentColor, width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: accentColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF5F4B32),
                  fontFamily: 'Serif',
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: accentColor, size: 16),
          ],
        ),
      ),
    );
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
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2,
                    color: Colors.white,
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
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 30.0), // Added extra bottom padding
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8, // Adjusted for more height
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: (category['gradient'][0] as Color).withOpacity(0.6),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
        ),
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
                      padding: const EdgeInsets.all(12.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min, // Minimize vertical space
                          children: [
                            // Icon with glowing effect
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Icon(
                                category['icon'],
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Title with highlight
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: (category['gradient'][0] as Color).withOpacity(0.7),
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                category['name'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Subtitle with shine effect
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Test your knowledge',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
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
            // Hover effect with pulsing animation
            Positioned.fill(
              child: TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(seconds: 2),
                curve: Curves.easeInOut,
                builder: (context, double value, child) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3 + (0.2 * math.sin(value * math.pi * 2))),
                        width: 1.0 + (0.5 * math.sin(value * math.pi * 2)),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
