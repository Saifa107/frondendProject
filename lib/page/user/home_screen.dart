import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';

// จำเป็นต้อง import ไฟล์เหล่านี้เพื่อให้ปุ่มกดลิงก์ไปถูกหน้า
import 'recommendation_screen.dart'; 
import '../search/food_search_screen.dart';   
import '../search/ingredient_search_screen.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // -----------------------------------------------------
  // ส่วนตั้งค่า Mock Data (ทดลองเปลี่ยนเป็น [] เพื่อดูหน้าจอตอนที่ไม่มีข้อมูลได้)
  // -----------------------------------------------------
  
  // ทดลองเปลี่ยนเป็น [] เพื่อดูสถานะ "ไม่มีเมนูแนะนำ"
  
  final List<String> recommendFoods = ["ต้มยำกุ้งน้ำข้น", "ผัดกะเพราหมูสับ", "ข้าวผัดทะเล"];

  // ทดลองเปลี่ยนเป็น [] เพื่อดูสถานะ "ไม่มีวัตถุดิบในคลัง"
   
  final List<Map<String, dynamic>> myIngredients = [
    {"name": "ไข่ไก่", "icon": Icons.egg_alt},
    {"name": "เนื้อหมู", "icon": Icons.set_meal},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. ส่วนหัว (Header)
              _buildHeader(),
              const SizedBox(height: 20),

              // 2. ส่วนปุ่มค้นหาด่วน (Quick Search)
              Text("ค้นหาด่วน", style: GoogleFonts.prompt(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildQuickSearchButton(
                    context, 
                    "ค้นหาอาหาร", 
                    Icons.restaurant_menu, 
                    const Color(0xFF1976D2), 
                    FoodSearchScreen()
                  ),
                  const SizedBox(width: 15),
                  _buildQuickSearchButton(
                    context, 
                    "ค้นหาวัตถุดิบ", 
                    Icons.shopping_basket, 
                    const Color(0xFF00ACC1), 
                    IngredientSearchScreen()
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // 3. ส่วน Carousel เมนูแนะนำ
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("เมนูแนะนำสำหรับคุณ", style: GoogleFonts.prompt(fontSize: 18, fontWeight: FontWeight.bold)),
                  if (recommendFoods.isNotEmpty) // โชว์ปุ่ม "ดูทั้งหมด" เฉพาะตอนที่มีข้อมูล
                    TextButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RecommendationScreen())),
                      child: Text("ดูทั้งหมด", style: GoogleFonts.prompt(color: const Color(0xFF00ACC1))),
                    ),
                ],
              ),
              const SizedBox(height: 15),
              // ตรวจสอบว่ามีข้อมูลหรือไม่ เพื่อแสดง Empty State หรือ Carousel
              recommendFoods.isEmpty 
                  ? _buildEmptyRecommendCard(context) 
                  : _buildCarouselSlider(),
              const SizedBox(height: 30),

              // 4. ส่วนรายการวัตถุดิบในคลัง
              _buildHorizontalIngredients(context),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // WIDGET HELPERS (ส่วนช่วยสร้าง UI ย่อย)
  // ==========================================

  // --- Widget: Header ส่วนหัว ---
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "สวัสดี, คุณผู้ใช้ 👋",
          style: GoogleFonts.prompt(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF0D47A1)),
        ),
        const CircleAvatar(
          backgroundColor: Color(0xFFE0F7FA), 
          child: Icon(Icons.person, color: Color(0xFF00ACC1))
        ),
      ],
    );
  }

  // --- Widget: ปุ่มค้นหาด่วน ---
  Widget _buildQuickSearchButton(BuildContext context, String label, IconData icon, Color color, Widget destination) {
    return Expanded(
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => destination)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(height: 8),
              Text(label, style: GoogleFonts.prompt(color: color, fontWeight: FontWeight.w600, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget: กรณี "ไม่มี" เมนูแนะนำ ---
  Widget _buildEmptyRecommendCard(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.no_food_outlined, size: 50, color: Colors.grey[400]),
          const SizedBox(height: 10),
          Text(
            "ยังไม่มีวัตถุดิบพอที่จะแนะนำเมนู",
            style: GoogleFonts.prompt(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 15),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00ACC1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            icon: const Icon(Icons.add, size: 16, color: Colors.white),
            label: Text("ไปเพิ่มวัตถุดิบเลย", style: GoogleFonts.prompt(color: Colors.white, fontSize: 14)),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => IngredientSearchScreen())),
          )
        ],
      ),
    );
  }

  // --- Widget: Carousel (เมื่อมีเมนูแนะนำ) ---
  Widget _buildCarouselSlider() {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RecommendationScreen())),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 180.0,
          enlargeCenterPage: true,
          autoPlay: true,
          viewportFraction: 0.85,
        ),
        items: recommendFoods.map((foodName) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: const LinearGradient(
                colors: [Color(0xFF1976D2), Color(0xFF00ACC1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                foodName,
                textAlign: TextAlign.center,
                style: GoogleFonts.prompt(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- Widget: ส่วนแสดงรายการวัตถุดิบแนวนอน ---
  Widget _buildHorizontalIngredients(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("วัตถุดิบในคลังของคุณ", style: GoogleFonts.prompt(fontSize: 18, fontWeight: FontWeight.bold)),
            if (myIngredients.isNotEmpty)
              TextButton(
                onPressed: () {
                  // TODO: ลิงก์ไปหน้าคลังวัตถุดิบ (InventoryScreen)
                  
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => IngredientSearchScreen()),
                    );
                }, 
                child: Text("ดูทั้งหมด", style: GoogleFonts.prompt(color: const Color(0xFF00ACC1))),
              )
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: myIngredients.isEmpty
              ? _buildEmptyIngredientAction(context) // ถ้าว่างให้โชว์ปุ่มเพิ่ม
              : ListView.builder( // ถ้ามีข้อมูลให้โชว์เป็น List แนวนอน
                  scrollDirection: Axis.horizontal,
                  itemCount: myIngredients.length,
                  itemBuilder: (context, index) {
                    return _buildIngredientItemCard(myIngredients[index]);
                  },
                ),
        ),
      ],
    );
  }

  // --- Widget: ปุ่มเพิ่มวัตถุดิบ (เมื่อคลังว่าง) ---
  Widget _buildEmptyIngredientAction(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => IngredientSearchScreen())),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: const Color(0xFFE0F7FA).withOpacity(0.5),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFF00ACC1).withOpacity(0.5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_circle_outline, color: Color(0xFF00ACC1), size: 35),
            const SizedBox(height: 8),
            Text("เพิ่มวัตถุดิบเลย", style: GoogleFonts.prompt(fontSize: 14, color: const Color(0xFF0D47A1), fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // --- Widget: การ์ดแสดงไอเทมวัตถุดิบเดี่ยว ---
  Widget _buildIngredientItemCard(Map<String, dynamic> item) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(item['icon'] ?? Icons.fastfood, color: Colors.orange, size: 35),
          const SizedBox(height: 5),
          Text(item['name'] ?? "", style: GoogleFonts.prompt(fontSize: 12)),
        ],
      ),
    );
  }
}