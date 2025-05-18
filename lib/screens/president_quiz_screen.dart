import 'package:flutter/material.dart';
import '../services/achievements_service.dart';

class PresidentQuizScreen extends StatefulWidget {
  final String presidentName;
  final String quizTitle;

  const PresidentQuizScreen({
    super.key,
    required this.presidentName,
    required this.quizTitle,
  });

  @override
  State<PresidentQuizScreen> createState() => _PresidentQuizScreenState();
}

class _PresidentQuizScreenState extends State<PresidentQuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _quizCompleted = false;
  List<Map<String, dynamic>> _questions = [];
  List<int> _userAnswers = [];
  
  // Achievement related data
  final AchievementsService _achievementsService = AchievementsService();
  String _achievementClusterId = 'presidents';
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
    // Set the appropriate achievement IDs based on the president name
    if (widget.presidentName == 'Emilio Aguinaldo') {
      _achievementSubcategoryId = 'early_republic';
      _achievementId = 'aguinaldo_quiz';
    } else if (widget.presidentName == 'Manuel L. Quezon') {
      _achievementSubcategoryId = 'early_republic';
      _achievementId = 'commonwealth_presidents';
    } else if (widget.presidentName == 'Ramon Magsaysay') {
      _achievementSubcategoryId = 'early_republic';
      _achievementId = 'commonwealth_presidents';
    } else if (widget.presidentName == 'Ferdinand Marcos') {
      _achievementSubcategoryId = 'modern_presidents';
      _achievementId = 'martial_law_quiz';
    } else if (widget.presidentName == 'Corazon Aquino') {
      _achievementSubcategoryId = 'modern_presidents';
      _achievementId = 'democracy_restored';
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
        await _achievementsService.updateAchievement(
          _achievementClusterId,
          _achievementSubcategoryId,
          _achievementId,
          score: newScore,
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
    // Load questions based on the president name
    if (widget.presidentName == 'Emilio Aguinaldo') {
      _questions = [
        {
          'question': 'When was Emilio Aguinaldo born?',
          'options': [
            'March 22, 1869',
            'June 12, 1869',
            'January 1, 1869',
            'December 30, 1869'
          ],
          'correctIndex': 0,
        },
        {
          'question': 'What significant event did Aguinaldo lead on June 12, 1898?',
          'options': [
            'Battle of Manila Bay',
            'Declaration of Philippine Independence',
            'Signing of the Pact of Biak-na-Bato',
            'The Malolos Convention'
          ],
          'correctIndex': 1,
        },
        {
          'question': 'In which province was Aguinaldo born?',
          'options': ['Manila', 'Bulacan', 'Cavite', 'Batangas'],
          'correctIndex': 2,
        },
        {
          'question': 'Against which two colonial powers did Aguinaldo fight?',
          'options': [
            'Spain and Great Britain',
            'Great Britain and United States',
            'Spain and United States',
            'United States and Japan'
          ],
          'correctIndex': 2,
        },
        {
          'question': 'How long did Aguinaldo live?',
          'options': [
            '75 years',
            '85 years',
            '95 years',
            'Over 100 years'
          ],
          'correctIndex': 2, // 1869-1964 = 95 years
        },
      ];
    } else if (widget.presidentName == 'Manuel L. Quezon') {
      _questions = [
        {
          'question': 'What position did Manuel Quezon hold before becoming president?',
          'options': [
            'Senate President',
            'Governor of Manila',
            'Secretary of War',
            'Chief Justice'
          ],
          'correctIndex': 0,
        },
        {
          'question': 'What national language policy did Quezon establish?',
          'options': [
            'English as the official language',
            'Spanish as the official language',
            'Filipino (based on Tagalog) as the national language',
            'Multilingual education system'
          ],
          'correctIndex': 2,
        },
        {
          'question': 'Where did Quezon die?',
          'options': [
            'Manila',
            'Corregidor',
            'Baguio',
            'New York'
          ],
          'correctIndex': 3,
        },
        {
          'question': 'What was Quezon\'s famous quote about government?',
          'options': [
            '"My loyalty to my party ends where my loyalty to my country begins"',
            '"I would rather have a government run like hell by Filipinos than a government run like heaven by Americans"',
            '"Social justice is the solution to the insurgency problem"',
            '"The Commonwealth is the pathway to independence"'
          ],
          'correctIndex': 1,
        },
        {
          'question': 'What was the name of the Commonwealth capital city created during Quezon\'s administration?',
          'options': [
            'Quezon City',
            'Baguio City',
            'Marikina',
            'Manila'
          ],
          'correctIndex': 0,
        },
      ];
    } else if (widget.presidentName == 'Ferdinand Marcos') {
      _questions = [
        {
          'question': 'When did Ferdinand Marcos declare Martial Law?',
          'options': [
            'August 21, 1971',
            'September 21, 1972',
            'February 25, 1986',
            'December 30, 1969'
          ],
          'correctIndex': 1,
        },
        {
          'question': 'How many years did Ferdinand Marcos rule the Philippines?',
          'options': ['10 years', '15 years', '20 years', '30 years'],
          'correctIndex': 2, // 1965-1986 = about 21 years
        },
        {
          'question': 'What event ended the Marcos regime?',
          'options': [
            'The assassination of Benigno Aquino Jr.',
            'The People Power Revolution',
            'A military coup',
            'The impeachment trial'
          ],
          'correctIndex': 1,
        },
        {
          'question': 'What was the name of Marcos\'s wife?',
          'options': [
            'Cory Aquino',
            'Aurora Quezon',
            'Imelda Marcos',
            'Gloria Macapagal'
          ],
          'correctIndex': 2,
        },
        {
          'question': 'Which of these was NOT built during the Marcos era?',
          'options': [
            'Cultural Center of the Philippines',
            'San Juanico Bridge',
            'Bataan Nuclear Power Plant',
            'SM Mall of Asia'
          ],
          'correctIndex': 3,
        },
      ];
    } else if (widget.presidentName == 'Corazon Aquino') {
      _questions = [
        {
          'question': 'Corazon Aquino was the widow of which Filipino leader?',
          'options': [
            'Ferdinand Marcos',
            'Ramon Magsaysay',
            'Benigno Aquino Jr.',
            'Manuel Roxas'
          ],
          'correctIndex': 2,
        },
        {
          'question': 'What was Corazon Aquino\'s profession before entering politics?',
          'options': [
            'Lawyer',
            'Teacher',
            'Housewife',
            'Journalist'
          ],
          'correctIndex': 2,
        },
        {
          'question': 'What 1987 document did Corazon Aquino\'s administration create?',
          'options': [
            'Philippine Declaration of Independence',
            'EDSA Manifesto',
            'Manila Accord',
            'Philippine Constitution'
          ],
          'correctIndex': 3,
        },
        {
          'question': 'How many coup attempts did Aquino\'s administration face?',
          'options': [
            '3',
            '5',
            '7',
            'More than 7'
          ],
          'correctIndex': 3, // There were at least 9 coup attempts
        },
        {
          'question': 'What nickname was given to Corazon Aquino?',
          'options': [
            'Iron Lady of Asia',
            'Mother of Philippine Democracy',
            'The Great Reformer',
            'The Revolutionary President'
          ],
          'correctIndex': 1,
        },
      ];
    } else if (widget.presidentName == 'Ramon Magsaysay') {
      _questions = [
        {
          'question': 'What was Ramon Magsaysay\'s profession before entering politics?',
          'options': [
            'Lawyer',
            'Mechanic',
            'Military officer',
            'Teacher'
          ],
          'correctIndex': 1,
        },
        {
          'question': 'What cabinet position did Magsaysay hold under President Quirino?',
          'options': [
            'Secretary of National Defense',
            'Secretary of Education',
            'Secretary of Agriculture',
            'Secretary of Foreign Affairs'
          ],
          'correctIndex': 0,
        },
        {
          'question': 'How did Ramon Magsaysay die?',
          'options': [
            'Assassination',
            'Heart attack',
            'Plane crash',
            'Illness'
          ],
          'correctIndex': 2,
        },
        {
          'question': 'What insurgent group did Magsaysay effectively combat during his time as Defense Secretary?',
          'options': [
            'Abu Sayyaf',
            'Hukbalahap (Huks)',
            'MILF',
            'New People\'s Army'
          ],
          'correctIndex': 1,
        },
        {
          'question': 'What was Magsaysay\'s campaign slogan?',
          'options': [
            'New Society',
            'Bias for the Poor',
            'People First',
            'Magsaysay is my Guy'
          ],
          'correctIndex': 3,
        },
      ];
    } else {
      // Default questions if president name doesn't match
      _questions = [
        {
          'question': 'Who was the first President of the Philippines?',
          'options': [
            'Emilio Aguinaldo',
            'Manuel Quezon',
            'Jose Rizal',
            'Andres Bonifacio'
          ],
          'correctIndex': 0,
        },
        {
          'question': 'Which president declared Martial Law in 1972?',
          'options': [
            'Diosdado Macapagal',
            'Ferdinand Marcos',
            'Corazon Aquino',
            'Manuel Roxas'
          ],
          'correctIndex': 1,
        },
      ];
    }

    // Initialize user answers array with -1 (no answer selected)
    _userAnswers = List.filled(_questions.length, -1);
  }

  void _selectAnswer(int optionIndex) {
    setState(() {
      _userAnswers[_currentQuestionIndex] = optionIndex;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _calculateScore();
    }
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
      _isNewHighScore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quizTitle),
      ),
      body: _quizCompleted ? _buildResultScreen() : _buildQuizScreen(),
    );
  }

  Widget _buildQuizScreen() {
    final currentQuestion = _questions[_currentQuestionIndex];
    final selectedAnswer = _userAnswers[_currentQuestionIndex];
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Text(
                  'Question ${_currentQuestionIndex + 1}/${_questions.length}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: (_currentQuestionIndex + 1) / _questions.length,
                      minHeight: 10,
                      backgroundColor: Colors.orange.shade100,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange.shade700),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Question text
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                currentQuestion['question'],
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Answer options
          Expanded(
            child: ListView.builder(
              itemCount: currentQuestion['options'].length,
              itemBuilder: (context, index) {
                return _buildOptionCard(index, currentQuestion['options'][index]);
              },
            ),
          ),
          
          // Next button
          ElevatedButton(
            onPressed: selectedAnswer != -1 ? _nextQuestion : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              disabledBackgroundColor: Colors.grey.shade300,
            ),
            child: Text(
              _currentQuestionIndex < _questions.length - 1 ? 'Next Question' : 'Finish Quiz',
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
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? Colors.orange : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () => _selectAnswer(optionIndex),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Option letter circle
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? Colors.orange : Colors.grey.shade200,
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + optionIndex), // A, B, C, D...
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Option text
              Expanded(
                child: Text(
                  optionText,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              
              // Checkmark if selected
              if (isSelected)
                const Icon(Icons.check_circle, color: Colors.orange, size: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    final double percentage = (_score / _questions.length) * 100;
    final bool isPerfectScore = _score == _questions.length;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Trophy icon
            Icon(
              isPerfectScore ? Icons.emoji_events : Icons.school,
              size: 80,
              color: isPerfectScore ? Colors.amber.shade700 : Colors.orange.shade700,
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
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
            
            // Back to president profile button
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to President Profile'),
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
