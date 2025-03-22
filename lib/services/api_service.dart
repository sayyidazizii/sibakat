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

  // Fungsi untuk menambahkan ATM baru
    Future<String> addATM(String cardNumber, String accountNumber, String cardName, String address, String balance) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null) {
        print("DEBUG: Token tidak ditemukan");
        return "Token tidak ditemukan. Harap login ulang.";
      }

      final response = await http.post(
        Uri.parse("$baseUrl/atm"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "card_number": cardNumber,
          "account_number": accountNumber,
          "card_name": cardName,
          "address": address,
          "balance": balance,
        }),
      );

      // Debugging: Print response
      print("DEBUG: Response Code: ${response.statusCode}");
      print("DEBUG: Response Body: ${response.body}");

      final responseData = jsonDecode(response.body);

      // Jika sukses (200 atau 201) dan statusnya "success"
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData["status"] == "success") {
          return "ATM berhasil ditambahkan!";
        }
      }

      // Jika API mengembalikan pesan error (Validasi atau lainnya)
      if (responseData.containsKey("error")) {
        String errorMessage = responseData["message"] ?? "Terjadi kesalahan.";

        if (responseData["error"] is Map) {
          responseData["error"].forEach((key, value) {
            errorMessage += "\n${key.replaceAll("_", " ")}: ${value.join(", ")}";
          });
        }

        return errorMessage;
      }

      return "Gagal menambahkan ATM. Silakan coba lagi.";
    } catch (e) {
      print("DEBUG: Error saat menghubungi API: $e");
      return "Terjadi kesalahan: $e";
    }
  }

  Future<Map<String, dynamic>> getATMById(String atmId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    String url = "$baseUrl/atm/$atmId";
    print("Fetching ATM data from: $url");
    print("Using Token: $token");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      
      // Pastikan response memiliki key "data"
      if (jsonResponse.containsKey("data")) {
        return jsonResponse["data"]; // Mengembalikan data ATM
      } else {
        throw Exception("Response tidak memiliki key 'data'");
      }
    } else {
      throw Exception("Gagal mengambil data ATM");
    }
  }


  Future<String> updateATM(String atmId, Map<String, String> data) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      print("Updating ATM ID: $atmId");
      print("Using Token: Bearer $token");
      print("Request Data: $data");

      final response = await http.put(
        Uri.parse("$baseUrl/atm/$atmId"),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",  // ✅ Sesuai dengan dokumentasi API
          "Authorization": "Bearer $token",
        },
        body: data,  // ✅ Pakai Map<String, String> langsung
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return "ATM berhasil diperbarui";
      } else {
        return "Gagal memperbarui ATM: ${response.body}";
      }
    }



  // ✅ Fungsi untuk menghapus ATM berdasarkan ID
  Future<String> deleteATM(String atmId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null) {
        return "Token tidak ditemukan. Silakan login ulang.";
      }

      final response = await http.delete(
        Uri.parse("$baseUrl/atm/$atmId"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      // Debugging response
      print("DEBUG: Response Code: ${response.statusCode}");
      print("DEBUG: Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 204) {
        return "ATM berhasil dihapus!";
      }

      final responseData = jsonDecode(response.body);

      return responseData["message"] ?? "Gagal menghapus ATM.";
    } catch (e) {
      print("DEBUG: Error saat menghapus ATM: $e");
      return "Terjadi kesalahan: $e";
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
