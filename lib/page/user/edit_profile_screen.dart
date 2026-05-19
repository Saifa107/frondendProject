import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';


class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // จำลองข้อมูลเดิมที่ดึงมาจาก API
  final TextEditingController _nameController = TextEditingController(text: "ชื่อผู้ใช้งาน ทดสอบ");
  final TextEditingController _passwordController = TextEditingController(); // เว้นว่างไว้หากไม่ต้องการเปลี่ยน

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
        title: Text("แก้ไขข้อมูลส่วนตัว", style: GoogleFonts.prompt(color: const Color(0xFF0D47A1), fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 1. ส่วนแก้ไขรูปโปรไฟล์
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF1976D2), width: 3),
                    ),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: เปิด Gallery หรือ Camera เพื่อเลือกรูปใหม่
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(color: Color(0xFF00ACC1), shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 40),

            // 2. ฟอร์มกรอกข้อมูล
            _buildTextField("ชื่อ-นามสกุล", Icons.person, _nameController),
            const SizedBox(height: 20),
            _buildTextField("รหัสผ่านใหม่ (หากต้องการเปลี่ยน)", Icons.lock, _passwordController, isPassword: true),
            const SizedBox(height: 40),

            // 3. ปุ่มบันทึกข้อมูล
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  // TODO: ส่งข้อมูล _nameController.text ไปอัปเดตที่ Node.js Backend
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("บันทึกข้อมูลเรียบร้อยแล้ว", style: GoogleFonts.prompt())),
                  );
                  Navigator.pop(context);
                },
                child: Text("บันทึกการเปลี่ยนแปลง", style: GoogleFonts.prompt(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController controller, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.prompt(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[800])),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword && isPasswordHidden,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF1976D2)),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(isPasswordHidden ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                    onPressed: () => setState(() => isPasswordHidden = !isPasswordHidden),
                  )
                : null,
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}