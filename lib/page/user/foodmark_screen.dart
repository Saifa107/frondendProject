import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../detail/food_detail_screen.dart';
import '../search/food_search_screen.dart';

class FoodmarkScreen extends StatefulWidget {
  const FoodmarkScreen({super.key});

  @override
  State<FoodmarkScreen> createState() => _FoodmarkScreenState();
}

class _FoodmarkScreenState extends State<FoodmarkScreen> {
  String searchQuery = "";
  String selectedCategory = "ทั้งหมด";

  // รายการหมวดหมู่สำหรับตัวกรองเมนูอาหาร
  final List<String> categories = ["ทั้งหมด", "ต้ม", "ผัด", "แกง", "ทอด"];
  List<Map<String, dynamic>> favoriteFoods = [
    {
      "id": 1,
      "name": "กะเพราหมูสับ",
      "imageUrl": "https://images.unsplash.com/photo-1626804475297-41609ea004eb?w=500", // ตัวอย่างรูปจากเน็ต
      "time": "15 นาที"
    },
    {
      "id": 2,
      "name": "ต้มยำกุ้ง",
      "imageUrl": "https://images.unsplash.com/photo-1548943487-a2e4f43b4850?w=500",
      "time": "30 นาที"
    },
    {
      "id": 3,
      "name": "ต้มยำกุ้ง",
      "imageUrl": "https://images.unsplash.com/photo-1548943487-a2e4f43b4850?w=500",
      "time": "30 นาที"
    },
  ];
  @override
  Widget build(BuildContext context) {
    // โค้ด Logic สำหรับกรองข้อมูลอาหารตามคำค้นหา และ ประเภท
    List<Map<String, dynamic>> filteredFoods = favoriteFoods.where((item) {
      bool matchesSearch = item['name'].toString().contains(searchQuery);
      bool matchesCategory = selectedCategory == "ทั้งหมด" || item['category'] == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header และ ปุ่มเพิ่มอาหารแบบ Manual
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "รายการอาหารโปรด",
                    style: GoogleFonts.prompt(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D47A1), // Navy Blue
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Color(0xFF00ACC1), size: 32), // Cyan
                    onPressed: () {
                      // TODO: เปิดหน้าต่างสำหรับเลือกเพิ่มอาหารลงในรายการโปรด
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FoodSearchScreen()),
                        );
                    },
                  )
                ],
              ),
              const SizedBox(height: 10),
              
              // 3. จำนวนอาหารใน FoodMark
              Text(
                "รายการโปรดทั้งหมด ${favoriteFoods.length} เมนู",
                style: GoogleFonts.prompt(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 15),

              // [เพิ่มเข้ามาใหม่] แถบเลือกประเภทอาหาร
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    String category = categories[index];
                    bool isSelected = selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ChoiceChip(
                        label: Text(category, style: GoogleFonts.prompt(fontSize: 13, color: isSelected ? Colors.white : Colors.black87)),
                        selected: isSelected,
                        selectedColor: const Color(0xFF0D47A1), // สีหลักน้ำเงินเข้ม
                        backgroundColor: Colors.grey[100],
                        onSelected: (selected) => setState(() => selectedCategory = category),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),

              // รายการอาหาร (Grid View)
              Expanded(
                child: favoriteFoods.isEmpty
                    ? Center(
                        child: Text(
                          "ยังไม่มีเมนูที่ถูกใจ\nลองค้นหาและกดดาวได้เลย",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.prompt(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: favoriteFoods.length,
                        itemBuilder: (context, index) {
                          final food = favoriteFoods[index];
                          return _buildFoodCard(food, index);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget สำหรับสร้างการ์ดอาหาร
  Widget _buildFoodCard(Map<String, dynamic> food, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FoodDetailScreen(foodData: food)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: CachedNetworkImage(
                  imageUrl: food['imageUrl'],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => Container(color: Colors.grey[200]),
                  errorWidget: (context, url, error) => const Icon(Icons.restaurant),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food['name'],
                    style: GoogleFonts.prompt(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "⏱ ${food['time']}",
                        style: GoogleFonts.prompt(color: Colors.grey[600], fontSize: 12),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            favoriteFoods.removeAt(index);
                          });
                        },
                        child: const Icon(Icons.favorite, color: Colors.pink, size: 20),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}