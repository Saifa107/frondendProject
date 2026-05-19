import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FoodDetailScreen extends StatelessWidget {
  final Map<String, dynamic> foodData;

  const FoodDetailScreen({Key? key, required this.foodData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // ส่วนหัวเป็นรูปภาพที่สามารถเลื่อนแล้วหดได้
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            backgroundColor: const Color(0xFF1976D2),
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: foodData['imageUrl'] ?? "https://via.placeholder.com/400",
                fit: BoxFit.cover,
              ),
            ),
            leading: IconButton(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
                child: Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          
          // เนื้อหารายละเอียดด้านล่าง
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          foodData['name'] ?? "ชื่อเมนู",
                          style: GoogleFonts.prompt(fontSize: 28, fontWeight: FontWeight.bold, color: const Color(0xFF0D47A1)),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite_border, color: Colors.pink, size: 30),
                        onPressed: () { /* TODO: เพิ่มลง FoodMark */ },
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text("เนื้อหา / คำอธิบาย:", style: GoogleFonts.prompt(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(
                    "เมนูยอดฮิตทำง่าย ได้โปรตีนสูง เหมาะสำหรับมื้อเที่ยงและมื้อเย็น (ข้อความจำลอง)",
                    style: GoogleFonts.prompt(fontSize: 15, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 20),
                  
                  // ตารางวัตถุดิบ
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(color: const Color(0xFFE0F7FA), borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ตารางวัตถุดิบที่ต้องใช้", style: GoogleFonts.prompt(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF00ACC1))),
                        const Divider(),
                        _buildIngredientRow("หมูสับ", "200 กรัม", true), // true = มีในคลัง
                        _buildIngredientRow("ใบกะเพรา", "1 กำ", false),  // false = ขาดวัตถุดิบนี้
                        _buildIngredientRow("พริก/กระเทียม", "ตามชอบ", true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // วิธีทำ
                  Text("วิธีการปรุง:", style: GoogleFonts.prompt(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text("1. ตั้งกระทะให้ร้อน ใส่น้ำมันและกระเทียมพริกที่โขลกไว้ลงไปผัดจนหอม\n2. ใส่เนื้อสัตว์ลงไปผัดจนสุก\n3. ปรุงรสตามใจชอบ แล้วใส่ใบกะเพรา ผัดเร็วๆ ปิดไฟ", 
                    style: GoogleFonts.prompt(fontSize: 15, height: 1.5),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildIngredientRow(String name, String amount, bool isAvailable) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(isAvailable ? Icons.check_circle : Icons.cancel, color: isAvailable ? Colors.green : Colors.red, size: 18),
              const SizedBox(width: 10),
              Text(name, style: GoogleFonts.prompt(fontSize: 15)),
            ],
          ),
          Text(amount, style: GoogleFonts.prompt(fontSize: 15, color: Colors.grey[700])),
        ],
      ),
    );
  }
}