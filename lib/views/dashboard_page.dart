import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'profile_page.dart'; // Import halaman profil
import 'add_page.dart'; // Import halaman tambah kartu jika ada
import 'edit_atm_page.dart';


class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ApiService apiService = ApiService();
  String _userName = "Pengguna";
  int _currentIndex = 0; // Tambahkan state untuk index navbar
  int _cardCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _checkAndShowPopup();
  }

  Future<void> _checkAndShowPopup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTimeLogin') ?? false;

    if (isFirstTime) {
      Future.delayed(Duration(milliseconds: 500), () {
        _showSiBakatPopup();
      });

      await prefs.setBool('isFirstTimeLogin', false); // Reset agar tidak muncul lagi
    }
  }


  // Fungsi untuk menampilkan popup
  void _showSiBakatPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("SiBakat"),
          content: Text(
            "SiBakat (Sistem Informasi Bank Jateng Kartu ATM) adalah sebuah aplikasi yang dirancang untuk mengelola data opname stok kartu ATM secara efisien. Aplikasi ini bertujuan untuk mempermudah pencatatan, pemantauan, dan pengelolaan persediaan kartu ATM Bank Jateng Syariah, sehingga memastikan ketersediaan stok tetap terjaga dan terorganisir dengan baik.",
          ),
          actions: [
            SizedBox(
              width: double.infinity, // Tombol melebar sesuai dialog
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey, // Warna abu-abu
                  foregroundColor: Colors.white, // Warna teks putih
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Tutup"),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('name');
    if (name != null) {
      setState(() {
        _userName = name;
      });
    }
  }

  // **Perbaiki Fungsi Navigasi**
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 1) {

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddPage()),
      ).then((_) {
        setState(() {
          _currentIndex = 0; // Kembali ke Home setelah selesai di halaman tambah
        });
      });
    } else if (index == 2) {

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    }
  }

  Future<bool> _showDeleteConfirmation() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Hapus Data",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "Apakah anda yakin ingin menghapus?",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text("Tidak", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[400],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text("Ya", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ) ?? false;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Sugeng Rawuh,", style: TextStyle(fontSize: 18, color: Colors.blue)),
                Text(_userName, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

                SizedBox(height: 20),

                FutureBuilder<List<dynamic>>(
                  future: apiService.fetchATMs(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Terjadi kesalahan"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text("Tidak ada data ATM"));
                    } else {
                      _cardCount = snapshot.data!.length;
                      return Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Color(0xFF3454D1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(_cardCount.toString(), style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                                Text("Kartu dibuat", style: TextStyle(color: Colors.white, fontSize: 16)),
                                Divider(color: Colors.white, height: 20, thickness: 1),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.calendar_today, color: Colors.white, size: 16),
                                    SizedBox(width: 5),
                                    Text("Sen, 19 Februari 2025", style: TextStyle(color: Colors.white, fontSize: 12)),
                                    SizedBox(width: 10),
                                    Icon(Icons.access_time, color: Colors.white, size: 16),
                                    SizedBox(width: 5),
                                    Text("Januari - Februari", style: TextStyle(color: Colors.white, fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                         SizedBox(height: 20),
                         Container(
                            width: double.infinity, // Pastikan Container melebar penuh
                            alignment: Alignment.centerLeft, // Paksa konten berada di kiri
                            margin: EdgeInsets.only(top: 20), // Tambahkan margin agar terpisah dari elemen sebelumnya
                            child: Text(
                              "Daftar Pembuatan Kartu",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),

                         ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var atm = snapshot.data![index];
                            return InkWell(
                              onTap: () {
                                // Navigasi ke EditATMPage saat item diklik
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditATMPage(atmId: atm["id"]),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFD0E1FF),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Color(0xFF3454D1), width: 1.5),
                                ),
                                margin: EdgeInsets.only(bottom: 10),
                                padding: EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    Icon(LineIcons.creditCard, color: Colors.black),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            atm["card_name"] ?? "Tanpa Nama",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 4),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              "Rek. ${atm["account_number"] ?? "Tidak Ada"}",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade400,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        atm["created_at"]?.split("T")[0] ?? "Tidak diketahui",
                                        style: TextStyle(fontSize: 12, color: Colors.black),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    IconButton(
                                      icon: Icon(LineIcons.trash, color: Colors.black),
                                      onPressed: () async {
                                        bool confirmDelete = await _showDeleteConfirmation();
                                        if (confirmDelete) {
                                          String message = await apiService.deleteATM(atm["id"]);
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                                          setState(() {}); // Refresh daftar ATM
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        color: Color(0xFFB0C4FF),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround, // Rapi di tengah
          children: [
            SizedBox(width: _currentIndex == 0 ? 50 : 0), // Beri jarak saat Home di kiri
            IconButton(
              icon: Icon(LineIcons.plusCircle,
                  size: 30,
                  color: _currentIndex == 1 ? Color(0xFF1E40AF) : Colors.black),
              onPressed: () => _onItemTapped(1),
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
        child: Icon(LineIcons.home, size: 30, color: Colors.white),
        onPressed: () => _onItemTapped(0), // Pastikan ini untuk Home
      ),

      floatingActionButtonLocation: _currentIndex == 0
          ? FloatingActionButtonLocation.startDocked
          : _currentIndex == 1
              ? FloatingActionButtonLocation.centerDocked
              : FloatingActionButtonLocation.endDocked,
    );
  }
}
