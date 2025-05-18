import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/achievement_models.dart';

class AchievementsService {
  // Singleton pattern
  static final AchievementsService _instance = AchievementsService._internal();
  factory AchievementsService() => _instance;
  AchievementsService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection references
  CollectionReference get _usersCollection => _firestore.collection('users');
  
  // Get current user ID
  String? get _currentUserId => _auth.currentUser?.uid;

  // Get user achievements document reference
  DocumentReference? get _userAchievementsDoc {
    final userId = _currentUserId;
    if (userId == null) return null;
    return _usersCollection.doc(userId).collection('userData').doc('achievements');
  }

  // Get all achievement clusters
  Future<List<AchievementCluster>> getAchievementClusters() async {
    // First, get the default achievement data
    final defaultClusters = _getDefaultAchievementClusters();
    
    try {
      // Try to get data from Firestore if the user is logged in
      if (_currentUserId != null) {
        final userAchievementsDoc = _userAchievementsDoc;
        if (userAchievementsDoc != null) {
          final docSnapshot = await userAchievementsDoc.get();
          
          // If user has no achievements data yet, initialize them
          if (!docSnapshot.exists) {
            await _initializeUserAchievements(defaultClusters);
          } else {
            // Parse user achievements from Firestore and merge with defaults
            return await _mergeUserAchievementsWithDefaults(docSnapshot.data() as Map<String, dynamic>, defaultClusters);
          }
        }
      }
      
      // If we can't get from Firestore or user is not logged in, try to load from local storage
      return await _loadFromLocalStorage(defaultClusters);
    } catch (e) {
      print('Error fetching achievements: $e');
      return defaultClusters;
    }
  }
  
  // Load achievement progress from local storage
  Future<List<AchievementCluster>> _loadFromLocalStorage(List<AchievementCluster> defaultClusters) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Create a deep copy of default clusters that we'll update with local data
      List<AchievementCluster> clusters = List.from(defaultClusters);
      
      // Iterate through clusters and look for saved data
      for (int i = 0; i < clusters.length; i++) {
        for (int j = 0; j < clusters[i].subcategories.length; j++) {
          for (int k = 0; k < clusters[i].subcategories[j].achievements.length; k++) {
            final achievement = clusters[i].subcategories[j].achievements[k];
            final clusterId = clusters[i].id;
            final subcatId = clusters[i].subcategories[j].id;
            
            String achievementKey = 'achievement_${clusterId}_${subcatId}_${achievement.id}';
            
            // Check if we have data for this achievement
            if (prefs.containsKey('${achievementKey}_score')) {
              int score = prefs.getInt('${achievementKey}_score') ?? 0;
              // Update achievement with a copy containing the new score
              int index = clusters[i].subcategories[j].achievements.indexOf(achievement);
              clusters[i].subcategories[j].achievements[k] = achievement.copyWith(userScore: score);
            }
            
            if (prefs.containsKey('${achievementKey}_completed')) {
              bool completed = prefs.getBool('${achievementKey}_completed') ?? false;
              // Update achievement with a copy containing the new completion status
              int index = clusters[i].subcategories[j].achievements.indexOf(achievement);
              clusters[i].subcategories[j].achievements[k] = achievement.copyWith(isCompleted: completed);
            }
          }
        }
      }
      
