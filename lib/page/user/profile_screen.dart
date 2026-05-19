import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../user/edit_profile_screen.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Map<String, dynamic> currentUser = {
    "uid": 1,
    "u_name": "ชื่อผู้ใช้งาน ทดสอบ", 
    "u_profile": "https://cdn-icons-png.flaticon.com/512/3135/3135715.png", // URL รูปโปรไฟล์ (เช่น จาก Cloudinary)
    "u_role": "user"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // พื้นหลังสีเทาอ่อนให้การ์ดดูโดดเด่น
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              
              // 1. ส่วนแสดงรูปภาพโปรไฟล์และชื่อ
              Center(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF1976D2), width: 3), // กรอบสีน้ำเงิน
                          ),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: currentUser['u_profile'],
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(Icons.person, size: 60),
                            ),
                          ),
                        ),
                        // ไอคอนแก้ไขรูปภาพเล็กๆ มุมขวาล่าง
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFF00ACC1), // สี Cyan
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      currentUser['u_name'],
                      style: GoogleFonts.prompt(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D47A1), // สี Navy Blue
                      ),
                    ),
                    Text(
                      "สถานะ: ${currentUser['u_role'].toUpperCase()}",
                      style: GoogleFonts.prompt(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // 2. ส่วนเมนูการจัดการต่างๆ
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ]
                ),
                child: Column(
                  children: [
                    _buildProfileMenu(
                      icon: Icons.edit_document,
                      title: "แก้ไขข้อมูลส่วนตัว",
                      onTap: () {
                        // TODO: ไปหน้าแก้ไขโปรไฟล์
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),

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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.logout),
                    label: Text(
                      "ออกจากระบบ",
                      style: GoogleFonts.prompt(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      // TODO: เคลียร์ค่าต่างๆ และกลับไปหน้า Login
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

  // Widget ช่วยสร้างเมนูแต่ละบรรทัดให้โค้ดดูสะอาดขึ้น
  Widget _buildProfileMenu({required IconData icon, required String title, required VoidCallback onTap}) {
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
}