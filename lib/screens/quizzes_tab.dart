import 'package:flutter/material.dart';
import 'category_detail_screen.dart'; // 🚨 Make sure this is imported if using direct navigation

class QuizzesTab extends StatelessWidget {
  const QuizzesTab({super.key});

  void _handleCategoryTap(BuildContext context, String category) {
    if (category == 'Presidents') {
      // ✅ Navigate to the actual quiz screen for Presidents
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CategoryDetailScreen(category: category),
        ),
      );
    } else {
      // 🛑 Other categories still show "Coming Soon!"
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$category Quiz Coming Soon!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'History', 'image': 'assets/images/history.jpg'},
      {'name': 'Heroes', 'image': 'assets/images/heroes.jpg'},
      {'name': 'Presidents', 'image': 'assets/images/16pres.jpg'},
      {'name': 'Traditions', 'image': 'assets/images/trad.jpg'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Quizzes')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Select a Quiz Category:',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ...categories.map((category) {
            return Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              child: InkWell(
                onTap: () => _handleCategoryTap(context, category['name']!),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(category['image']!),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        category['name']!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
