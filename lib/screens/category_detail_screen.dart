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
        {
          'name': 'Emilio Aguinaldo',
          'image': 'assets/images/emilio.jpg',
          'term': '1899-1901'
        },
        {
          'name': 'Manuel L. Quezon',
          'image': 'assets/images/quezon.jpg',
          'term': '1935-1944'
        },
        {
          'name': 'Ramon Magsaysay',
          'image': 'assets/images/magsaysay.jpg',
          'term': '1953-1957'
        },
        {
          'name': 'Ferdinand Marcos',
          'image': 'assets/images/fmarcos.jpg',
          'term': '1965-1986'
        },
        {
          'name': 'Corazon Aquino',
          'image': 'assets/images/corazon.jpg',
          'term': '1986-1992'
        },
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
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
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
                                      term: item['term'],
                                    ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            margin: const EdgeInsets.only(bottom: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // President Image
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                    ),
                                    child: Image.asset(
                                      item['image']!,
                                      width: 120,
                                      height: 140,
                                      fit: BoxFit.cover,
                                      alignment: Alignment.topCenter,
                                    ),
                                  ),
                                  // President Info
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            item['name'] ?? '',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              height: 1.3,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Term: ${item['term'] ?? ''}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Tap to view details',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontStyle: FontStyle.italic,
                                              color: Colors.orange[800],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () async {
                        // Show dialog to choose president or random
                        final selected = await showDialog<String>(
                          context: context,
                          builder: (context) {
                            return SimpleDialog(
                              title: const Text('Choose a President Quiz'),
                              children: [
                                ...items.map((item) => SimpleDialogOption(
                                      onPressed: () => Navigator.pop(context, item['name']),
                                      child: Text(item['name'] ?? ''),
                                    )),
                                const Divider(),
                                SimpleDialogOption(
                                  onPressed: () => Navigator.pop(context, 'Random'),
                                  child: const Text('Random President Quiz'),
                                ),
                              ],
                            );
                          },
                        );
                        if (selected != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizQuestionsScreen(
                                presidentName: selected == 'Random' ? null : selected,
                                isRandom: selected == 'Random',
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Start Presidents Quiz",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
