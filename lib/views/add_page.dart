import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import '../services/api_service.dart';
import 'profile_page.dart';
import 'dashboard_page.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController cardNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController balanceController = TextEditingController();
  bool _isLoading = false; // Untuk menampilkan indikator loading

  int _currentIndex = 1;
  final ApiService apiService = ApiService();

  void _onItemTapped(int index) {
    if (index == _currentIndex) return;
    if (index == 0) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardPage()));
    } else if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
    }
  }

  void _submitATM() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String response = await apiService.addATM(
        cardNumberController.text,
        accountNumberController.text,
        cardNameController.text,
        addressController.text,
        balanceController.text,
      );

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response),
          backgroundColor: response.contains("berhasil") ? Colors.green : Colors.red,
        ),
      );

      if (response.contains("berhasil")) {
        Navigator.pop(context); // Kembali ke halaman sebelumnya jika sukses
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFF),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tambah Kartu",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF)),
              ),
              SizedBox(height: 20),
              buildInputField("No. ATM", cardNumberController, length: 16),
              buildInputField("No. Rekening", accountNumberController, length: 10),
              buildInputField("Nama Lengkap", cardNameController),
              buildInputField("Alamat", addressController),
              buildInputField("Saldo", balanceController, isNumber: true),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1E40AF),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _isLoading ? null : _submitATM, // Disable button saat loading
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Simpan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
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
              icon: Icon(LineIcons.home, size: 30, color: _currentIndex == 0 ? Color(0xFF1E40AF) : Colors.black),
              onPressed: () => _onItemTapped(0),
            ),
            IconButton(
              icon: Icon(LineIcons.userCircle, size: 30, color: _currentIndex == 2 ? Color(0xFF1E40AF) : Colors.black),
              onPressed: () => _onItemTapped(2),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF1E40AF),
        child: Icon(LineIcons.plusCircle, size: 30, color: Colors.white),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget buildInputField(String label, TextEditingController controller, {bool isNumber = false, int? length}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          maxLength: length,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFF0F4FF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFF1E40AF), width: 1.5),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "$label tidak boleh kosong";
            }
            if (length != null && value.length != length) {
              return "$label harus $length digit";
            }
            return null;
          },
        ),
        SizedBox(height: 14),
      ],
    );
  }
}
