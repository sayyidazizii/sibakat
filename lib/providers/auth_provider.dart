import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  final ApiService _apiService = ApiService();

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    User? loggedInUser = await _apiService.login(email, password);

    if (loggedInUser != null) {
      _user = loggedInUser;
      _isLoading = false;
      notifyListeners();
      return true; // Login berhasil
    } else {
      _isLoading = false;
      notifyListeners();
      return false; // Login gagal
    }
  }
}
