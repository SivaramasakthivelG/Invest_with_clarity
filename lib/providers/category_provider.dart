// lib/providers/category_provider.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:qna01/providers/auth_provider.dart';

class CategoryProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  List<dynamic> _categories = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<dynamic> get categories => _categories;

  Future<void> fetchCategories(String? token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final url = Uri.parse('https://investment-qna-backend-1.onrender.com/api/categories');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token!.isNotEmpty) 'Authorization': 'Bearer $token',
        }
      );

      if (response.statusCode == 200) {
        _categories = json.decode(response.body);
      } else {
        _errorMessage = 'Error loading categories';
      }
    } catch (e) {
      _errorMessage = 'Failed to load categories: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
}
