import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../dashboard_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Stack untuk ellipse, rectangle, teks "SiBakat", dan komponen di bawahnya
                  SizedBox(
                    height: 500, // Tinggi Stack yang cukup untuk menampilkan semua komponen
                    child: Stack(
                      clipBehavior: Clip.none, // Agar komponen di luar batas tetap terlihat
                      alignment: Alignment.center,
                      children: [
                        // Rectangle di sisi kiri bawah
                        Positioned(
                          left: -100, // Posisi lebih ke kiri
                          bottom: -100, // Posisi lebih ke bawah
                          child: Container(
                            width: 300, // Lebar rectangle
                            height: 300, // Tinggi rectangle
                            decoration: BoxDecoration(
                              color: Color(0xFFF8F9FF).withOpacity(0.5), // Warna dengan opacity
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(50), // Sudut melengkung di kanan atas
                                bottomRight: Radius.circular(50), // Sudut melengkung di kanan bawah
                              ),
                            ),
                          ),
                        ),
                        // Ellipse 1 (Stroke)
                        Positioned(
                          left: 10, // Posisi lebih ke kiri
                          top: -350, // Posisi lebih ke atas
                          child: Container(
                            width: 500, // Lebih besar
                            height: 500, // Lebih besar
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color(0xFFF8F9FF),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        // Ellipse 2 (Fill)
                        Positioned(
                          left: 120, // Posisi lebih ke kanan
                          top: -380, // Posisi lebih ke atas
                          child: Container(
                            width: 500, // Lebih besar
                            height: 500, // Lebih besar
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFF8F9FF),
                            ),
                          ),
                        ),
                        // Text "SiBakat"
                        Positioned(
                          top: 50, // Posisi teks "SiBakat" di dalam Stack
                          child: Text(
                            "SiBakat",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3454D1),
                            ),
                          ),
                        ),
                        // Teks deskripsi
                        Positioned(
                          top: 120, // Posisi teks deskripsi di bawah teks "SiBakat"
                          child: Container(
                            width: MediaQuery.of(context).size.width - 48, // Lebar sesuai padding
                            child: Text(
                              "Silakan masukkan email & password untuk masuk ke SiBakat.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold, // Teks dibuat bold
                              ),
                            ),
                          ),
                        ),
                        // Input Email
                        Positioned(
                          top: 200, // Posisi input email
                          child: Container(
                            width: MediaQuery.of(context).size.width - 48, // Lebar sesuai padding
                            height: 60,
                            decoration: BoxDecoration(
                              color: Color(0xFF3454D1).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: TextField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Input Password
                        Positioned(
                          top: 280, // Posisi input password
                          child: Container(
                            width: MediaQuery.of(context).size.width - 48, // Lebar sesuai padding
                            height: 60,
                            decoration: BoxDecoration(
                              color: Color(0xFF3454D1).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: TextField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Tombol Masuk
                        Positioned(
                          top: 360, // Posisi tombol masuk
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 48, // Lebar sesuai padding
                            height: 56,
                            child: ElevatedButton(
                              onPressed: authProvider.isLoading
                                  ? null
                                  : () async {
                                bool success = await authProvider.login(
                                  emailController.text,
                                  passwordController.text,
                                );
                                if (success) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => DashboardPage()),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Login gagal, periksa email & password!")),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF3454D1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: authProvider.isLoading
                                  ? CircularProgressIndicator(color: Colors.white)
                                  : Text(
                                "Masuk",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 450, // Posisi teks "Baru mengenal SiBakat?"
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Baru mengenal SiBakat? ",
                                  style: TextStyle(
                                    color: Colors.black, // Warna hitam
                                    fontWeight: FontWeight.bold, // Teks dibuat bold
                                  ),
                                ),
                                TextSpan(
                                  text: "Klik disini.",
                                  style: TextStyle(
                                    color: Color(0xFF3454D1), // Warna biru
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}