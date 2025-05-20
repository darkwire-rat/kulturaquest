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
          _previousHighScore = newScore;
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
    } else if (widget.heroName == 'Andres Bonifacio') {
      _questions = [
        {
          'question': 'When was Andres Bonifacio born?',
          'options': [
            'November 30, 1863',
            'November 30, 1864',
            'May 10, 1897',
            'December 15, 1875'
          ],
          'correctIndex': 0,
        },
        {
          'question': 'What revolutionary organization did Bonifacio found?',
          'options': [
            'La Liga Filipina',
            'Katipunan',
            'La Solidaridad',
            'Magdalo'
          ],
          'correctIndex': 1,
        },
        {
          'question': 'What title did Andres Bonifacio hold in the Katipunan?',
          'options': ['Presidente', 'Heneral', 'Supremo', 'Generalissimo'],
          'correctIndex': 2,
        },
        {
          'question': 'Where did the "Cry of Pugad Lawin" event led by Bonifacio take place?',
          'options': ['Manila', 'Caloocan', 'Cavite', 'Quezon City'],
          'correctIndex': 3,
        },
        {
          'question': 'What was Andres Bonifacio\'s cause of death?',
          'options': [
            'Execution after trial by revolutionary court',
            'Died in battle',
            'Assassination',
            'Natural causes'
          ],
          'correctIndex': 0,
        },
      ];
    } else if (widget.heroName == 'Antonio Luna') {
      _questions = [
        {
          'question': 'When was Antonio Luna born?',
          'options': [
            'October 29, 1866',
            'October 29, 1867',
            'June 5, 1899',
            'June 12, 1898'
          ],
          'correctIndex': 0,
        },
        {
          'question': 'What was Antonio Luna\'s primary profession before becoming a general?',
          'options': ['Lawyer', 'Scientist/Pharmacist', 'Engineer', 'Doctor'],
          'correctIndex': 1,
        },
        {
          'question': 'What newspaper did Antonio Luna establish?',
          'options': [
            'La Solidaridad',
            'La Independencia',
            'El Renacimiento',
            'Diariong Tagalog'
          ],
          'correctIndex': 1,
        },
        {
          'question': 'In which war did Antonio Luna serve as a general?',
          'options': [
            'Spanish-American War',
            'Philippine-American War',
            'Philippine Revolution against Spain',
            'World War I'
          ],
          'correctIndex': 1,
        },
        {
          'question': 'What was Antonio Luna\'s cause of death?',
          'options': [
            'Assassination',
            'Died in battle',
            'Execution',
            'Illness'
          ],
          'correctIndex': 0,
        },
      ];
    } else if (widget.heroName == 'Apolinario Mabini') {
      _questions = [
        {
          'question': 'When was Apolinario Mabini born?',
          'options': [
            'July 23, 1864',
            'July 23, 1865',
            'May 13, 1903',
            'August 23, 1864'
          ],
          'correctIndex': 0,
        },
        {
          'question': 'What physical condition affected Mabini, earning him the nickname "The Sublime Paralytic"?',
          'options': [
            'Blindness',
            'Deafness',
            'Paralysis of the legs',
            'Loss of arms'
          ],
          'correctIndex': 2,
        },
        {
          'question': 'What position did Mabini hold in Aguinaldo\'s government?',
          'options': [
            'Secretary of War',
            'Prime Minister/Chief Adviser',
            'Secretary of Education',
            'Vice President'
          ],
          'correctIndex': 1,
        },
        {
          'question': 'Which important document did Mabini draft?',
          'options': [
            'The True Decalogue',
            'Kartilya ng Katipunan',
            'Mi Último Adiós',
            'Noli Me Tangere'
          ],
          'correctIndex': 0,
        },
        {
          'question': 'What was Apolinario Mabini\'s cause of death?',
          'options': [
            'Tuberculosis',
            'Cholera',
            'Execution',
            'Assassination'
          ],
          'correctIndex': 1,
        },
      ];
    } else if (widget.heroName == 'Emilio Jacinto') {
      _questions = [
        {
          'question': 'When was Emilio Jacinto born?',
          'options': [
            'December 15, 1875',
            'December 15, 1876',
            'April 16, 1899',
            'January 15, 1875'
          ],
          'correctIndex': 0,
        },
        {
          'question': 'What was Emilio Jacinto\'s nickname?',
          'options': [
            'The Hero of Tarlac',
            'The Great Plebeian',
            'The Brains of the Katipunan',
            'The Sublime Paralytic'
          ],
          'correctIndex': 2,
        },
        {
          'question': 'What important document did Emilio Jacinto write for the Katipunan?',
          'options': [
            'The True Decalogue',
            'Kartilya ng Katipunan',
            'Noli Me Tangere',
            'La Independencia'
          ],
          'correctIndex': 1,
        },
        {
          'question': 'At what age did Emilio Jacinto die?',
          'options': ['35', '30', '28', '23'],
          'correctIndex': 3,
        },
        {
          'question': 'What was Emilio Jacinto\'s cause of death?',
          'options': [
            'Assassination',
            'Execution',
            'Malaria',
            'Died in battle'
          ],
          'correctIndex': 2,
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
  }

  void _selectAnswer(int optionIndex) {
    if (_quizCompleted) return;

    setState(() {
      _userAnswers[_currentQuestionIndex] = optionIndex;
      
      // Check if answer is correct and update running score
      bool isCorrect = optionIndex == _questions[_currentQuestionIndex]['correctIndex'];
      _answerCorrectness[_currentQuestionIndex] = isCorrect;
      
      // Update current correct answers count
      _currentCorrectAnswers = _answerCorrectness.where((correct) => correct).length;
      
      // Calculate current percentage (based on questions answered so far)
      _currentPercentage = (_currentCorrectAnswers / _questions.length) * 100;
      
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
    });
  }

  void _nextQuestion() {
    if (_userAnswers[_currentQuestionIndex] == -1) {
      // User hasn't selected an answer
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an answer before proceeding')),
      );
      return;
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _calculateScore();
      setState(() {
        _quizCompleted = true;
      });
    }
    
    // Update the running score in real-time
    _updateRunningScore();
  }
  
  void _updateRunningScore() {
    // Calculate current score based on questions answered so far
    int answeredCount = _userAnswers.where((answer) => answer != -1).length;
    int correctCount = 0;
    
    for (int i = 0; i < answeredCount; i++) {
      if (_userAnswers[i] == _questions[i]['correctIndex']) {
        correctCount++;
      }
    }
    
    setState(() {
      _currentCorrectAnswers = correctCount;
      _currentPercentage = (correctCount / _questions.length) * 100;
    });
  }

  void _calculateScore() async {
    int correctAnswers = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_userAnswers[i] == _questions[i]['correctIndex']) {
        correctAnswers++;
      }
    }
    
    final int totalQuestions = _questions.length;
    final int newScore = (correctAnswers * 100) ~/ totalQuestions; // Calculate percentage score
    
    setState(() {
      _score = correctAnswers;
      _quizCompleted = true;
    });
    
    // Save achievement progress
    await _saveAchievementProgress(newScore);
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _quizCompleted = false;
      _userAnswers = List.filled(_questions.length, -1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quizTitle),
        elevation: 0,
      ),
      body: _quizCompleted ? _buildResultScreen() : _buildQuizScreen(),
    );
  }

  Widget _buildQuizScreen() {
    final currentQuestion = _questions[_currentQuestionIndex];
    final selectedAnswer = _userAnswers[_currentQuestionIndex];
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.orange.shade50, Colors.white],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Score and question counter row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Current score
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.emoji_events, size: 16, color: Colors.amber.shade800),
                    const SizedBox(width: 4),
                    Text(
                      'Score: ${_currentCorrectAnswers}/${_questions.length} (${_currentPercentage.toStringAsFixed(0)}%)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.amber.shade900,
                      ),
                    ),
                  ],
                ),
              ),
            
              // Question counter
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Question ${_currentQuestionIndex + 1}/${_questions.length}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.red.shade900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Progress indicator
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / _questions.length,
            backgroundColor: Colors.blue.shade100,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
            minHeight: 10,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 8),
          Text(
            'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[700]),
          ),
          const SizedBox(height: 24),
          
          // Question
          Text(
            currentQuestion['question'],
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          // Options
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  currentQuestion['options'].length,
                  (index) => _buildOptionCard(index, currentQuestion['options'][index]),
                ),
              ),
            ),
          ),
          
          // Next button
          ElevatedButton(
            onPressed: _nextQuestion,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              _currentQuestionIndex < _questions.length - 1 ? 'Next Question' : 'Submit Quiz',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(int optionIndex, String optionText) {
    final isSelected = _userAnswers[_currentQuestionIndex] == optionIndex;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: isSelected ? Colors.orange.shade50 : Colors.white,
      child: InkWell(
        onTap: () => _selectAnswer(optionIndex),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? Colors.orange : Colors.grey.shade200,
                  border: Border.all(
                    color: isSelected ? Colors.orange.shade700 : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + optionIndex), // A, B, C, D
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  optionText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    final double percentage = (_score / _questions.length) * 100;
    final bool isPerfectScore = _score == _questions.length;
    final int calculatedScore = (percentage).round();
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Trophy icon for perfect score, otherwise medal icon
            Icon(
              isPerfectScore ? Icons.emoji_events : Icons.military_tech,
              size: 80,
              color: isPerfectScore ? Colors.amber : Colors.blue,
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
                color: isPerfectScore ? Colors.amber.shade700 : Colors.blue.shade700,
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.amber.shade700, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      'New High Score!',
                      style: TextStyle(color: Colors.amber.shade900, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            Text(
              '${percentage.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: isPerfectScore
                    ? Colors.amber.shade700
                    : percentage >= 70
                        ? Colors.green
                        : percentage >= 50
                            ? Colors.orange
                            : Colors.red,
              ),
            ),
            const SizedBox(height: 32),
            
            // Results breakdown
            _buildResultBreakdown(),
            
            const SizedBox(height: 32),
            
            // Restart button
            ElevatedButton.icon(
              onPressed: _restartQuiz,
              icon: const Icon(Icons.refresh),
              label: const Text('Restart Quiz'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
            
            // Back to hero profile button
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Hero Profile'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultBreakdown() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Question Results:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...List.generate(
              _questions.length,
              (index) {
                final question = _questions[index];
                final userAnswer = _userAnswers[index];
                final correctIndex = question['correctIndex'];
                final isCorrect = userAnswer == correctIndex;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        isCorrect ? Icons.check_circle : Icons.cancel,
                        color: isCorrect ? Colors.green : Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Q${index + 1}: ${question['question']}',
                          style: const TextStyle(fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
