import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/achievements_service.dart';
import '../models/achievement_models.dart';
import '../utils/quiz_score_calculator.dart';
import '../screens/achievements_tab.dart';
import 'main_screen.dart';

class TraditionsQuizScreen extends StatefulWidget {
  final String? region;
  final bool isRandom;

  const TraditionsQuizScreen({Key? key, this.region, this.isRandom = false}) : super(key: key);

  @override
  State<TraditionsQuizScreen> createState() => _TraditionsQuizScreenState();
}

class _TraditionsQuizScreenState extends State<TraditionsQuizScreen> {
  int currentQuestionIndex = 0;
  String? selectedChoice;
  bool? isCorrect;
  bool isAnswered = false;
  int score = 0;
  List<Map<String, dynamic>> questions = [];
  bool isQuizCompleted = false; // Flag to track if this quiz was previously completed

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _checkQuizCompletion();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if quiz is completed and show retry dialog
    if (isQuizCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showRetryDialog();
      });
    }
  }
  
  // Show dialog asking if user wants to retry the quiz
  void _showRetryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Quiz Already Completed'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('You have already completed this quiz.'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.emoji_events, color: Colors.amber),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Your achievement for this quiz has been recorded.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Return to previous screen
              },
              child: const Text('GO BACK'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Reset quiz state to retry
                setState(() {
                  currentQuestionIndex = 0;
                  selectedChoice = null;
                  isCorrect = null;
                  isAnswered = false;
                  score = 0;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
              ),
              child: const Text('RETRY QUIZ'),
            ),
          ],
        );
      },
    );
  }
  
  // Check if this quiz has already been completed
  Future<void> _checkQuizCompletion() async {
    // Determine which achievement to check based on region
    String? achievementId;
    if (widget.region == 'Luzon') {
      achievementId = 'luzon_traditions_quiz';
    } else if (widget.region == 'Visayas') {
      achievementId = 'visayas_traditions_quiz';
    } else if (widget.region == 'Mindanao') {
      achievementId = 'mindanao_traditions_quiz';
    }
    
    if (achievementId != null) {
      final achievementsService = AchievementsService();
      final clusters = await achievementsService.getAchievementClusters();
      
      // Find the traditions cluster
      final traditionsCluster = clusters.firstWhere(
        (cluster) => cluster.id == 'traditions',
        orElse: () => AchievementCluster(
          id: 'traditions',
          title: 'Traditions',
          description: '',
          subcategories: [],
          color: Colors.orange,
        ),
      );
      
      // Find the regional traditions subcategory
      final regionalSubcategory = traditionsCluster.subcategories.firstWhere(
        (subcat) => subcat.id == 'regional_traditions',
        orElse: () => AchievementSubcategory(
          id: 'regional_traditions',
          title: 'Regional Traditions',
          description: '',
          achievements: [],
        ),
      );
      
      // Find the specific achievement
      final achievement = regionalSubcategory.achievements.firstWhere(
        (achievement) => achievement.id == achievementId,
        orElse: () => Achievement(
          id: achievementId!,
          title: '',
          description: '',
          maxScore: 100,
          isCompleted: false,
        ),
      );
      
      // Update state if the achievement is completed
      if (achievement.isCompleted) {
        setState(() {
          isQuizCompleted = true;
        });
      }
    }
  }

  void _loadQuestions() {
    // Load questions based on region or random
    if (widget.region == 'Luzon') {
      questions = _getLuzonQuestions();
    } else if (widget.region == 'Visayas') {
      questions = _getVisayasQuestions();
    } else if (widget.region == 'Mindanao') {
      questions = _getMindanaoQuestions();
    } else {
      // Random questions from all regions
      List<Map<String, dynamic>> allQuestions = [
        ..._getLuzonQuestions(),
        ..._getVisayasQuestions(),
        ..._getMindanaoQuestions(),
      ];
      
      // Shuffle and select 10 random questions
      allQuestions.shuffle();
      questions = allQuestions.take(10).toList();
    }
  }

  List<Map<String, dynamic>> _getLuzonQuestions() {
    return [
      {
        'question': 'Which traditional rice terraces in Luzon are known as the \'Eighth Wonder of the World\'?',
        'choices': ['Chocolate Hills', 'Banaue Rice Terraces', 'Mayon Volcano', 'Hundred Islands'],
        'correctAnswer': 'Banaue Rice Terraces',
        'explanation': 'The Banaue Rice Terraces in Ifugao province are often called the \'Eighth Wonder of the World\'. They were carved into the mountains by ancestors of the indigenous people over 2,000 years ago.',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'What traditional Filipino martial art originated in Luzon?',
        'choices': ['Arnis', 'Muay Thai', 'Silat', 'Karate'],
        'correctAnswer': 'Arnis',
        'explanation': 'Arnis (also known as Kali or Eskrima) is a traditional Filipino martial art that uses sticks, bladed weapons, and empty hands. It originated in the northern Philippines and became the national martial art.',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'What traditional Igorot garment is made of hand-woven cloth and worn as a skirt or dress in the Cordillera region?',
        'choices': ['Tapis', 'Malong', 'Bahag', 'Kimona'],
        'correctAnswer': 'Tapis',
        'explanation': 'The Tapis is a traditional hand-woven skirt or tube dress worn by Igorot women in the Cordillera region. It is often decorated with intricate patterns that represent tribal identity and status.',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'Which traditional Luzon musical instrument is made from bamboo tubes of varying lengths to produce different pitches?',
        'choices': ['Kulintang', 'Kudyapi', 'Bungkaka', 'Tongali'],
        'correctAnswer': 'Tongali',
        'explanation': 'The Tongali (or nose flute) is a traditional bamboo musical instrument played by blowing through the nose. It is commonly used by indigenous groups in Northern Luzon, particularly the Kalinga and Ifugao.',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'What traditional Ilocano dish is made from fermented fish or shrimp with rice and salt?',
        'choices': ['Dinuguan', 'Pinakbet', 'Bagnet', 'Bagoong'],
        'correctAnswer': 'Bagoong',
        'explanation': 'Bagoong is a traditional fermented fish or shrimp paste that originated in Ilocos. It\'s a staple condiment in Ilocano cuisine and is used as a flavoring for many dishes like pinakbet.',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'What traditional Ifugao ceremony is performed to bless the rice terraces before planting?',
        'choices': ['Begnas', 'Punnuk', 'Hagabi', 'Bakle'],
        'correctAnswer': 'Begnas',
        'explanation': 'Begnas is a traditional agricultural ritual performed by the Ifugao people to bless the rice terraces before planting season. It involves prayers, offerings, and community celebrations to ensure a bountiful harvest.',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'Which architectural feature is unique to traditional Ivatan houses in Batanes?',
        'choices': ['Sliding bamboo windows', 'Thick cogon grass roofs', 'Limestone walls', 'Stone roofs'],
        'correctAnswer': 'Stone roofs',
        'explanation': 'Traditional Ivatan houses in Batanes feature stone roofs (called "vakul") made from limestone and thatch, designed to withstand the strong typhoons that frequently hit the northernmost province of Luzon.',
        'image': 'images/philpic.jpg',
      },
    ];
  }

  List<Map<String, dynamic>> _getVisayasQuestions() {
    return [
      {
        'question': 'Which famous festival in Cebu celebrates the Santo Niño and is known for its colorful street dancing?',
        'choices': ['Ati-Atihan', 'Sinulog', 'Dinagyang', 'Masskara'],
        'correctAnswer': 'Sinulog',
        'explanation': 'The Sinulog Festival is celebrated every third Sunday of January in Cebu City. It honors the Santo Niño (Child Jesus) and is known for its colorful street dancing and grand parade.',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'What is the name of the traditional weaving technique from Iloilo that produces colorful textiles?',
        'choices': ['Hablon', 'T\'nalak', 'Inabel', 'Yakan'],
        'correctAnswer': 'Hablon',
        'explanation': 'Hablon is a traditional textile weaving technique from Iloilo in the Western Visayas. It produces colorful fabrics with intricate designs used for clothing and home decor.',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'Which natural formation in Bohol consists of over 1,200 cone-shaped hills?',
        'choices': ['Rice Terraces', 'Chocolate Hills', 'Hanging Gardens', 'Limestone Caves'],
        'correctAnswer': 'Chocolate Hills',
        'explanation': 'The Chocolate Hills are a geological formation in Bohol consisting of at least 1,268 perfectly cone-shaped hills. During the dry season, the grass turns brown, giving them a chocolate-like appearance.',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'What traditional Visayan fishing method uses bamboo traps to catch fish in shallow waters?',
        'choices': ['Pamunit', 'Bungsod', 'Pukot', 'Pana'],
        'correctAnswer': 'Bungsod',
        'explanation': 'Bungsod is a traditional fishing method in the Visayas that uses bamboo traps or corrals set in shallow waters to catch fish during high tide. As the tide recedes, the fish are trapped inside the bamboo enclosure.',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'Which traditional Visayan healing practice involves the use of coconut oil, prayers, and massage to treat various ailments?',
        'choices': ['Hilot', 'Tawas', 'Kulam', 'Albularyo'],
        'correctAnswer': 'Hilot',
        'explanation': 'Hilot is a traditional Filipino healing practice that combines massage techniques with the use of coconut oil and prayers. In the Visayas, hilot practitioners (manghihilot) are respected members of the community who treat various physical ailments.',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'What traditional Cebuano dish consists of pork meat cooked until crispy and served with a vinegar dipping sauce?',
        'choices': ['Lechon', 'Kinilaw', 'Humba', 'Pochero'],
        'correctAnswer': 'Lechon',
        'explanation': 'Lechon is a traditional Cebuano dish where a whole pig is roasted over charcoal until the skin becomes crispy. Cebu is famous for having the best lechon in the Philippines, often served with a vinegar dipping sauce called suka.',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'What traditional architectural feature is common in old Visayan houses to provide ventilation?',
        'choices': ['Capiz shell windows', 'Bamboo floors', 'Stone foundations', 'Nipa roofs'],
        'correctAnswer': 'Capiz shell windows',
        'explanation': 'Capiz shell windows are a distinctive architectural feature of traditional Visayan houses. These translucent windows made from capiz shells allow light to enter while keeping the interior cool, providing natural ventilation in the tropical climate.',
        'image': 'images/philpic.jpg',
      },
    ];
  }

  List<Map<String, dynamic>> _getMindanaoQuestions() {
    return [
      {
        'question': 'What is the name of the traditional dance performed by Maranao women during special occasions?',
        'choices': ['Singkil', 'Pangalay', 'Kapa Malong-Malong', 'Sagayan'],
        'correctAnswer': 'Singkil',
        'explanation': 'Singkil is a traditional royal Maranao dance that depicts a Muslim princess escaping from falling bamboo poles, symbolizing her escape from an earthquake caused by forest spirits.',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'Which indigenous group from Mindanao is known for their T\'nalak weaving?',
        'choices': ['Bagobo', 'T\'boli', 'Manobo', 'Tausug'],
        'correctAnswer': 'T\'boli',
        'explanation': 'The T\'boli people are known for their intricate T\'nalak weaving, a sacred cloth made from abaca fibers with patterns that come to the weavers in dreams.',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'What is the highest mountain in the Philippines, located in Mindanao?',
        'choices': ['Mount Pulag', 'Mount Apo', 'Mount Kitanglad', 'Mount Dulang-dulang'],
        'correctAnswer': 'Mount Apo',
        'explanation': 'Mount Apo, standing at 2,954 meters (9,692 feet) above sea level in Davao, is the highest mountain in the Philippines.',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'What traditional Mindanao instrument consists of a row of small bronze or brass gongs arranged horizontally on a wooden frame?',
        'choices': ['Agung', 'Kulintang', 'Dabakan', 'Gandingan'],
        'correctAnswer': 'Kulintang',
        'explanation': 'The Kulintang is a traditional percussion instrument from Mindanao consisting of a row of small bronze or brass gongs arranged horizontally on a wooden frame. It is central to the musical traditions of the Maguindanao, Maranao, and Tausug peoples.',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'Which traditional boat is used by the Sama-Bajau people of the Sulu Archipelago?',
        'choices': ['Vinta', 'Balangay', 'Lepa', 'Bangka'],
        'correctAnswer': 'Lepa',
        'explanation': 'The Lepa is a traditional houseboat used by the Sama-Bajau people (sea gypsies) of the Sulu Archipelago. These colorful boats serve as both transportation and homes, reflecting the seafaring culture of these indigenous people.',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'What traditional Mindanao food is made from cassava and coconut, often served during special occasions?',
        'choices': ['Piyanggang', 'Pastil', 'Puto Maya', 'Tinagtag'],
        'correctAnswer': 'Tinagtag',
        'explanation': 'Tinagtag is a traditional Maguindanaon delicacy made from cassava and coconut. It is a sweet, crispy wafer-like dessert that is commonly served during special occasions and celebrations in Mindanao.',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'What traditional Mindanao wedding ceremony involves the payment of a dowry called "ungsod"?',
        'choices': ['Kasal', 'Nikah', 'Sunggod', 'Pagkawin'],
        'correctAnswer': 'Sunggod',
        'explanation': 'Sunggod is a traditional Tausug wedding ceremony that involves the payment of a dowry (ungsod) from the groom\'s family to the bride\'s family. The amount is determined by factors such as social status, education, and family background.',
        'image': 'images/philpic.jpg',
      },
    ];
  }

  void _answerQuestion(String choice) async {
    if (isAnswered) return;

    final currentQuestion = questions[currentQuestionIndex];
    final isCorrectAnswer = choice == currentQuestion['correctAnswer'];

    setState(() {
      selectedChoice = choice;
      isCorrect = isCorrectAnswer;
      isAnswered = true;
      if (isCorrectAnswer) {
        score++;
      }
    });
    
    // Save progress after each question is answered
    await _saveQuizProgress();
  }
  
  // Save the current quiz progress
  Future<void> _saveQuizProgress() async {
    // Use the QuizScoreCalculator to ensure consistent scoring across all quizzes
    // This guarantees that perfect scores always equal exactly 100%
    final normalizedScore = QuizScoreCalculator.calculateScore(score, questions.length);
    
    // Determine which achievement to update based on region
    String? achievementId;
    if (widget.region == 'Luzon') {
      achievementId = 'luzon_traditions_quiz';
    } else if (widget.region == 'Visayas') {
      achievementId = 'visayas_traditions_quiz';
    } else if (widget.region == 'Mindanao') {
      achievementId = 'mindanao_traditions_quiz';
    }
    
    if (achievementId != null) {
      final achievementsService = AchievementsService();
      
      // Use the QuizScoreCalculator to determine if the quiz is completed
      // A quiz is considered complete if the user has answered at least 80% of the questions correctly
      final questionsAnswered = currentQuestionIndex + 1;
      final isCompleted = QuizScoreCalculator.isQuizCompleted(
        correctAnswers: score,
        totalQuestions: questions.length,
        questionsAnswered: questionsAnswered,
        completionThreshold: 0.8,
      );
      
      // Update the achievement with current progress
      await achievementsService.updateAchievement(
        'traditions',
        'regional_traditions',
        achievementId,
        score: normalizedScore,  // Use the normalized score
        completed: isCompleted,
      );
      
      // Notify the achievements tab to refresh and show updated score
      AchievementUpdateController.notifyAchievementsUpdated();
      
      // Update UI if quiz is now completed
      if (isCompleted && !isQuizCompleted) {
        setState(() {
          isQuizCompleted = true;
        });
      }
    }
  }

  Widget _buildCompletionDialog(String title, String message, bool isPerfectScore) {
    // Calculate normalized score as percentage
    final normalizedScore = QuizScoreCalculator.calculateScore(score, questions.length);
    
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isPerfectScore
                ? const Icon(Icons.emoji_events, color: Colors.amber, size: 80)
                : const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Text(
              'Score: $normalizedScore%',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your achievement has been updated!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop(); // Return to previous screen
          },
          child: const Text('Return'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            // Navigate back to main screen and pass parameter to show achievements tab
            Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false, 
              arguments: {'initialTab': 2} // Pass argument to show achievements tab
            );
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.amber[700],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.emoji_events),
              SizedBox(width: 4),
              Text('View Achievements'),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            setState(() {
              currentQuestionIndex = 0;
              selectedChoice = null;
              isCorrect = null;
              isAnswered = false;
              score = 0;
              _loadQuestions(); // Reload questions for a new quiz
            });
          },
          child: const Text('Try Again'),
        ),
      ],
    );
  }

  // Finalize quiz achievements after completion
  Future<void> _finalizeQuizAchievements() async {
    final achievementsService = AchievementsService();
    
    // Determine which achievement to update based on region
    String? achievementId;
    if (widget.region == 'Luzon') {
      achievementId = 'luzon_traditions_quiz';
    } else if (widget.region == 'Visayas') {
      achievementId = 'visayas_traditions_quiz';
    } else if (widget.region == 'Mindanao') {
      achievementId = 'mindanao_traditions_quiz';
    }
    
    // Update the specific regional achievement
    if (achievementId != null) {
      // Use the QuizScoreCalculator to ensure consistent score calculation
      final normalizedScore = QuizScoreCalculator.calculateScore(score, questions.length);
      // Use the achievement-specific score calculator to ensure proper achievement progress
      final achievementScore = QuizScoreCalculator.calculateAchievementScore(score, questions.length, maxAchievementScore: 7); // 7 points for regional quizzes
      final isCompleted = score >= (questions.length * 0.8).round(); // Completed if score is at least 80%
      
      // Get current achievement data to check if we should update
      final clusters = await achievementsService.getAchievementClusters();
      final traditionsCluster = clusters.firstWhere(
        (cluster) => cluster.id == 'traditions',
        orElse: () => AchievementCluster(
          id: 'traditions',
          title: 'Traditions',
          description: '',
          subcategories: [],
          color: Colors.orange,
        ),
      );
      
      final regionalSubcategory = traditionsCluster.subcategories.firstWhere(
        (subcat) => subcat.id == 'regional_traditions',
        orElse: () => AchievementSubcategory(
          id: 'regional_traditions',
          title: 'Regional Traditions',
          description: '',
          achievements: [],
        ),
      );
      
      final existingAchievement = regionalSubcategory.achievements.firstWhere(
        (achievement) => achievement.id == achievementId,
        orElse: () => Achievement(
          id: achievementId!,
          title: '',
          description: '',
          maxScore: 100,
          isCompleted: false,
          userScore: 0,
        ),
      );
      
      // Only update if the new score is better than the existing score or if not completed yet
      if (normalizedScore > (existingAchievement.userScore) || !existingAchievement.isCompleted) {
        // Update the achievement with the better score
        await achievementsService.updateAchievement(
          'traditions',
          'regional_traditions',
          achievementId,
          score: achievementScore,  // Use the achievement-specific score
          completed: isCompleted,
        );
        
        // Update the UI to reflect the completed status for next time
        if (isCompleted) {
          setState(() {
            isQuizCompleted = true;
          });
        }
      }
      
      // Check if all regional quizzes are completed with perfect scores
      if (score == questions.length) {
        // This was a perfect score, check if user has earned the grand master achievement
        // First get all regional achievements to check their status
        final luzonAchievement = regionalSubcategory.achievements.firstWhere(
          (a) => a.id == 'luzon_traditions_quiz',
          orElse: () => Achievement(id: 'luzon_traditions_quiz', title: '', description: '', maxScore: 100, isCompleted: false),
        );
        
        final visayasAchievement = regionalSubcategory.achievements.firstWhere(
          (a) => a.id == 'visayas_traditions_quiz',
          orElse: () => Achievement(id: 'visayas_traditions_quiz', title: '', description: '', maxScore: 100, isCompleted: false),
        );
        
        final mindanaoAchievement = regionalSubcategory.achievements.firstWhere(
          (a) => a.id == 'mindanao_traditions_quiz',
          orElse: () => Achievement(id: 'mindanao_traditions_quiz', title: '', description: '', maxScore: 100, isCompleted: false),
        );
        
        // Calculate grand master score based on completion of regional quizzes
        int grandMasterScore = 0;
        // For grand master, we use a maximum of 10 points
        // If all regions are completed with perfect scores, award full 10 points
        if (luzonAchievement.isCompleted && luzonAchievement.userScore == 7) grandMasterScore += 3;
        if (visayasAchievement.isCompleted && visayasAchievement.userScore == 7) grandMasterScore += 3;
        if (mindanaoAchievement.isCompleted && mindanaoAchievement.userScore == 7) grandMasterScore += 4;
        
        // Check if all regions are perfect for completion
        bool allPerfect = luzonAchievement.userScore == 7 && 
                         visayasAchievement.userScore == 7 && 
                         mindanaoAchievement.userScore == 7;
        
        // Update the grand master achievement
        await achievementsService.updateAchievement(
          'traditions',
          'regional_traditions',
          'traditions_grand_master',
          score: allPerfect ? 10 : grandMasterScore, // Award full 10 points if all regional quizzes are perfect
          completed: allPerfect,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentQuestion = questions[currentQuestionIndex];
    final questionText = currentQuestion['question'];
    final choices = currentQuestion['choices'] as List<String>;
    final explanation = currentQuestion['explanation'];
    final imagePath = currentQuestion['image'];

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.region ?? 'All Regions'} Traditions Quiz'),
        backgroundColor: widget.region == 'Luzon'
            ? Colors.blue
            : widget.region == 'Visayas'
                ? Colors.green
                : widget.region == 'Mindanao'
                    ? Colors.red
                    : Colors.purple,
        actions: [
          // Show completion badge if quiz was already completed
          if (isQuizCompleted)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Tooltip(
                message: 'Quiz already completed',
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.check_circle, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'COMPLETED',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              widget.region == 'Luzon'
                  ? Colors.blue[50]!
                  : widget.region == 'Visayas'
                      ? Colors.green[50]!
                      : widget.region == 'Mindanao'
                          ? Colors.red[50]!
                          : Colors.purple[50]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Progress indicator
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(
                      'Question ${currentQuestionIndex + 1}/${questions.length}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: (currentQuestionIndex + 1) / questions.length,
                          minHeight: 10,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            widget.region == 'Luzon'
                                ? Colors.blue
                                : widget.region == 'Visayas'
                                    ? Colors.green
                                    : widget.region == 'Mindanao'
                                        ? Colors.red
                                        : Colors.purple,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: widget.region == 'Luzon'
                            ? Colors.blue
                            : widget.region == 'Visayas'
                                ? Colors.green
                                : widget.region == 'Mindanao'
                                    ? Colors.red
                                    : Colors.purple,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Score: $score',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Question card
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          imagePath,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 200,
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Question text
                      Text(
                        questionText,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      
                      // Choices
                      ...choices.map((choice) {
                        final isSelected = selectedChoice == choice;
                        final isCorrectAnswer = choice == currentQuestion['correctAnswer'];
                        
                        // Determine colors and icons based on selection and correctness
                        Color? backgroundColor;
                        Color? borderColor;
                        Color? textColor;
                        IconData? icon;
                        Color? iconColor;
                        
                        if (isAnswered) {
                          if (isSelected) {
                            if (isCorrect == true) {
                              backgroundColor = Colors.green[100];
                              borderColor = Colors.green;
                              textColor = Colors.green[800];
                              icon = Icons.check_circle;
                              iconColor = Colors.green;
                            } else {
                              backgroundColor = Colors.red[100];
                              borderColor = Colors.red;
                              textColor = Colors.red[800];
                              icon = Icons.cancel;
                              iconColor = Colors.red;
                            }
                          } else if (isCorrectAnswer) {
                            backgroundColor = Colors.green[50];
                            borderColor = Colors.green[300];
                            textColor = Colors.green[800];
                            icon = Icons.check_circle_outline;
                            iconColor = Colors.green[300];
                          }
                        }
                        
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: () => _answerQuestion(choice),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: backgroundColor ?? Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: borderColor ?? Colors.grey[300]!,
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      choice,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        color: textColor ?? Colors.black87,
                                      ),
                                    ),
                                  ),
                                  if (isAnswered && icon != null)
                                    Icon(icon, color: iconColor, size: 24),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      
                      // Explanation (shown after answering)
                      if (isAnswered) ...[  
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: widget.region == 'Luzon'
                                ? Colors.blue[50]
                                : widget.region == 'Visayas'
                                    ? Colors.green[50]
                                    : widget.region == 'Mindanao'
                                        ? Colors.red[50]
                                        : Colors.purple[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: widget.region == 'Luzon'
                                  ? Colors.blue[300]!
                                  : widget.region == 'Visayas'
                                      ? Colors.green[300]!
                                      : widget.region == 'Mindanao'
                                          ? Colors.red[300]!
                                          : Colors.purple[300]!,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.info,
                                    color: widget.region == 'Luzon'
                                        ? Colors.blue
                                        : widget.region == 'Visayas'
                                            ? Colors.green
                                            : widget.region == 'Mindanao'
                                                ? Colors.red
                                                : Colors.purple,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Explanation:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: widget.region == 'Luzon'
                                          ? Colors.blue
                                          : widget.region == 'Visayas'
                                              ? Colors.green
                                              : widget.region == 'Mindanao'
                                                  ? Colors.red
                                                  : Colors.purple,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(explanation),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              // Next button or completion indicator
              if (isAnswered)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      if (currentQuestionIndex < questions.length - 1) {
                        setState(() {
                          currentQuestionIndex++;
                          selectedChoice = null;
                          isCorrect = null;
                          isAnswered = false;
                        });
                      } else {
                        // Quiz completed
                        // Final update to achievements with complete status
                        _finalizeQuizAchievements();
                        
                        if (score == questions.length) {
                          showDialog(
                            context: context,
                            builder: (_) => _buildCompletionDialog(
                              '🏆 Perfect Score!',
                              'Congratulations! You answered all questions correctly!',
                              true,
                            ),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (_) => _buildCompletionDialog(
                              'Quiz Completed!',
                              'You scored $score out of ${questions.length}!',
                              false,
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.region == 'Luzon'
                          ? Colors.blue
                          : widget.region == 'Visayas'
                              ? Colors.green
                              : widget.region == 'Mindanao'
                                  ? Colors.red
                                  : Colors.purple,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      minimumSize: const Size(double.infinity, 54),
                    ),
                    child: Text(
                      currentQuestionIndex < questions.length - 1 ? 'Next Question' : 'See Results',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
