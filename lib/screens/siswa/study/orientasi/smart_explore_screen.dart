import 'package:flutter/material.dart';
import 'point_detail_screen.dart';

class SmartExploreEcosystemScreen extends StatelessWidget {
  const SmartExploreEcosystemScreen({super.key});

  // Hardcode data point
  final List<Map<String, String>> points = const [
    {
      "title": "Point 1",
      "image": "assets/images/map_1.png",
      "description": "Eksplorasi awal ekosistem mulai dari dasar perkenalan.",
    },
    {
      "title": "Point 2",
      "image": "assets/images/map_1.png",
      "description": "Tahap pengembangan menuju pemahaman yang lebih dalam.",
    },
    {
      "title": "Point 3",
      "image": "assets/images/map_1.png",
      "description": "Penerapan konsep dalam aktivitas sehari-hari.",
    },
    {
      "title": "Point 4",
      "image": "assets/images/map_1.png",
      "description":
          "Kolaborasi dengan ekosistem sekitar untuk hasil lebih besar.",
    },
    {
      "title": "Point 5",
      "image": "assets/images/map_1.png",
      "description": "Inovasi dan keberlanjutan dalam Smart Ecosystem.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00707E), Color(0xFFA9F67F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header dengan tombol back
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 16),
                    Text(
                      "Smart Explore Ecosystem",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Gambar utama peta
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      "assets/images/map.png",
                      fit: BoxFit.cover, // supaya isi penuh
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.55,
                      // 40% dari tinggi layar, bisa diganti 0.5 biar lebih besar
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),

              // List point
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ecosystem Points",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00707E),
                          ),
                        ),
                        SizedBox(height: 16),
                        Expanded(
                          child: ListView.separated(
                            itemCount: points.length,
                            separatorBuilder:
                                (context, index) => SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final point = points[index];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(16),
                                  leading: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                        image: AssetImage(point["image"]!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    point["title"]!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFF00707E),
                                    ),
                                  ),
                                  subtitle: Text(
                                    point["description"]!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[700],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Color(0xFF00707E),
                                    size: 16,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => PointDetailScreen(
                                              title: point["title"]!,
                                              image: point["image"]!,
                                              description:
                                                  point["description"]!,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
