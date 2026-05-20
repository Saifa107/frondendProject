import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

import '../../config/config.dart';
import '../../service/auth_service.dart';

class AdminEditUserScreen extends StatefulWidget {
  final Map<String, dynamic> userData; // รับข้อมูลผู้ใช้มาจากหน้าค้นหา

  const AdminEditUserScreen({super.key, required this.userData});

  @override
  State<AdminEditUserScreen> createState() => _AdminEditUserScreenState();
}

class _AdminEditUserScreenState extends State<AdminEditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late String _selectedRole;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // นำข้อมูลเดิมมาใส่ในกล่องข้อความ
    _nameController = TextEditingController(text: widget.userData['u_name']);
    _selectedRole = widget.userData['u_role'] ?? 'user';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // ==========================================
  // API: บันทึกการแก้ไขข้อมูลผู้ใช้
  // ==========================================
  Future<void> _updateUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final config = await Configuration.getConfig();
      final apiEndpoint = config['apiEndpoint'];
      final String? token = await AuthService.getToken();
      final uid = widget.userData['uid'];

      final response = await http.put(
        Uri.parse("$apiEndpoint/update/$uid"), // ⚠️ ตรวจสอบเส้น API อัปเดตข้อมูลผู้ใช้ใน Node.js ของคุณด้วยครับ
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "u_name": _nameController.text,
          "u_role": _selectedRole,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("อัปเดตข้อมูลสำเร็จ", style: GoogleFonts.prompt()), backgroundColor: Colors.green),
        );
        Navigator.pop(context); // ปิดหน้าต่างกลับไปหน้าค้นหา
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("เกิดข้อผิดพลาดในการบันทึก", style: GoogleFonts.prompt()), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้", style: GoogleFonts.prompt()), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("แก้ไขข้อมูลผู้ใช้งาน", style: GoogleFonts.prompt(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0D47A1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // รหัสผู้ใช้
              Text("รหัสผู้ใช้งาน: ${widget.userData['uid']}", style: GoogleFonts.prompt(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 20),

              // กล่องใส่ชื่อ
              TextFormField(
                controller: _nameController,
                style: GoogleFonts.prompt(),
                decoration: InputDecoration(
                  labelText: "ชื่อผู้ใช้งาน",
                  labelStyle: GoogleFonts.prompt(),
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => value!.isEmpty ? "กรุณากรอกชื่อผู้ใช้งาน" : null,
              ),
              const SizedBox(height: 20),

              // Dropdown เลือกสิทธิ์
              DropdownButtonFormField<String>(
                value: _selectedRole,
                style: GoogleFonts.prompt(color: Colors.black87, fontSize: 16),
                decoration: InputDecoration(
                  labelText: "สิทธิ์การใช้งาน (Role)",
                  labelStyle: GoogleFonts.prompt(),
                  prefixIcon: const Icon(Icons.admin_panel_settings),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: const [
                  DropdownMenuItem(value: "user", child: Text("ผู้ใช้ทั่วไป (user)")),
                  DropdownMenuItem(value: "admin", child: Text("ผู้ดูแลระบบ (admin)")),
                ],
                onChanged: (value) => setState(() => _selectedRole = value!),
              ),
              const SizedBox(height: 40),

              // ปุ่มบันทึก
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00ACC1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _isLoading ? null : _updateUser,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text("บันทึกการแก้ไข", style: GoogleFonts.prompt(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}