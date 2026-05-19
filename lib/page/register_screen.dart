import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool isPasswordHidden = true;
  bool isConfirmPasswordHidden = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      // TODO: นำข้อมูลส่งไปยัง Node.js Backend API เพื่อสร้างบัญชีใหม่
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("สมัครสมาชิกสำเร็จ! กรุณาเข้าสู่ระบบ", style: GoogleFonts.prompt()),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // เด้งกลับไปหน้า Login
    }
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
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ส่วนหัวเรื่อง
                  Text(
                    "สร้างบัญชีใหม่",
                    style: GoogleFonts.prompt(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D47A1), // Navy Blue
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "กรอกข้อมูลด้านล่างเพื่อเริ่มต้นใช้งานแอปพลิเคชัน",
                    style: GoogleFonts.prompt(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 40),

                  // ช่องกรอกชื่อ-นามสกุล
                  _buildTextField(
                    controller: _nameController,
                    hintText: "ชื่อ-นามสกุล",
                    icon: Icons.person,
                    validator: (value) => value!.isEmpty ? "กรุณากรอกชื่อ-นามสกุล" : null,
                  ),
                  const SizedBox(height: 20),

                  // ช่องกรอกอีเมล หรือ Username
                  _buildTextField(
                    controller: _emailController,
                    hintText: "อีเมล หรือ ชื่อผู้ใช้งาน",
                    icon: Icons.email,
                    validator: (value) => value!.isEmpty ? "กรุณากรอกอีเมลหรือชื่อผู้ใช้งาน" : null,
                  ),
                  const SizedBox(height: 20),

                  // ช่องกรอกรหัสผ่าน
                  _buildPasswordField(
                    controller: _passwordController,
                    hintText: "รหัสผ่าน",
                    isHidden: isPasswordHidden,
                    toggleVisibility: () => setState(() => isPasswordHidden = !isPasswordHidden),
                    validator: (value) {
                      if (value!.isEmpty) return "กรุณากรอกรหัสผ่าน";
                      if (value.length < 6) return "รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร";
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // ช่องยืนยันรหัสผ่าน
                  _buildPasswordField(
                    controller: _confirmPasswordController,
                    hintText: "ยืนยันรหัสผ่านอีกครั้ง",
                    isHidden: isConfirmPasswordHidden,
                    toggleVisibility: () => setState(() => isConfirmPasswordHidden = !isConfirmPasswordHidden),
                    validator: (value) {
                      if (value!.isEmpty) return "กรุณายืนยันรหัสผ่าน";
                      if (value != _passwordController.text) return "รหัสผ่านไม่ตรงกัน";
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),

                  // ปุ่มสมัครสมาชิก
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00ACC1), // สี Cyan สดใส
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 2,
                      ),
                      onPressed: _register,
                      child: Text(
                        "สมัครสมาชิก",
                        style: GoogleFonts.prompt(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ปุ่มกลับไปหน้าเข้าสู่ระบบ
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("มีบัญชีอยู่แล้ว? ", style: GoogleFonts.prompt(color: Colors.grey[600], fontSize: 15)),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          "เข้าสู่ระบบ",
                          style: GoogleFonts.prompt(
                            color: const Color(0xFF0D47A1),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget ช่วยสร้างช่องกรอกข้อความทั่วไป
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: GoogleFonts.prompt(),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.prompt(color: Colors.grey[400]),
        prefixIcon: Icon(icon, color: const Color(0xFF1976D2)),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey[200]!)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey[200]!)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFF00ACC1))),
      ),
    );
  }

  // Widget ช่วยสร้างช่องกรอกรหัสผ่าน (มีปุ่มเปิด-ปิดตา)
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool isHidden,
    required VoidCallback toggleVisibility,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isHidden,
      validator: validator,
      style: GoogleFonts.prompt(),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.prompt(color: Colors.grey[400]),
        prefixIcon: const Icon(Icons.lock, color: Color(0xFF1976D2)),
        suffixIcon: IconButton(
          icon: Icon(isHidden ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
          onPressed: toggleVisibility,
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey[200]!)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey[200]!)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFF00ACC1))),
      ),
    );
  }
}