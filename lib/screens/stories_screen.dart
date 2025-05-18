import 'package:flutter/material.dart';
import 'story_content.dart';

class StoriesScreen extends StatelessWidget {
  const StoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Image.asset(
          'assets/images/KBackground.png',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
        // Content overlay
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Historical Stories',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            backgroundColor: Colors.brown.withOpacity(0.7),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: stories.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  color: Colors.brown.shade200.withOpacity(0.9),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      stories[index].title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                    subtitle: const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Tap to read this historical story',
                        style: TextStyle(color: Colors.brown),
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.brown),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoryDetailScreen(story: stories[index]),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class StoryDetailScreen extends StatefulWidget {
  final Story story;
  
  const StoryDetailScreen({super.key, required this.story});
  
  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  bool _showQuiz = false;
  int _score = 0;
  List<int?> _selectedAnswers = [];
  bool _quizCompleted = false;
  
  @override
  void initState() {
    super.initState();
    _selectedAnswers = List.filled(widget.story.quiz.length, null);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.story.title),
        backgroundColor: Colors.brown,
      ),
      body: _showQuiz ? _buildQuiz() : _buildStoryContent(),
    );
  }
  
  Widget _buildStoryContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Use the user's preferred image
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              'assets/images/philpic.jpeg',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // If image fails to load, show a colored container instead
                return Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.brown.shade200,
                  child: const Center(
                    child: Icon(Icons.history, size: 64, color: Colors.brown),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.story.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.story.content,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _showQuiz = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            ),
            child: const Text('Take Quiz'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuiz() {
    if (_quizCompleted) {
      return _buildQuizResults();
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quiz Time!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Test your knowledge about ${widget.story.title}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.brown.shade700,
            ),
          ),
          const SizedBox(height: 24),
          ...List.generate(widget.story.quiz.length, (index) {
            return _buildQuestionCard(index);
          }),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Check if all questions are answered
              if (!_selectedAnswers.contains(null)) {
                _calculateScore();
                setState(() {
                  _quizCompleted = true;
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please answer all questions')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            ),
            child: const Text('Submit Answers'),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              setState(() {
                _showQuiz = false;
              });
            },
            child: const Text('Back to Story', style: TextStyle(color: Colors.brown)),
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuestionCard(int questionIndex) {
    final question = widget.story.quiz[questionIndex];
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${questionIndex + 1}: ${question.question}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...List.generate(question.options.length, (optionIndex) {
              return RadioListTile<int>(
                title: Text(question.options[optionIndex]),
                value: optionIndex,
                groupValue: _selectedAnswers[questionIndex],
                onChanged: (value) {
                  setState(() {
                    _selectedAnswers[questionIndex] = value;
                  });
                },
                activeColor: Colors.brown,
              );
            }),
          ],
        ),
      ),
    );
  }
  
  void _calculateScore() {
    _score = 0;
    for (int i = 0; i < widget.story.quiz.length; i++) {
      if (_selectedAnswers[i] == widget.story.quiz[i].correctIndex) {
        _score++;
      }
    }
  }
  
  Widget _buildQuizResults() {
    final percentage = (_score / widget.story.quiz.length) * 100;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.emoji_events,
              size: 80,
              color: Colors.amber,
            ),
            const SizedBox(height: 24),
            Text(
              'Quiz Completed!',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'You scored $_score out of ${widget.story.quiz.length}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
              '${percentage.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: percentage >= 70 ? Colors.green : Colors.orange,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              percentage >= 70
                  ? 'Great job! You know your Philippine history!'
                  : 'Keep learning about Philippine history!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showQuiz = false;
                  _quizCompleted = false;
                  _selectedAnswers = List.filled(widget.story.quiz.length, null);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
              child: const Text('Return to Story'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back to Stories List', style: TextStyle(color: Colors.brown)),
            ),
          ],
        ),
      ),
    );
  }
}
