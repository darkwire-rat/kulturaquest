import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import '../services/achievements_service.dart';
import '../models/achievement_models.dart';
import '../utils/quiz_score_calculator.dart';
import '../screens/achievements_tab.dart';
import 'main_screen.dart';

class HistoryQuizScreen extends StatefulWidget {
  final String? region;
  final bool isRandom;

  const HistoryQuizScreen({Key? key, this.region, this.isRandom = false}) : super(key: key);

  @override
  State<HistoryQuizScreen> createState() => _HistoryQuizScreenState();
}

class _HistoryQuizScreenState extends State<HistoryQuizScreen> {
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
      achievementId = 'luzon_history_quiz';
    } else if (widget.region == 'Visayas') {
      achievementId = 'visayas_history_quiz';
    } else if (widget.region == 'Mindanao') {
      achievementId = 'mindanao_history_quiz';
    }
    
    if (achievementId != null) {
      final achievementsService = AchievementsService();
      final clusters = await achievementsService.getAchievementClusters();
      
      // Find the history cluster
      final historyCluster = clusters.firstWhere(
        (cluster) => cluster.id == 'history',
        orElse: () => AchievementCluster(
          id: 'history',
          title: 'History',
          description: '',
          subcategories: [],
          color: Colors.brown,
        ),
      );
      
      // Find the regional history subcategory
      final regionalSubcategory = historyCluster.subcategories.firstWhere(
        (subcat) => subcat.id == 'regional_history',
        orElse: () => AchievementSubcategory(
          id: 'regional_history',
          title: 'Regional History',
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
        'question': 'In what year was the First Philippine Republic established in Malolos, Bulacan?',
        'choices': ['1896', '1898', '1899', '1901'],
        'correctAnswer': '1899',
        'explanation': 'The First Philippine Republic was established in Malolos, Bulacan in 1899, making the Philippines the first constitutional republic in Asia.',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'Which Filipino general held off American forces at Tirad Pass to allow President Aguinaldo to escape?',
        'choices': ['Antonio Luna', 'Gregorio del Pilar', 'Emilio Jacinto', 'Juan Luna'],
        'correctAnswer': 'Gregorio del Pilar',
        'explanation': 'General Gregorio del Pilar, known as the "Boy General," and 60 Filipino soldiers held off 500 American soldiers at Tirad Pass in Ilocos Sur in 1899, allowing President Aguinaldo to escape.',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'When did the Philippines gain full independence from the United States?',
        'choices': ['1898', '1935', '1946', '1965'],
        'correctAnswer': '1946',
        'explanation': 'The Philippines gained full independence from the United States on July 4, 1946, with the inauguration of the Third Republic in Manila.',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'What year did the EDSA People Power Revolution occur?',
        'choices': ['1972', '1981', '1986', '1992'],
        'correctAnswer': '1986',
        'explanation': 'The EDSA People Power Revolution occurred in 1986. It was a nonviolent revolution in Metro Manila that ousted President Ferdinand Marcos and restored democracy to the Philippines.',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'Which Philippine president declared Martial Law in 1972?',
        'choices': ['Corazon Aquino', 'Ferdinand Marcos', 'Fidel Ramos', 'Joseph Estrada'],
        'correctAnswer': 'Ferdinand Marcos',
        'explanation': 'President Ferdinand Marcos declared Martial Law on September 21, 1972, which lasted until 1981. This period was marked by human rights abuses, censorship, and the suppression of political opposition.',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'What was the name of the Spanish colonial fort built in Intramuros, Manila?',
        'choices': ['Fort Santiago', 'Fort San Pedro', 'Fort Pilar', 'Fort San Antonio'],
        'correctAnswer': 'Fort Santiago',
        'explanation': 'Fort Santiago was a citadel built by Spanish conquistador Miguel López de Legazpi in Intramuros, Manila. It served as the headquarters of the Spanish military and later became a prison where many Filipino revolutionaries, including José Rizal, were detained.',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'Which volcanic eruption in Luzon in 1991 was one of the largest in the 20th century?',
        'choices': ['Mayon Volcano', 'Taal Volcano', 'Mount Pinatubo', 'Mount Arayat'],
        'correctAnswer': 'Mount Pinatubo',
        'explanation': 'The eruption of Mount Pinatubo on June 15, 1991, was one of the largest volcanic eruptions of the 20th century. It affected global climate and caused extensive damage to surrounding areas in Luzon.',
        'image': 'images/philpic.jpg',
      },
    ];
  }

  List<Map<String, dynamic>> _getVisayasQuestions() {
    return [
      {
        'question': 'Who was the Filipino chieftain who defeated Ferdinand Magellan in the Battle of Mactan in 1521?',
        'choices': ['Humabon', 'Lapu-Lapu', 'Rajah Sulayman', 'Sultan Kudarat'],
        'correctAnswer': 'Lapu-Lapu',
        'explanation': 'Lapu-Lapu was the datu (chieftain) of Mactan who defeated Ferdinand Magellan and his Spanish forces at the Battle of Mactan in 1521, marking the first successful resistance against European colonizers in the Philippines.',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'How long did the Dagohoy Rebellion in Bohol last?',
        'choices': ['10 years', '35 years', '50 years', '85 years'],
        'correctAnswer': '85 years',
        'explanation': 'The Dagohoy Rebellion, led by Francisco Dagohoy in Bohol from 1744 to 1829, was the longest revolt against Spanish colonial rule in Philippine history, lasting for 85 years.',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'Which city in the Visayas became the first Spanish settlement and capital in the Philippines?',
        'choices': ['Iloilo', 'Cebu', 'Tacloban', 'Bacolod'],
        'correctAnswer': 'Cebu',
        'explanation': 'Cebu became the first Spanish settlement and capital in the Philippines when Miguel López de Legazpi established a colony there in 1565.',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'Where did General Douglas MacArthur land when he returned to the Philippines in 1944?',
        'choices': ['Cebu Gulf', 'Samar Bay', 'Leyte Gulf', 'Panay Island'],
        'correctAnswer': 'Leyte Gulf',
        'explanation': 'General Douglas MacArthur fulfilled his promise to return to the Philippines by landing at Leyte Gulf on October 20, 1944, beginning the liberation of the Philippines from Japanese occupation.',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'What religious icon brought by Magellan is celebrated annually in Cebu during the Sinulog Festival?',
        'choices': ['Black Nazarene', 'Santo Niño', 'Our Lady of Caysasay', 'Virgen de los Remedios'],
        'correctAnswer': 'Santo Niño',
        'explanation': 'The Santo Niño (Holy Child) was a gift from Ferdinand Magellan to Queen Juana of Cebu in 1521. It is celebrated annually during the Sinulog Festival, one of the largest and most colorful festivals in the Philippines.',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'Which Visayan island was known as a major shipbuilding center during the Spanish colonial period?',
        'choices': ['Cebu', 'Bohol', 'Panay', 'Leyte'],
        'correctAnswer': 'Panay',
        'explanation': 'Panay Island, particularly the town of Iloilo, was a major shipbuilding center during the Spanish colonial period. The ships built there, known as "Panay lorchas," were used for inter-island trade and for the Manila-Acapulco Galleon Trade.',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'What devastating typhoon hit the Visayas in 2013, causing widespread destruction?',
        'choices': ['Typhoon Haiyan (Yolanda)', 'Typhoon Bopha (Pablo)', 'Typhoon Fengshen (Frank)', 'Typhoon Hagupit (Ruby)'],
        'correctAnswer': 'Typhoon Haiyan (Yolanda)',
        'explanation': 'Typhoon Haiyan, locally known as Typhoon Yolanda, struck the Visayas on November 8, 2013. It was one of the strongest tropical cyclones ever recorded and caused catastrophic damage, particularly in Leyte and Samar.',
        'image': 'images/philpic.jpg',
      },
    ];
  }

  List<Map<String, dynamic>> _getMindanaoQuestions() {
    return [
      {
        'question': 'When was the Sultanate of Sulu established?',
        'choices': ['1405', '1515', '1635', '1744'],
        'correctAnswer': '1405',
        'explanation': 'The Sultanate of Sulu was established in 1405 by Arab missionary Sharif ul-Hashim (also known as Abu Bakr). It became a powerful Islamic state and trading power in Southeast Asia.',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'Who founded the Maguindanao Sultanate in 1515?',
        'choices': ['Sultan Kudarat', 'Sharif Muhammad Kabungsuwan', 'Rajah Sulayman', 'Datu Piang'],
        'correctAnswer': 'Sharif Muhammad Kabungsuwan',
        'explanation': 'The Maguindanao Sultanate was founded in 1515 by Sharif Muhammad Kabungsuwan, an Arab-Malay missionary. It became a major political and cultural center in Mindanao.',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'Which Sultan successfully led resistance against Spanish colonization attempts in Mindanao in the 17th century?',
        'choices': ['Sultan Jamal ul-Kiram', 'Sultan Bolkiah', 'Sultan Kudarat', 'Sultan Dipatuan Kudarat'],
        'correctAnswer': 'Sultan Kudarat',
        'explanation': 'Sultan Kudarat successfully led resistance against Spanish colonization attempts in Mindanao during the 17th century, particularly during the Zamboanga Siege of 1635, preserving the independence of Muslim territories.',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'What 1968 event led to increased Muslim separatism and the formation of the Moro National Liberation Front?',
        'choices': ['Jabidah Massacre', 'Zamboanga Siege', 'Battle of Marawi', 'Jolo Uprising'],
        'correctAnswer': 'Jabidah Massacre',
        'explanation': 'The Jabidah Massacre in 1968 was a pivotal event where Filipino Muslim trainees were killed in Corregidor. This incident led to increased Muslim separatism and the formation of the Moro National Liberation Front (MNLF) under Nur Misuari.',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'Which indigenous group in Mindanao is known for their T\'boli weaving tradition called T\'nalak?',
        'choices': ['Manobo', 'Bagobo', 'T\'boli', 'Tausug'],
        'correctAnswer': 'T\'boli',
        'explanation': 'The T\'boli people of South Cotabato in Mindanao are known for their intricate T\'nalak weaving, a sacred cloth made from abaca fibers with patterns that come to the weavers in dreams.',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'What agreement was signed in 1996 between the Philippine government and the Moro National Liberation Front?',
        'choices': ['Tripoli Agreement', 'Final Peace Agreement', 'Bangsamoro Basic Law', 'Comprehensive Agreement on the Bangsamoro'],
        'correctAnswer': 'Final Peace Agreement',
        'explanation': 'The Final Peace Agreement (also known as the Jakarta Peace Agreement) was signed in 1996 between the Philippine government and the Moro National Liberation Front (MNLF), establishing the Autonomous Region in Muslim Mindanao (ARMM).',
        'image': 'images/philpic.jpg',
      },
      {
        'question': 'Which city in Mindanao was the site of a five-month battle between Philippine government forces and ISIS-affiliated militants in 2017?',
        'choices': ['Davao City', 'Zamboanga City', 'Cotabato City', 'Marawi City'],
        'correctAnswer': 'Marawi City',
        'explanation': 'The Battle of Marawi was a five-month armed conflict in 2017 between Philippine government forces and militants affiliated with the Islamic State (ISIS), including the Maute and Abu Sayyaf groups, in Marawi City, Lanao del Sur.',
        'image': 'images/philpic.jpg',
      },
    ];
  }

  void _answerQuestion(String choice) async {
    if (isAnswered) return; // Prevent multiple answers
    
    final correctAnswer = questions[currentQuestionIndex]['correctAnswer'];
    final bool correct = choice == correctAnswer;
    
    setState(() {
      selectedChoice = choice;
      isCorrect = correct;
      isAnswered = true;
      // Only increment score if it won't exceed total questions
      if (correct && score < questions.length) {
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
      achievementId = 'luzon_history_quiz';
    } else if (widget.region == 'Visayas') {
      achievementId = 'visayas_history_quiz';
    } else if (widget.region == 'Mindanao') {
      achievementId = 'mindanao_history_quiz';
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
        'history',
        'regional_history',
        achievementId,
        score: QuizScoreCalculator.calculateAchievementScore(score, questions.length),  // Use the achievement-specific score
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
            // No images or icons as per requirement
            const SizedBox(height: 8),
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
      achievementId = 'luzon_history_quiz';
    } else if (widget.region == 'Visayas') {
      achievementId = 'visayas_history_quiz';
    } else if (widget.region == 'Mindanao') {
      achievementId = 'mindanao_history_quiz';
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
      final historyCluster = clusters.firstWhere(
        (cluster) => cluster.id == 'history',
        orElse: () => AchievementCluster(
          id: 'history',
          title: 'History',
          description: '',
          subcategories: [],
          color: Colors.brown,
        ),
      );
      
      final regionalSubcategory = historyCluster.subcategories.firstWhere(
        (subcat) => subcat.id == 'regional_history',
        orElse: () => AchievementSubcategory(
          id: 'regional_history',
          title: 'Regional History',
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
          'history',
          'regional_history',
          achievementId,
          score: achievementScore, // Use the achievement-specific score (7 points max)
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
        // This was a perfect score, check if user has earned the grand scholar achievement
        // First get all regional achievements to check their status
        final luzonAchievement = regionalSubcategory.achievements.firstWhere(
          (a) => a.id == 'luzon_history_quiz',
          orElse: () => Achievement(id: 'luzon_history_quiz', title: '', description: '', maxScore: 100, isCompleted: false),
        );
        
        final visayasAchievement = regionalSubcategory.achievements.firstWhere(
          (a) => a.id == 'visayas_history_quiz',
          orElse: () => Achievement(id: 'visayas_history_quiz', title: '', description: '', maxScore: 100, isCompleted: false),
        );
        
        final mindanaoAchievement = regionalSubcategory.achievements.firstWhere(
          (a) => a.id == 'mindanao_history_quiz',
          orElse: () => Achievement(id: 'mindanao_history_quiz', title: '', description: '', maxScore: 100, isCompleted: false),
        );
        
        // Calculate grand scholar score based on completion of regional quizzes
        int grandScholarScore = 0;
        // For grand scholar, we use a maximum of 10 points
        // Calculate proportional points from each regional quiz, capped at their maximum
        if (luzonAchievement.isCompleted) grandScholarScore += (luzonAchievement.userScore > 7 ? 7 : luzonAchievement.userScore);
        if (visayasAchievement.isCompleted) grandScholarScore += (visayasAchievement.userScore > 7 ? 7 : visayasAchievement.userScore);
        if (mindanaoAchievement.isCompleted) grandScholarScore += (mindanaoAchievement.userScore > 7 ? 7 : mindanaoAchievement.userScore);
        
        // Check if all regions are completed for grand scholar achievement
        bool allRegionsCompleted = luzonAchievement.isCompleted && 
                                visayasAchievement.isCompleted && 
                                mindanaoAchievement.isCompleted;
        
        // Update the grand scholar achievement
        // Calculate the grand scholar score, capped at 10 points
        int finalGrandScholarScore = math.min(grandScholarScore, 10);
        
        // Calculate the overall progress percentage based on total points earned out of 31 (7+7+7+10)
        // This ensures the total score doesn't exceed 31 points and progress is calculated consistently
        int totalPointsEarned = (luzonAchievement.isCompleted ? (luzonAchievement.userScore > 7 ? 7 : luzonAchievement.userScore) : 0) +
                             (visayasAchievement.isCompleted ? (visayasAchievement.userScore > 7 ? 7 : visayasAchievement.userScore) : 0) +
                             (mindanaoAchievement.isCompleted ? (mindanaoAchievement.userScore > 7 ? 7 : mindanaoAchievement.userScore) : 0) +
                             finalGrandScholarScore;
        
        // Grand scholar is considered completed if all regional quizzes are completed
        bool isGrandScholarCompleted = allRegionsCompleted;
        
        await achievementsService.updateAchievement(
          'history',
          'regional_history',
          'history_grand_scholar',
          score: finalGrandScholarScore, // Score is capped at 10 points
          completed: isGrandScholarCompleted,
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
        title: Text(widget.isRandom ? 'History Grand Scholar Quiz' : '${widget.region} History Quiz'),
        backgroundColor: Colors.orange.shade400,
        foregroundColor: Colors.white,
        elevation: 4,
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
              // Progress and score indicator - Only show for non-random (regional) quizzes
              if (!widget.isRandom)
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Raw Score: $score',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Percentage: ${(score / questions.length * 100).clamp(0, 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
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
                      // No images during quiz as per requirement
                      const SizedBox(height: 10),
                      
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
                        
                        // Don't show correct/incorrect indicators during the quiz
                        // Only highlight the selected answer
                        if (isAnswered) {
                          if (isSelected) {
                            backgroundColor = Colors.orange.shade100;
                            borderColor = Colors.orange.shade400;
                            textColor = Colors.orange.shade800;
                            icon = null; // Don't show any icon to avoid revealing the answer
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
                              'ud83cudfc6 Perfect Score!',
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
