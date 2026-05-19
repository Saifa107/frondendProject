import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminAddUserScreen extends StatefulWidget {
  @override
  _AdminAddUserScreenState createState() => _AdminAddUserScreenState();
}

class _AdminAddUserScreenState extends State<AdminAddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  String selectedRole = "user"; // ค่าเริ่มต้นเป็น user
  final List<String> roles = ["user", "admin"];
  bool isPasswordHidden = true;

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF0D47A1)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "เพิ่มผู้ใช้งานใหม่",
          style: GoogleFonts.prompt(color: const Color(0xFF0D47A1), fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. ส่วนเลือกรูปโปรไฟล์ (จำลอง)
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F7FA),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF1976D2), width: 2),
                      ),
                      child: const Icon(Icons.person, size: 65, color: Color(0xFF00ACC1)),
                    ),
                    GestureDetector(
                      onTap: () {
                        // TODO: เชื่อมต่อ Image Picker เพื่อเลือกรูปโปรไฟล์และส่งไป Cloudinary
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFF0D47A1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // 2. ช่องกรอกชื่อผู้ใช้งาน
              _buildLabel("ชื่อ-นามสกุล"),
              TextFormField(
                controller: _nameController,
                validator: (value) => value!.isEmpty ? 'กรุณากรอกชื่อ-นามสกุล' : null,
                decoration: _buildInputDecoration("ตัวอย่าง: สมชาย ใจดี", Icons.person),
              ),
              const SizedBox(height: 20),

              // 3. ช่องกรอกรหัสผ่าน
              _buildLabel("รหัสผ่าน"),
              TextFormField(
                controller: _passwordController,
                obscureText: isPasswordHidden,
                validator: (value) => value!.isEmpty ? 'กรุณากรอกรหัสผ่าน' : null,
                decoration: InputDecoration(
                  hintText: "กำหนดรหัสผ่านบัญชี...",
                  hintStyle: GoogleFonts.prompt(color: Colors.grey[400], fontSize: 14),
                  filled: true,
                  fillColor: Colors.grey[50],
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFF1976D2)),
                  suffixIcon: IconButton(
                    icon: Icon(isPasswordHidden ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                    onPressed: () => setState(() => isPasswordHidden = !isPasswordHidden),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF00ACC1))),
                ),
              ),
              const SizedBox(height: 20),

              // 4. ส่วนเลือกสิทธิ์การใช้งาน (Role)
              _buildLabel("สิทธิ์การใช้งานระบบ (Role)"),
              Row(
                children: roles.map((role) {
                  bool isSelected = selectedRole == role;
                  return Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: ChoiceChip(
                      showCheckmark: false,
                      label: Text(
                        role.toUpperCase(),
                        style: GoogleFonts.prompt(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected ? const Color(0xFF00ACC1) : Colors.grey[700],
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: const Color(0xFF00ACC1).withOpacity(0.1),
                      backgroundColor: Colors.grey[100],
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => selectedRole = role);
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),

              // 5. ปุ่มสร้างบัญชีผู้ใช้งาน
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1), // Navy Blue
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // TODO: ดึงค่าจาก Controller ส่งไปยัง Node.js Backend API เพื่อบันทึกลงฐานข้อมูล MySQL
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("สร้างบัญชีผู้ใช้งานสำเร็จ", style: GoogleFonts.prompt())),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    "สร้างบัญชีผู้ใช้งาน",
                    style: GoogleFonts.prompt(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: GoogleFonts.prompt(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.prompt(color: Colors.grey[400], fontSize: 14),
      filled: true,
      fillColor: Colors.grey[50],
      prefixIcon: Icon(icon, color: const Color(0xFF1976D2)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF00ACC1))),
    );
  }
}