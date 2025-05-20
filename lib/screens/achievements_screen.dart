import 'package:flutter/material.dart';
import '../models/achievement_models.dart';
import '../services/achievements_service.dart';
import '../utils/quiz_score_calculator.dart';
import 'president_quiz_screen.dart';
import 'hero_quiz_screen.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> with SingleTickerProviderStateMixin {
  final AchievementsService _achievementsService = AchievementsService();
  List<AchievementCluster> _clusters = [];
  bool _isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final clusters = await _achievementsService.getAchievementClusters();
      setState(() {
        _clusters = clusters;
        _tabController = TabController(length: clusters.length, vsync: this);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load achievements: $e')),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Achievements')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_clusters.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Achievements')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events_outlined, size: 80, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'No achievements available',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _loadAchievements,
                child: const Text('Refresh'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _clusters.map((cluster) => _buildTabItem(cluster)).toList(),
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black54,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _clusters.map((cluster) => _buildClusterView(cluster)).toList(),
      ),
    );
  }

  Widget _buildTabItem(AchievementCluster cluster) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: cluster.color,
            child: Text(
              cluster.title[0].toUpperCase(),
              style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Text(cluster.title),
        ],
      ),
    );
  }

  Widget _buildClusterView(AchievementCluster cluster) {
    return Container(
      // Darker background with less opacity for better text contrast
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Cluster Header
          _buildClusterHeader(cluster),
          const SizedBox(height: 20),
          
          // Subcategories
          ...cluster.subcategories.map((subcategory) => _buildSubcategory(cluster, subcategory)).toList(),
        ],
      ),
    );
  }

  Widget _buildClusterHeader(AchievementCluster cluster) {
    // Cap the completion percentage at 1.0 (100%)
    final completionPercentage = cluster.completionPercentage > 1.0 ? 1.0 : cluster.completionPercentage;
    final percentComplete = ((completionPercentage * 100).round() > 100) ? 100 : (completionPercentage * 100).round(); // Ensure percentage never exceeds 100%
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              cluster.color.withOpacity(0.9),  // Darker background
              cluster.color,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.emoji_events, color: cluster.color, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cluster.title,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cluster.description,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Overall progress
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Overall Progress', style: TextStyle(fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(
                        '$percentComplete%',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  // Total score
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Total Score', style: TextStyle(fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(
                        '${cluster.totalScore}/${_getMaxCategoryScore(cluster.id)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  // Ensure progress bar value never exceeds 1.0 (100%)
                  value: completionPercentage.clamp(0.0, 1.0),
                  minHeight: 10,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(cluster.color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubcategory(AchievementCluster cluster, AchievementSubcategory subcategory) {
    final completionPercentage = subcategory.completionPercentage;
    final percentComplete = (completionPercentage * 100).round();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subcategory Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: cluster.color.withOpacity(0.5),  // Darker background for better contrast
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: cluster.color,
                  child: Text(
                    subcategory.title[0],
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subcategory.title,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: cluster.color),
                      ),
                      Text(
                        subcategory.description,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                // Subcategory progress percentage
                CircleAvatar(
                  radius: 20,
                  backgroundColor: cluster.color.withOpacity(0.2),
                  child: Text(
                    '$percentComplete%',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: cluster.color),
                  ),
                ),
              ],
            ),
          ),
          // Achievement Items Container
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],  // Very light grey background
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),  // Slightly darker shadow
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Achievement items
                ...subcategory.achievements.map((achievement) => _buildAchievementItem(cluster, subcategory, achievement)).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(AchievementCluster cluster, AchievementSubcategory subcategory, Achievement achievement) {
    // Calculate progress percentage
    final progressPercentage = achievement.userScore / achievement.maxScore;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,  // Ensure white background for achievement items
        border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1.0)),  // Darker border
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Show achievement details
          _showAchievementDetails(cluster, subcategory, achievement);
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Completion indicator
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: achievement.isCompleted ? cluster.color : Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    achievement.isCompleted ? Icons.check : Icons.hourglass_empty,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Achievement Title and Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      achievement.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: achievement.isCompleted ? cluster.color.withOpacity(0.8) : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      achievement.description,
                      style: const TextStyle(fontSize: 12, color: Colors.black87),  // Darker text color
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Score display
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${achievement.userScore}/${achievement.maxScore}', // Show score as fraction
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: achievement.isCompleted ? cluster.color : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Builder(
                    builder: (context) {
                      final percentage = achievement.userScore >= achievement.maxScore ? 100 : ((achievement.userScore / achievement.maxScore) * 100).round();
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Only show star if percentage is at least 80%
                          if (percentage >= 80)
                            Icon(
                              Icons.star,
                              size: 14,
                              color: Colors.amber,
                            ),
                          if (percentage >= 80)
                            const SizedBox(width: 2),
                          Text(
                            '$percentage%',
                            style: TextStyle(
                              fontSize: 12,
                              color: percentage >= 80 ? Colors.amber : Colors.grey[500],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAchievementDetails(AchievementCluster cluster, AchievementSubcategory subcategory, Achievement achievement) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _AchievementDetailsSheet(
        cluster: cluster,
        subcategory: subcategory,
        achievement: achievement,
      ),
    );
  }
  
  // Helper method to get the maximum score for each category based on requirements
  int _getMaxCategoryScore(String categoryId) {
    // Maximum possible scores for each category based on requirements
    final Map<String, int> maxCategoryScores = {
      'history': 31,     // 7 points each for 3 regional quizzes + 10 for grand scholar
      'traditions': 31,   // 7 points each for 3 regional quizzes + 10 for grand master
      'heroes': 20,       // 5 points each for 4 national heroes quizzes
      'presidents': 20,   // 5 points each for 4 early republic quizzes
    };
    
    return maxCategoryScores[categoryId] ?? 100;
  }
}

// Method to navigate to the appropriate challenge based on achievement ID
void _navigateToChallenge(BuildContext context, String clusterId, String subcategoryId, String achievementId) {
  // Heroes Cluster
  if (clusterId == 'heroes') {
    if (subcategoryId == 'national_heroes') {
      // Map achievementId to heroName and quizTitle
      final heroMap = {
        'rizal_quiz': {'name': 'Jose Rizal', 'quizTitle': 'Jose Rizal Quiz'},
        'bonifacio_quiz': {'name': 'Andres Bonifacio', 'quizTitle': 'Andres Bonifacio Quiz'},
        'luna_quiz': {'name': 'Antonio Luna', 'quizTitle': 'Antonio Luna Quiz'},
        'mabini_quiz': {'name': 'Apolinario Mabini', 'quizTitle': 'Apolinario Mabini Quiz'},
        'jacinto_quiz': {'name': 'Emilio Jacinto', 'quizTitle': 'Emilio Jacinto Quiz'},
      };
      
      // Directly navigate to the hero's quiz
      if (heroMap.containsKey(achievementId)) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HeroQuizScreen(
              heroName: heroMap[achievementId]!['name']!,
              quizTitle: heroMap[achievementId]!['quizTitle']!,
            ),
          ),
        );
      } else {
        _showComingSoonMessage(context);
      }
    } else {
      // For other hero subcategories
      _showComingSoonMessage(context);
    }
  }
  // Presidents Cluster
  else if (clusterId == 'presidents') {
    // Map achievementId to presidentName and quizTitle
    final presidentMap = {
      'aguinaldo_quiz': {'name': 'Emilio Aguinaldo', 'quizTitle': 'Emilio Aguinaldo Quiz'},
      'quezon_quiz': {'name': 'Manuel L. Quezon', 'quizTitle': 'Manuel L. Quezon Quiz'},
      'magsaysay_quiz': {'name': 'Ramon Magsaysay', 'quizTitle': 'Ramon Magsaysay Quiz'},
      'marcos_quiz': {'name': 'Ferdinand Marcos', 'quizTitle': 'Ferdinand Marcos Quiz'},
      'aquino_quiz': {'name': 'Corazon Aquino', 'quizTitle': 'Corazon Aquino Quiz'},
      'modern_presidents_quiz': {'name': 'Modern Presidents', 'quizTitle': 'Modern Presidents Scholar'},
    };
    
    // Directly navigate to the president's quiz
    if (presidentMap.containsKey(achievementId)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PresidentQuizScreen(
            presidentName: presidentMap[achievementId]!['name']!,
            quizTitle: presidentMap[achievementId]!['quizTitle']!,
          ),
        ),
      );
    } else {
      _showComingSoonMessage(context);
    }
  }
  // History Cluster
  else if (clusterId == 'history') {
    _showComingSoonMessage(context);
  }
  // Traditions Cluster
  else if (clusterId == 'traditions') {
    _showComingSoonMessage(context);
  }
  // Default case
  else {
    _showComingSoonMessage(context);
  }
}

