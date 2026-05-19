import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'admin_edit_profile_screen.dart';

class AdminProfileScreen extends StatefulWidget {
  @override
  _AdminProfileScreenState createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  // จำลองข้อมูลแอดมินที่ล็อกอินเข้าสู่ระบบ (อิงจาก user_model.ts)
  Map<String, dynamic> currentAdmin = {
    "uid": 2,
    "u_name": "ผู้ดูแลระบบ หลัก", 
    "u_profile": "https://cdn-icons-png.flaticon.com/512/3135/3135768.png",
    "u_role": "admin"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        automaticallyImplyLeading: false, // ซ่อนปุ่มย้อนกลับเพราะเป็นหน้าหลักของ Bottom Nav
        title: Text(
          "โปรไฟล์ผู้ดูแลระบบ",
          style: GoogleFonts.prompt(color: const Color(0xFF0D47A1), fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              // 1. ส่วนแสดงรูปภาพโปรไฟล์แอดมิน
              Center(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF1976D2), width: 4), // กรอบสีน้ำเงินหนาขึ้น
                            boxShadow: [
                              BoxShadow(color: const Color(0xFF1976D2).withOpacity(0.2), blurRadius: 15, spreadRadius: 5)
                            ],
                          ),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: currentAdmin['u_profile'],
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(Icons.admin_panel_settings, size: 60),
                            ),
                          ),
                        ),
                        // ไอคอนโล่บ่งบอกความเป็น Admin
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0D47A1), // Navy Blue
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.admin_panel_settings, color: Colors.white, size: 22),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      currentAdmin['u_name'],
                      style: GoogleFonts.prompt(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D47A1),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00ACC1).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "สิทธิ์การใช้งาน: ${currentAdmin['u_role'].toUpperCase()}",
                        style: GoogleFonts.prompt(fontSize: 14, color: const Color(0xFF00ACC1), fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // 2. ส่วนเมนูการตั้งค่าและจัดการ
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, spreadRadius: 2)
                  ]
                ),
                child: Column(
                  children: [
                    _buildAdminMenu(
                      icon: Icons.manage_accounts,
                      title: "แก้ไขข้อมูลส่วนตัว",
                      onTap: () {
                        // TODO: ไปหน้าแก้ไขข้อมูลส่วนตัวของแอดมิน
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminEditProfileScreen(adminData: currentAdmin),
                          ),
                        );

                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),

              // 3. ปุ่มออกจากระบบ
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFEBEE), // พื้นหลังสีแดงอ่อน
                      foregroundColor: Colors.red[700], // ตัวหนังสือสีแดง
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.logout),
                    label: Text(
                      "ออกจากระบบผู้ดูแล",
                      style: GoogleFonts.prompt(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      _showLogoutDialog(context);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Widget ช่วยสร้างเมนูแต่ละบรรทัดให้โค้ดดูสะอาด
  Widget _buildAdminMenu({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFE0F7FA), // สี Cyan อ่อนๆ
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFF00ACC1)),
      ),
      title: Text(
        title,
        style: GoogleFonts.prompt(fontSize: 16, color: Colors.black87),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  // Popup ยืนยันการออกจากระบบ
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text("ออกจากระบบ?", style: GoogleFonts.prompt(fontWeight: FontWeight.bold, color: const Color(0xFF0D47A1))),
        content: Text("คุณต้องการออกจากระบบผู้ดูแลระบบใช่หรือไม่?", style: GoogleFonts.prompt()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("ยกเลิก", style: GoogleFonts.prompt(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              // TODO: เคลียร์ Token และเด้งกลับไปหน้า LoginScreen
              Navigator.pop(context); // ปิด Dialog
            },
            child: Text("ออกจากระบบ", style: GoogleFonts.prompt(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}