import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  User? _user;
  bool _isLoading = false;

  AuthProvider(this._prefs) {
    _loadUser();
  }

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;

  void _loadUser() {
    final userJson = _prefs.getString('user');
    if (userJson != null) {
      _user = User.fromJson(json.decode(userJson));
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Mock authentication - replace with real API
    final mockUsers = [
      {'email': 'demo@example.com', 'password': 'password', 'name': 'Demo User'},
      {'email': 'john@example.com', 'password': 'password', 'name': 'John Doe'},
    ];

    final foundUser = mockUsers.firstWhere(
      (u) => u['email'] == email && u['password'] == password,
      orElse: () => {},
    );

    if (foundUser.isNotEmpty) {
      _user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: foundUser['email']!,
        name: foundUser['name']!,
        avatar: 'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=150&h=150&fit=crop',
      );

      await _prefs.setString('user', json.encode(_user!.toJson()));
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register(String email, String password, String name) async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    _user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name,
      avatar: 'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=150&h=150&fit=crop',
    );

    await _prefs.setString('user', json.encode(_user!.toJson()));
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _user = null;
    await _prefs.remove('user');
    await _prefs.remove('cart');
    await _prefs.remove('wishlist');
    notifyListeners();
  }

  Future<void> updateProfile(User updatedUser) async {
    _user = updatedUser;
    await _prefs.setString('user', json.encode(_user!.toJson()));
    notifyListeners();
  }
}