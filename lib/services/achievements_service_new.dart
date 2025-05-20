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
            if (prefs.containsKey('${achievementKey}_userScore')) {
              int score = prefs.getInt('${achievementKey}_userScore') ?? 0;
              // Update achievement with a copy containing the new score
              clusters[i].subcategories[j].achievements[k] = achievement.copyWith(userScore: score);
            }
            
            if (prefs.containsKey('${achievementKey}_completed')) {
              bool completed = prefs.getBool('${achievementKey}_completed') ?? false;
              // Update achievement with a copy containing the new completion status
              clusters[i].subcategories[j].achievements[k] = 
                  clusters[i].subcategories[j].achievements[k].copyWith(isCompleted: completed);
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
  
  // Merge user achievements from Firestore with default achievements
  Future<List<AchievementCluster>> _mergeUserAchievementsWithDefaults(
      Map<String, dynamic> userData, List<AchievementCluster> defaultClusters) async {
    try {
      // Create a deep copy of default clusters that we'll update with user data
      List<AchievementCluster> mergedClusters = List.from(defaultClusters);
      
      // Safely access individual achievement data instead of relying on nested structures
      // This avoids issues with the data format (Map vs List)
      Map<String, dynamic> achievementData = {};
      
      // Extract all achievement data into a flat map for easier access
      if (userData.containsKey('achievements') && userData['achievements'] != null) {
        achievementData = Map<String, dynamic>.from(userData['achievements']);
      }
      
      // Update each achievement in our default clusters if we have user data for it
      for (int i = 0; i < mergedClusters.length; i++) {
        final cluster = mergedClusters[i];
        
        for (int j = 0; j < cluster.subcategories.length; j++) {
          final subcategory = cluster.subcategories[j];
          
          for (int k = 0; k < subcategory.achievements.length; k++) {
            final achievement = subcategory.achievements[k];
            final achievementKey = '${cluster.id}_${subcategory.id}_${achievement.id}';
            
            // Check if we have user data for this specific achievement
            if (achievementData.containsKey(achievementKey)) {
              final userData = achievementData[achievementKey];
              
              // Extract score and completion status
              int? userScore;
              bool? isCompleted;
              
              if (userData is Map<String, dynamic>) {
                if (userData.containsKey('userScore')) {
                  userScore = userData['userScore'] as int?;
                }
                if (userData.containsKey('isCompleted')) {
                  isCompleted = userData['isCompleted'] as bool?;
                }
              }
              
              // Update the achievement with user progress
              if (userScore != null || isCompleted != null) {
                mergedClusters[i].subcategories[j].achievements[k] = achievement.copyWith(
                  userScore: userScore ?? achievement.userScore,
                  isCompleted: isCompleted ?? achievement.isCompleted,
                );
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
      final prefs = await SharedPreferences.getInstance();
      
      for (final cluster in clusters) {
        for (final subcategory in cluster.subcategories) {
          for (final achievement in subcategory.achievements) {
            String achievementKey = 'achievement_${cluster.id}_${subcategory.id}_${achievement.id}';
            
            await prefs.setInt('${achievementKey}_userScore', achievement.userScore);
            await prefs.setBool('${achievementKey}_completed', achievement.isCompleted);
            await prefs.setInt('${achievementKey}_lastUpdated', DateTime.now().millisecondsSinceEpoch);
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
    
    // Create a flat map of achievements for easier storage
    final Map<String, dynamic> achievementsData = {
      'achievements': {},
      'lastUpdated': FieldValue.serverTimestamp(),
    };
    
    // Also save to local storage
    await _saveAllToLocalStorage(clusters);
    
    await userAchievementsDoc.set(achievementsData);
  }

  // Update achievement progress
  Future<void> updateAchievement(String clusterId, String subcategoryId, String achievementId, {int? score, bool? completed}) async {
    try {
      // Get current user ID
      final userId = _currentUserId;
      
      // Create a unique key for this achievement
      final achievementKey = '${clusterId}_${subcategoryId}_${achievementId}';
      
      // Always update local storage first for immediate feedback
      await _saveToLocalStorage(clusterId, subcategoryId, achievementId, score, completed);
      
      // If not logged in, we're done
      if (userId == null) {
        return;
      }
      
      // Get user achievements document
      final userAchievementsDoc = _userAchievementsDoc;
      if (userAchievementsDoc == null) {
        return;
      }
      
      // Get current achievements data
      final docSnapshot = await userAchievementsDoc.get();
      Map<String, dynamic> userData = {};
      
      if (docSnapshot.exists) {
        userData = docSnapshot.data() as Map<String, dynamic>;
      }
      
      // Initialize achievements map if it doesn't exist
      if (!userData.containsKey('achievements')) {
        userData['achievements'] = <String, dynamic>{};
      }
      
      // Get existing achievement data or create new entry
      Map<String, dynamic> achievementData = {};
      if (userData['achievements'].containsKey(achievementKey)) {
        achievementData = Map<String, dynamic>.from(userData['achievements'][achievementKey]);
      }
      
      // Update with new data, but only if the score is higher than existing score
      if (score != null) {
        final existingScore = achievementData['userScore'] as int? ?? 0;
        if (score > existingScore) {
          achievementData['userScore'] = score;
        }
      }
      
      if (completed != null) {
        achievementData['isCompleted'] = completed;
      }
      
      // Store back in the userData map
      userData['achievements'][achievementKey] = achievementData;
      
      // Save to Firestore
      await userAchievementsDoc.set(userData);
      
      print('Successfully updated achievement: $achievementKey with score: $score, completed: $completed');
    } catch (e) {
      print('Error updating achievement: $e');
    }
  }
  
  // Save achievement progress to local storage for offline access
  Future<void> _saveToLocalStorage(String clusterId, String subcategoryId, String achievementId, int? score, bool? completed) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Create a key for this achievement
      String achievementKey = 'achievement_${clusterId}_${subcategoryId}_${achievementId}';
      
      // Save score if provided, but only if it's higher than the existing score
      if (score != null) {
        final existingScore = prefs.getInt('${achievementKey}_userScore') ?? 0;
        if (score > existingScore) {
          await prefs.setInt('${achievementKey}_userScore', score);
        }
      }
      
      // Save completion status if provided
      if (completed != null) {
        await prefs.setBool('${achievementKey}_completed', completed);
      }
      
      // Also save the last update timestamp
      await prefs.setInt('${achievementKey}_lastUpdated', DateTime.now().millisecondsSinceEpoch);
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
        description: 'Achievements related to Philippine historical events and milestones',
        color: const Color(0xFF5D8CAE), // Blue
        iconPath: 'assets/images/history_icon.png',
        subcategories: [
          AchievementSubcategory(
            id: 'regional_history',
            title: 'Regional History',
            description: 'Historical achievements from different regions',
            iconPath: 'assets/images/history_icon.png',
            achievements: [
              Achievement(
                id: 'luzon_history_quiz',
                title: 'Luzon History Scholar',
                description: 'Complete the Luzon history quiz with at least 80% accuracy',
                maxScore: 100,
              ),
              Achievement(
                id: 'visayas_history_quiz',
                title: 'Visayas History Scholar',
                description: 'Complete the Visayas history quiz with at least 80% accuracy',
                maxScore: 100,
              ),
              Achievement(
                id: 'mindanao_history_quiz',
                title: 'Mindanao History Scholar',
                description: 'Complete the Mindanao history quiz with at least 80% accuracy',
                maxScore: 100,
              ),
              Achievement(
                id: 'history_grand_scholar',
                title: 'History Grand Scholar',
                description: 'Complete all regional history quizzes with perfect scores',
                maxScore: 150,
              ),
            ],
          ),
        ],
      ),
      
      // TRADITIONS CLUSTER
      AchievementCluster(
        id: 'traditions',
        title: 'Filipino Traditions',
        description: 'Achievements related to Philippine cultural traditions and practices',
        color: const Color(0xFFFFB74D), // Orange
        iconPath: 'assets/images/traditions_icon.png',
        subcategories: [
          AchievementSubcategory(
            id: 'regional_traditions',
            title: 'Regional Traditions',
            description: 'Traditional practices from different regions',
            iconPath: 'assets/images/regional_traditions_icon.png',
            achievements: [
              Achievement(
                id: 'luzon_traditions_quiz',
                title: 'Luzon Traditions Expert',
                description: 'Complete the Luzon traditions quiz with at least 80% accuracy',
                maxScore: 100,
              ),
              Achievement(
                id: 'visayas_traditions_quiz',
                title: 'Visayas Traditions Expert',
                description: 'Complete the Visayas traditions quiz with at least 80% accuracy',
                maxScore: 100,
              ),
              Achievement(
                id: 'mindanao_traditions_quiz',
                title: 'Mindanao Traditions Expert',
                description: 'Complete the Mindanao traditions quiz with at least 80% accuracy',
                maxScore: 100,
              ),
              Achievement(
                id: 'traditions_grand_master',
                title: 'Traditions Grand Master',
                description: 'Complete all regional traditions quizzes with perfect scores',
                maxScore: 150,
              ),
            ],
          ),
        ],
      ),
    ];
  }
}
