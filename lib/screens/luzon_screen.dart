import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flip_card/flip_card.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter/services.dart';
import 'cultural_highlight_content.dart';
import 'taal_gallery_viewer.dart';

class LuzonScreen extends StatelessWidget {
  const LuzonScreen({super.key});

  // IMAGE PATH REFERENCES (for developer reference):
  // - Andres Bonifacio: 'images/luzon/andres_boni.jpeg'
  // - First Republic: 'images/luzon/first_republic.jpg' 
  // - Battle of Tirad Pass: 'images/luzon/tirad_pass.jpg'
  // - Philippine Independence: 'images/luzon/philippine_independence.jpg'
  // - EDSA People Power: 'images/luzon/edsa_peoplepower.jpeg'

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
                          'assets/images/luzon/Luzon_cover.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback to another local image if the first one fails
                            return Image.asset(
                              'images/philpic.jpg',
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
                  const SizedBox(height: 16),
                  // Watch Video Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        // YouTube link for Luzon history
                        final Uri youtubeUrl = Uri.parse('https://www.youtube.com/watch?v=P-I4Bay5SXo');
                        try {
                          await launchUrl(
                            youtubeUrl,
                            mode: LaunchMode.platformDefault // Use platform default browser
                          );
                        } catch (e) {
                          print('Error launching YouTube: $e');
                        }
                      },
                      icon: const Icon(Icons.play_circle_filled),
                      label: const Text('WATCH LUZON HISTORY VIDEO'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
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
                  const SizedBox(height: 24),
                  const SizedBox(height: 24),
                  // Historical Achievements
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Historical Achievements', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 10),
                  _buildHistoricalAchievements(),
                  const SizedBox(height: 24),
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
                  const SizedBox(height: 16),
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
        'color': Colors.green,
        'bgColor': Colors.green[50],
      },
      {
        'era': 'Spanish Era',
        'period': '1521–1898',
        'desc': 'Arrival of Magellan; 333 years of Spanish rule; Christianity spreads; revolts and reforms.',
        'icon': Icons.landscape,
        'color': Colors.blue,
        'bgColor': Colors.blue[50],
      },
      {
        'era': 'American Period',
        'period': '1898–1946',
        'desc': 'US takes control after Spanish-American War; education reforms; infrastructure development.',
        'icon': Icons.school,
        'color': Colors.red,
        'bgColor': Colors.red[50],
      },
      {
        'era': 'Japanese Occupation',
        'period': '1942–1945',
        'desc': 'World War II; resistance movements; liberation in 1945.',
        'icon': Icons.warning,
        'color': Colors.orange[800],
        'bgColor': Colors.orange[50],
      },
      {
        'era': 'Independence',
        'period': '1946–Present',
        'desc': 'Republic established; economic development; cultural renaissance; modern challenges.',
        'icon': Icons.flag,
        'color': Colors.purple,
        'bgColor': Colors.purple[50],
      },
    ];

    return Container(
      height: 200, // Increased height for better visibility
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
              width: 180, // Slightly wider for better text display
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
                              height: 1.3,
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Read more indicator
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: (event['color'] as Color).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Tap for more',
                              style: TextStyle(
                                color: event['color'] as Color,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
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

  void _showTimelineEventDetails(BuildContext context, Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
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
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    event['period'] as String,
                    style: TextStyle(
                      color: (event['color'] as Color).withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: Text(
          event['desc'] as String,
          style: const TextStyle(fontSize: 15, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalities() {
    final personalities = [
      {
        'name': 'Jose Rizal',
        'role': 'National Hero',
        'image': 'assets/images/luzon/jse_rizal.jpg',
        'desc': 'Writer, physician, and nationalist whose works sparked revolution.'
      },
      {
        'name': 'Andres Bonifacio',
        'role': 'Revolutionary Leader',
        'image': 'assets/images/luzon/andres_boni.jpeg',
        'desc': 'Founder of the Katipunan, led armed resistance against Spanish rule.'
      },
      {
        'name': 'Emilio Aguinaldo',
        'role': 'First President',
        'image': 'assets/images/luzon/emilio_aguinaldo.jpg',
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
                          child: Image.asset(
                            person['image'] as String,
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
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
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

        // Taal Volcano Section has been moved to the 'Did You Know' section
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

  // Helper method to build Taal Volcano image items
  Widget _buildTaalImage(String imagePath) {
    final List<String> taalImages = [
      'images/taal_volcano.jpg',
      'images/taal_volcano2.jpg',
      'images/taal_volcano3.jpg',
      'images/taal_volcano4.jpg',
      'images/taal_volcano5.jpg',
      'images/taal_volcano6.jpg',
      'images/taal_volcano7.jpg',
    ];
    
    final initialIndex = taalImages.indexOf(imagePath);
    
    return Builder(
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            // Show full screen image viewer when tapped with all images
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaalGalleryViewer(
                  images: taalImages,
                  initialIndex: initialIndex >= 0 ? initialIndex : 0,
                ),
              ),
            );
          },
          child: Container(
            width: 300,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                width: 300,
                height: 200,
                fit: BoxFit.cover,
                // Pre-cache images to ensure they load immediately when dropdown is opened
                cacheWidth: 600, // 2x display width for higher quality
                cacheHeight: 400, // 2x display height for higher quality
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading image: $imagePath - $error');
                  // Use philpic.jpg as fallback as per user preference
                  return Image.asset(
                    'assets/images/pottery.jpg',
                    width: 300,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // If even the fallback fails, show a colored container
                      return Container(
                        width: 300,
                        height: 200,
                        color: Colors.orange[100],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.volcano, size: 40, color: Colors.deepOrange),
                            const SizedBox(height: 8),
                            const Text('Taal Volcano', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHistoricalAchievements() {
    final achievements = [
      {
        'title': 'First Philippine Republic',
        'year': '1899',
        'description': 'The First Philippine Republic was established in Malolos, Bulacan, making the Philippines the first constitutional republic in Asia.',
        'icon': Icons.account_balance,
        'image': 'assets/images/luzon/first_republic.jpg',
      },
      {
        'title': 'Battle of Tirad Pass',
        'year': '1899',
        'description': 'General Gregorio del Pilar and 60 Filipino soldiers held off 500 American soldiers at Tirad Pass in Ilocos Sur, allowing President Aguinaldo to escape.',
        'icon': Icons.military_tech,
        'image': 'assets/images/luzon/tirad_pass.jpg',
      },
      {
        'title': 'Philippine Independence',
        'year': '1946',
        'description': 'The Philippines gained full independence from the United States on July 4, 1946, with the inauguration of the Third Republic in Manila.',
        'icon': Icons.flag,
        'image': 'assets/images/luzon/philippine_independence.jpeg',
      },
      {
        'title': 'EDSA People Power Revolution',
        'year': '1986',
        'description': 'A nonviolent revolution in Metro Manila that ousted President Ferdinand Marcos and restored democracy to the Philippines.',
        'icon': Icons.people,
        'image': 'assets/images/luzon/eda_peoplepower.jpeg',
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
                          color: Colors.blue[100],
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(achievement['icon'] as IconData, size: 50, color: Colors.blue[800]),
                                const SizedBox(height: 8),
                                const Text('Image not available', style: TextStyle(color: Colors.blue)),
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
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                achievement['year'] as String,
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800]),
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
                "Test your knowledge about Luzon traditions with these questions:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Quiz questions
              _buildQuizQuestion(
                question: 'Which traditional rice terraces in Luzon are known as the \'Eighth Wonder of the World\'?',
                options: ['Chocolate Hills', 'Banaue Rice Terraces', 'Mayon Volcano', 'Hundred Islands'],
                correctAnswerIndex: 1,
                explanation: 'The Banaue Rice Terraces in Ifugao province are often called the \'Eighth Wonder of the World\'. They were carved into the mountains by ancestors of the indigenous people over 2,000 years ago.',
                imageAsset: 'images/philpic.jpg',
              ),
              const SizedBox(height: 16),
              _buildQuizQuestion(
                question: 'What traditional Filipino martial art originated in Luzon?',
                options: ['Arnis', 'Muay Thai', 'Silat', 'Karate'],
                correctAnswerIndex: 0,
                explanation: 'Arnis (also known as Kali or Eskrima) is a traditional Filipino martial art that uses sticks, bladed weapons, and empty hands. It originated in the northern Philippines and became the national martial art.',
                imageAsset: 'images/philpic.jpg',
              ),
              const SizedBox(height: 16),
              _buildQuizQuestion(
                question: 'Which traditional festival in Luzon features participants covered in mud and wearing costumes made of dried banana leaves?',
                options: ['Pahiyas Festival', 'Moriones Festival', 'Panagbenga Festival', 'Mudpack Festival'],
                correctAnswerIndex: 3,
                explanation: 'The Mudpack Festival (or Taong Putik Festival) is celebrated in Nueva Ecija where devotees cover themselves in mud and wear costumes made of dried banana leaves to honor Saint John the Baptist.',
                imageAsset: 'images/philpic.jpg',
              ),
              const SizedBox(height: 16),
              _buildQuizQuestion(
                question: 'What traditional Igorot garment is made of hand-woven cloth and worn as a skirt or dress in the Cordillera region?',
                options: ['Tapis', 'Malong', 'Bahag', 'Kimona'],
                correctAnswerIndex: 0,
                explanation: 'The Tapis is a traditional hand-woven skirt or tube dress worn by Igorot women in the Cordillera region. It is often decorated with intricate patterns that represent tribal identity and status.',
                imageAsset: 'images/philpic.jpg',
              ),
              const SizedBox(height: 16),
              _buildQuizQuestion(
                question: 'Which traditional Luzon musical instrument is made from bamboo tubes of varying lengths to produce different pitches?',
                options: ['Kulintang', 'Kudyapi', 'Bungkaka', 'Tongali'],
                correctAnswerIndex: 3,
                explanation: 'The Tongali (or nose flute) is a traditional bamboo musical instrument played by blowing through the nose. It is commonly used by indigenous groups in Northern Luzon, particularly the Kalinga and Ifugao.',
                imageAsset: 'images/philpic.jpg',
              ),
              const SizedBox(height: 16),
              _buildQuizQuestion(
                question: 'What traditional Ilocano dish is made from fermented fish or shrimp with rice and salt?',
                options: ['Dinuguan', 'Pinakbet', 'Bagnet', 'Bagoong'],
                correctAnswerIndex: 3,
                explanation: 'Bagoong is a traditional fermented fish or shrimp paste that originated in Ilocos. It\'s a staple condiment in Ilocano cuisine and is used as a flavoring for many dishes like pinakbet.',
                imageAsset: 'images/philpic.jpg',
              ),
              const SizedBox(height: 16),
              _buildQuizQuestion(
                question: 'What traditional Ifugao ceremony is performed to bless the rice terraces before planting?',
                options: ['Begnas', 'Punnuk', 'Hagabi', 'Bakle'],
                correctAnswerIndex: 0,
                explanation: 'Begnas is a traditional agricultural ritual performed by the Ifugao people to bless the rice terraces before planting season. It involves prayers, offerings, and community celebrations to ensure a bountiful harvest.',
                imageAsset: 'images/philpic.jpg',
              ),
              const SizedBox(height: 16),
              _buildQuizQuestion(
                question: 'Which architectural feature is unique to traditional Ivatan houses in Batanes?',
                options: ['Sliding bamboo windows', 'Thick cogon grass roofs', 'Limestone walls', 'Stone roofs'],
                correctAnswerIndex: 3,
                explanation: 'Traditional Ivatan houses in Batanes feature stone roofs (called "vakul") made from limestone and thatch, designed to withstand the strong typhoons that frequently hit the northernmost province of Luzon.',
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
                    color: Colors.blue[100],
                    child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image, size: 40, color: Colors.blue[800]),
                            const SizedBox(height: 8),
                            const Text('Image not available', style: TextStyle(color: Colors.blue)),
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
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue[300]!),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.2),
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
              initiallyExpanded: false,
              maintainState: true, // Keep the state when collapsed to avoid reloading images
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Taal Volcano Images Gallery
                      SizedBox(
                        height: 200,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildTaalImage('assets/images/taal_volcano.jpg'),
                            _buildTaalImage('assets/images/taal_volcano2.jpg'),
                            _buildTaalImage('assets/images/taal_volcano3.jpg'),
                            _buildTaalImage('assets/images/taal_volcano4.jpg'),
                            _buildTaalImage('assets/images/taal_volcano5.jpg'),
                            _buildTaalImage('assets/images/taal_volcano6.jpg'),
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
                          color: Colors.orange[100],
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
                                // Directly open in browser for maximum compatibility
                                try {
                                  await launchUrl(
                                    Uri.parse('https://www.google.com/maps/search/?api=1&query=Taal+Volcano'),
                                    mode: LaunchMode.platformDefault // Use platform default browser
                                  );
                                } catch (e) {
                                  print('Error launching map in browser: $e');
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
                                          'Talisay, Batangas, Philippines',
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
                                // Directly open in browser for maximum compatibility
                                try {
                                  await launchUrl(
                                    Uri.parse('https://www.google.com/maps/search/?api=1&query=14.0111,120.9977'),
                                    mode: LaunchMode.platformDefault // Use platform default browser
                                  );
                                } catch (e) {
                                  print('Error launching map in browser: $e');
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
                                          '14.0111° N, 120.9977° E',
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
                        icon: const Icon(Icons.info_outline, size: 16, color: Colors.blue),
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
}
