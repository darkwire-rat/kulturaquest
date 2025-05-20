import 'package:flutter/material.dart';
import '../utils/quiz_score_calculator.dart';

/// Achievement models to handle the clustered achievement system

// Represents a single achievement
class Achievement {
  final String id;
  final String title;
  final String description;
  final int maxScore;
  final int userScore; // User's actual score
  final bool isCompleted;
  final String iconPath; // Path to the icon asset

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.maxScore,
    this.userScore = 0,
    this.isCompleted = false,
    this.iconPath = 'assets/images/achievement_default.png',
  });

  // Create a copy of the achievement with updated values
  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    int? maxScore,
    int? userScore,
    bool? isCompleted,
    String? iconPath,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      maxScore: maxScore ?? this.maxScore,
      userScore: userScore ?? this.userScore,
      isCompleted: isCompleted ?? this.isCompleted,
      iconPath: iconPath ?? this.iconPath,
    );
  }
}

// Represents a subcategory containing multiple achievements
class AchievementSubcategory {
  final String id;
  final String title;
  final String description;
  final List<Achievement> achievements;
  final String iconPath;

  const AchievementSubcategory({
    required this.id,
    required this.title,
    required this.description,
    required this.achievements,
    this.iconPath = 'assets/images/subcategory_default.png',
  });

  // Calculate completion percentage (capped at 1.0 or 100%)
  double get completionPercentage {
    if (achievements.isEmpty) return 0.0;
    
    // Calculate based on user scores relative to max scores instead of just completed count
    final totalUserScore = totalScore;
    final maxPossible = maxPossibleScore;
    
    if (maxPossible <= 0) return 0.0;
    if (totalUserScore >= maxPossible) return 1.0; // Cap at 100%
    
    return totalUserScore / maxPossible; // Will be between 0.0 and 1.0
  }

  // Calculate total score
  int get totalScore {
    return achievements.fold(0, (sum, achievement) => sum + achievement.userScore);
  }

  // Calculate maximum possible score
  int get maxPossibleScore {
    return achievements.fold(0, (sum, achievement) => sum + achievement.maxScore);
  }
}

// Represents a main cluster containing multiple subcategories
class AchievementCluster {
  final String id;
  final String title;
  final String description;
  final List<AchievementSubcategory> subcategories;
  final String iconPath;
  final Color color; // Theme color for the cluster

  const AchievementCluster({
    required this.id,
    required this.title,
    required this.description,
    required this.subcategories,
    required this.color,
    this.iconPath = 'assets/images/cluster_default.png',
  });

  // Calculate overall completion percentage (capped at 1.0 or 100%)
  double get completionPercentage {
    // First check direct score comparison to enforce hard cap
    final userScore = totalScore;
    final maxScore = maxPossibleScore;
    
    if (maxScore <= 0) return 0.0;
    if (userScore >= maxScore) return 1.0; // Always cap at 100%
    
    // Use the category-specific percentage calculation
    final percentage = QuizScoreCalculator.calculateCategoryPercentage(id, totalScore);
    final calculatedPercentage = percentage / 100.0;
    return calculatedPercentage > 1.0 ? 1.0 : calculatedPercentage; // Convert to a value between 0 and 1, and ensure it never exceeds 1.0
  }

  // Calculate total score across all subcategories
  int get totalScore {
    return subcategories.fold(0, (sum, subcat) => sum + subcat.totalScore);
  }

  // Calculate maximum possible score
  int get maxPossibleScore {
    return subcategories.fold(
        0, (sum, subcat) => sum + subcat.maxPossibleScore);
  }
}
