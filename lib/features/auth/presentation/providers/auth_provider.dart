import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _hasCompletedOnboarding = false;
  String? _username;
  String? _email;

  bool get isAuthenticated => _isAuthenticated;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;
  String? get username => _username;
  String? get email => _email;

  // Simulate loading states
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> login(String emailInput, String passwordInput) async {
    if (emailInput.isEmpty || passwordInput.isEmpty) return false;
    _setLoading(true);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1200));

    _isAuthenticated = true;
    _email = emailInput;
    _username = emailInput.split('@').first;
    _setLoading(false);
    return true;
  }

  Future<bool> signup(String name, String emailInput, String passwordInput) async {
    if (name.isEmpty || emailInput.isEmpty || passwordInput.isEmpty) return false;
    _setLoading(true);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1500));

    _isAuthenticated = true;
    _email = emailInput;
    _username = name;
    _setLoading(false);
    return true;
  }

  void logout() {
    _isAuthenticated = false;
    _username = null;
    _email = null;
    notifyListeners();
  }

  void completeOnboarding() {
    _hasCompletedOnboarding = true;
    notifyListeners();
  }

  void resetOnboarding() {
    _hasCompletedOnboarding = false;
    notifyListeners();
  }
}
