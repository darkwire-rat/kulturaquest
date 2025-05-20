import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flip_card/flip_card.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter/services.dart';

class VisayasScreen extends StatelessWidget {
  const VisayasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visayas: History & Heritage'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2E7D32), Color(0xFF81C784)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
        ),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Image and Subtitle
                  Container(
                    height: 220,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Background image - using philpic.jpg as preferred by the user
                        Image.asset(
                          'images/philpic.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.green[200],
                              child: Center(
                                child: Icon(Icons.image_not_supported, size: 50, color: Colors.green[800]),
                              ),
                            );
                          },
                        ),
                        // Gradient overlay for better text readability
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.2),
                                Colors.black.withOpacity(0.6),
                              ],
                            ),
                          ),
                        ),
                        // Title and subtitle
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'VISAYAS',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(1, 1),
                                      blurRadius: 4,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Explore the rich cultural tapestry of the central islands',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(1, 1),
                                      blurRadius: 3,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Timeline Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Timeline of History', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 10),
                  _buildTimeline(),
                  const SizedBox(height: 24),
                  // Historical Figures
                  _buildPersonalities(),
                  const SizedBox(height: 24),
                  // Cultural Highlights
                  _buildCulturalHighlights(context),
                  const SizedBox(height: 24),
                  // Fun Facts
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Did You Know?', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 10),
                  _buildFunFacts(),
                  const SizedBox(height: 24),
                  // Traditional Knowledge Quiz section removed - now in Quizzes tab
                  const SizedBox(height: 24),
                  // Historical Achievements
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Historical Achievements', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 10),
                  _buildHistoricalAchievements(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline() {
    final events = [
      {
        'era': 'Pre-Colonial Era',
        'period': 'Before 1521',
        'desc': 'Visayan societies flourished with advanced maritime trade, gold craftsmanship, and the Code of Kalantiaw in Panay.',
        'icon': Icons.emoji_nature,
        'color': Colors.green,
        'bgColor': Colors.green[50],
        'details': 'Before Spanish colonization, the Visayas were home to sophisticated societies with established social hierarchies. The region was known for its skilled seafarers, gold craftsmanship, and the legendary Code of Kalantiaw, a set of laws said to have been established in Panay Island. The Pintados, or "painted people," were famous for their intricate tattoos that signified social status and achievements.'
      },
      {
        'era': 'Spanish Arrival',
        'period': '1521',
        'desc': 'Ferdinand Magellan arrived in Cebu, establishing the first European contact and introducing Christianity to the Philippines.',
        'icon': Icons.sailing,
        'color': Colors.blue,
        'bgColor': Colors.blue[50],
        'details': 'On March 16, 1521, Ferdinand Magellan arrived in Homonhon Island, Eastern Samar, marking the first European contact with the Philippines. He later reached Cebu, where he formed an alliance with Rajah Humabon. The first Catholic mass in the Philippines was held in Limasawa, Southern Leyte. Magellan later died in the Battle of Mactan against Datu Lapu-Lapu, who is now celebrated as the first Filipino to resist foreign invasion.'
      },
      {
        'era': 'Spanish Colonial Period',
        'period': '1565–1898',
        'desc': 'Miguel López de Legazpi established the first Spanish settlement in Cebu, beginning 333 years of Spanish rule.',
        'icon': Icons.church,
        'color': Colors.brown,
        'bgColor': Colors.brown[50],
        'details': 'In 1565, Miguel López de Legazpi established the first permanent Spanish settlement in Cebu. The Visayas became central to Spanish colonization with the establishment of encomiendas and the spread of Catholicism. The region witnessed numerous revolts against Spanish rule, including the Dagohoy Rebellion in Bohol (1744-1829), the longest revolt in Philippine history, lasting 85 years.'
      },
      {
        'era': 'American Period',
        'period': '1898–1942',
        'desc': 'After the Spanish-American War, the Visayas saw economic development and educational reforms under American rule.',
        'icon': Icons.school,
        'color': Colors.red,
        'bgColor': Colors.red[50],
        'details': 'Following the Spanish-American War, the Philippines came under American control. The Visayas experienced significant changes with the introduction of the American educational system and English language. Economic development accelerated with improved infrastructure and public health systems. However, resistance movements like the Pulahan in Samar and Leyte continued to fight against foreign occupation.'
      },
      {
        'era': 'World War II',
        'period': '1942–1945',
        'desc': 'Japanese occupation and strong guerrilla resistance movements shaped the Visayan islands during WWII.',
        'icon': Icons.warning,
        'color': Colors.orange[800],
        'bgColor': Colors.orange[50],
        'details': 'During World War II, the Japanese occupied the Visayas, establishing military bases in strategic locations. The region became a stronghold for guerrilla resistance movements, particularly in Leyte, Samar, Cebu, and Negros. General Douglas MacArthur\'s famous return to the Philippines began with the Leyte Landing on October 20, 1944, fulfilling his "I shall return" promise and beginning the liberation of the Philippines.'
      },
      {
        'era': 'Modern Era',
        'period': '1946–Present',
        'desc': 'Post-independence development with economic growth in tourism, agriculture, and emerging technology sectors.',
        'icon': Icons.business,
        'color': Colors.purple,
        'bgColor': Colors.purple[50],
        'details': 'After Philippine independence in 1946, the Visayas region has developed into important centers of commerce, education, and culture. Cebu emerged as the "Queen City of the South" and the country\'s second major metropolitan center. The region has faced challenges from natural disasters, including the devastating Super Typhoon Yolanda (Haiyan) in 2013, but has shown remarkable resilience and recovery.'
      },
    ];

    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (context, index) {
          final event = events[index];
          return GestureDetector(
            onTap: () {
              // Show dialog with more details when tapped
              _showTimelineEventDetails(context, event);
            },
            child: Container(
              width: 180,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        event['bgColor'] as Color,
                        Colors.white,
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Era and Icon Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: event['color'] as Color,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                event['icon'] as IconData,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event['era'] as String,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    event['period'] as String,
                                    style: TextStyle(
                                      color: (event['color'] as Color).withOpacity(0.9),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Description
                        Expanded(
                          child: Text(
                            event['desc'] as String,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCulturalHighlights(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cultural Dances Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Cultural Dances of Visayas', 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 320,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: [
              // Sinulog Dance
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  width: 220,
                  child: FlipCard(
                    direction: FlipDirection.HORIZONTAL,
                    front: _buildCardFront(
                      imagePath: 'images/philpic.jpg',
                      title: 'Sinulog',
                    ),
                    back: _buildCardBack(
                      title: 'Sinulog',
                      description: "A ritual prayer-dance honoring Señor Santo Niño that commemorates the Filipino people's acceptance of Christianity.",
                      learnMoreUrl: 'https://www.sinulog.ph/about-sinulog/',
                    ),
                  ),
                ),
              ),
              // Kuratsa Dance
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  width: 220,
                  child: FlipCard(
                    direction: FlipDirection.HORIZONTAL,
                    front: _buildCardFront(
                      imagePath: 'images/philpic.jpg',
                      title: 'Kuratsa',
                    ),
                    back: _buildCardBack(
                      title: 'Kuratsa',
                      description: 'A courtship dance popular in Leyte and Samar that depicts a rooster (male) pursuing a hen (female).',
                      learnMoreUrl: 'https://ncca.gov.ph/about-culture-and-arts/culture-profile/phil-folk-dance/kuratsa/',
                    ),
                  ),
                ),
              ),
              // Ati-Atihan Dance
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  width: 220,
                  child: FlipCard(
                    direction: FlipDirection.HORIZONTAL,
                    front: _buildCardFront(
                      imagePath: 'images/philpic.jpg',
                      title: 'Ati-Atihan',
                    ),
                    back: _buildCardBack(
                      title: 'Ati-Atihan',
                      description: 'Known as the "Mother of All Philippine Festivals," this Aklan celebration honors the Santo Niño with street dancing and body painting.',
                      learnMoreUrl: 'https://ncca.gov.ph/about-culture-and-arts/culture-profile/philippine-festivals/ati-atihan-festival/',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Traditional Crafts Section
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Traditional Crafts', 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 320,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: [
              // Hablon Weaving
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  width: 220,
                  child: FlipCard(
                    direction: FlipDirection.HORIZONTAL,
                    front: _buildCardFront(
                      imagePath: 'images/philpic.jpg',
                      title: 'Hablon Weaving',
                    ),
                    back: _buildCardBack(
                      title: 'Hablon Weaving',
                      description: 'A traditional textile weaving practice from Iloilo, producing colorful fabrics with intricate designs used for clothing and home decor.',
                      learnMoreUrl: 'https://ncca.gov.ph/about-culture-and-arts/articles-on-culture-and-arts/the-hablon-weaving-industry-of-iloilo/',
                    ),
                  ),
                ),
              ),
              // Pottery from Bohol
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  width: 220,
                  child: FlipCard(
                    direction: FlipDirection.HORIZONTAL,
                    front: _buildCardFront(
                      imagePath: 'images/philpic.jpg',
                      title: 'Bohol Pottery',
                    ),
                    back: _buildCardBack(
                      title: 'Bohol Pottery',
                      description: "Clay pottery from Bohol showcases the island's rich cultural heritage with designs influenced by pre-colonial and Spanish colonial periods.",
                      learnMoreUrl: 'https://www.choosephilippines.com/specials/heritage/2217/bohol-pottery',
                    ),
                  ),
                ),
              ),
              // Pandan Weaving
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  width: 220,
                  child: FlipCard(
                    direction: FlipDirection.HORIZONTAL,
                    front: _buildCardFront(
                      imagePath: 'images/philpic.jpg',
                      title: 'Pandan Weaving',
                    ),
                    back: _buildCardBack(
                      title: 'Pandan Weaving',
                      description: 'A craft tradition in Bohol and other Visayan islands where pandan leaves are woven into mats, bags, hats, and other functional items.',
                      learnMoreUrl: 'https://www.bohol.ph/article275.html',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCardFront({required String imagePath, required String title}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Use a colored container with an icon as fallback
                  return Container(
                    color: Colors.green[100],
                    child: Center(
                      child: Icon(Icons.image, size: 60, color: Colors.green[800]),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Tap to learn more',
                  style: TextStyle(fontSize: 12, color: Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalities() {
    final personalities = [
      {
        'name': 'Lapu-Lapu',
        'role': 'Warrior Chieftain',
        'image': 'images/philpic.jpg',
        'desc': 'Chieftain of Mactan who led the victory against Ferdinand Magellan in 1521.'
      },
      {
        'name': 'Graciano López Jaena',
        'role': 'Journalist & Reformist',
        'image': 'images/philpic.jpg',
        'desc': 'Founder of La Solidaridad newspaper and prominent figure in the Propaganda Movement.'
      },
      {
        'name': 'Pantaleon Villegas',
        'role': 'Revolutionary Leader',
        'image': 'images/philpic.jpg',
        'desc': 'Known as "León Kilat", led the Cebuano revolution against Spanish rule.'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Historical Figures', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 16),
        Container(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: personalities.length,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemBuilder: (context, index) {
              final person = personalities[index];
              return Container(
                width: 160,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: FlipCard(
                  fill: Fill.fillBack,
                  direction: FlipDirection.HORIZONTAL,
                  front: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.asset(
                            person['image'] as String,
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 140,
                                color: Colors.green[100],
                                child: const Icon(Icons.person, size: 60, color: Colors.green),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                person['name'] as String,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                person['role'] as String,
                                style: TextStyle(color: Colors.green[700], fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  back: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            person['name'] as String,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            person['desc'] as String,
                            style: const TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () async {
                              final url = Uri.parse('https://en.wikipedia.org/wiki/${person['name']}');
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url, mode: LaunchMode.externalApplication);
                              }
                            },
                            child: const Text('Learn More'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCardBack({
    required String title,
    required String description,
    required String learnMoreUrl,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            TextButton.icon(
              icon: const Icon(Icons.language, size: 16),
              label: const Text('Learn More'),
              onPressed: () async {
                final url = Uri.parse(learnMoreUrl);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFunFacts() {
    final facts = [
      {
        'title': 'Chocolate Hills in Bohol are made of marine limestone',
        'context': 'The iconic Chocolate Hills of Bohol, consisting of over 1,200 perfectly cone-shaped hills, are actually made of marine limestone covered with grass. During the dry season, the grass turns brown, giving them a chocolate-like appearance.',
        'resource': 'https://www.bohol.ph/article4.html',
        'resourceLabel': 'Bohol Tourism',
        'type': 'landmark',
      },
      {
        'title': 'Cebu is home to the oldest street in the Philippines',
        'context': 'Colon Street in Cebu City is considered the oldest street in the Philippines, established in 1565 by Miguel López de Legazpi as part of the first Spanish settlement in the country.',
        'resource': 'https://www.cebucity.gov.ph/history',
        'resourceLabel': 'Cebu City Government',
        'type': 'history',
      },
      {
        'title': 'The Visayas has the highest concentration of marine biodiversity in the world',
        'context': 'The Verde Island Passage, located between Mindoro and Batangas, is considered the "center of the center" of marine biodiversity globally, housing thousands of species of fish, corals, and other marine life.',
        'resource': 'https://www.conservation.org/places/verde-island-passage',
        'resourceLabel': 'Conservation International',
        'type': 'nature',
      },
    ];

    return Column(
      children: facts.map((fact) {
        // Special case for landmark fact
        if (fact['type'] == 'landmark') {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            color: Colors.green[50],
            elevation: 2,
            child: ExpansionTile(
              leading: const Icon(Icons.landscape, color: Colors.green, size: 32),
              title: Text(fact['title'] as String, style: const TextStyle(fontSize: 15)),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Gallery for Chocolate Hills
                      SizedBox(
                        height: 200,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildVisayasImage('images/philpic.jpg'),
                            _buildVisayasImage('images/philpic.jpg'),
                            _buildVisayasImage('images/philpic.jpg'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Description
                      Text(fact['context'] as String, style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 16),
                      // Location Info
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Location Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 8),
                            // Location
                            GestureDetector(
                              onTap: () async {
                                final url = Uri.parse('https://www.google.com/maps/place/Chocolate+Hills');
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url, mode: LaunchMode.externalApplication);
                                }
                              },
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on, size: 18, color: Colors.red),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Location:', style: TextStyle(fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Carmen, Bohol, Philippines',
                                          style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue[800]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Coordinates
                            GestureDetector(
                              onTap: () async {
                                final url = Uri.parse('https://www.google.com/maps/place/9.8312,124.1387');
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url, mode: LaunchMode.externalApplication);
                                }
                              },
                              child: Row(
                                children: [
                                  const Icon(Icons.explore, size: 18, color: Colors.blue),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Coordinates:', style: TextStyle(fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 2),
                                        Text(
                                          '9.8312° N, 124.1387° E',
                                          style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue[800]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Learn More Button
                      TextButton.icon(
                        icon: const Icon(Icons.info_outline, size: 16, color: Colors.green),
                        label: Text('Learn more on ${fact['resourceLabel']}'),
                        onPressed: () async {
                          final url = Uri.parse(fact['resource'] as String);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url, mode: LaunchMode.externalApplication);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        
        // Default for other facts
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          color: fact['type'] == 'history' ? Colors.brown[50] : Colors.blue[50],
          elevation: 2,
          child: ExpansionTile(
            leading: Icon(
              fact['type'] == 'history' ? Icons.history : Icons.water,
              color: fact['type'] == 'history' ? Colors.brown : Colors.blue,
              size: 32
            ),
            title: Text(fact['title'] as String, style: const TextStyle(fontSize: 15)),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(fact['context'] as String, style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      icon: const Icon(Icons.link, size: 16),
                      label: Text('Read more on ${fact['resourceLabel']}'),
                      onPressed: () async {
                        final url = Uri.parse(fact['resource'] as String);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHistoricalAchievements() {
    final achievements = [
      {
        'title': 'Battle of Mactan',
        'year': '1521',
        'description': 'Lapu-Lapu and his warriors defeated Ferdinand Magellan and his Spanish forces at Mactan Island, marking the first successful resistance against European colonizers.',
        'icon': Icons.military_tech,
        'image': 'images/philpic.jpg',
      },
      {
        'title': 'Dagohoy Rebellion',
        'year': '1744-1829',
        'description': 'Led by Francisco Dagohoy in Bohol, this was the longest revolt against Spanish colonial rule, lasting for 85 years.',
        'icon': Icons.whatshot,
        'image': 'images/philpic.jpg',
      },
      {
        'title': 'Cebu as First Capital',
        'year': '1565',
        'description': 'Cebu became the first Spanish settlement and capital in the Philippines when Miguel López de Legazpi established a colony there.',
        'icon': Icons.location_city,
        'image': 'images/philpic.jpg',
      },
      {
        'title': 'Leyte Gulf Landing',
        'year': '1944',
        'description': 'General Douglas MacArthur fulfilled his promise to return to the Philippines by landing at Leyte Gulf, beginning the liberation of the Philippines from Japanese occupation.',
        'icon': Icons.sailing,
        'image': 'images/philpic.jpg',
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: achievements.map((achievement) {
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Achievement image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.asset(
                      achievement['image'] as String,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 150,
                          width: double.infinity,
                          color: Colors.green[100],
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(achievement['icon'] as IconData, size: 50, color: Colors.green[800]),
                                const SizedBox(height: 8),
                                const Text('Image not available', style: TextStyle(color: Colors.green)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Achievement content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and year
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                achievement['title'] as String,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green[100],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                achievement['year'] as String,
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[800]),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Description
                        Text(
                          achievement['description'] as String,
                          style: const TextStyle(fontSize: 14, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTraditionalQuiz() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Test your knowledge about Visayas traditions with these questions:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Quiz questions
              _buildQuizQuestion(
                question: 'Which famous festival in Cebu celebrates the Santo Niño and is known for its colorful street dancing?',
                options: ['Ati-Atihan', 'Sinulog', 'Dinagyang', 'Masskara'],
                correctAnswerIndex: 1,
                explanation: 'The Sinulog Festival is celebrated every third Sunday of January in Cebu City. It honors the Santo Niño (Child Jesus) and is known for its colorful street dancing and grand parade.',
                imageAsset: 'images/philpic.jpg',
              ),
              const SizedBox(height: 16),
              _buildQuizQuestion(
                question: 'What is the name of the traditional weaving technique from Iloilo that produces colorful textiles?',
                options: ['Hablon', 'T\'nalak', 'Inabel', 'Yakan'],
                correctAnswerIndex: 0,
                explanation: 'Hablon is a traditional textile weaving technique from Iloilo in the Western Visayas. It produces colorful fabrics with intricate designs used for clothing and home decor.',
                imageAsset: 'images/philpic.jpg',
              ),
              const SizedBox(height: 16),
              _buildQuizQuestion(
                question: 'Which natural formation in Bohol consists of over 1,200 cone-shaped hills?',
                options: ['Rice Terraces', 'Chocolate Hills', 'Hanging Gardens', 'Limestone Caves'],
                correctAnswerIndex: 1,
                explanation: 'The Chocolate Hills are a geological formation in Bohol consisting of at least 1,268 perfectly cone-shaped hills. During the dry season, the grass turns brown, giving them a chocolate-like appearance.',
                imageAsset: 'images/philpic.jpg',
              ),
              const SizedBox(height: 16),
              _buildQuizQuestion(
                question: 'What traditional Visayan fishing method uses bamboo traps to catch fish in shallow waters?',
                options: ['Pamunit', 'Bungsod', 'Pukot', 'Pana'],
                correctAnswerIndex: 1,
                explanation: 'Bungsod is a traditional fishing method in the Visayas that uses bamboo traps or corrals set in shallow waters to catch fish during high tide. As the tide recedes, the fish are trapped inside the bamboo enclosure.',
                imageAsset: 'images/philpic.jpg',
              ),
              const SizedBox(height: 16),
              _buildQuizQuestion(
                question: 'Which traditional Visayan healing practice involves the use of coconut oil, prayers, and massage to treat various ailments?',
                options: ['Hilot', 'Tawas', 'Kulam', 'Albularyo'],
                correctAnswerIndex: 0,
                explanation: 'Hilot is a traditional Filipino healing practice that combines massage techniques with the use of coconut oil and prayers. In the Visayas, hilot practitioners (manghihilot) are respected members of the community who treat various physical ailments.',
                imageAsset: 'images/philpic.jpg',
              ),
              const SizedBox(height: 16),
              _buildQuizQuestion(
                question: 'What traditional Cebuano dish consists of pork meat cooked until crispy and served with a vinegar dipping sauce?',
                options: ['Lechon', 'Kinilaw', 'Humba', 'Pochero'],
                correctAnswerIndex: 0,
                explanation: 'Lechon is a traditional Cebuano dish where a whole pig is roasted over charcoal until the skin becomes crispy. Cebu is famous for having the best lechon in the Philippines, often served with a vinegar dipping sauce called suka.',
                imageAsset: 'images/philpic.jpg',
              ),
              const SizedBox(height: 16),
              _buildQuizQuestion(
                question: 'What traditional Waray coming-of-age ceremony is celebrated when a girl turns 18?',
                options: ['Kasalan', 'Debut', 'Pamalaye', 'Pag-uli'],
                correctAnswerIndex: 1,
                explanation: 'The Debut is a traditional coming-of-age celebration in Waray culture when a girl turns 18. It includes ceremonies like the 18 roses (where 18 males dance with the debutante) and 18 candles (where 18 females give messages).',
                imageAsset: 'images/philpic.jpg',
              ),
              const SizedBox(height: 16),
              _buildQuizQuestion(
                question: 'What traditional architectural feature is common in old Visayan houses to provide ventilation?',
                options: ['Capiz shell windows', 'Bamboo floors', 'Stone foundations', 'Nipa roofs'],
                correctAnswerIndex: 0,
                explanation: 'Capiz shell windows are a distinctive architectural feature of traditional Visayan houses. These translucent windows made from capiz shells allow light to enter while keeping the interior cool, providing natural ventilation in the tropical climate.',
                imageAsset: 'images/philpic.jpg',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizQuestion({
    required String question,
    required List<String> options,
    required int correctAnswerIndex,
    required String explanation,
    required String imageAsset,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        // Local state for this quiz question
        int? selectedAnswerIndex;
        bool showExplanation = false;
        bool isAnimating = false;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question text
            Text(
              question,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            // Image related to the question
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imageAsset,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    width: double.infinity,
                    color: Colors.green[100],
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, size: 40, color: Colors.green[800]),
                          const SizedBox(height: 8),
                          const Text('Image not available', style: TextStyle(color: Colors.green)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            // Answer options
            ...List.generate(options.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: InkWell(
                  onTap: () {
                    if (isAnimating) return; // Prevent multiple taps during animation
                    setState(() {
                      isAnimating = true;
                      selectedAnswerIndex = index;
                    });
                    
                    // Add a slight delay before showing the explanation
                    Future.delayed(const Duration(milliseconds: 500), () {
                      setState(() {
                        showExplanation = true;
                        isAnimating = false;
                      });
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: selectedAnswerIndex == index
                          ? (index == correctAnswerIndex ? Colors.green[100] : Colors.red[100])
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        width: selectedAnswerIndex == index ? 2.0 : 1.0,
                        color: selectedAnswerIndex == index
                            ? (index == correctAnswerIndex ? Colors.green : Colors.red)
                            : Colors.grey[300]!,
                      ),
                      boxShadow: selectedAnswerIndex == index ? [
                        BoxShadow(
                          color: index == correctAnswerIndex 
                              ? Colors.green.withOpacity(0.3) 
                              : Colors.red.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ] : null,
                    ),
                    child: Row(
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${String.fromCharCode(65 + index)}. ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selectedAnswerIndex == index
                                  ? (index == correctAnswerIndex ? Colors.green[800] : Colors.red[800])
                                  : Colors.black87,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            options[index],
                            style: TextStyle(
                              fontSize: 14, // Smaller font size
                              color: selectedAnswerIndex == index
                                  ? (index == correctAnswerIndex ? Colors.green[800] : Colors.red[800])
                                  : Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                            maxLines: 2, // Allow up to 2 lines
                          ),
                        ),
                        if (selectedAnswerIndex == index)
                          Icon(
                            index == correctAnswerIndex ? Icons.check_circle : Icons.cancel,
                            color: index == correctAnswerIndex ? Colors.green : Colors.red,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            // Explanation (shown after answering)
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 500),
              firstChild: const SizedBox.shrink(),
              secondChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green[300]!),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Explanation:',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(explanation),
                  ],
                ),
              ),
                ],
              ),
              crossFadeState: showExplanation ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            ),
          ],
        );
      },
    );
  }

  Widget _buildVisayasImage(String imagePath) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: () {
          // Implement full-screen image view if needed
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            imagePath,
            width: 280,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 280,
                height: 200,
                color: Colors.green[100],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, size: 50, color: Colors.green[800]),
                      const SizedBox(height: 8),
                      const Text('Image not available', style: TextStyle(color: Colors.green)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showTimelineEventDetails(BuildContext context, Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: event['color'] as Color,
                shape: BoxShape.circle,
              ),
              child: Icon(
                event['icon'] as IconData,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event['era'] as String,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    event['period'] as String,
                    style: TextStyle(
                      fontSize: 16,
                      color: (event['color'] as Color).withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: Container(
          constraints: const BoxConstraints(maxHeight: 300),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  event['details'] as String,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                // Learn more button
                TextButton.icon(
                  icon: const Icon(Icons.language, size: 18),
                  label: const Text('Learn more online'),
                  onPressed: () async {
                    final url = Uri.parse('https://en.wikipedia.org/wiki/Visayas');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
