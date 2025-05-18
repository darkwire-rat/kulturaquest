import 'package:flutter/material.dart';
import '../models/achievement_models.dart';
import '../services/achievements_service.dart';

class AchievementsTab extends StatefulWidget {
  const AchievementsTab({super.key});

  @override
  State<AchievementsTab> createState() => _AchievementsTabState();
}

class _AchievementsTabState extends State<AchievementsTab> with SingleTickerProviderStateMixin {
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
          indicatorWeight: 3.0, // Thicker indicator for better visibility
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          unselectedLabelStyle: const TextStyle(fontSize: 13),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          labelPadding: const EdgeInsets.symmetric(horizontal: 12),
          indicatorSize: TabBarIndicatorSize.label,
        ),
        elevation: 4, // Add shadow for better separation
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _clusters.map((cluster) => _buildClusterView(cluster)).toList(),
            ),
          ),
          // Bottom buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Stories button
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/stories');
                  },
                  icon: const Icon(Icons.menu_book),
                  label: const Text('Kultura Quest Stories'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                // Certificate button
                _buildCertificateButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(AchievementCluster cluster) {
    return Tab(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cluster.color.withOpacity(0.3), width: 1),
        ),
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
            Text(
              cluster.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClusterView(AchievementCluster cluster) {
    return Container(
      color: cluster.color.withOpacity(0.1),
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
    final completionPercent = (cluster.completionPercentage * 100).round();
    final totalScore = cluster.totalScore;
    final maxScore = cluster.maxPossibleScore;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: cluster.color.withOpacity(0.8),
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
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        cluster.description,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
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
                    const Text('Overall Progress', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(
                      '$completionPercent%',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                // Total score
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Total Score', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(
                      '$totalScore / $maxScore',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
                value: cluster.completionPercentage,
                minHeight: 10,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubcategory(AchievementCluster cluster, AchievementSubcategory subcategory) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Subcategory header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: cluster.color,
                radius: 16,
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: cluster.color,
                      ),
                    ),
                    Text(
                      subcategory.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // Subcategory progress percentage
              CircleAvatar(
                radius: 20,
                backgroundColor: cluster.color.withOpacity(0.2),
                child: Text(
                  '${(subcategory.completionPercentage * 100).round()}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: cluster.color,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Achievement items
        ...subcategory.achievements.map((achievement) => _buildAchievementItem(cluster, subcategory, achievement)).toList(),
        
        const SizedBox(height: 20),
        const Divider(),
      ],
    );
  }

  Widget _buildAchievementItem(AchievementCluster cluster, AchievementSubcategory subcategory, Achievement achievement) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
              
              // Achievement details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      achievement.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: achievement.isCompleted ? cluster.color : Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      achievement.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Score display
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${achievement.userScore}/${achievement.maxScore}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: achievement.isCompleted ? cluster.color : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        size: 14,
                        color: achievement.isCompleted ? Colors.amber : Colors.grey[400],
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${(achievement.userScore / achievement.maxScore * 100).round()}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: achievement.isCompleted ? Colors.amber : Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCertificateButton() {
    // Calculate if certificate should be unlocked
    // For now using a simple check - in real app would be more complex
    final totalCompletedAchievements = _clusters.fold(
        0,
        (sum, cluster) => sum + cluster.subcategories.fold(
            0,
            (subSum, subcat) => subSum + subcat.achievements.where((a) => a.isCompleted).length));
    final totalAchievements = _clusters.fold(
        0,
        (sum, cluster) => sum + cluster.subcategories.fold(
            0,
            (subSum, subcat) => subSum + subcat.achievements.length));

    final allCleared = totalCompletedAchievements > 0 && totalCompletedAchievements >= totalAchievements / 2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: ElevatedButton.icon(
        icon: Icon(Icons.workspace_premium_rounded, size: 28, color: allCleared ? Colors.white : Colors.orange[300]),
        label: Text(
          allCleared ? 'Download Certificate' : 'Unlock Certificate',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          backgroundColor: allCleared ? Colors.orange[800] : Colors.grey[400],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 6,
        ),
        onPressed: allCleared
            ? () {
                // Certificate download logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Downloading your certificate...')),
                );
              }
            : () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('How to Unlock Certificate'),
                    content: const Text(
                      'To download your certificate, you need to complete at least 50% of all achievements. '
                      'Keep going with quizzes and challenges to unlock your personalized certificate!',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
      ),
    );
  }

  void _showAchievementDetails(AchievementCluster cluster, AchievementSubcategory subcategory, Achievement achievement) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _AchievementDetailsSheet(
        cluster: cluster,
        subcategory: subcategory,
        achievement: achievement,
      ),
    );
  }
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
            value: achievement.userScore / achievement.maxScore,
            minHeight: 12,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(cluster.color),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(achievement.userScore / achievement.maxScore * 100).round()}% Complete',
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                '${achievement.userScore}/${achievement.maxScore} Points',
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
                      // Navigate to the challenge
                      Navigator.of(context).pop();
                      
                      // Show loading indicator
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Starting challenge...')),
                      );
                      
                      // Handle navigation based on achievement type
                      _navigateToChallenge(context, cluster, subcategory, achievement);
                    },
            ),
          ),
        ],
      ),
    );
  }
  
  // Navigate to the appropriate challenge based on achievement ID
  void _navigateToChallenge(BuildContext context, AchievementCluster cluster, AchievementSubcategory subcategory, Achievement achievement) {
    // Determine which screen to navigate to based on the cluster, subcategory, and achievement IDs
    if (cluster.id == 'heroes') {
      // Handle Hero challenges
      if (achievement.id == 'rizal_quiz') {
        Navigator.of(context).pushNamed('/hero_quiz', arguments: {
          'heroName': 'Jose Rizal',
          'quizTitle': 'Jose Rizal Quiz',
        });
      } else if (achievement.id == 'bonifacio_quiz') {
        Navigator.of(context).pushNamed('/hero_quiz', arguments: {
          'heroName': 'Andres Bonifacio',
          'quizTitle': 'Andres Bonifacio Quiz',
        });
      } else if (achievement.id == 'mabini_quiz') {
        Navigator.of(context).pushNamed('/hero_quiz', arguments: {
          'heroName': 'Apolinario Mabini',
          'quizTitle': 'Apolinario Mabini Quiz',
        });
      } else {
        // Default to Heroes screen
        Navigator.of(context).pushNamed('/heroes');
      }
    } else if (cluster.id == 'presidents') {
      // Handle President challenges
      if (achievement.id == 'aguinaldo_quiz') {
        Navigator.of(context).pushNamed('/president_detail', arguments: {
          'name': 'Emilio Aguinaldo',
          'imagePath': 'assets/images/aguinaldo.jpg',
          'term': '1899-1901',
        });
      } else if (achievement.id == 'commonwealth_presidents') {
        if (subcategory.id == 'early_republic') {
          Navigator.of(context).pushNamed('/president_detail', arguments: {
            'name': 'Manuel L. Quezon',
            'imagePath': 'assets/images/quezon.jpg',
            'term': '1935-1944',
          });
        }
      } else if (achievement.id == 'martial_law_quiz') {
        Navigator.of(context).pushNamed('/president_detail', arguments: {
          'name': 'Ferdinand Marcos',
          'imagePath': 'assets/images/marcos.jpg',
          'term': '1965-1986',
        });
      } else if (achievement.id == 'democracy_restored') {
        Navigator.of(context).pushNamed('/president_detail', arguments: {
          'name': 'Corazon Aquino',
          'imagePath': 'assets/images/cory.jpg',
          'term': '1986-1992',
        });
      } else {
        // Default to Presidents list
        Navigator.of(context).pushNamed('/presidents');
      }
    } else if (cluster.id == 'traditions') {
      // Navigate to traditions page based on subcategory
      if (subcategory.id == 'festivals') {
        Navigator.of(context).pushNamed('/festivals');
      } else if (subcategory.id == 'customs') {
        Navigator.of(context).pushNamed('/customs');
      } else {
        // Default traditions screen
        Navigator.of(context).pushNamed('/traditions');
      }
    } else if (cluster.id == 'history') {
      // Navigate to history page based on achievement
      Navigator.of(context).pushNamed('/history');
    } else {
      // If no specific navigation is defined, show a message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This challenge is not available yet.')),
      );
    }
  }
}
