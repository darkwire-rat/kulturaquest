import 'package:flutter/material.dart';
import 'president_detail_screen.dart';
import 'quiz_questions_screen.dart'; // Make sure this is imported!

class CategoryDetailScreen extends StatelessWidget {
  final String category;
  const CategoryDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> items = [];

    if (category == 'Presidents') {
      items = [
        {'name': 'Emilio Aguinaldo', 'image': 'assets/images/emilio.jpg'},
        {'name': 'Manuel L. Quezon', 'image': 'assets/images/quezon.jpg'},
        {'name': 'Ramon Magsaysay', 'image': 'assets/images/magsaysay.jpg'},
        {'name': 'Ferdinand Marcos', 'image': 'assets/images/fmarcos.jpg'},
        {'name': 'Corazon Aquino', 'image': 'assets/images/corazon.jpg'},
      ];
    }

    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body:
          items.isEmpty
              ? const Center(child: Text('No data available yet!'))
              : Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => PresidentDetailScreen(
                                      name: item['name']!,
                                      imagePath: item['image']!,
                                    ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(8),
                                    ),
                                    child: Image.asset(
                                      item['image']!,
                                      fit:
                                          BoxFit
                                              .cover, // ✅ fill the box properly
                                      alignment:
                                          Alignment
                                              .topCenter, // ✅ focus on top (face area)
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    item['name'] ?? '',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QuizQuestionsScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "LET'S START",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
