import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../detail/ingredient_detail_screen.dart';
import '../search/ingredient_search_screen.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  String searchQuery = "";
  String selectedCategory = "ทั้งหมด";

  // รายการหมวดหมู่สำหรับตัวกรอง
  final List<String> categories = ["ทั้งหมด", "เนื้อสัตว์", "ผัก", "เครื่องปรุง", "ผลไม้"];
  // ข้อมูลจำลอง (Mock Data) สำหรับวัตถุดิบ
  List<Map<String, dynamic>> myIngredients = [
    {
      "id": "1",
      "name": "ไข่ไก่",
      "amount": 10,
      "unit": "ฟอง",
      "imageUrl": "https://cdn-icons-png.flaticon.com/512/837/837560.png"
    },
    {
      "id": "2",
      "name": "เนื้อหมูสามชั้น",
      "amount": 500,
      "unit": "กรัม",
      "imageUrl": "https://cdn-icons-png.flaticon.com/512/3143/3143645.png"
    },
    {
      "id": "3",
      "name": "ผักกาดขาว",
      "amount": 1,
      "unit": "หัว",
      "imageUrl": "https://cdn-icons-png.flaticon.com/512/2153/2153788.png"
    },
    {
      "id": "4",
      "name": "กระเทียม",
      "amount": 200,
      "unit": "กรัม",
      "imageUrl": "https://cdn-icons-png.flaticon.com/512/7235/7235422.png"
    },
  ];

  // ฟังก์ชันลบวัตถุดิบ
  void _deleteIngredient(int index) {
    setState(() {
      myIngredients.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ลบวัตถุดิบเรียบร้อยแล้ว', style: GoogleFonts.prompt()),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    // โค้ด Logic สำหรับกรองข้อมูลตามคำค้นหา และ ประเภทที่เลือก
    List<Map<String, dynamic>> filteredIngredients = myIngredients.where((item) {
      bool matchesSearch = item['ing_name'].toString().contains(searchQuery);
      bool matchesCategory = selectedCategory == "ทั้งหมด" || item['ing_category'] == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "คลังวัตถุดิบของฉัน",
                  style: GoogleFonts.prompt(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0D47A1), // Navy Blue
                  ),
                ),
                // ปุ่มเพิ่มวัตถุดิบแบบ Manual
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Color(0xFF00ACC1), size: 32), // Cyan
                  onPressed: () {
                    // TODO: เปิดหน้าต่าง/Popup สำหรับเพิ่มวัตถุดิบแบบกรอกเอง
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => IngredientSearchScreen()),
                    );
                  },
                )
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "วัตถุดิบทั้งหมด ${myIngredients.length} รายการ",
              style: GoogleFonts.prompt(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),

            // Search Bar สำหรับค้นหาในคลัง
            TextField(
              decoration: InputDecoration(
                hintText: "ค้นหาวัตถุดิบในคลัง...",
                hintStyle: GoogleFonts.prompt(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF1976D2)),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
            const SizedBox(height: 20),
            // [เพิ่มเข้ามาใหม่] แถบเลือกประเภทวัตถุดิบ
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
                      selectedColor: const Color(0xFF00ACC1), // สี Cyan มินิมอล
                      backgroundColor: Colors.grey[100],
                      onSelected: (selected) => setState(() => selectedCategory = category),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // รายการวัตถุดิบ (List)
            Expanded(
              child: myIngredients.isEmpty
                  ? Center(
                      child: Text(
                        "ยังไม่มีวัตถุดิบในคลัง\nกดสแกนหรือเพิ่มวัตถุดิบได้เลย",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.prompt(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: myIngredients.length,
                      itemBuilder: (context, index) {
                        final item = myIngredients[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          // ใช้ Slidable สำหรับปัดซ้ายเพื่อลบ
                          child: Slidable(
                            key: ValueKey(item['id']),
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) => _deleteIngredient(index),
                                  backgroundColor: const Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'ลบ',
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                ),
                              ],
                            ),
                            child: _buildIngredientCard(item),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget สำหรับสร้างการ์ดแสดงวัตถุดิบแต่ละชิ้น
  Widget _buildIngredientCard(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        // แก้ไขส่วนนี้: เมื่อคลิกที่รายการ
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => IngredientDetailScreen(ingredient: item),
          //   ),
          // );
        },
        leading: Container(
          width: 60,
          height: 60,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFE0F7FA), // Light Cyan background
            borderRadius: BorderRadius.circular(12),
          ),
          // จำลองการโหลดภาพจาก URL (ถ้ามี URL จริงจาก Cloudinary ให้เปลี่ยนตรงนี้)
          child: CachedNetworkImage(
            imageUrl: item['imageUrl'],
            placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 2),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        title: Text(
          item['name'],
          style: GoogleFonts.prompt(fontSize: 18, fontWeight: FontWeight.w500, color: const Color(0xFF0D47A1)),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            "คงเหลือ: ${item['amount']} ${item['unit']}",
            style: GoogleFonts.prompt(fontSize: 14, color: Colors.grey[600]),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: Colors.grey),
          onPressed: () {
            // TODO: เปิดหน้าต่างแก้ไขจำนวนวัตถุดิบ
          },
        ),
      ),
    );
  }
}