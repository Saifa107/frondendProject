import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FoodSearchScreen extends StatefulWidget {
  @override
  _FoodSearchScreenState createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen> {
  String searchQuery = "";
  String selectedCategory = "ทั้งหมด";

  final List<String> categories = ["ทั้งหมด", "ต้ม", "ผัด", "แกง", "ทอด"];

  // ข้อมูลจำลองอาหารทั้งหมด (อ้างอิงจาก model/food_Item.ts)
  final List<Map<String, dynamic>> allFoods = [
    {"id": 1, "name": "กะเพราหมูสับ", "category": "ผัด", "imageUrl": "https://images.unsplash.com/photo-1626804475297-41609ea004eb?w=500"},
    {"id": 2, "name": "ต้มยำกุ้ง", "category": "ต้ม", "imageUrl": "https://images.unsplash.com/photo-1548943487-a2e4f43b4850?w=500"},
    {"id": 3, "name": "ไก่ทอดกระเทียม", "category": "ทอด", "imageUrl": "https://images.unsplash.com/photo-1626645738196-c2a7c87a8f58?w=500"},
    {"id": 4, "name": "แกงเขียวหวาน", "category": "แกง", "imageUrl": "https://images.unsplash.com/photo-1548943487-a2e4f43b4850?w=500"},
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredList = allFoods.where((item) {
      bool matchesSearch = item['name'].toString().contains(searchQuery);
      bool matchesCategory = selectedCategory == "ทั้งหมด" || item['category'] == selectedCategory;
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
        title: Text("ค้นหาเมนูอาหาร", style: GoogleFonts.prompt(color: const Color(0xFF0D47A1), fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                hintText: "พิมพ์ชื่อเมนูที่ต้องการค้นหา...",
                hintStyle: GoogleFonts.prompt(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF1976D2)),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              ),
            ),
          ),

          // 2. แถบแยกประเภท
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
                    selectedColor: const Color(0xFF0D47A1), // Navy Blue
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
                ? Center(child: Text("ไม่พบเมนูอาหาร", style: GoogleFonts.prompt(color: Colors.grey)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        clipBehavior: Clip.antiAlias,
                        child: Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl: item['imageUrl'],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['name'], style: GoogleFonts.prompt(fontSize: 16, fontWeight: FontWeight.bold)),
                                  Text("หมวดหมู่: ${item['category']}", style: GoogleFonts.prompt(color: Colors.grey, fontSize: 13)),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.favorite_border, color: Colors.pink, size: 28),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("เพิ่มลงรายการโปรดแล้ว")));
                              },
                            ),
                            const SizedBox(width: 10),
                          ],
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