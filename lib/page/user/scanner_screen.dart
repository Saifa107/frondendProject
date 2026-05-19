import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // พื้นหลังสีดำเหมือนเปิดกล้อง
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 30),
          onPressed: () => Navigator.pop(context), // ปิดหน้าสแกน
        ),
      ),
      body: Stack(
        children: [
          // ตรงนี้ในอนาคตจะนำ Package 'camera' มาใส่เพื่อให้เห็นภาพจากกล้องจริง
          Center(
            child: Container(
              width: 300,
              height: 400,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF00ACC1), width: 3), // กรอบสี Cyan สำหรับเล็ง
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text("พื้นที่สแกนภาพกล้อง", style: GoogleFonts.prompt(color: Colors.white54)),
              ),
            ),
          ),
          
          // ข้อความแนะนำ
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Text(
              "จัดวัตถุดิบให้อยู่ในกรอบเพื่อสแกน",
              textAlign: TextAlign.center,
              style: GoogleFonts.prompt(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // ปุ่มกดถ่ายภาพด้านล่าง
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  // แสดง Dialog แจ้งผลการสแกนจำลอง
                  _showResultDialog(context);
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    color: const Color(0xFF1976D2), // สี Navy Blue
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 40),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Popup สำหรับให้ผู้ใช้เลือกว่าจะบันทึกหรือทิ้ง
  void _showResultDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text("สแกนสำเร็จ!", style: GoogleFonts.prompt(color: const Color(0xFF0D47A1), fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.fastfood, size: 60, color: Colors.orange),
            const SizedBox(height: 15),
            Text("ระบบตรวจพบ: 'แครอท' 1 ชิ้น", style: GoogleFonts.prompt(fontSize: 16)),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // ปิด Dialog (ลองใหม่)
            },
            child: Text("ละทิ้ง / ลองใหม่", style: GoogleFonts.prompt(color: Colors.red)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00ACC1)),
            onPressed: () {
              // TODO: ส่งข้อมูล 'แครอท' กลับไปเพิ่มในหน้าคลังวัตถุดิบ (API)
              Navigator.pop(context); // ปิด Dialog
              Navigator.pop(context); // กลับหน้าหลัก
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("บันทึกลงคลังสำเร็จ")));
            },
            child: Text("เก็บไว้", style: GoogleFonts.prompt(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}