import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../guru/guru_orientasi_screen.dart';
import '../guru/guru_organisasi_screen.dart';
import '../guru/guru_proyek_screen.dart';
import '../guru/guru_evaluasi_screen.dart';
import '../guru/guru_test_result_screen.dart';
import '../guru/make_report_screen.dart';

class GuruDiscussForumScreen extends StatefulWidget {
  final String kelas;
  const GuruDiscussForumScreen({super.key, required this.kelas});

  @override
  State<GuruDiscussForumScreen> createState() => _GuruDiscussForumScreenState();
}

class _GuruDiscussForumScreenState extends State<GuruDiscussForumScreen> {
  final supabase = Supabase.instance.client;

  final List<Map<String, dynamic>> menu = const [
    {
      "title": "Diskusi Orientasi",
      "icon": Icons.explore,
      "color": Color(0xFF00707E),
      "description": "Pantau diskusi orientasi siswa",
    },
    {
      "title": "Organisasi Tim",
      "icon": Icons.group,
      "color": Color(0xFF4CAF50),
      "description": "Lihat organisasi tim siswa",
    },
    {
      "title": "Diskusi Proyek",
      "icon": Icons.lightbulb,
      "color": Color(0xFFFF9800),
      "description": "Pantau diskusi proyek tim",
    },
    {
      "title": "Evaluasi Nilai",
      "icon": Icons.assessment,
      "color": Color(0xFF9C27B0),
      "description": "Lihat evaluasi nilai siswa",
    },
  ];

  void _navigateToScreen(String menuType, String kelas) {
    switch (menuType) {
      case "orientasi":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GuruOrientasiScreen(kelas: kelas)),
        );
        break;
      case "organisasi":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GuruOrganisasiScreen(kelas: kelas)),
        );
        break;
      case "proyek":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GuruProyekScreen(kelas: kelas)),
        );
        break;
      case "evaluasi":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GuruEvaluasiScreen(kelas: kelas)),
        );
        break;
    }
  }

  void _handleMenuTap(String title) {
    switch (title) {
      case "Diskusi Orientasi":
        _navigateToScreen("orientasi", widget.kelas);
        break;
      case "Organisasi Tim":
        _navigateToScreen("organisasi", widget.kelas);
        break;
      case "Diskusi Proyek":
        _navigateToScreen("proyek", widget.kelas);
        break;
      case "Evaluasi Nilai":
        _navigateToScreen("evaluasi", widget.kelas);
        break;
      default:
        break;
    }
  }

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
            children: [
              // Header dengan tombol back
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Forum Diskusi - ${widget.kelas}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // Konten utama
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Icon(
                            Icons.forum,
                            size: 48,
                            color: Color(0xFF00707E),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Center(
                          child: Text(
                            "Menu Diskusi",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00707E),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Pilih jenis diskusi yang ingin dipantau:",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        
                        // Menu Flex yang rapi
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // Row 1
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildMenuCard(menu[0]),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildMenuCard(menu[1]),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                // Row 2
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildMenuCard(menu[2]),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildMenuCard(menu[3]),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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

  Widget _buildMenuCard(Map<String, dynamic> item) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: InkWell(
        onTap: () => _handleMenuTap(item['title']),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                item['color'],
                item['color'].withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                item['icon'],
                size: 36,
                color: Colors.white,
              ),
              const SizedBox(height: 12),
              Text(
                item['title'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                item['description'],
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}