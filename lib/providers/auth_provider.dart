import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = false;
  bool _rememberMe = false;
  String? _error;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  bool get rememberMe => _rememberMe;
  String? get error => _error;

  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate network request
      await Future.delayed(const Duration(seconds: 2));

      // Mock validation (accepts any email with a @ and any password >= 6 chars)
      if (!email.contains('@')) {
        throw Exception('Invalid email format');
      }
      if (password.length < 6) {
        throw Exception('Password must be at least 6 characters');
      }

      _isAuthenticated = true;
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    // Simulate network request
    await Future.delayed(const Duration(milliseconds: 800));
    
    _isAuthenticated = false;
    if (!_rememberMe) {
      // Clear saved credentials logic would go here
    }
    
    _isLoading = false;
    notifyListeners();
  }
}
