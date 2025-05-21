/// Utility class for calculating quiz scores consistently across the app
/// Ensures that perfect scores always equal 100% regardless of quiz length

class QuizScoreCalculator {
  /// Calculates a quiz score as a percentage (0-100)
  /// 
  /// [correctAnswers] - Number of questions answered correctly
  /// [totalQuestions] - Total number of questions in the quiz
  /// 
  /// Returns an integer score between 0-100
  /// A perfect score (all questions correct) will always return exactly 100
  static int calculateScore(int correctAnswers, int totalQuestions) {
    // Handle edge cases
    if (totalQuestions <= 0) return 0;
    if (correctAnswers < 0) return 0; // Handle negative scores
    if (correctAnswers > totalQuestions) correctAnswers = totalQuestions; // Ensure raw score never exceeds total questions
    
    // Calculate raw percentage: (correct answers / total questions) * 100
    // This is the fundamental formula that should be used consistently across all quizzes
    final percentage = ((correctAnswers / totalQuestions) * 100).round();
    
    // Ensure score never exceeds 100%
    return percentage > 100 ? 100 : percentage;
  }
  
  /// Calculates the achievement score based on quiz performance
  /// This ensures that achievement scores are always proportional to the quiz items
  /// 
  /// [correctAnswers] - Number of questions answered correctly
  /// [totalQuestions] - Total number of questions in the quiz
  /// [maxAchievementScore] - Maximum possible achievement score (default: 100)
  /// 
  /// Returns an integer score for the achievement
  static int calculateAchievementScore(
    int correctAnswers, 
    int totalQuestions, 
    {int maxAchievementScore = 100}
  ) {
    // Handle edge cases
    if (totalQuestions <= 0) return 0;
    if (correctAnswers < 0) return 0;
    if (correctAnswers > totalQuestions) correctAnswers = totalQuestions; // Ensure raw score never exceeds total questions
    
    // Calculate raw percentage first: (correct answers / total questions)
    final rawPercentage = correctAnswers / totalQuestions;
    
    // Apply the raw percentage to the max achievement score
    // This ensures the achievement score is directly proportional to the quiz performance
    final achievementScore = (rawPercentage * maxAchievementScore).round();
    
    // Ensure score never exceeds the maximum
    return achievementScore > maxAchievementScore ? maxAchievementScore : achievementScore;
  }
  
  /// Determines if a quiz is completed based on score threshold
  /// 
  /// [correctAnswers] - Number of questions answered correctly
  /// [totalQuestions] - Total number of questions in the quiz
  /// [questionsAnswered] - Number of questions the user has answered so far
  /// [completionThreshold] - Percentage threshold for completion (default: 80%)
  /// 
  /// Returns true if the quiz is considered completed
  static bool isQuizCompleted({
    required int correctAnswers,
    required int totalQuestions,
    required int questionsAnswered,
    double completionThreshold = 0.8,
  }) {
    // Quiz is only completed if all questions have been answered
    if (questionsAnswered < totalQuestions) return false;
    
    // Calculate minimum number of correct answers needed
    final minimumCorrectNeeded = (totalQuestions * completionThreshold).round();
    
    // Quiz is completed if the user has answered enough questions correctly
    return correctAnswers >= minimumCorrectNeeded;
  }
  
  /// Calculates the progress percentage of a quiz (0-100)
  /// 
  /// [questionsAnswered] - Number of questions the user has answered
  /// [totalQuestions] - Total number of questions in the quiz
  /// 
  /// Returns a progress percentage between 0-100
  static int calculateProgress(int questionsAnswered, int totalQuestions) {
    if (totalQuestions <= 0) return 0;
    if (questionsAnswered <= 0) return 0;
    
    final progress = ((questionsAnswered / totalQuestions) * 100).round();
    return progress > 100 ? 100 : progress;
  }
  
  /// Calculates the total score across all quizzes in a category
  /// 
  /// [quizScores] - List of individual quiz scores
  /// 
  /// Returns the sum of all quiz scores
  static int calculateTotalScore(List<int> quizScores) {
    if (quizScores.isEmpty) return 0;
    
    // Sum all quiz scores
    return quizScores.fold(0, (sum, score) => sum + score);
  }
  
  /// Calculates the percentage completion for a specific achievement category
  /// based on the defined maximum scores for each category
  /// 
  /// [categoryId] - The ID of the category (history, traditions, heroes, presidents)
  /// [currentScore] - Current total score in the category
  /// 
  /// Returns a precise percentage between 0 and 100 as a double
  static double calculateCategoryPercentage(String categoryId, int currentScore) {
    // Maximum possible scores for each category based on requirements
    final Map<String, int> maxCategoryScores = {
      'history': 31,     // 7 points each for 3 regional quizzes + 10 for grand scholar
      'traditions': 31,   // 7 points each for 3 regional quizzes + 10 for grand master
      'heroes': 20,       // 5 points each for national heroes (15) + 5 for Luna + 15 for heroines
      'presidents': 30,   // 5 points each for early republic (20) + 5 points each for modern era (15) + 5 for contemporary
    };
    
    // Get max score for the category
    final maxScore = maxCategoryScores[categoryId] ?? 100;
    
    // For traditions category, we don't cap the raw score to show the actual achievement
    if (categoryId == 'traditions') {
      // Calculate precise percentage without capping the raw score
      return (currentScore / maxScore) * 100;
    }
    
    // For other categories, ensure current score doesn't exceed the maximum
    if (currentScore > maxScore) {
      currentScore = maxScore;
    }
    
    // Calculate percentage with strict capping at 100%
    if (maxScore <= 0) return 0.0;
    if (currentScore >= maxScore) return 100.0;
    
    // Calculate precise percentage without rounding
    final percentage = (currentScore / maxScore) * 100;
    
    // Extra safety check to ensure we never exceed 100%
    return percentage > 100.0 ? 100.0 : percentage;
  }
  
  /// Ensures a given percentage does not exceed 100%
  /// 
  /// [percentage] - The percentage to be capped
  /// 
  /// Returns the capped percentage
  static int capPercentage(int percentage) {
    return percentage > 100 ? 100 : percentage;
  }
}