void _showComingSoonMessage(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('This challenge is coming soon!')),
  );
}

class _AchievementDetailsSheet extends StatelessWidget {
  final AchievementCluster cluster;
  final AchievementSubcategory subcategory;
  final Achievement achievement;

  const _AchievementDetailsSheet({
    required this.cluster,
    required this.subcategory,
    required this.achievement,
  });
  
  // Helper method to get the maximum score for each category based on requirements
  int _getMaxCategoryScore(String categoryId) {
    // Maximum possible scores for each category based on requirements
    final Map<String, int> maxCategoryScores = {
      'history': 31,     // 7 points each for 3 regional quizzes + 10 for grand scholar
      'traditions': 31,   // 7 points each for 3 regional quizzes + 10 for grand master
      'heroes': 20,       // 5 points each for 4 national heroes quizzes
      'presidents': 20,   // 5 points each for 4 early republic quizzes
    };
    
    return maxCategoryScores[categoryId] ?? 100;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: achievement.isCompleted ? cluster.color : Colors.grey[300],
                child: Icon(
                  achievement.isCompleted ? Icons.emoji_events : Icons.hourglass_empty,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      achievement.title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      subcategory.title,
                      style: TextStyle(fontSize: 16, color: cluster.color),
                    ),
                  ],
                ),
              ),
              // Close button
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Description
          const Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(achievement.description, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 24),
          
          // Progress
          const Text('Progress', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            // If user has achieved the max score, show full progress bar (capped at 1.0)
            value: achievement.userScore >= achievement.maxScore ? 1.0 : (achievement.userScore / achievement.maxScore).clamp(0.0, 1.0),
            minHeight: 12,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(cluster.color),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Builder(
                builder: (context) {
                  final percentage = (achievement.userScore >= achievement.maxScore) ? 100 : ((achievement.userScore / achievement.maxScore) * 100).round();
                  return Row(
                    children: [
                      // Only show star if percentage is at least 80%
                      if (percentage >= 80)
                        Icon(Icons.star, size: 14, color: Colors.amber),
                      if (percentage >= 80)
                        const SizedBox(width: 4),
                      Text(
                        '$percentage% Complete',
                        style: TextStyle(
                          fontSize: 14,
                          color: percentage >= 80 ? Colors.amber : Colors.grey[700],
                        ),
                      ),
                    ],
                  );
                },
              ),
              Text(
                '${achievement.userScore}/${achievement.maxScore} Points', // Show score as fraction
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Action button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: Icon(achievement.isCompleted ? Icons.check_circle : Icons.play_arrow),
              label: Text(achievement.isCompleted ? 'Completed' : 'Start Challenge'),
              style: ElevatedButton.styleFrom(
                backgroundColor: achievement.isCompleted ? Colors.green : cluster.color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: achievement.isCompleted
                  ? null
                  : () {
                      Navigator.of(context).pop();
                      
                      // Direct user to appropriate challenge based on achievement ID
                      _navigateToChallenge(context, cluster.id, subcategory.id, achievement.id);
                    },
            ),
          ),
        ],
      ),
    );
  }
}
