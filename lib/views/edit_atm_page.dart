import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EditATMPage extends StatefulWidget {
  final String? atmId;

  EditATMPage({this.atmId});

  @override
  _EditATMPageState createState() => _EditATMPageState();
}

class _EditATMPageState extends State<EditATMPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController cardNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController balanceController = TextEditingController();
  bool _isLoading = false;

  bool isCardNumberUsed = false;
  bool isAccountNumberUsed = false;

  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    if (widget.atmId != null) {
      _fetchATMData(widget.atmId!);
    } else {
      print("ATM ID tidak tersedia");
    }
  }


  Future<void> _fetchATMData(String atmId) async {
    setState(() => _isLoading = true);
    try {
      Map<String, dynamic> atmData = await apiService.getATMById(atmId);
      setState(() {
        cardNumberController.text = atmData['card_number'] ?? '';
        accountNumberController.text = atmData['account_number'] ?? '';
        cardNameController.text = atmData['card_name'] ?? '';
        addressController.text = atmData['address'] ?? '';
        balanceController.text = atmData['balance'] ?? '';

        isCardNumberUsed = atmData.containsKey("card_number");
        isAccountNumberUsed = atmData.containsKey("account_number");
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Gagal mengambil data ATM")));
    }
    setState(() => _isLoading = false);
  }

  void _updateATM() async {
    if (!_formKey.currentState!.validate()) {
      return; // Jangan lanjut jika form tidak valid
    }

    // Ambil data awal sebelum diedit
    Map<String, dynamic>? oldData = await apiService.getATMById(widget.atmId!);

    Map<String, String> data = {
      if (cardNumberController.text != oldData?['card_number']) 
        "card_number": cardNumberController.text, // Kirim hanya jika berubah
      if (accountNumberController.text != oldData?['account_number']) 
        "account_number": accountNumberController.text, // Kirim hanya jika berubah
      if (cardNameController.text.isNotEmpty) 
        "card_name": cardNameController.text,
      if (addressController.text.isNotEmpty) 
        "address": addressController.text,
      if (balanceController.text.isNotEmpty) 
        "balance": balanceController.text,
    };

    setState(() => _isLoading = true);

    String resultMessage = await apiService.updateATM(widget.atmId!, data);

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(resultMessage)),
    );
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
                widget.atmId != null ? "Edit Kartu" : "Tambah Kartu",
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF)),
              ),
              SizedBox(height: 20),
              buildInputField("No. ATM", cardNumberController, length: 16, isUsed: isCardNumberUsed),
              buildInputField("No. Rekening", accountNumberController, length: 10, isUsed: isAccountNumberUsed),
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
                  onPressed: _isLoading ? null : _updateATM,
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Simpan Perubahan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField(String label, TextEditingController controller, {bool isNumber = false, int? length, bool isUsed = false}) {
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
            if (isUsed) {
              return "$label sudah terdaftar, gunakan nomor lain";
            }
            return null;
          },
        ),
        SizedBox(height: 14),
      ],
    );
  }
}
