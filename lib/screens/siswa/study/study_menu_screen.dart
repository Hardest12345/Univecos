import 'package:flutter/material.dart';
import 'package:univecos/screens/siswa/study/merancang_proyek_screen.dart';
import 'capaian_screen.dart';
import 'orientasi_screen.dart';
import 'organizer_screen.dart';
import 'merancang_proyek_screen.dart';
import 'assessment_screen.dart';

class StudyMenuScreen extends StatelessWidget {
  const StudyMenuScreen({super.key});

  final List<Map<String, dynamic>> studyMenu = const [
    {
      "title": "Orientasi dan Formulasi Masalah",
      // "subtitle": "Orfanbach dan Formulas (Masalah)",
      "icon": Icons.explore,
      "route": "orientasi",
      "phase": 1,
      "color": Color(0xFF00707E)
    },
    {
      "title": "Mengorganisasi Siswa untuk Belajar",
      // "subtitle": "Mengorganisasi Siswa untuk\nBelajar",
      "icon": Icons.people,
      "route": "organizer",
      "phase": 2,
      "color": Color(0xFF4CAF50)
    },
    {
      "title": "Merancang & Melaksanakan Proyek",
      // "subtitle": "Merancang dan Melaksanakan\nProyek",
      "icon": Icons.lightbulb,
      "route": "proyek",
      "phase": 3,
      "color": Color(0xFFFF9800)
    },
    {
      "title": "Menyajikan Hasil dan Evaluasi",
      // "subtitle": "Menyajikan Hasil dan Evaluasi",
      "icon": Icons.check_circle,
      "route": "assessment",
      "phase": 4,
      "color": Color(0xFFF44336)
    },
    // {
    //   "title": "Capaian Belajar",
    //   // "subtitle": "Pencapaian Hasil Belajar",
    //   "icon": Icons.flag,
    //   "route": "capaian",
    //   "phase": 5,
    //   "color": Color(0xFF9C27B0)
    // },
  ];

  void _navigateToStudy(BuildContext context, String route) {
    if (route == "capaian") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CapaianScreen()),
      );
    } else if (route == "orientasi") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const OrientasiScreen()),
      );
    } else if (route == "organizer") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const OrganizerScreen()),
      );
    } else if (route == "proyek") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MerancangProyekScreen()),
      );
    } else if (route == "assessment") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AssessmentScreen()),
      );
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    const Text(
                      "Let's Study",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Menu Grid
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
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
                        // Icon menu_book di atas teks Fase Pembelajaran
                        const Center(
                          child: Icon(
                            Icons.menu_book,
                            size: 40,
                            color: Color(0xFF00707E),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Center(
                          child: Text(
                            'Fase Pembelajaran',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00707E),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.85,
                            ),
                            itemCount: studyMenu.length,
                            itemBuilder: (context, index) {
                              final item = studyMenu[index];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 4,
                                child: InkWell(
                                  onTap: () => _navigateToStudy(context, item['route']!),
                                  borderRadius: BorderRadius.circular(20),
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
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Badge nomor fase
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            'Fase ${item['phase']}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Center(
                                          child: Icon(
                                            item['icon'],
                                            size: 32,
                                            color: Colors.white,
                                          ),
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
                                          maxLines: 2,
                                        ),
                                        const SizedBox(height: 4),
                                        // Text(
                                        //   // item['subtitle'],
                                        //   style: TextStyle(
                                        //     color: Colors.white.withOpacity(0.9),
                                        //     fontSize: 10,
                                        //   ),
                                        //   textAlign: TextAlign.center,
                                        //   maxLines: 2,
                                        // ),
                                      ],
                                    ),
                                  ),
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