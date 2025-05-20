import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flip_card/flip_card.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter/services.dart';

class MindanaoScreen extends StatelessWidget {
  const MindanaoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mindanao: Land of Promise'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFD32F2F), Color(0xFFEF9A9A)],
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
                              color: Colors.red[200],
                              child: Center(
                                child: Icon(Icons.image_not_supported, size: 50, color: Colors.red[800]),
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
                                'MINDANAO',
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
                                'Discover the diverse cultures of the southern frontier',
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
        'desc': 'Sultanates and indigenous communities thrived with advanced trading networks and cultural traditions.',
        'icon': Icons.emoji_nature,
        'color': Colors.green,
        'bgColor': Colors.green[50],
        'details': 'Before Spanish colonization, Mindanao was home to established sultanates and indigenous communities. The Sultanate of Maguindanao and the Sultanate of Sulu were powerful Islamic states with extensive trading networks across Southeast Asia. Indigenous groups like the Lumad maintained their own cultural traditions and governance systems. The region was known for gold mining, weaving, and boat building.'
      },
      {
        'era': 'Spanish Period',
        'period': '1521–1898',
        'desc': 'Resistance against Spanish colonization; most of Mindanao remained independent from Spanish rule.',
        'icon': Icons.shield,
        'color': Colors.brown,
        'bgColor': Colors.brown[50],
        'details': 'Unlike Luzon and Visayas, most of Mindanao successfully resisted Spanish colonization. The Spanish established some settlements in northern Mindanao, but the Moro sultanates maintained their independence throughout most of the colonial period. This era was marked by the "Moro Wars" - a series of conflicts between Spanish forces and the Moro people that lasted for over 300 years.'
      },
      {
        'era': 'American Period',
        'period': '1898–1946',
        'desc': 'American colonial administration; Moro Province established; migration from Luzon and Visayas began.',
        'icon': Icons.school,
        'color': Colors.blue,
        'bgColor': Colors.blue[50],
        'details': 'The American colonial period saw more effective control over Mindanao. The Americans established the Moro Province (later renamed Mindanao and Sulu) as a separate administrative unit. This period saw the beginning of significant migration from Luzon and Visayas to Mindanao, encouraged by the American administration. The Bacon Bill of 1926 declared Mindanao open to settlement and agricultural development.'
      },
      {
        'era': 'Japanese Occupation',
        'period': '1942–1945',
        'desc': 'Japanese invasion; strong guerrilla resistance movements across the island.',
        'icon': Icons.warning,
        'color': Colors.orange[800],
        'bgColor': Colors.orange[50],
        'details': 'During World War II, Japanese forces occupied parts of Mindanao. However, strong guerrilla resistance movements operated throughout the island. The 10th Military District of the USAFFE was particularly active in Mindanao. The Battle of Mindanao in 1945 was one of the final major battles in the Philippines Campaign of World War II, leading to the liberation of the island.'
      },
      {
        'era': 'Post-Independence',
        'period': '1946–1970s',
        'desc': 'Continued migration; land disputes; beginning of Moro independence movements.',
        'icon': Icons.people,
        'color': Colors.purple,
        'bgColor': Colors.purple[50],
        'details': 'After Philippine independence, government-sponsored migration programs brought more settlers from Luzon and Visayas to Mindanao. This led to increasing tensions over land ownership and cultural differences. The 1968 Jabidah Massacre became a catalyst for the Moro independence movement, leading to the formation of the Moro National Liberation Front (MNLF) in 1972.'
      },
      {
        'era': 'Modern Era',
        'period': '1980s–Present',
        'desc': 'Peace processes; creation of ARMM and later BARMM; economic development amid ongoing challenges.',
        'icon': Icons.handshake,
        'color': Colors.teal,
        'bgColor': Colors.teal[50],
        'details': 'Recent decades have seen various peace processes between the Philippine government and Moro groups. The Autonomous Region in Muslim Mindanao (ARMM) was established in 1989, later replaced by the Bangsamoro Autonomous Region in Muslim Mindanao (BARMM) in 2019. Mindanao continues to develop economically, with growing urban centers like Davao City, while working to address historical challenges and promote inclusive development.'
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

  Widget _buildPersonalities() {
    final personalities = [
      {
        'name': 'Sultan Kudarat',
        'role': 'Maguindanao Sultan',
        'image': 'images/philpic.jpg',
        'desc': 'Powerful 17th century sultan who successfully resisted Spanish colonization of central Mindanao.'
      },
      {
        'name': 'Apolonio de la Cruz',
        'role': 'Revolutionary Leader',
        'image': 'images/philpic.jpg',
        'desc': 'Led the resistance against American colonization in Mindanao during the Philippine-American War.'
      },
      {
        'name': 'Salipada Pendatun',
        'role': 'Politician & War Hero',
        'image': 'images/philpic.jpg',
        'desc': 'WWII guerrilla leader who later became one of the first Muslim senators of the Philippines.'
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
                                color: Colors.red[100],
                                child: const Icon(Icons.person, size: 60, color: Colors.red),
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
                                style: TextStyle(color: Colors.red[700], fontSize: 12),
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

  Widget _buildCulturalHighlights(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cultural Dances Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Cultural Dances of Mindanao', 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 320,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: [
              // Singkil Dance
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  width: 220,
                  child: FlipCard(
                    direction: FlipDirection.HORIZONTAL,
                    front: _buildCardFront(
                      imagePath: 'images/philpic.jpg',
                      title: 'Singkil',
                    ),
                    back: _buildCardBack(
                      title: 'Singkil',
                      description: "A royal Maranao dance that depicts a Muslim princess escaping from falling bamboo poles, symbolizing her escape from an earthquake caused by forest spirits.",
                      learnMoreUrl: 'https://ncca.gov.ph/about-culture-and-arts/culture-profile/phil-folk-dance/singkil/',
                    ),
                  ),
                ),
              ),
              // Pangalay Dance
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  width: 220,
                  child: FlipCard(
                    direction: FlipDirection.HORIZONTAL,
                    front: _buildCardFront(
                      imagePath: 'images/philpic.jpg',
                      title: 'Pangalay',
                    ),
                    back: _buildCardBack(
                      title: 'Pangalay',
                      description: "A traditional fingernail dance of the Tausug people of Sulu, characterized by graceful hand movements mimicking ocean waves and sea birds.",
                      learnMoreUrl: 'https://ncca.gov.ph/about-culture-and-arts/culture-profile/phil-folk-dance/pangalay/',
                    ),
                  ),
                ),
              ),
              // Sagayan Dance
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  width: 220,
                  child: FlipCard(
                    direction: FlipDirection.HORIZONTAL,
                    front: _buildCardFront(
                      imagePath: 'images/philpic.jpg',
                      title: 'Sagayan',
                    ),
                    back: _buildCardBack(
                      title: 'Sagayan',
                      description: "A war dance performed by Maguindanao warriors before going to battle, showcasing their agility, strength, and combat skills.",
                      learnMoreUrl: 'https://ncca.gov.ph/about-culture-and-arts/culture-profile/phil-folk-dance/sagayan/',
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
              // T'nalak Weaving
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  width: 220,
                  child: FlipCard(
                    direction: FlipDirection.HORIZONTAL,
                    front: _buildCardFront(
                      imagePath: 'images/philpic.jpg',
                      title: 'T\'nalak Weaving',
                    ),
                    back: _buildCardBack(
                      title: 'T\'nalak Weaving',
                      description: "Sacred cloth woven by T'boli women from abaca fibers, featuring intricate patterns that come to them in dreams.",
                      learnMoreUrl: 'https://ncca.gov.ph/about-culture-and-arts/articles-on-culture-and-arts/the-tboli-and-the-tnalak/',
                    ),
                  ),
                ),
              ),
              // Brass Casting
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  width: 220,
                  child: FlipCard(
                    direction: FlipDirection.HORIZONTAL,
                    front: _buildCardFront(
                      imagePath: 'images/philpic.jpg',
                      title: 'Brass Casting',
                    ),
                    back: _buildCardBack(
                      title: 'Brass Casting',
                      description: "Traditional Maranao and Maguindanao metalwork creating ornate decorative items like the kulintang gongs, jars, and the iconic okir-designed gador.",
                      learnMoreUrl: 'https://ncca.gov.ph/about-culture-and-arts/articles-on-culture-and-arts/the-art-of-metal-casting/',
                    ),
                  ),
                ),
              ),
              // Yakan Weaving
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  width: 220,
                  child: FlipCard(
                    direction: FlipDirection.HORIZONTAL,
                    front: _buildCardFront(
                      imagePath: 'images/philpic.jpg',
                      title: 'Yakan Weaving',
                    ),
                    back: _buildCardBack(
                      title: 'Yakan Weaving',
                      description: "Distinctive geometric textile patterns created by the Yakan people of Basilan, known for their vibrant colors and intricate designs.",
                      learnMoreUrl: 'https://ncca.gov.ph/about-culture-and-arts/articles-on-culture-and-arts/the-yakan-weaving-tradition/',
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
                    color: Colors.red[100],
                    child: Center(
                      child: Icon(Icons.image, size: 60, color: Colors.red[800]),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red[50],
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
                  style: TextStyle(fontSize: 12, color: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
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
        'title': 'Mount Apo is the highest peak in the Philippines',
        'context': 'Standing at 2,954 meters (9,692 feet) above sea level, Mount Apo in Davao is the highest mountain in the Philippines. The name "Apo" means "grandfather" in local dialects, signifying its revered status among indigenous communities.',
        'resource': 'https://www.tourism.gov.ph/mount_apo.aspx',
        'resourceLabel': 'Department of Tourism',
        'type': 'landmark',
      },
      {
        'title': 'Mindanao is home to the Philippine Eagle, one of the largest eagles in the world',
        'context': 'The critically endangered Philippine Eagle (Pithecophaga jefferyi), also known as the Monkey-eating Eagle, is endemic to the Philippines with its remaining population primarily in Mindanao. With a wingspan of up to 7 feet, it is considered one of the largest and most powerful eagles in the world.',
        'resource': 'https://www.philippineeaglefoundation.org',
        'resourceLabel': 'Philippine Eagle Foundation',
        'type': 'wildlife',
      },
      {
        'title': 'Mindanao has over 30 different ethnolinguistic groups',
        'context': 'Mindanao is one of the most culturally diverse regions in the Philippines, with over 30 ethnolinguistic groups including the Manobo, T\'boli, Maranao, Tausug, Yakan, and Bagobo, each with their own distinct language, traditions, and cultural practices.',
        'resource': 'https://ncca.gov.ph/about-culture-and-arts/culture-profile/',
        'resourceLabel': 'National Commission for Culture and the Arts',
        'type': 'culture',
      },
    ];

    return Column(
      children: facts.map((fact) {
        // Special case for landmark fact
        if (fact['type'] == 'landmark') {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            color: Colors.red[50],
            elevation: 2,
            child: ExpansionTile(
              leading: const Icon(Icons.landscape, color: Colors.red, size: 32),
              title: Text(fact['title'] as String, style: const TextStyle(fontSize: 15)),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Gallery for Mount Apo
                      SizedBox(
                        height: 200,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildMindanaoImage('images/philpic.jpg'),
                            _buildMindanaoImage('images/philpic.jpg'),
                            _buildMindanaoImage('images/philpic.jpg'),
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
                          color: Colors.red[100],
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
                                final url = Uri.parse('https://www.google.com/maps/place/Mount+Apo');
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
                                          'Davao del Sur, Philippines',
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
                                final url = Uri.parse('https://www.google.com/maps/place/6.9886,125.2716');
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
                                          '6.9886° N, 125.2716° E',
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
                        icon: const Icon(Icons.info_outline, size: 16, color: Colors.red),
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
        
        // Wildlife fact
        if (fact['type'] == 'wildlife') {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            color: Colors.green[50],
            elevation: 2,
            child: ExpansionTile(
              leading: Icon(Icons.pets, color: Colors.green[700], size: 32),
              title: Text(fact['title'] as String, style: const TextStyle(fontSize: 15)),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image of Philippine Eagle
                      Container(
                        height: 200,
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'images/philpic.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
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
        }
        
        // Default for other facts
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          color: Colors.orange[50],
          elevation: 2,
          child: ExpansionTile(
            leading: const Icon(Icons.people, color: Colors.orange, size: 32),
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
        'title': 'Sultanate of Sulu',
        'year': '1405',
        'description': 'The establishment of the Sultanate of Sulu by Arab missionary Sharif ul-Hashim, which became a powerful Islamic state and trading power in Southeast Asia.',
        'icon': Icons.account_balance,
        'image': 'images/philpic.jpg',
      },
      {
        'title': 'Maguindanao Sultanate',
        'year': '1515',
        'description': 'The founding of the Maguindanao Sultanate by Sharif Muhammad Kabungsuwan, which became a major political and cultural center in Mindanao.',
        'icon': Icons.mosque,
        'image': 'images/philpic.jpg',
      },
      {
        'title': 'Zamboanga Siege',
        'year': '1635',
        'description': 'Sultan Kudarat successfully led resistance against Spanish colonization attempts in Mindanao, preserving the independence of Muslim territories.',
        'icon': Icons.security,
        'image': 'images/philpic.jpg',
      },
      {
        'title': 'Jabidah Massacre',
        'year': '1968',
        'description': 'A pivotal event where Filipino Muslim trainees were killed in Corregidor, leading to increased Muslim separatism and the formation of the Moro National Liberation Front.',
        'icon': Icons.history_edu,
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
                          color: Colors.red[100],
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(achievement['icon'] as IconData, size: 50, color: Colors.red[800]),
                                const SizedBox(height: 8),
                                const Text('Image not available', style: TextStyle(color: Colors.red)),
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
                                color: Colors.red[100],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                achievement['year'] as String,
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red[800]),
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
                "Test your knowledge about Mindanao's traditions with these questions:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Quiz questions
              _buildQuizQuestion(
                question: 'What is the name of the traditional dance performed by Maranao women during special occasions?',
                options: ['Singkil', 'Pangalay', 'Kapa Malong-Malong', 'Sagayan'],
                correctAnswerIndex: 0,
                explanation: 'Singkil is a traditional royal Maranao dance that depicts a Muslim princess escaping from falling bamboo poles, symbolizing her escape from an earthquake caused by forest spirits.',
                imageAsset: 'images/philpic.jpg',
              ),
              const SizedBox(height: 16),
              _buildQuizQuestion(
                question: "Which indigenous group from Mindanao is known for their T'nalak weaving?",
                options: ['Bagobo', "T'boli", 'Manobo', 'Tausug'],
                correctAnswerIndex: 1,
                explanation: "The T'boli people are known for their intricate T'nalak weaving, a sacred cloth made from abaca fibers with patterns that come to the weavers in dreams.",
                imageAsset: 'images/philpic.jpg',
              ),
              const SizedBox(height: 16),
              _buildQuizQuestion(
                question: 'What is the highest mountain in the Philippines, located in Mindanao?',
                options: ['Mount Pulag', 'Mount Apo', 'Mount Kitanglad', 'Mount Dulang-dulang'],
                correctAnswerIndex: 1,
                explanation: 'Mount Apo, standing at 2,954 meters (9,692 feet) above sea level in Davao, is the highest mountain in the Philippines.',
                imageAsset: 'images/philpic.jpg',
              ),
              const SizedBox(height: 16),
              _buildQuizQuestion(
                question: 'What traditional Mindanao instrument consists of a row of small bronze or brass gongs arranged horizontally on a wooden frame?',
                options: ['Agung', 'Kulintang', 'Dabakan', 'Gandingan'],
                correctAnswerIndex: 1,
                explanation: 'The Kulintang is a traditional percussion instrument from Mindanao consisting of a row of small bronze or brass gongs arranged horizontally on a wooden frame. It is central to the musical traditions of the Maguindanao, Maranao, and Tausug peoples.',
                imageAsset: 'images/philpic.jpg',
              ),
              const SizedBox(height: 16),
              _buildQuizQuestion(
                question: 'Which traditional boat is used by the Sama-Bajau people of the Sulu Archipelago?',
                options: ['Vinta', 'Balangay', 'Lepa', 'Bangka'],
                correctAnswerIndex: 2,
                explanation: 'The Lepa is a traditional houseboatused by the Sama-Bajau people (sea gypsies) of the Sulu Archipelago. These colorful boats serve as both transportation and homes, reflecting the seafaring culture of these indigenous people.',
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
                    color: Colors.red[100],
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, size: 40, color: Colors.red[800]),
                          const SizedBox(height: 8),
                          const Text('Image not available', style: TextStyle(color: Colors.red)),
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
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[300]!),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.2),
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

  Widget _buildMindanaoImage(String imagePath) {
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
                color: Colors.red[100],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, size: 50, color: Colors.red[800]),
                      const SizedBox(height: 8),
                      const Text('Image not available', style: TextStyle(color: Colors.red)),
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
                    final url = Uri.parse('https://en.wikipedia.org/wiki/Mindanao');
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
