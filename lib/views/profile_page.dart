import 'package:flutter/material.dart';
import 'package:sibakat/views/dashboard_page.dart';
import 'package:sibakat/views/auth/login_page.dart';
import 'package:sibakat/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    Widget nextPage;
    switch (index) {
      case 0:
        nextPage = DashboardPage();
        break;
      case 2:
        nextPage = ProfilePage();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextPage),
    );

    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    await ApiService().logout(); // Panggil logout dari ApiService
    
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
                width: double.infinity, // Lebar penuh mengikuti menu sebelumnya
                child: ElevatedButton(
                  onPressed: _logout, // Fungsi logout sudah async
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 16), // Hapus horizontal agar otomatis
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color(0xFF1A3E92),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Tambah'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
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