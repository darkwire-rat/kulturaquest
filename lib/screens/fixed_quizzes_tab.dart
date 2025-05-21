import 'package:flutter/material.dart';
import 'category_detail_screen.dart';
import 'heroes_screen.dart';
import 'traditions_quiz_screen.dart';
import 'history_quiz_screen.dart';

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
      _showRegionDialog(context, 'Traditions');
    } else if (category == 'History') {
      // Show dialog to choose region or random
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
        'description': 'Test your knowledge of Philippine history across regions',
        'icon': Icons.history_rounded,
        'color': Colors.blue[700], // Blue for History (like Luzon)
        'points': 31, // Total points for History category
      },
      {
        'name': 'Heroes', 
        'image': 'assets/images/heroes.jpg',
        'description': 'Learn about the national heroes who shaped the Philippines',
        'icon': Icons.military_tech_rounded,
        'color': Colors.red[700], // Red for Heroes (like Mindanao)
        'points': 35, // Total points for Heroes category
      },
      {
        'name': 'Presidents', 
        'image': 'assets/images/16pres.jpg',
        'description': 'Explore the legacy of Philippine presidents through time',
        'icon': Icons.person_outline_rounded,
        'color': Colors.deepPurple[700], // Purple for Presidents
        'points': 40, // Total points for Presidents category
      },
      {
        'name': 'Traditions', 
        'image': 'assets/images/trad.jpg',
        'description': 'Discover the rich cultural traditions across the archipelago',
        'icon': Icons.celebration_rounded,
        'color': Colors.amber[700], // Yellow/Amber for Traditions (like Visayas)
        'points': 31, // Total points for Traditions category
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historical Quizzes', 
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF5F4B32), // Dark brown text
            fontFamily: 'Serif',
            fontSize: 24,
          ),
        ),
        backgroundColor: const Color(0xFFF5EFE0), // Parchment/vintage paper color
        elevation: 4,
        shadowColor: Color(0xFFD0C8B0), // Subtle shadow for depth
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/philpic.jpg'),
            fit: BoxFit.cover,
            opacity: 0.2, // Faded background image
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF5EFE0), // Parchment/vintage paper color at top
                Color(0xFFE8DFC9), // Slightly darker vintage color at bottom
              ],
              stops: [0.0, 1.0],
            ),
          ),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0E6D2), // Lighter parchment color
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFD2B48C), // Tan border
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8B4513).withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Test Your Knowledge',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B4513), // Saddle brown
                            fontFamily: 'Serif',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Explore Philippine history through interactive quizzes',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.brown[700],
                            fontFamily: 'Serif',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
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
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, Map<String, dynamic> category) {
    final Color categoryColor = category['color'] as Color;
    final String categoryName = category['name'] as String;
    final String description = category['description'] as String;
    final IconData icon = category['icon'] as IconData;
    final int points = category['points'] as int;
    
    return InkWell(
      onTap: () => _handleCategoryTap(context, categoryName),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Pure white background
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: categoryColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Category icon with colored background
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: categoryColor, width: 2),
                ),
                child: Icon(
                  icon,
                  color: categoryColor,
                  size: 28,
                ),
              ),
              const SizedBox(height: 12),
              // Category name
              Text(
                categoryName,
                style: TextStyle(
                  color: const Color(0xFF5F4B32),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Serif',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              // Decorative divider
              Container(
                height: 2,
                width: 40,
                color: categoryColor,
              ),
              const SizedBox(height: 6),
              // Description
              Text(
                description,
                style: const TextStyle(
                  color: Color(0xFF5F4B32),
                  fontSize: 12,
                  fontFamily: 'Serif',
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              // Points indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: categoryColor, width: 1),
                ),
                child: Text(
                  '$points pts',
                  style: TextStyle(
                    color: categoryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
