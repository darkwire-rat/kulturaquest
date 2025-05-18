import 'package:flutter/material.dart';
import 'hero_detail_screen.dart';
import 'hero_quiz_screen.dart';

class HeroesScreen extends StatelessWidget {
  const HeroesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filipino Heroes'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.blue.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'National Heroes of the Philippines',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Learn about the lives and contributions of Filipino heroes who shaped our nation',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            
            // Heroes List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Hero Profiles',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ),
            const SizedBox(height: 8),
            
            // Jose Rizal
            _buildHeroCard(
              context: context,
              name: 'Jose Rizal',
              imagePath: 'assets/images/heroes.jpg',
              subtitle: 'National Hero of the Philippines',
              birth: 'June 19, 1861',
              death: 'December 30, 1896',
              causeOfDeath: 'Execution by firing squad',
              quizTitle: 'Jose Rizal Quiz',
              quizDescription: "Test your knowledge about Jose Rizal's life, works, and legacy",
            ),
            
            // Andres Bonifacio
            _buildHeroCard(
              context: context,
              name: 'Andres Bonifacio',
              imagePath: 'assets/images/heroes.jpg',
              subtitle: 'Father of the Philippine Revolution',
              birth: 'November 30, 1863',
              death: 'May 10, 1897',
              causeOfDeath: 'Execution (trial by the Revolutionary Court)',
              quizTitle: 'Andres Bonifacio Quiz',
              quizDescription: "Test your knowledge about the Supremo of the Katipunan",
            ),
            
            // Antonio Luna
            _buildHeroCard(
              context: context,
              name: 'Antonio Luna',
              imagePath: 'assets/images/heroes.jpg',
              subtitle: 'Chief General of the Philippine Revolutionary Army',
              birth: 'October 29, 1866',
              death: 'June 5, 1899',
              causeOfDeath: 'Assassination',
              quizTitle: 'Antonio Luna Quiz',
              quizDescription: "Test your knowledge about this brilliant military strategist",
            ),
            
            // Apolinario Mabini
            _buildHeroCard(
              context: context,
              name: 'Apolinario Mabini',
              imagePath: 'assets/images/philpic.jpeg',
              subtitle: 'The Sublime Paralytic',
              birth: 'July 23, 1864',
              death: 'May 13, 1903',
              causeOfDeath: 'Cholera',
              quizTitle: 'Apolinario Mabini Quiz',
              quizDescription: "Test your knowledge about the Brains of the Revolution",
            ),
            
            // Emilio Jacinto
            _buildHeroCard(
              context: context,
              name: 'Emilio Jacinto',
              imagePath: 'assets/images/philpic.jpeg',
              subtitle: 'Brains of the Katipunan',
              birth: 'December 15, 1875',
              death: 'April 16, 1899',
              causeOfDeath: 'Malaria',
              quizTitle: 'Emilio Jacinto Quiz',
              quizDescription: "Test your knowledge about this young revolutionary leader"
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard({
    required BuildContext context,
    required String name,
    required String imagePath,
    required String subtitle,
    required String birth,
    required String death,
    required String causeOfDeath,
    required String quizTitle,
    required String quizDescription,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            // Hero Info Section
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HeroDetailScreen(
                      name: name,
                      imagePath: imagePath,
                      birth: birth,
                      death: death,
                      causeOfDeath: causeOfDeath,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        imagePath,
                        width: 80,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 80,
                          height: 100,
                          color: Colors.grey[300],
                          child: const Icon(Icons.person, size: 40, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // Hero Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$birth - $death',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Cause of Death: $causeOfDeath',
                            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blue),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            
            // Quiz Section
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HeroQuizScreen(
                      heroName: name,
                      quizTitle: quizTitle,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.quiz, color: Colors.blue[700]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quizTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            quizDescription,
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.blue),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
