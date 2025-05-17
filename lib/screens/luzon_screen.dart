import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flip_card/flip_card.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'cultural_highlight_content.dart';
import 'taal_gallery_viewer.dart';

class LuzonScreen extends StatelessWidget {
  const LuzonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Luzon: History & Heritage'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1976D2), Color(0xFF64B5F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50], // Light gray background instead of missing texture
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
                        // Background image
                        Image.asset(
                          'assets/images/heroes.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback to another local image if the first one fails
                            return Image.asset(
                              'assets/images/taal_volcano.jpg',
                              fit: BoxFit.cover,
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
                                'LUZON',
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
                                'Discover the rich history of the largest island in the Philippines',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
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
                  // Featured Personalities
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
                  const SizedBox(height: 16),
                  // Video Resource Button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final url = Uri.parse('https://www.youtube.com/watch?v=P-I4Bay5SXo'); // Replace with your video
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        }
                      },
                      icon: const Icon(Icons.play_circle_fill),
                      label: const Text('Watch: Luzon History Video'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        textStyle: const TextStyle(fontSize: 16),
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
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
        'desc': 'Indigenous cultures thrive; barangays led by datus; trade with China, India, and neighboring islands.',
        'icon': Icons.emoji_nature,
        'color': Colors.greenAccent
      },
      {
        'era': 'Spanish Colonization',
        'period': '1521–1898',
        'desc': 'Arrival of Magellan; 333 years of Spanish rule; Christianity spreads; revolts and reforms.',
        'icon': Icons.menu_book,
        'color': Colors.orangeAccent
      },
      {
        'era': 'American Period',
        'period': '1898–1946',
        'desc': 'US takes control after Spanish-American War; education reforms; infrastructure development.',
        'icon': Icons.school,
        'color': Colors.blueAccent
      },
      {
        'era': 'Japanese Occupation',
        'period': '1942–1945',
        'desc': 'World War II; resistance movements; liberation in 1945.',
        'icon': Icons.local_fire_department,
        'color': Colors.redAccent
      },
      {
        'era': 'Independence',
        'period': '1946–Present',
        'desc': 'Republic established; economic development; cultural renaissance; modern challenges.',
        'icon': Icons.flag,
        'color': Colors.purpleAccent
      },
    ];

    return Container(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Container(
            width: 200,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Card(
              elevation: 3,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(event['icon'] as IconData, color: event['color'] as Color, size: 24),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            event['era'] as String,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event['period'] as String,
                      style: TextStyle(color: Colors.grey[700], fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        event['desc'] as String,
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                  ],
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
        'name': 'Jose Rizal',
        'role': 'National Hero',
        'image': 'assets/rizal.jpg',
        'desc': 'Writer, physician, and nationalist whose works sparked revolution.'
      },
      {
        'name': 'Andres Bonifacio',
        'role': 'Revolutionary Leader',
        'image': 'assets/bonifacio.jpg',
        'desc': 'Founder of the Katipunan, led armed resistance against Spanish rule.'
      },
      {
        'name': 'Emilio Aguinaldo',
        'role': 'First President',
        'image': 'assets/aguinaldo.jpg',
        'desc': 'Led Philippine forces during the Spanish and American wars.'
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
                          child: Image.network(
                            'https://i.imgur.com/4OlVYlA.jpg', // Placeholder image
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 140,
                                color: Colors.grey[300],
                                child: const Icon(Icons.person, size: 60, color: Colors.grey),
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
                                style: TextStyle(color: Colors.blue[700], fontSize: 12),
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
          child: Text('Cultural Dances of Luzon', 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 320,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: [
              // Binasuan Dance
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  width: 220,
                  child: FlipCard(
                    direction: FlipDirection.HORIZONTAL,
                    front: _buildCardFront(
                      imagePath: 'assets/culture/binasuan.jpg',
                      title: 'Binasuan',
                    ),
                    back: _buildCardBack(
                      title: 'Binasuan',
                      description: 'A lively dance from Pangasinan performed with drinking glasses filled with rice wine balanced on the head and hands.',
                      learnMoreUrl: 'https://ncca.gov.ph/about-culture-and-arts/culture-profile/phil-folk-dance/binansuan/',
                    ),
                  ),
                ),
              ),
              // Pandanggo sa Ilaw Dance
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  width: 220,
                  child: FlipCard(
                    direction: FlipDirection.HORIZONTAL,
                    front: _buildCardFront(
                      imagePath: 'assets/culture/pandanggo.jpg',
                      title: 'Pandanggo sa Ilaw',
                    ),
                    back: _buildCardBack(
                      title: 'Pandanggo sa Ilaw',
                      description: 'A graceful dance from Mindoro that involves balancing oil lamps on the head and hands while dancing to waltz music.',
                      learnMoreUrl: 'https://ncca.gov.ph/about-culture-and-arts/culture-profile/phil-folk-dance/pandanggo-sa-ilaw/',
                    ),
                  ),
                ),
              ),
              // Tayaw Dance
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  width: 220,
                  child: FlipCard(
                    direction: FlipDirection.HORIZONTAL,
                    front: _buildCardFront(
                      imagePath: 'assets/culture/tayaw.jpg',
                      title: 'Tayaw',
                    ),
                    back: _buildCardBack(
                      title: 'Tayaw',
                      description: 'A traditional dance from the Cordillera region, often performed during celebrations and rituals.',
                      learnMoreUrl: 'https://ncca.gov.ph/about-culture-and-arts/culture-profile/phil-folk-dance/cordillera-dances/',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Taal Volcano Section
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Taal Volcano: Natural Wonder of Luzon', 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 16),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Taal Volcano Image
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (buildContext) => TaalGalleryViewer(initialIndex: 0),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    // Image
                    Image.asset(
                      'assets/images/taal_volcano.jpg',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    // Gallery indicator overlay
                    Positioned(
                      right: 16,
                      bottom: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.photo_library, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text('Gallery (7)', style: TextStyle(color: Colors.white, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Volcano info with longitude & latitude
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Taal Volcano',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'One of the most active volcanoes in the Philippines, located in Batangas province on Luzon island.',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    // Location info with coordinates
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.location_on, size: 18, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Location:', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Padding(
                            padding: EdgeInsets.only(left: 26),
                            child: Text('Talisay, Batangas, Philippines'),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: const [
                              Icon(Icons.explore, size: 18, color: Colors.blue),
                              SizedBox(width: 8),
                              Text('Coordinates:', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Padding(
                            padding: EdgeInsets.only(left: 26),
                            child: Text('14.0111° N, 120.9977° E'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // View Gallery Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.photo_library),
                        label: const Text('View Full Gallery'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (buildContext) => TaalGalleryViewer(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper method to build the front of flip cards
  Widget _buildCardFront({required String imagePath, required String title}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build the back of flip cards
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                description,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            TextButton.icon(
              icon: const Icon(Icons.info_outline, size: 16, color: Colors.blue),
              label: const Text('Learn More', style: TextStyle(color: Colors.blue)),
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
        'title': 'Luzon is home to the smallest active volcano in the world',
        'context': 'The Taal Volcano, located in Batangas, is considered the smallest active volcano in the world. It sits on an island within a lake, which is on an island within a lake, which is on an island!',
        'resource': 'https://www.nationalgeographic.com/travel/article/taal-volcano-philippines-eruption',
        'resourceLabel': 'National Geographic',
        'type': 'volcano',
      },
      {
        'title': 'Manila was once the most devastated city in WWII after Warsaw',
        'context': 'During World War II, Manila was the second most devastated city after Warsaw. The Battle of Manila in 1945 resulted in the deaths of over 100,000 civilians and the destruction of architectural and cultural heritage.',
        'resource': 'https://www.nationalww2museum.org/war/articles/battle-manila-1945',
        'resourceLabel': 'National WWII Museum',
        'type': 'history',
      },
      {
        'title': 'Luzon has over 30 different ethnolinguistic groups',
        'context': 'The island is home to more than 30 ethnolinguistic groups, each with their own distinct language, culture, and traditions. Some of the major groups include the Ilocano, Pangasinan, Kapampangan, Tagalog, and Bicolano.',
        'resource': 'https://ncca.gov.ph/about-culture-and-arts/culture-profile/',
        'resourceLabel': 'National Commission for Culture and the Arts',
        'type': 'culture',
      },
    ];

    return Column(
      children: facts.map((fact) {
        // Special case for volcano fact
        if (fact['type'] == 'volcano') {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            color: Colors.orange[50],
            elevation: 2,
            child: ExpansionTile(
              leading: const Icon(Icons.whatshot, color: Colors.deepOrange, size: 32),
              title: Text(fact['title'] as String, style: const TextStyle(fontSize: 15)),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(fact['context'] as String),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        icon: const Icon(Icons.link),
                        label: Text(fact['resourceLabel'] as String),
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
          color: Colors.yellow[50],
          elevation: 2,
          child: ExpansionTile(
            leading: const Icon(Icons.lightbulb, color: Colors.amber, size: 32),
            title: Text(fact['title'] as String, style: const TextStyle(fontSize: 15)),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(fact['context'] as String),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      icon: const Icon(Icons.link),
                      label: Text(fact['resourceLabel'] as String),
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
}
