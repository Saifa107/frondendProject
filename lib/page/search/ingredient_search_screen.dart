import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class IngredientSearchScreen extends StatefulWidget {
  @override
  _IngredientSearchScreenState createState() => _IngredientSearchScreenState();
}

class _IngredientSearchScreenState extends State<IngredientSearchScreen> {
  String searchQuery = "";
  String selectedCategory = "ทั้งหมด";

  // หมวดหมู่สำหรับตัวกรอง
  final List<String> categories = ["ทั้งหมด", "เนื้อสัตว์", "ผัก", "เครื่องปรุง", "ผลไม้"];

  // ข้อมูลจำลองวัตถุดิบทั้งหมดในระบบ (อ้างอิงจาก model/Ingredient_Item.ts)
  final List<Map<String, dynamic>> allIngredients = [
    {"ing_id": 1, "ing_name": "หมูสับ", "ing_category": "เนื้อสัตว์", "ing_image": "https://cdn-icons-png.flaticon.com/512/3143/3143645.png"},
    {"ing_id": 2, "ing_name": "กะหล่ำปลี", "ing_category": "ผัก", "ing_image": "https://cdn-icons-png.flaticon.com/512/2153/2153788.png"},
    {"ing_id": 3, "ing_name": "ซีอิ๊วขาว", "ing_category": "เครื่องปรุง", "ing_image": "https://cdn-icons-png.flaticon.com/512/7235/7235422.png"},
    {"ing_id": 4, "ing_name": "ไก่ชิ้น", "ing_category": "เนื้อสัตว์", "ing_image": "https://cdn-icons-png.flaticon.com/512/1041/1041369.png"},
  ];

  @override
  Widget build(BuildContext context) {
    // กรองข้อมูลตาม Search Bar และ หมวดหมู่
    List<Map<String, dynamic>> filteredList = allIngredients.where((item) {
      bool matchesSearch = item['ing_name'].toString().contains(searchQuery);
      bool matchesCategory = selectedCategory == "ทั้งหมด" || item['ing_category'] == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF0D47A1)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("ค้นหาและเพิ่มวัตถุดิบ", style: GoogleFonts.prompt(color: const Color(0xFF0D47A1), fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                hintText: "ค้นหาวัตถุดิบ...",
                hintStyle: GoogleFonts.prompt(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF1976D2)),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              ),
            ),
          ),

          // 2. แถบแยกประเภท (Category Filter)
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                String category = categories[index];
                bool isSelected = selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ChoiceChip(
                    label: Text(category, style: GoogleFonts.prompt(color: isSelected ? Colors.white : Colors.black87)),
                    selected: isSelected,
                    selectedColor: const Color(0xFF00ACC1),
                    backgroundColor: Colors.grey[200],
                    onSelected: (selected) => setState(() => selectedCategory = category),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),

          // 3. รายการผลการค้นหา
          Expanded(
            child: filteredList.isEmpty
                ? Center(child: Text("ไม่พบวัตถุดิบที่ค้นหา", style: GoogleFonts.prompt(color: Colors.grey)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      return Card(
                        elevation: 0,
                        color: Colors.grey[50],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(color: const Color(0xFFE0F7FA), borderRadius: BorderRadius.circular(8)),
                            child: CachedNetworkImage(imageUrl: item['ing_image'], width: 40, height: 40),
                          ),
                          title: Text(item['ing_name'], style: GoogleFonts.prompt(fontWeight: FontWeight.w500)),
                          subtitle: Text(item['ing_category'], style: GoogleFonts.prompt(color: Colors.grey, fontSize: 12)),
                          trailing: IconButton(
                            icon: const Icon(Icons.add_circle, color: Color(0xFF1976D2)),
                            onPressed: () {
                              // TODO: ส่งข้อมูลกลับไป หรือ บันทึกลงคลังผ่าน API
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("เพิ่ม ${item['ing_name']} แล้ว")));
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}