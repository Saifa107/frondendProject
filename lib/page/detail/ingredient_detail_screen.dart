import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';


class IngredientDetailScreen extends StatelessWidget {
  final Map<String, dynamic> ingredient;

  const IngredientDetailScreen({Key? key, required this.ingredient}) : super(key: key);

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
          "รายละเอียดวัตถุดิบ",
          style: GoogleFonts.prompt(color: const Color(0xFF0D47A1), fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. ส่วนแสดงรูปภาพวัตถุดิบ (ing_image)
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: const Color(0xFFE0F7FA),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(ingredient['ing_image'] ?? ""),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. หมวดหมู่ (ing_category)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00ACC1).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      ingredient['ing_category'] ?? "ไม่มีหมวดหมู่",
                      style: GoogleFonts.prompt(color: const Color(0xFF00ACC1), fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // 3. ชื่อวัตถุดิบ (ing_name)
                  Text(
                    ingredient['ing_name'] ?? "ชื่อวัตถุดิบ",
                    style: GoogleFonts.prompt(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D47A1),
                    ),
                  ),
                  const Divider(height: 40, thickness: 1),

                  // 4. รายละเอียด (ing_detail)
                  Text(
                    "ข้อมูลเพิ่มเติม:",
                    style: GoogleFonts.prompt(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    ingredient['ing_detail'] ?? "ไม่มีข้อมูลรายละเอียดสำหรับวัตถุดิบนี้",
                    style: GoogleFonts.prompt(fontSize: 16, color: Colors.grey[700], height: 1.6),
                  ),
                  
                  const SizedBox(height: 50),
                  
                  // ปุ่มลบวัตถุดิบออกจากคลัง (ตัวอย่าง)
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: ใส่ Logic สำหรับลบวัตถุดิบ
                      },
                      icon: const Icon(Icons.delete_outline),
                      label: Text("ลบออกจากคลังของคุณ", style: GoogleFonts.prompt(fontSize: 16)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}