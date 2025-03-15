import 'package:flutter/material.dart';
import 'package:sibakat/views/add_page.dart';
import 'package:sibakat/views/dashboard_page.dart';
import 'package:sibakat/views/auth/login_page.dart';
import 'package:sibakat/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:line_icons/line_icons.dart';


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 2; // Tetapkan index default ke halaman profil

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return; // Hindari navigasi ulang ke halaman yang sama

    Widget nextPage;
    switch (index) {
      case 0:
        nextPage = DashboardPage();
        break;
      case 1:
        // Tambah halaman tambah kartu jika ada
        nextPage = AddPage();
        break;
      case 2:
        return;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextPage),
    );
  }

  Future<void> _logout() async {
    await ApiService().logout(); // Logout dari API

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTimeLogin', true); // Set agar popup muncul setelah login lagi

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F9FC),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60),
            Text(
              "Data Profil",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A3E92),
              ),
            ),
            SizedBox(height: 20),
            _buildProfileMenuItem(
              icon: Icons.person_outline,
              text: "Data Diri",
              onTap: () {},
            ),
            SizedBox(height: 10),
            _buildProfileMenuItem(
              icon: Icons.vpn_key_outlined,
              text: "Ubah Password",
              onTap: () {},
            ),
            SizedBox(height: 30),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Keluar",
                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 10,
          color: Color(0xFFB0C4FF),
          child: Row(
            children: [
              Expanded(
                child: IconButton(
                  icon: Icon(LineIcons.home,
                      color: _selectedIndex == 0 ? Color(0xFF1A3E92) : Colors.black),
                  onPressed: () => _onItemTapped(0),
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Icon(LineIcons.plusCircle,
                      size: 30, // Ukuran lebih besar agar menonjol
                      color: _selectedIndex == 1 ? Color(0xFF1A3E92) : Colors.black),
                  onPressed: () => _onItemTapped(1),
                ),
              ),
              Expanded(child: SizedBox()), // Spacer agar ikon Plus tetap di tengah
            ],
          ),
        ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF1A3E92),
          child: Icon(LineIcons.userCircle, size: 28, color: Colors.white),
          onPressed: () {}, // Bisa digunakan untuk fitur lain
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,


    );
  }

  Widget _buildProfileMenuItem({required IconData icon, required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 24, color: Colors.black54),
                SizedBox(width: 10),
                Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
            Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}
