import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'profile_page.dart';
import 'dashboard_page.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  int _currentIndex = 1; // Set default index ke AddPage

  void _onItemTapped(int index) {
    if (index == _currentIndex) return; // Hindari navigasi ulang ke halaman yang sama

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFF),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tambah Kartu",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E40AF),
              ),
            ),
            SizedBox(height: 20),

            buildInputField("No. ATM", "1234xxxx5678xxxx9012"),
            buildInputField("No. Rekening", "12345xxxxx"),
            buildInputField("Nama Lengkap", "Utami xxxxxx", isBold: true),
            buildInputField("Alamat", "Jl. Lompo Batang Timur xxxxx", isBold: true),
            buildInputField("Saldo", "770.000"),

            SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1E40AF),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                child: Text("Simpan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(LineIcons.home,
                  size: 30,
                  color: _currentIndex == 0 ? Color(0xFF1E40AF) : Colors.black),
              onPressed: () => _onItemTapped(0),
            ),

            IconButton(
              icon: Icon(LineIcons.userCircle,
                  size: 30,
                  color: _currentIndex == 2 ? Color(0xFF1E40AF) : Colors.black),
              onPressed: () => _onItemTapped(2),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF1E40AF),
        child: Icon(LineIcons.plusCircle, size: 30, color: Colors.white),
        onPressed: () {}, // Tidak perlu navigasi karena sudah di halaman ini
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget buildInputField(String label, String value, {bool isBold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Color(0xFFF0F4FF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xFF1E40AF), width: 1.5),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.black54,
            ),
          ),
        ),
        SizedBox(height: 14),
      ],
    );
  }
}