      return clusters;
    } catch (e) {
      print('Error loading achievements from local storage: $e');
      return defaultClusters;
    }
  }
  
  // Merge user achievements from Firestore with defaults
  Future<List<AchievementCluster>> _mergeUserAchievementsWithDefaults(
      Map<String, dynamic> userData, List<AchievementCluster> defaultClusters) async {
    try {
      List<AchievementCluster> mergedClusters = List.from(defaultClusters);
      List<dynamic> userClusters = userData['clusters'] ?? [];
      
      // For each user cluster, find the matching default cluster and update its achievements
      for (var userCluster in userClusters) {
        String clusterId = userCluster['id'];
        int clusterIndex = mergedClusters.indexWhere((c) => c.id == clusterId);
        
        if (clusterIndex != -1) {
          List<dynamic> userSubcats = userCluster['subcategories'] ?? [];
          
          // Process each subcategory
          for (var userSubcat in userSubcats) {
            String subcatId = userSubcat['id'];
            int subcatIndex = mergedClusters[clusterIndex].subcategories.indexWhere((s) => s.id == subcatId);
            
            if (subcatIndex != -1) {
              List<dynamic> userAchievements = userSubcat['achievements'] ?? [];
              
              // Process each achievement
              for (var userAchievement in userAchievements) {
                String achievementId = userAchievement['id'];
                int achievementIndex = mergedClusters[clusterIndex].subcategories[subcatIndex].achievements
                    .indexWhere((a) => a.id == achievementId);
                
                if (achievementIndex != -1) {
                  // Update the achievement data with user progress
                  Achievement achievement = mergedClusters[clusterIndex].subcategories[subcatIndex].achievements[achievementIndex];
                  
                  if (userAchievement.containsKey('score')) {
                    // Update achievement with a copy containing the user score
                    int achievementIdx = mergedClusters[clusterIndex].subcategories[subcatIndex].achievements.indexOf(achievement);
                    mergedClusters[clusterIndex].subcategories[subcatIndex].achievements[achievementIndex] = 
                        achievement.copyWith(userScore: userAchievement['score']);
                  }
                  
                  if (userAchievement.containsKey('completed')) {
                    // Update achievement with a copy containing the completion status
                    int achievementIdx = mergedClusters[clusterIndex].subcategories[subcatIndex].achievements.indexOf(achievement);
                    mergedClusters[clusterIndex].subcategories[subcatIndex].achievements[achievementIndex] = 
                        achievement.copyWith(isCompleted: userAchievement['completed']);
                  }
                }
              }
            }
          }
        }
      }
      
      // Also save to local storage for offline access
      await _saveAllToLocalStorage(mergedClusters);
      
      return mergedClusters;
    } catch (e) {
      print('Error merging user achievements: $e');
      return defaultClusters;
    }
  }
  
  // Save all achievements to local storage
  Future<void> _saveAllToLocalStorage(List<AchievementCluster> clusters) async {
    try {
      for (var cluster in clusters) {
        for (var subcategory in cluster.subcategories) {
          for (var achievement in subcategory.achievements) {
            await _saveToLocalStorage(
              cluster.id,
              subcategory.id,
              achievement.id,
              achievement.userScore,
              achievement.isCompleted
            );
          }
        }
      }
    } catch (e) {
      print('Error saving all achievements to local storage: $e');
    }
  }
  
  // Initialize user achievements with defaults
  Future<void> _initializeUserAchievements(List<AchievementCluster> clusters) async {
    final userAchievementsDoc = _userAchievementsDoc;
    if (userAchievementsDoc == null) return;
    
    // Create a simple data structure to store user achievement progress
    // This would be expanded in a real implementation
    final Map<String, dynamic> achievementsData = {
      'lastUpdated': FieldValue.serverTimestamp(),
      'clusters': clusters.map((cluster) => {
        'id': cluster.id,
        'subcategories': cluster.subcategories.map((subcat) => {
          'id': subcat.id,
          'achievements': subcat.achievements.map((achievement) => {
            'id': achievement.id,
            'completed': false,
            'score': 0,
          }).toList(),
        }).toList(),
      }).toList(),
    };
    
    await userAchievementsDoc.set(achievementsData);
  }
  
  // Update achievement progress
  Future<void> updateAchievement(String clusterId, String subcategoryId, String achievementId, {int? score, bool? completed}) async {
    final userAchievementsDoc = _userAchievementsDoc;
    if (userAchievementsDoc == null) return;
    
    try {
      // Get the current data first
      final docSnapshot = await userAchievementsDoc.get();
      if (!docSnapshot.exists) {
        // Initialize if not exists
        await _initializeUserAchievements(_getDefaultAchievementClusters());
        return updateAchievement(clusterId, subcategoryId, achievementId, score: score, completed: completed);
      }
      
      // Update the specific achievement in the nested structure
      final data = docSnapshot.data() as Map<String, dynamic>;
      final List<dynamic> clusters = data['clusters'] ?? [];
      
      // Find the cluster index
      int clusterIndex = clusters.indexWhere((c) => c['id'] == clusterId);
      if (clusterIndex == -1) return;
      
      // Find the subcategory index
      final List<dynamic> subcategories = clusters[clusterIndex]['subcategories'] ?? [];
      int subcatIndex = subcategories.indexWhere((s) => s['id'] == subcategoryId);
      if (subcatIndex == -1) return;
      
      // Find the achievement index
      final List<dynamic> achievements = subcategories[subcatIndex]['achievements'] ?? [];
      int achievementIndex = achievements.indexWhere((a) => a['id'] == achievementId);
      if (achievementIndex == -1) return;
      
      // Build update path
      String updatePath = 'clusters.$clusterIndex.subcategories.$subcatIndex.achievements.$achievementIndex';
      
      // Prepare update data
      Map<String, dynamic> updateData = {
        'lastUpdated': FieldValue.serverTimestamp()
      };
      
      // Add score update if provided
      if (score != null) {
        updateData['$updatePath.score'] = score;
      }
      
      // Add completion update if provided
      if (completed != null) {
        updateData['$updatePath.completed'] = completed;
      }
      
      await userAchievementsDoc.update(updateData);
      
      // Also save to local storage for offline access
      await _saveToLocalStorage(clusterId, subcategoryId, achievementId, score, completed);
      
    } catch (e) {
      print('Error updating achievement: $e');
    }
  }
  
  // Save achievement progress to local storage for offline access
  Future<void> _saveToLocalStorage(String clusterId, String subcategoryId, String achievementId, int? score, bool? completed) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Create a key that uniquely identifies this achievement
      String achievementKey = 'achievement_${clusterId}_${subcategoryId}_${achievementId}';
      
      // Save the score if provided
      if (score != null) {
        await prefs.setInt('${achievementKey}_score', score);
      }
      
      // Save completion status if provided
      if (completed != null) {
        await prefs.setBool('${achievementKey}_completed', completed);
      }
      
      // Save last update timestamp
      await prefs.setInt('${achievementKey}_lastUpdated', DateTime.now().millisecondsSinceEpoch);
      
      // Also save the userId so we know whose data this is
      if (_currentUserId != null) {
        await prefs.setString('${achievementKey}_userId', _currentUserId!);
      }
    } catch (e) {
      print('Error saving achievement to local storage: $e');
    }
  }
  
  // Get default achievement clusters data
  List<AchievementCluster> _getDefaultAchievementClusters() {
    return [
      // HISTORY CLUSTER
      AchievementCluster(
        id: 'history',
        title: 'Philippine History',
        description: 'Achievements related to Philippine historical events and periods',
        color: const Color(0xFF5D8CAE), // Blue
        iconPath: 'assets/images/history_icon.png',
        subcategories: [
          AchievementSubcategory(
            id: 'pre_colonial',
            title: 'Pre-Colonial Era',
            description: 'Life before Spanish colonization',
            iconPath: 'assets/images/precolonial_icon.png',
            achievements: [
              Achievement(
                id: 'precolonial_quiz',
                title: 'Pre-Colonial Expert',
                description: 'Complete the Pre-Colonial Era quiz with perfect score',
                maxScore: 100,
              ),
              Achievement(
                id: 'ancient_artifacts',
                title: 'Ancient Artifacts',
                description: 'Identify all ancient Philippine artifacts',
                maxScore: 50,
              ),
            ],
          ),
          AchievementSubcategory(
            id: 'spanish_era',
            title: 'Spanish Colonial Period',
            description: '1521-1898: Life under Spanish rule',
            iconPath: 'assets/images/spanish_icon.png',
            achievements: [
              Achievement(
                id: 'spanish_quiz',
                title: 'Spanish Era Scholar',
                description: 'Complete the Spanish Era quiz with 80% accuracy',
                maxScore: 80,
              ),
              Achievement(
                id: 'revolution_timeline',
                title: 'Revolution Timeline Master',
                description: 'Correctly order all events of the Philippine Revolution',
                maxScore: 100,
              ),
            ],
          ),
        ],
      ),

      // HEROES CLUSTER
      AchievementCluster(
        id: 'heroes',
        title: 'Filipino Heroes',
        description: 'Achievements related to Philippine national heroes and heroines',
        color: const Color(0xFFE57373), // Red
        iconPath: 'assets/images/heroes_icon.png',
        subcategories: [
          AchievementSubcategory(
            id: 'national_heroes',
            title: 'National Heroes',
            description: 'Learn about the most prominent Filipino heroes',
            iconPath: 'assets/images/national_heroes_icon.png',
            achievements: [
              Achievement(
                id: 'rizal_expert',
                title: 'Rizal Expert',
                description: 'Complete all quizzes about Jose Rizal',
                maxScore: 100,
              ),
              Achievement(
                id: 'bonifacio_quiz',
                title: 'Supremo Knowledge',
                description: 'Answer all questions about Andres Bonifacio correctly',
                maxScore: 75,
              ),
            ],
          ),
          AchievementSubcategory(
            id: 'heroines',
            title: 'Filipino Heroines',
            description: 'Learn about the women who shaped Philippine history',
            iconPath: 'assets/images/heroines_icon.png',
            achievements: [
              Achievement(
                id: 'women_revolution',
                title: 'Women of the Revolution',
                description: 'Identify all the major female figures in the Philippine Revolution',
                maxScore: 50,
              ),
              Achievement(
                id: 'modern_heroines',
                title: 'Modern Heroines',
                description: 'Complete the quiz on modern Filipino heroines',
                maxScore: 60,
              ),
            ],
          ),
        ],
      ),

      // PRESIDENTS CLUSTER
      AchievementCluster(
        id: 'presidents',
        title: 'Philippine Presidents',
        description: 'Achievements related to Philippine presidents and leadership',
        color: const Color(0xFF81C784), // Green
        iconPath: 'assets/images/presidents_icon.png',
        subcategories: [
          AchievementSubcategory(
            id: 'early_republic',
            title: 'Early Republic',
            description: 'Presidents from Aguinaldo to Magsaysay',
            iconPath: 'assets/images/early_republic_icon.png',
            achievements: [
              Achievement(
                id: 'aguinaldo_quiz',
                title: 'Emilio Aguinaldo Quiz',
                description: 'Complete the quiz about the first Philippine President',
                maxScore: 50,
              ),
              Achievement(
                id: 'commonwealth_presidents',
                title: 'Commonwealth Era',
                description: 'Identify all Commonwealth Era presidents and their contributions',
                maxScore: 75,
              ),
            ],
          ),
          AchievementSubcategory(
            id: 'modern_presidents',
            title: 'Modern Presidents',
            description: 'Presidents from Marcos to present',
            iconPath: 'assets/images/modern_presidents_icon.png',
            achievements: [
              Achievement(
                id: 'martial_law_quiz',
                title: 'Martial Law Period',
                description: 'Complete the Martial Law era quiz with 90% accuracy',
                maxScore: 90,
              ),
              Achievement(
                id: 'democracy_restored',
                title: 'Democracy Restored',
                description: 'Learn about the transition back to democracy',
                maxScore: 60,
              ),
            ],
          ),
        ],
      ),

      // TRADITIONS CLUSTER
      AchievementCluster(
        id: 'traditions',
        title: 'Filipino Traditions',
        description: 'Achievements related to cultural traditions and practices',
        color: const Color(0xFFFFB74D), // Orange
        iconPath: 'assets/images/traditions_icon.png',
        subcategories: [
          AchievementSubcategory(
            id: 'festivals',
            title: 'Filipino Festivals',
            description: 'Celebrations across the Philippines',
            iconPath: 'assets/images/festivals_icon.png',
            achievements: [
              Achievement(
                id: 'major_festivals',
                title: 'Festival Expert',
                description: 'Match all major Filipino festivals to their correct regions',
                maxScore: 100,
              ),
              Achievement(
                id: 'festival_meanings',
                title: 'Festival Origins',
                description: 'Learn the historical and cultural significance of key festivals',
                maxScore: 75,
              ),
            ],
          ),
          AchievementSubcategory(
            id: 'customs',
            title: 'Filipino Customs',
            description: 'Traditional practices and values',
            iconPath: 'assets/images/customs_icon.png',
            achievements: [
              Achievement(
                id: 'family_traditions',
                title: 'Family Values',
                description: 'Complete the quiz on Filipino family traditions',
                maxScore: 50,
              ),
              Achievement(
                id: 'cultural_practices',
                title: 'Cultural Practices',
                description: 'Identify traditional practices from different regions',
                maxScore: 80,
              ),
            ],
          ),
        ],
      ),
    ];
  }
}
