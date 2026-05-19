import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../detail/food_detail_screen.dart';

class RecommendationScreen extends StatelessWidget {
  // ข้อมูลจำลองเมนูที่แนะนำ (อิงตามข้อมูลที่มีในคลัง)
  final List<Map<String, dynamic>> recommendedList = [
    {
      "name": "ผัดกะเพราไข่ดาว",
      "imageUrl": "https://images.unsplash.com/photo-1626804475297-41609ea004eb?w=500",
      "match_count": 3, // จำนวนวัตถุดิบที่ตรงกับในคลัง
      "total_ingredients": 5
    },
    {
      "name": "ไข่เจียวสมุนไพร",
      "imageUrl": "https://images.unsplash.com/photo-1598103442097-8b74394b95c6?w=500",
      "match_count": 2,
      "total_ingredients": 2
    },
  ];

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
          "เมนูที่ทำได้จากวัตถุดิบของคุณ",
          style: GoogleFonts.prompt(color: const Color(0xFF0D47A1), fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: recommendedList.length,
        itemBuilder: (context, index) {
          final food = recommendedList[index];
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FoodDetailScreen(foodData: food))),
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, spreadRadius: 2)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: CachedNetworkImage(
                      imageUrl: food['imageUrl'],
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(food['name'], style: GoogleFonts.prompt(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Text(
                          "คุณมีวัตถุดิบตรงกัน ${food['match_count']} จาก ${food['total_ingredients']} อย่าง",
                          style: GoogleFonts.prompt(
                            color: food['match_count'] == food['total_ingredients'] ? Colors.green : Colors.orange,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}