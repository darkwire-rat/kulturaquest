import 'package:flutter/material.dart';
import 'category_detail_screen.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  // Define your categories
  final List<Map<String, String>> categories = const [
    {"title": "Philippine Presidents", "image": "assets/images/president.png"},
    {"title": "Heroes", "image": "assets/images/heroes.png"},
    {"title": "Cuisine", "image": "assets/images/food.jpg"},
    {"title": "Architecture", "image": "assets/images/architecture.png"},
    {"title": "Religion and Beliefs", "image": "assets/images/religion.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two cards per row
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              // Navigate to the detail screen and pass the category title.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          CategoryDetailScreen(category: category["title"]!),
                ),
              );
            },
            child: Card(
              elevation: 4,
              clipBehavior:
                  Clip.antiAlias, // Ensures the image fits within the card.
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background image
                  Image.asset(category["image"]!, fit: BoxFit.cover),
                  // Optional overlay for text readability
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  // Centered title text
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        category["title"]!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
