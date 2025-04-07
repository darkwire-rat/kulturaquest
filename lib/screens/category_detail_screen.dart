import 'package:flutter/material.dart';

class CategoryDetailScreen extends StatelessWidget {
  final String category;
  const CategoryDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // Check if the selected category is "Cuisine"
    if (category == "Cuisine") {
      // Display a single large representative image for Cuisine
      return Scaffold(
        appBar: AppBar(title: Text(category)),
        body: Center(
          child: Image.asset(
            'assets/images/food.jpg', // Use your representative image here
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      // For other categories, display a grid of items
      List<Map<String, String>> items = [];
      switch (category) {
        case "Philippine Presidents":
          items = [
            {
              "name": "Emilio Aguinaldo",
              "image": "assets/images/aguinaldo.png",
            },
            {"name": "Manuel L. Quezon", "image": "assets/images/quezon.png"},
            {"name": "Ramon Magsaysay", "image": "assets/images/magsaysay.png"},
            {"name": "Ferdinand Marcos", "image": "assets/images/marcos.png"},
            {"name": "Corazon Aquino", "image": "assets/images/aquino.png"},
          ];
          break;
        // You can add similar cases for "Heroes", "Architecture", etc.
        default:
          items = [];
      }

      return Scaffold(
        appBar: AppBar(title: Text(category)),
        body: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(
              elevation: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    item["image"] ?? "assets/images/placeholder.png",
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item["name"] ?? "",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }
  }
}
