import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // ตั้งชื่อ Key สำหรับอ้างอิงตอนบันทึก
  static const String _tokenKey = 'jwt_token';
  static const String _roleKey = 'user_role';

  // 1. ฟังก์ชันสำหรับ "บันทึก" Token และ Role ลงเครื่อง (เรียกใช้ตอน Login ผ่าน)
  static Future<void> saveLoginData(String token, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_roleKey, role);
  }

  // 2. ฟังก์ชันสำหรับ "ดึง" Token ออกมาใช้ (เรียกใช้ตอนยิง API)
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // 3. ฟังก์ชันสำหรับ "ดึง" Role ออกมาใช้ (ใช้เช็คสิทธิ์ในหน้าต่างๆ)
  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  // 4. ฟังก์ชันสำหรับ "ลบ" ข้อมูลทิ้ง (เรียกใช้ตอนกด Logout)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_roleKey);
  }
}