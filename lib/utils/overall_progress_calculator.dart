import '../models/achievement_models.dart';

class OverallProgressCalculator {
  /// Calculates the overall progress based on completion of all 4 main categories
  /// Returns a value between 0.0 and 1.0 (where 1.0 means all 4 categories are completed)
  static double calculateOverallProgress(List<AchievementCluster> clusters) {
    if (clusters.isEmpty) return 0.0;
    
    // We have 4 main categories: history, traditions, heroes, and presidents
    const int totalCategories = 4;
    
    // Count how many categories have at least 80% completion
    int completedCategories = 0;
    
    for (final cluster in clusters) {
      // A category is considered complete if it has at least 80% completion
      if (cluster.completionPercentage >= 0.8) {
        completedCategories++;
      }
    }
    
    // Calculate progress as a percentage of completed categories
    final progress = completedCategories / totalCategories;
    
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
}
