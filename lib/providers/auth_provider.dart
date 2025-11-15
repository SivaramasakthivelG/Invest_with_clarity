import 'package:flutter/material.dart';
import '../core/api_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _token;
  String? get token => _token;
  set token(String? val) {
    _token = val;
    notifyListeners();
  }




  Future<Map<String, dynamic>> login(String email, String password) async {
    _setLoading(true);
    final res = await ApiService.login(email, password);
    _setLoading(false);
    return res;
  }

  Future<Map<String, dynamic>> register(String username, String email, String password) async {
    _setLoading(true);
    final res = await ApiService.register(username, email, password);
    _setLoading(false);
    return res;
  }

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }
}
