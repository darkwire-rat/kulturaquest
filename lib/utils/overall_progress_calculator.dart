import '../models/achievement_models.dart';
import 'package:flutter/material.dart';

class OverallProgressCalculator {
  // Define maximum scores for each category based on requirements
  static const Map<String, int> maxCategoryScores = {
    'history': 31,     // 7 points each for 3 regional quizzes + 10 for grand scholar
    'traditions': 31,   // 7 points each for 3 regional quizzes + 10 for grand master
    'heroes': 20,       // 5 points each for national heroes (15) + 5 for Luna + 15 for heroines
    'presidents': 30,   // 5 points each for early republic (20) + 5 points each for modern era (15) + 5 for contemporary
  };

  /// Calculates the overall progress based on total raw scores across all categories
  /// Returns a value between 0.0 and 1.0 representing the percentage of total possible points earned
  static double calculateOverallProgress(List<AchievementCluster> clusters) {
    if (clusters.isEmpty) return 0.0;
    
    // Calculate total raw score across all categories
    int totalRawScore = 0;
    int totalMaxScore = 0;
    
    // Sum up all raw scores and max possible scores
    for (final cluster in clusters) {
      // Skip the overall_progress cluster if it exists
      if (cluster.id == 'overall_progress') continue;
      
      // Add up the raw scores from all achievements in this cluster
      for (final subcategory in cluster.subcategories) {
        for (final achievement in subcategory.achievements) {
          totalRawScore += achievement.userScore;
          totalMaxScore += achievement.maxScore;
        }
      }
    }
    
    // Calculate progress as raw score divided by max possible score
    // This gives us the exact percentage (e.g., 4/30 = 0.133 or 13.3%)
    if (totalMaxScore <= 0) return 0.0;
    final progress = totalRawScore / totalMaxScore.toDouble();
    
    // Ensure it's capped at 1.0 (100%)
    return progress > 1.0 ? 1.0 : progress;
  }
  
  /// Calculates the overall progress percentage with more precision (0-100)
  static double calculateOverallProgressPercentage(List<AchievementCluster> clusters) {
    final progress = calculateOverallProgress(clusters);
    final percentage = progress * 100;
    
    // Ensure it never exceeds 100%
    return percentage > 100 ? 100.0 : percentage;
  }

  /// Calculate the progress percentage for Philippine History category
  /// For history, we use the raw score directly (not percentage-based)
  static double calculateHistoryProgress(List<AchievementCluster> clusters) {
    if (clusters.isEmpty) return 0.0;
    
    // Find the history cluster
    final historyCluster = clusters.firstWhere(
      (cluster) => cluster.id == 'history',
      orElse: () => AchievementCluster(
        id: 'history',
        title: '',
        description: '',
        color: const Color(0xFF000000),
        iconPath: '',
        subcategories: [],
      ),
    );
    
    // Calculate total raw score for history
    int totalRawScore = 0;
    int maxScore = maxCategoryScores['history'] ?? 31; // Default to 31 if not found
    
    // Sum up all raw scores in this category
    for (final subcategory in historyCluster.subcategories) {
      for (final achievement in subcategory.achievements) {
        totalRawScore += achievement.userScore;
      }
    }
    
    // Calculate progress as raw score divided by max possible score
    // This gives us the exact percentage (e.g., 4/31 = 0.129 or 12.9%)
    return totalRawScore / maxScore.toDouble();
  }

  /// Calculate the progress percentage for Filipino Traditions category
  /// For traditions, we use the raw score directly (not percentage-based)
  static double calculateTraditionsProgress(List<AchievementCluster> clusters) {
    if (clusters.isEmpty) return 0.0;
    
    // Find the traditions cluster
    final traditionsCluster = clusters.firstWhere(
      (cluster) => cluster.id == 'traditions',
      orElse: () => AchievementCluster(
        id: 'traditions',
        title: '',
        description: '',
        color: const Color(0xFF000000),
        iconPath: '',
        subcategories: [],
      ),
    );
    
    // Calculate total raw score for traditions
    int totalRawScore = 0;
    int maxScore = maxCategoryScores['traditions'] ?? 31; // Default to 31 if not found
    
    // Sum up all raw scores in this category
    for (final subcategory in traditionsCluster.subcategories) {
      for (final achievement in subcategory.achievements) {
        totalRawScore += achievement.userScore;
      }
    }
    
    // Calculate progress as raw score divided by max possible score
    // This gives us the exact percentage (e.g., 4/31 = 0.129 or 12.9%)
    return totalRawScore / maxScore.toDouble();
  }

  /// Calculate the progress percentage for Filipino Heroes category
  static double calculateHeroesProgress(List<AchievementCluster> clusters) {
    return _calculateCategoryProgress(clusters, 'heroes');
  }

  /// Calculate the progress percentage for Philippine Presidents category
  static double calculatePresidentsProgress(List<AchievementCluster> clusters) {
    return _calculateCategoryProgress(clusters, 'presidents');
  }

  /// Internal helper method to calculate progress for a specific category
  static double _calculateCategoryProgress(List<AchievementCluster> clusters, String categoryId) {
    if (clusters.isEmpty) return 0.0;
    
    // Find the specific category cluster
    final categoryCluster = clusters.firstWhere(
      (cluster) => cluster.id == categoryId,
      orElse: () => AchievementCluster(
        id: categoryId,
        title: '',
        description: '',
        color: const Color(0xFF000000),
        iconPath: '',
        subcategories: [],
      ),
    );
    
    // Calculate total raw score for this category
    int categoryRawScore = 0;
    int categoryMaxScore = maxCategoryScores[categoryId] ?? 0;
    
    // Sum up all raw scores in this category
    for (final subcategory in categoryCluster.subcategories) {
      for (final achievement in subcategory.achievements) {
        categoryRawScore += achievement.userScore;
      }
    }
    
    // Calculate progress as raw score divided by max possible score for this category
    if (categoryMaxScore <= 0) return 0.0;
    final progress = categoryRawScore / categoryMaxScore.toDouble();
    
    // For all categories except traditions, cap at 100%
    if (categoryId != 'traditions' && progress > 1.0) {
      return 1.0;
    }
    
    return progress;
  }

  /// Get the raw score for a specific category
  static int getCategoryRawScore(List<AchievementCluster> clusters, String categoryId) {
    if (clusters.isEmpty) return 0;
    
    // Find the specific category cluster
    final categoryCluster = clusters.firstWhere(
      (cluster) => cluster.id == categoryId,
      orElse: () => AchievementCluster(
        id: categoryId,
        title: '',
        description: '',
        color: const Color(0xFF000000),
        iconPath: '',
        subcategories: [],
      ),
    );
    
    // Calculate total raw score for this category
    int categoryRawScore = 0;
    
    // Sum up all raw scores in this category
    for (final subcategory in categoryCluster.subcategories) {
      for (final achievement in subcategory.achievements) {
        categoryRawScore += achievement.userScore;
      }
    }
    
    return categoryRawScore;
  }
}
