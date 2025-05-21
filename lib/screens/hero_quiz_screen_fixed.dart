import 'package:flutter/material.dart';
import '../services/achievements_service.dart';

class HeroQuizScreen extends StatefulWidget {
  final String heroName;
  final String quizTitle;

  const HeroQuizScreen({
    super.key,
    required this.heroName,
    required this.quizTitle,
  });

  @override
  State<HeroQuizScreen> createState() => _HeroQuizScreenState();
}

class _HeroQuizScreenState extends State<HeroQuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _currentCorrectAnswers = 0;
  double _currentPercentage = 0.0;
  bool _quizCompleted = false;
  List<Map<String, dynamic>> _questions = [];
  List<int> _userAnswers = [];
  List<bool> _answerCorrectness = [];
  bool _answerSelected = false; // Track when an answer is selected but not yet confirmed
  bool _showCorrectAnswer = false; // For Jose Rizal quiz, show correct answer before proceeding
  
  // Achievement related data
  final AchievementsService _achievementsService = AchievementsService();
  String _achievementClusterId = 'heroes';
  String _achievementSubcategoryId = '';
  String _achievementId = '';
  int _previousHighScore = 0;
  bool _isNewHighScore = false;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _setupAchievementIds();
    _loadPreviousScore();
  }
  
  void _setupAchievementIds() {
    // Set the appropriate achievement IDs based on the hero name
    if (widget.heroName == 'Jose Rizal') {
      _achievementSubcategoryId = 'national_heroes';
      _achievementId = 'rizal_quiz';
    } else if (widget.heroName == 'Andres Bonifacio') {
      _achievementSubcategoryId = 'national_heroes';
      _achievementId = 'bonifacio_quiz';
    } else if (widget.heroName == 'Antonio Luna') {
      _achievementSubcategoryId = 'national_heroes';
      _achievementId = 'luna_quiz';
    } else if (widget.heroName == 'Apolinario Mabini') {
      _achievementSubcategoryId = 'national_heroes';
      _achievementId = 'mabini_quiz';
    } else if (widget.heroName == 'Emilio Jacinto') {
      _achievementSubcategoryId = 'national_heroes';
      _achievementId = 'jacinto_quiz';
    }
  }
  
  Future<void> _loadPreviousScore() async {
    try {
      // Load achievement clusters to get previous score
      final clusters = await _achievementsService.getAchievementClusters();
      
      // Find the specific achievement
      for (final cluster in clusters) {
        if (cluster.id == _achievementClusterId) {
          for (final subcategory in cluster.subcategories) {
            if (subcategory.id == _achievementSubcategoryId) {
              for (final achievement in subcategory.achievements) {
                if (achievement.id == _achievementId) {
                  setState(() {
                    _previousHighScore = achievement.userScore;
                  });
                  return;
                }
              }
            }
          }
        }
      }
    } catch (e) {
      print('Error loading previous score: $e');
    }
  }
  
  // Save achievement progress
  Future<void> _saveAchievementProgress(int newScore) async {
    try {
      // Only update if the new score is higher than the previous high score
      if (newScore > _previousHighScore) {
        // Calculate achievement score on a 5-point scale for national heroes quizzes
        // Each hero quiz is worth exactly 5 points maximum
        int achievementScore = 5;
        
        // If score is less than 100%, calculate proportional points (capped at 5)
        if (newScore < 100) {
          achievementScore = ((newScore / 100) * 5).round();
        }
        
        // Ensure the score never exceeds 5 points per quiz
        achievementScore = achievementScore > 5 ? 5 : achievementScore;
        
        await _achievementsService.updateAchievement(
          _achievementClusterId,
          _achievementSubcategoryId,
          _achievementId,
          score: achievementScore, // Use the 5-point scale
          completed: newScore >= 80, // Consider completed if score is 80% or higher
        );
        
        setState(() {
          _isNewHighScore = true;
        });
      }
    } catch (e) {
      print('Error saving achievement progress: $e');
    }
  }

  void _loadQuestions() {
    // Load questions based on the hero name
    if (widget.heroName == 'Jose Rizal') {
      _questions = [
        {
          'question': 'When was Jose Rizal born?',
          'options': [
            'June 19, 1861',
            'June 19, 1860',
            'December 30, 1896',
            'July 23, 1864'
          ],
          'correctIndex': 0,
        },
        {
          'question': 'What was Jose Rizal\'s profession?',
          'options': ['Lawyer', 'Soldier', 'Ophthalmologist', 'Engineer'],
          'correctIndex': 2,
        },
        {
          'question': 'Which novels did Jose Rizal write?',
          'options': [
            'El Filibusterismo and La Solidaridad',
            'Noli Me Tangere and El Filibusterismo',
            'Noli Me Tangere and La Solidaridad',
            'El Filibusterismo and Kartilya'
          ],
          'correctIndex': 1,
        },
        {
          'question': 'Where was Jose Rizal executed?',
          'options': [
            'Intramuros',
            'Dapitan',
            'Luneta Park (Bagumbayan)',
            'Calamba'
          ],
          'correctIndex': 2,
        },
        {
          'question': 'What was Jose Rizal\'s cause of death?',
          'options': [
            'Illness',
            'Execution by firing squad',
            'Poisoning',
            'Assassination'
          ],
          'correctIndex': 1,
        },
      ];
    } else {
      // Default questions if hero is not recognized
      _questions = [
        {
          'question': 'This is a sample question',
          'options': ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
          'correctIndex': 0,
        },
      ];
    }

    // Initialize user answers and answer correctness tracking
    _userAnswers = List.filled(_questions.length, -1);
    _answerCorrectness = List.filled(_questions.length, false);
    _answerSelected = false;
    _showCorrectAnswer = false;
  }
  
  // Handle answer selection
  void _selectAnswer(int optionIndex) {
    if (_quizCompleted || _answerSelected) return;
    
    setState(() {
      _userAnswers[_currentQuestionIndex] = optionIndex;
      
      // Check if answer is correct and update running score
      bool isCorrect = optionIndex == _questions[_currentQuestionIndex]['correctIndex'];
      _answerCorrectness[_currentQuestionIndex] = isCorrect;
      
      // Update current correct answers count
      _currentCorrectAnswers = _answerCorrectness.where((correct) => correct).length;
      
      // Calculate current percentage (based on questions answered so far)
      _currentPercentage = (_currentCorrectAnswers / _questions.length) * 100;
      
      // For Jose Rizal quiz, we want to show the correct answer before proceeding
      if (widget.heroName == 'Jose Rizal') {
        _answerSelected = true;
        _showCorrectAnswer = true;
        
        // Show feedback toast
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isCorrect ? 'Correct! 🎉' : 'Incorrect. The correct answer is option ${String.fromCharCode(65 + (_questions[_currentQuestionIndex]['correctIndex'] as int))}',
            ),
            backgroundColor: isCorrect ? Colors.green.shade700 : Colors.red.shade700,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        // For other quizzes, proceed as normal
        // Show feedback toast
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isCorrect ? 'Correct! 🎉' : 'Incorrect. The correct answer was option ${String.fromCharCode(65 + (_questions[_currentQuestionIndex]['correctIndex'] as int))}',
            ),
            backgroundColor: isCorrect ? Colors.green.shade700 : Colors.red.shade700,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    });
  }

  // Move to the next question or complete the quiz
  void _nextQuestion() {
    // For Jose Rizal quiz, if an answer is selected but not yet confirmed
    if (widget.heroName == 'Jose Rizal' && _answerSelected && !_quizCompleted) {
      setState(() {
        // Reset the answer selection state
        _answerSelected = false;
        _showCorrectAnswer = false;
        
        // Check if we're at the last question
        if (_currentQuestionIndex < _questions.length - 1) {
          // Move to the next question
          _currentQuestionIndex++;
        } else {
          // Complete the quiz
          _completeQuiz();
        }
      });
    } else if (!_answerSelected && !_quizCompleted) {
      // For other quizzes or if no answer is selected yet
      if (_userAnswers[_currentQuestionIndex] == -1) {
        // Show a message if no answer is selected
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an answer before proceeding'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      
      setState(() {
        // Check if we're at the last question
        if (_currentQuestionIndex < _questions.length - 1) {
          // Move to the next question
          _currentQuestionIndex++;
        } else {
          // Complete the quiz
          _completeQuiz();
        }
      });
    }
  }
  
  // Complete the quiz and calculate final score
  void _completeQuiz() {
    if (_quizCompleted) return;
    
    setState(() {
      _quizCompleted = true;
      
      // Calculate final score
      _score = _answerCorrectness.where((correct) => correct).length;
      
      // Calculate percentage (ensure it's capped at 100%)
      double normalizedScore = (_score / _questions.length) * 100;
      normalizedScore = normalizedScore > 100 ? 100 : normalizedScore;
      
      // Save achievement progress
      _saveAchievementProgress(normalizedScore.round());
    });
  }

  // Build the completion dialog
  Widget _buildCompletionDialog(double normalizedScore) {
    final bool isPerfectScore = _score == _questions.length;
    final int percentage = normalizedScore.round();
    
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Trophy icon for perfect score, otherwise medal icon
            Icon(
              isPerfectScore ? Icons.emoji_events : Icons.military_tech,
              size: 80,
              color: isPerfectScore ? Colors.amber : Colors.orange,
            ),
            const SizedBox(height: 24),
            Text(
              isPerfectScore
                  ? 'Perfect Score!'
                  : percentage >= 70
                      ? 'Great Job!'
                      : 'Quiz Completed',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isPerfectScore ? Colors.amber.shade700 : Colors.orange.shade700,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'You scored $_score out of ${_questions.length}',
              style: const TextStyle(fontSize: 20),
            ),
            if (_isNewHighScore)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber.shade700),
                ),
                child: const Text(
                  'New High Score!',
                  style: TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                'Return to Heroes',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build the option card
  Widget _buildOptionCard(int optionIndex, String optionText) {
    final bool isSelected = _userAnswers[_currentQuestionIndex] == optionIndex;
    final bool isCorrect = optionIndex == _questions[_currentQuestionIndex]['correctIndex'];
    final bool showCorrectness = _showCorrectAnswer && widget.heroName == 'Jose Rizal';
    
    // Determine the border color based on selection and correctness
    Color borderColor = Colors.transparent;
    if (isSelected) {
      borderColor = Colors.orange;
    }
    if (showCorrectness && isCorrect) {
      borderColor = Colors.green;
    }
    
    return Card(
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: borderColor,
          width: isSelected ? 2 : 0,
        ),
      ),
      child: InkWell(
        onTap: _quizCompleted || _answerSelected ? null : () => _selectAnswer(optionIndex),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Option letter circle
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? Colors.orange : Colors.grey.shade200,
                ),
                alignment: Alignment.center,
                child: Text(
                  String.fromCharCode(65 + optionIndex), // A, B, C, D
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  optionText,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              // Show check or x icon if answer is selected and we're showing correctness
              if (showCorrectness && isCorrect)
                const Icon(Icons.check_circle, color: Colors.green),
              if (showCorrectness && isSelected && !isCorrect)
                const Icon(Icons.cancel, color: Colors.red),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quizTitle),
        backgroundColor: Colors.orange.shade700,
      ),
      body: _quizCompleted
          ? _buildCompletionDialog((_score / _questions.length) * 100)
          : Container(
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Progress indicator
                      LinearProgressIndicator(
                        value: (_currentQuestionIndex + 1) / _questions.length,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Question card
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            _questions[_currentQuestionIndex]['question'] as String,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Options
                      Expanded(
                        child: ListView.separated(
                          itemCount: (_questions[_currentQuestionIndex]['options'] as List).length,
                          separatorBuilder: (context, index) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            return _buildOptionCard(
                              index,
                              (_questions[_currentQuestionIndex]['options'] as List)[index] as String,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Next button
                      ElevatedButton(
                        onPressed: _nextQuestion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          widget.heroName == 'Jose Rizal' && _answerSelected
                              ? 'Continue'
                              : _currentQuestionIndex < _questions.length - 1
                                  ? 'Next Question'
                                  : 'Submit Quiz',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
