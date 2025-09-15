import 'package:flutter/material.dart';
import 'study_menu_screen.dart';

class CpTpScreen extends StatelessWidget {
  const CpTpScreen({super.key});

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Capaian & Tujuan Pembelajaran",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
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
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header konten
                        const Center(
                          child: Icon(
                            Icons.school,
                            size: 48,
                            color: Color(0xFF00707E),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Center(
                          child: Text(
                            "Capaian & Tujuan Pembelajaran",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00707E),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Pelajari capaian dan tujuan pembelajaran sebelum memulai aktivitas belajar",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),

                        // CP Section
                        _buildSectionHeader("Capaian Pembelajaran (CP)"),
                        const SizedBox(height: 12),
                        _buildCpList(),

                        const SizedBox(height: 24),

                        // TP Section
                        _buildSectionHeader("Tujuan Pembelajaran (TP)"),
                        const SizedBox(height: 12),
                        _buildTpList(),

                        const SizedBox(height: 32),

                        // Start Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const StudyMenuScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00707E),
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.play_arrow, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  "Mulai Pembelajaran",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
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

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF00707E),
      ),
    );
  }

  Widget _buildCpList() {
    final cpItems = [
      "Pemahaman IPA: Peserta didik memahami proses klasifikasi makhluk hidup; peranan virus, bakteri, dan jamur dalam kehidupan; ekosistem dan interaksi antarkomponen serta faktor yang mempengaruhi; dan pemanfaatan bioteknologi dalam berbagai bidang kehidupan.",
      "Keterampilan Proses: Peserta didik mampu mengamati, mempertanyakan, merencanakan, memproses, mengevaluasi dan refleksi, dan mengomunikasikan.", // "Menganalisis interaksi antara komponen biotik dan abiotik",
      // "Mengidentifikasi jenis-jenis ekosistem yang ada di lingkungan sekitar",
      // "Menerapkan konsep konservasi dalam kehidupan sehari-hari",
      // "Mengembangkan sikap peduli terhadap lingkungan hidup",
    ];

    return Column(
      children:
          cpItems.map((cp) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF00707E).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF00707E).withOpacity(0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF00707E),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      cp,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildTpList() {
    final tpItems = [
      "Melalui kegiatan pembelajaran dengan media UNIVECOS dan model Project Oriented Problem Based (POPBL):",
          "1. Peserta didik dapat menjelaskan materi ekosistem melalui diskusi kelompok.",
          "2. Peserta didik dapat menganalisis solusi dari permasalahan terkait materi ekosistem melalui teknologi metaverse secara berkelompok.", // "Siswa mampu menjelaskan pengertian ekosistem dengan benar",
          "3. Peserta didik dapat menghasilkan produk berupa solusi inovatif sesuai dengan permasalahan ekosistem yang dipelajari.", // "Siswa dapat mengidentifikasi komponen biotik dan abiotik dalam suatu ekosistem",
      // "Siswa mampu menganalisis hubungan antar komponen dalam ekosistem",
      // "Siswa dapat memberikan contoh penerapan konsep konservasi",
      // "Siswa mampu menyusun laporan hasil observasi lingkungan",
    ];

    return Column(
      children:
          tpItems.map((tp) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF4CAF50).withOpacity(0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      tp,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }
}
