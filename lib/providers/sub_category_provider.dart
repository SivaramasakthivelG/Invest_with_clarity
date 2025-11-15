import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SubCategoryProvider extends ChangeNotifier {
  List<dynamic> subcategories = [];
  bool isLoading = false;
  String? errorMessage;

  /// Fetch all subcategories in a category
  Future<void> fetchSubcategories(String token, int categoryId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final url = Uri.parse(
      'https://investment-qna-backend-1.onrender.com/api/subcategories/by-category/$categoryId',
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        subcategories = jsonDecode(response.body);
      } else {
        errorMessage =
        'Failed to load subcategories (${response.statusCode})';
      }
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  /// Returns the subcategory name by ID
  String getSubCategoryName(int subCategoryId) {
    try {
      final sub = subcategories.firstWhere(
            (e) => e['id'] == subCategoryId,
        orElse: () => null,
      );

      return sub != null ? (sub['name'] ?? '') : '';
    } catch (_) {
      return '';
    }
  }
}
