
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../nav/main_navigation.dart';
import '../nav/admin_main_navigation.dart';
import '../page/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool isLoginMode = true; // ใช้สลับระหว่าง Login / Signup
  bool isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                isLoginMode ? "ยินดีต้อนรับกลับมา!" : "สร้างบัญชีใหม่",
                style: GoogleFonts.prompt(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0D47A1), // Navy Blue
                ),
              ),
              const SizedBox(height: 10),
              Text(
                isLoginMode 
                  ? "เข้าสู่ระบบเพื่อค้นหาเมนูอร่อยจากวัตถุดิบของคุณ" 
                  : "สมัครสมาชิกเพื่อเริ่มต้นจัดการคลังวัตถุดิบ",
                style: GoogleFonts.prompt(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 40),

              // ฟอร์มกรอกข้อมูล
              if (!isLoginMode) ...[
                _buildTextField("ชื่อ-นามสกุล", Icons.person),
                const SizedBox(height: 20),
              ],
              _buildTextField("อีเมล", Icons.email),
              const SizedBox(height: 20),
              _buildTextField("รหัสผ่าน", Icons.lock, isPassword: true),
              const SizedBox(height: 30),

              // ปุ่ม Login / Signup
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2), // Blue
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // TODO: นำข้อมูลไปเช็คกับ Backend Node.js
                    // ถ้าสำเร็จให้ย้ายไปหน้า MainNavigation
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainNavigation()),
                    );
                  },
                  child: Text(
                    isLoginMode ? "เข้าสู่ระบบ" : "สมัครสมาชิก",
                    style: GoogleFonts.prompt(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // สลับโหมด
              Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Text(
      "ยังไม่มีบัญชีใช่ไหม? ",
      style: GoogleFonts.prompt(color: Colors.grey[600], fontSize: 15),
    ),
    GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegisterScreen()),
        );
      },
      child: Text(
        "สมัครสมาชิก",
        style: GoogleFonts.prompt(
          color: const Color(0xFF00ACC1),
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ],
),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, IconData icon, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword && isPasswordHidden,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.prompt(color: Colors.grey[400]),
        prefixIcon: Icon(icon, color: const Color(0xFF1976D2)),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(isPasswordHidden ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                onPressed: () => setState(() => isPasswordHidden = !isPasswordHidden),
              )
            : null,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}