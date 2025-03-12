import 'dart:convert';
import 'package:flutter/foundation.dart'; // Untuk debugPrint
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class ApiService {
  static const String baseUrl = "https://sibakat.andikariskys.my.id/api";

  Future<User?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      body: {"email": email, "password": password},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      // Ambil token dari response
      String token = responseData['token'];

      // Ambil data user dari response
      final userData = responseData['data'];

      if (userData != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('name', userData['name']); // Simpan nama user

        // Cetak nama untuk debug
        debugPrint("Nama user disimpan: ${userData['name']}");

        return User(
          id: userData['id'],
          name: userData['name'],
          email: userData['email'],
        );
      }
    } else {
      debugPrint("Login gagal: ${response.body}");
    }
    return null;
  }

  //*function get all atm
  Future<List<dynamic>> fetchATMs() async {
    String? token = await getToken();
    if (token == null) {
      debugPrint("Token tidak ditemukan, pengguna harus login kembali.");
      return [];
    }

    final response = await http.get(
      Uri.parse("$baseUrl/atm"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData['data'];
    } else {
      debugPrint("Gagal mengambil data ATM: ${response.body}");
      return [];
    }
  }


  // Fungsi untuk mendapatkan token dari SharedPreferences
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // Cetak token dari SharedPreferences ke Logcat
    debugPrint("Token dari SharedPreferences: $token");

    return token;
  }

// Fungsi logout (menghapus token)
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
