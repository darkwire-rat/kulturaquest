import 'package:flutter/material.dart';

class HeroDetailScreen extends StatelessWidget {
  final String name;
  final String imagePath;
  final String birth;
  final String death;
  final String causeOfDeath;

  const HeroDetailScreen({
    super.key,
    required this.name,
    required this.imagePath,
    required this.birth,
    required this.death,
    required this.causeOfDeath,
  });

  @override
  Widget build(BuildContext context) {
    // Hardcoded info based on hero name
    String biography = '';
    String birthDeathText = '$birth – $death';
    String achievements = '';
    
    // Assign biographies and achievements based on hero name
    if (name == "Jose Rizal") {
      biography = "José Protasio Rizal Mercado y Alonso Realonda was a Filipino nationalist, writer and polymath active at the end of the Spanish colonial period of the Philippines. He is considered the national hero of the Philippines. An ophthalmologist by profession, Rizal became a writer and a key member of the Filipino Propaganda Movement, which advocated political reforms for the colony under Spain.";
      achievements = "• Wrote 'Noli Me Tangere' and 'El Filibusterismo', novels that exposed Spanish abuses\n• Advocated for Philippine representation in the Spanish Cortes\n• Founded La Liga Filipina, a civic organization\n• Master of 22 languages\n• Poet, essayist, diarist, novelist and artist";
    } else if (name == "Andres Bonifacio") {
      biography = "Andrés Bonifacio y de Castro was a Filipino revolutionary leader and the president of the Tagalog Republic. He is often called 'The Father of the Philippine Revolution'. He was one of the founders and later the Supremo (Supreme Leader) of the Kataas-taasan, Kagalang-galangang Katipunan ng mga Anak ng Bayan, or more commonly known as the Katipunan, a movement which sought the independence of the Philippines from Spanish colonial rule.";
      achievements = "• Founded the Katipunan revolutionary society\n• Initiated the Philippine Revolution against Spain in 1896\n• Served as Supremo (Supreme Leader) of the Katipunan\n• Advocate for armed resistance against Spanish colonialism\n• United Filipinos under the common cause of independence";
    } else if (name == "Antonio Luna") {
      biography = "Antonio Luna y Novicio Ancheta was a Filipino general who fought in the Philippine–American War. Regarded as one of the fiercest generals of his time, he succeeded Artemio Ricarte as the Supreme Military Commander of the Philippine Republican Army. He was also a scientist, journalist, and pharmacist.";
      achievements = "• Director of War during the Philippine-American War\n• Organized the Luna Defense Line, a military defense strategy\n• Founded the Philippines' first military academy\n• Established the Philippines' first military newspaper, La Independencia\n• Earned a doctorate in Pharmacy from the University of Madrid";
    } else if (name == "Apolinario Mabini") {
      biography = "Apolinario Mabini y Maranan was a Filipino revolutionary leader, educator, lawyer, and statesman who served as the first Prime Minister of the Philippines, serving under President Emilio Aguinaldo. He is often referred to as the 'Sublime Paralytic' and the 'Brains of the Revolution'. He was an intellectual who authored the constitution for the First Philippine Republic and served as Aguinaldo's chief adviser during the war.";
      achievements = "• Authored 'The True Decalogue' and constitutional programs\n• Served as the Philippines' first Prime Minister\n• Chief adviser to President Emilio Aguinaldo\n• Created the first Philippine state constitution\n• Established the framework for a democratic Philippine government";
    } else if (name == "Emilio Jacinto") {
      biography = "Emilio Jacinto y Dizon was a Filipino revolutionary known as the 'Brains of the Katipunan'. He was one of the highest-ranking officers in the Philippine Revolution and the most trusted adviser of Andrés Bonifacio. He wrote the constitution of the Katipunan and authored the famous Kartilya ng Katipunan. Besides being a revolutionary, he was also a poet and a journalist.";
      achievements = "• Authored Kartilya ng Katipunan (Teachings of the Katipunan)\n• Served as the Secretary of State of the Katipunan\n• Editor of the Katipunan newspaper 'Kalayaan'\n• Military General during the Philippine Revolution\n• Known as the 'Brains of the Katipunan'";
    } else {
      biography = 'Biography about $name will be shown here.';
      achievements = 'Achievements will be listed here.';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with image and basic info
            Container(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Hero image with frame
                    Container(
                      height: 200,
                      width: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.person, size: 80, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Hero name
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    // Birth-Death years
                    const SizedBox(height: 8),
                    Text(
                      birthDeathText,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    // Cause of death
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Cause of Death: $causeOfDeath',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Biography section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Biography',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    biography,
                    style: const TextStyle(fontSize: 16, height: 1.6),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Achievements section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Notable Achievements',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    achievements,
                    style: const TextStyle(fontSize: 16, height: 1.6),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
