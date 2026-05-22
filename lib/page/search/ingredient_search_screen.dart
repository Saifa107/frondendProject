import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

import '../../config/config.dart';
import '../../service/auth_service.dart';
import '../detail/ingredient_detail_screen.dart';

class IngredientSearchScreen extends StatefulWidget {
  const IngredientSearchScreen({super.key});

  @override
  _IngredientSearchScreenState createState() => _IngredientSearchScreenState();
}

class _IngredientSearchScreenState extends State<IngredientSearchScreen> {
  String searchQuery = "";
  
  // ⭐️ 1. เปลี่ยนตัวแปรสำหรับเก็บหมวดหมู่ที่ถูกเลือก ให้เก็บเป็น ID แทนชื่อ (0 = ทั้งหมด)
  int selectedCategoryId = 0; 
  bool _isLoading = true; 

  // ⭐️ 2. เปลี่ยนให้เก็บ Map แทน String เพื่อเก็บทั้ง ing_type_id และ ing_type_name
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> allIngredients = [];

  @override
  void initState() {
    super.initState();
    _loadAllData(); 
  }

  Future<void> _loadAllData() async {
    setState(() => _isLoading = true);
    
    await Future.wait([
      _fetchCategories(),
      _fetchIngredients(),
    ]);

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  // ==========================================
  // ⭐️ 3. ฟังก์ชันดึงหมวดหมู่ และยัด "ทั้งหมด" ไว้เป็นอันดับแรก
  // ==========================================
  Future<void> _fetchCategories() async {
    try {
      final config = await Configuration.getConfig();
      final apiEndpoint = config['apiEndpoint'];
      final String? token = await AuthService.getToken();

      final response = await http.get(
        Uri.parse("$apiEndpoint/ingredient/types/all"), // ตรวจสอบเส้น API ของคุณ
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          // ใส่ "ทั้งหมด" เป็นค่าเริ่มต้น โดยให้ ID = 0 (เพราะ Database มักจะเริ่มที่ 1)
          categories = [
            {"ing_type_id": 0, "ing_type_name": "ทั้งหมด"}
          ];
          
          // นำข้อมูลจาก API มาต่อท้าย
          categories.addAll(List<Map<String, dynamic>>.from(data));
        });
      }
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  // ==========================================
  // ฟังก์ชันดึงรายการวัตถุดิบ 
  // ==========================================
  Future<void> _fetchIngredients() async {
    try {
      final config = await Configuration.getConfig();
      final apiEndpoint = config['apiEndpoint'];
      final String? token = await AuthService.getToken();

      final response = await http.get(
        Uri.parse("$apiEndpoint/ingredient"), // ตรวจสอบเส้น API ของคุณ
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          allIngredients = List<Map<String, dynamic>>.from(data);
        });
      } else {
        _showSnackBar("ไม่สามารถดึงข้อมูลวัตถุดิบได้");
      }
    } catch (e) {
      _showSnackBar("เชื่อมต่อเซิร์ฟเวอร์ไม่ได้: $e");
    }
  }

  // ==========================================
  // ⭐️ 4. ฟังก์ชันตัวช่วย: แปลง ID เป็นชื่อหมวดหมู่
  // ==========================================
  String _getCategoryName(int typeId) {
    // ค้นหาใน list categories ว่า typeId ตรงกับอันไหน
    final cat = categories.firstWhere(
      (element) => element['ing_type_id'] == typeId, 
      orElse: () => {"ing_type_name": "ไม่ระบุหมวดหมู่"} // ถ้าหาไม่เจอ
    );
    return cat['ing_type_name'];
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: GoogleFonts.prompt()), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ⭐️ 5. อัปเดตตรรกะการกรองข้อมูล โดยเช็คจาก ing_type_id
    List<Map<String, dynamic>> filteredList = allIngredients.where((item) {
      bool matchesSearch = (item['ing_name'] ?? '').toString().toLowerCase().contains(searchQuery.toLowerCase());
      
      // ถ้าเลือก "ทั้งหมด" (ID=0) ให้ผ่านหมด แต่ถ้าไม่ใช่ ต้องดูว่า ing_type_id ตรงกันไหม
      bool matchesCategory = selectedCategoryId == 0 || item['ing_type_id'] == selectedCategoryId;
      
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
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : Column(
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
                final category = categories[index];
                final int catId = category['ing_type_id'];
                final String catName = category['ing_type_name'];
                
                // เช็คว่าหมวดหมู่นี้กำลังถูกเลือกอยู่หรือไม่ (เช็คจาก ID)
                bool isSelected = selectedCategoryId == catId;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ChoiceChip(
                    label: Text(catName, style: GoogleFonts.prompt(color: isSelected ? Colors.white : Colors.black87)),
                    selected: isSelected,
                    selectedColor: const Color(0xFF00ACC1),
                    backgroundColor: Colors.grey[200],
                    showCheckmark: false,
                    onSelected: (selected) => setState(() => selectedCategoryId = catId),
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
                      final String imageUrl = (item['ing_image'] != null && item['ing_image'].toString().isNotEmpty && item['ing_image'] != "-") 
                                              ? item['ing_image'] 
                                              : "https://cdn-icons-png.flaticon.com/512/3143/3143645.png"; 

                      // ⭐️ 6. นำ ing_type_id ไปหาชื่อหมวดหมู่ภาษาไทยมาโชว์
                      final String typeName = _getCategoryName(item['ing_type_id']);

                      return Card(
                        elevation: 0,
                        color: Colors.grey[50],
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => IngredientDetailScreen(ingredientId: item['ing_id']), 
                              ),
                            );
                          },
                          leading: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(color: const Color(0xFFE0F7FA), borderRadius: BorderRadius.circular(8)),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl, 
                              width: 40, 
                              height: 40,
                              errorWidget: (context, url, error) => const Icon(Icons.fastfood, color: Colors.grey),
                            ),
                          ),
                          title: Text(item['ing_name'] ?? 'ไม่ระบุชื่อ', style: GoogleFonts.prompt(fontWeight: FontWeight.w500)),
                          // แสดงชื่อหมวดหมู่ที่จับคู่มาได้แล้ว
                          subtitle: Text(typeName, style: GoogleFonts.prompt(color: Colors.grey, fontSize: 12)),
                          trailing: IconButton(
                            icon: const Icon(Icons.add_circle, color: Color(0xFF1976D2)),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("เพิ่ม ${item['ing_name']} แล้ว", style: GoogleFonts.prompt())),
                              );
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