import 'package:flutter/material.dart';
import 'president_quiz_screen.dart';
import '../services/achievements_service.dart';

class PresidentDetailScreen extends StatefulWidget {
  final String name;
  final String imagePath;
  final String? term;
  final bool showQuiz;

  const PresidentDetailScreen({
    super.key,
    required this.name,
    required this.imagePath,
    this.term,
    this.showQuiz = true,
  });
  
  @override
  State<PresidentDetailScreen> createState() => _PresidentDetailScreenState();
}

class _PresidentDetailScreenState extends State<PresidentDetailScreen> {
  final AchievementsService _achievementsService = AchievementsService();
  String _achievementClusterId = 'presidents';
  String _achievementSubcategoryId = '';
  String _achievementId = '';
  int _quizScore = 0;
  bool _quizCompleted = false;

  @override
  void initState() {
    super.initState();
    _setupAchievementIds();
    _loadAchievementProgress();
  }
  
  void _setupAchievementIds() {
    // Set appropriate achievement IDs based on president name
    if (widget.name == 'Emilio Aguinaldo') {
      _achievementSubcategoryId = 'early_republic';
      _achievementId = 'aguinaldo_quiz';
    } else if (widget.name == 'Manuel L. Quezon') {
      _achievementSubcategoryId = 'early_republic';
      _achievementId = 'commonwealth_presidents';
    } else if (widget.name == 'Ramon Magsaysay') {
      _achievementSubcategoryId = 'early_republic';
      _achievementId = 'commonwealth_presidents';
    } else if (widget.name == 'Ferdinand Marcos') {
      _achievementSubcategoryId = 'modern_presidents';
      _achievementId = 'martial_law_quiz';
    } else if (widget.name == 'Corazon Aquino') {
      _achievementSubcategoryId = 'modern_presidents';
      _achievementId = 'democracy_restored';
    }
  }
  
  Future<void> _loadAchievementProgress() async {
    try {
      final clusters = await _achievementsService.getAchievementClusters();
      
      // Find matching achievement to get score and completion status
      for (final cluster in clusters) {
        if (cluster.id == _achievementClusterId) {
          for (final subcategory in cluster.subcategories) {
            if (subcategory.id == _achievementSubcategoryId) {
              for (final achievement in subcategory.achievements) {
                if (achievement.id == _achievementId) {
                  setState(() {
                    _quizScore = achievement.userScore;
                    _quizCompleted = achievement.isCompleted;
                  });
                  return;
                }
              }
            }
          }
        }
      }
    } catch (e) {
      print('Error loading achievement progress: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Hardcoded info based on president name
    String biography = '';
    String termText = widget.term ?? '';
    String birthDeath = '';
    
    if (widget.name == "Emilio Aguinaldo") {
      biography = "Emilio Aguinaldo was a Filipino revolutionary leader and military commander who fought for independence against Spain and later against the United States. He declared Philippine independence on June 12, 1898 and served as the first President of the Philippines.";
      birthDeath = "1869–1964";
    } else if (widget.name == "Manuel L. Quezon") {
      biography = "Manuel Luis Quezon was a Filipino statesman, soldier and politician who served as president of the Commonwealth of the Philippines from 1935 to 1944. He was the first Filipino to head a government of the Philippines.";
      birthDeath = "1878-1944";
    } else if (widget.name == "Ramon Magsaysay") {
      biography = "Ramon del Fierro Magsaysay Sr. was the seventh President of the Philippines, serving from 1953 until his death in 1957. An automobile mechanic by profession, he rose to the presidency through his popular appeal with the masses.";
      birthDeath = "1907-1957";
    } else if (widget.name == "Ferdinand Marcos") {
      biography = "Ferdinand Emmanuel Edralin Marcos Sr. was a Filipino politician, lawyer, and kleptocrat who served as the 10th President of the Philippines from 1965 to 1986. He ruled under martial law from 1972 to 1981.";
      birthDeath = "1917-1989";
    } else if (widget.name == "Corazon Aquino") {
      biography = "Maria Corazon Sumulong Cojuangco Aquino was a Filipino politician who served as the 11th President of the Philippines from 1986 to 1992. She was the first female president of the Philippines and the first female president in Asia.";
      birthDeath = "1933-2009";
    } else {
      biography = 'Biography or information about ${widget.name} will be shown here.';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with image and basic info
            Container(
              color: Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // President image with frame
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
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          widget.imagePath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // President name
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    // Birth-Death years
                    if (birthDeath.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        birthDeath,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    
                    // Term dates
                    if (termText.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Presidential Term: $termText',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
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
                  color: Colors.orange[800],
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
            
            // Quiz Section
            if (widget.showQuiz && _achievementId.isNotEmpty) ...[
              const SizedBox(height: 24),
              
              // Quiz Section Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Test Your Knowledge',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              
              // Quiz Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Quiz description and progress
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                _quizCompleted ? Icons.emoji_events : Icons.quiz,
                                size: 28,
                                color: Colors.orange.shade700,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${widget.name} Quiz',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Test your knowledge about ${widget.name}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  
                                  // Progress indicator
                                  if (_quizScore > 0) ... [
                                    const Text(
                                      'Your progress:',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(height: 4),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: LinearProgressIndicator(
                                        value: _quizScore / 100,
                                        minHeight: 8,
                                        backgroundColor: Colors.grey.shade200,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          _quizCompleted ? Colors.green : Colors.orange,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '$_quizScore%',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: _quizCompleted ? Colors.green : Colors.orange,
                                          ),
                                        ),
                                        if (_quizCompleted)
                                          const Text(
                                            'Completed!',
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        // Quiz button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Navigate to quiz screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PresidentQuizScreen(
                                    presidentName: widget.name,
                                    quizTitle: '${widget.name} Quiz',
                                  ),
                                ),
                              ).then((_) {
                                // Refresh achievement progress when coming back from quiz
                                _loadAchievementProgress();
                              });
                            },
                            icon: Icon(
                              _quizCompleted ? Icons.replay : Icons.play_arrow,
                              color: Colors.white,
                            ),
                            label: Text(
                              _quizCompleted ? 'Retake Quiz' : 'Start Quiz',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

