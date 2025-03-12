import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  bool _isLoggedIn = false; // Tambahkan variabel untuk sesi login

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn; // Getter untuk status login

  final ApiService _apiService = ApiService();

  //* Fungsi untuk mengecek status login
  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      _isLoggedIn = true;
      notifyListeners();
      //* Tampilkan notifikasi selamat datang kembali
      Fluttertoast.showToast(
        msg: "Selamat datang kembali!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP, // Notifikasi di atas
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  //* Fungsi untuk Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    User? loggedInUser = await _apiService.login(email, password);

    if (loggedInUser != null) {
      _user = loggedInUser;
      _isLoggedIn = true; // Set status login 
      _isLoading = false;
      notifyListeners();
      return true; // Login berhasil
    } else {
      _isLoading = false;
      notifyListeners();
      return false; // Login gagal
    }
  }

  //* Fungsi untuk logout
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _isLoggedIn = false; // Reset status login
    _user = null;
    notifyListeners();
  }
}
