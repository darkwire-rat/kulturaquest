import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Story {
  final String title;
  final String content;
  final List<Question> quiz;

  Story({required this.title, required this.content, required this.quiz});
}

class Question {
  final String question;
  final List<String> options;
  final int correctIndex;

  Question({required this.question, required this.options, required this.correctIndex});
}

// This is a simple version with just one story to test if it works
final List<Story> stories = [
  Story(
    title: 'The Lost Kingdom of Namayan',
    content: 'Historical content about Namayan',
    quiz: [
      Question(
        question: 'Where was Namayan located?',
        options: ['Manila', 'Cebu', 'Davao', 'Baguio'],
        correctIndex: 0,
      ),
    ],
  ),
];
