// lib/providers/question_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QuestionProvider extends ChangeNotifier {
  List<dynamic> _questions = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _currentIndex = 0;
  final Map<int, String> _answers = {}; // questionId -> userAnswer

  List<dynamic> get questions => _questions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get currentIndex => _currentIndex;
  Map<int, String> get answers => _answers;

  bool get isFinished => _currentIndex >= _questions.length;

  Future<void> fetchQuestions(String token, int subCategoryId) async {
    _isLoading = true;
    _errorMessage = null;
    _questions = [];
    _currentIndex = 0;
    _answers.clear();
    notifyListeners();

    final url = Uri.parse(
        'https://investment-qna-backend-1.onrender.com/api/questions');

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        _questions = jsonDecode(response.body);
      } else {
        _errorMessage = 'Failed to load questions';
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void saveAnswer(int questionId, String answer) {
    _answers[questionId] = answer;
  }

  void nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
    } else {
      _currentIndex = _questions.length;
    }
    notifyListeners();
  }

  void restart() {
    _currentIndex = 0;
    _answers.clear();
    notifyListeners();
  }
}
