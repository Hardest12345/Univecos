// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'project_siswa.dart';

// class MyProjectScreen extends StatelessWidget {
//   const MyProjectScreen({super.key});

//   // fungsi untuk ambil public URL pdf dari supabase
//   Future<String> _getPdfUrl(String fileName) async {
//     final supabase = Supabase.instance.client;
//     final response = supabase.storage
//         .from('univecos')
//         .getPublicUrl('templates/$fileName');
//     return response;
//   }

//   void _openPdf(BuildContext context, String fileName) async {
//     final url = await _getPdfUrl(fileName);
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => PdfViewerScreen(pdfUrl: url, title: fileName),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [Color(0xFF00707E), Color(0xFFA9F67F)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           image: DecorationImage(
//             image: AssetImage("assets/images/background.png"),
//             fit: BoxFit.cover,
//             colorFilter: ColorFilter.mode(
//               Colors.black.withOpacity(0.2),
//               BlendMode.darken,
//             ),
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               // Header dengan tombol back
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 8,
//                 ),
//                 child: Row(
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.arrow_back, color: Colors.white),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                     const SizedBox(width: 8),
//                     const Text(
//                       "My Project",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Konten utama
//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     // color: Colors.white.withOpacity(0.7),
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(32),
//                       topRight: Radius.circular(32),
//                     ),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(24),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Header konten
//                         // const Center(
//                         //   child: Icon(
//                         //     Icons.work,
//                         //     size: 48,
//                         //     color: Color(0xFF00707E),
//                         //   ),
//                         // ),
//                         const SizedBox(height: 16),
//                         const Center(
//                           // child: Text(
//                           //   "Kelola Proyek Saya",
//                           //   style: TextStyle(
//                           //     fontSize: 20,
//                           //     fontWeight: FontWeight.bold,
//                           //     color: Color(0xFF00707E),
//                           //   ),
//                           // ),
//                         ),
//                         // const SizedBox(height: 24),

//                         // Section Rancangan
//                         _buildSectionHeader("Rancangan"),
//                         const SizedBox(height: 12),
//                         _buildActionCard(
//                           context,
//                           "Download Format Rancangan",
//                           Icons.download,
//                           Colors.blue,
//                           () {
//                             _openPdf(context, "rancangan.pdf");
//                           },
//                         ),
//                         const SizedBox(height: 8),
//                         _buildActionCard(
//                           context,
//                           "Upload Rancangan",
//                           Icons.upload,
//                           Colors.green,
//                           () {
//                             // upload file rancangan
//                           },
//                         ),

//                         const SizedBox(height: 24),

//                         // Section Laporan Akhir
//                         _buildSectionHeader("Laporan Akhir"),
//                         const SizedBox(height: 12),
//                         _buildActionCard(
//                           context,
//                           "Download Format Laporan",
//                           Icons.download,
//                           Colors.blue,
//                           () {
//                             _openPdf(context, "laporan.pdf");
//                           },
//                         ),
//                         const SizedBox(height: 8),
//                         _buildActionCard(
//                           context,
//                           "Upload Laporan",
//                           Icons.upload,
//                           Colors.green,
//                           () {
//                             // upload file laporan akhir
//                           },
//                         ),

//                         const SizedBox(height: 24),

//                         // Section Project
//                         _buildSectionHeader("Project"),
//                         const SizedBox(height: 12),
//                         _buildActionCard(
//                           context,
//                           "Lihat Project Saya",
//                           Icons.folder_open,
//                           Colors.orange,
//                           () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => const ProjectSiswaScreen(),
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionHeader(String title) {
//     return Center(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//         margin: const EdgeInsets.only(bottom: 12),
//         decoration: BoxDecoration(
//           color: Colors.white, // background putih
//           border: Border.all(color: Colors.white, width: 2),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Text(
//           title,
//           textAlign: TextAlign.center,
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF00707E),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildActionCard(
//     BuildContext context,
//     String title,
//     IconData icon,
//     Color color,
//     VoidCallback onTap,
//   ) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 3,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(40),
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: color.withOpacity(0.3), width: 1),
//           ),
//           child: Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(icon, color: color, size: 24),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ),
//               Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// layar viewer pdf
// class PdfViewerScreen extends StatelessWidget {
//   final String pdfUrl;
//   final String title;

//   const PdfViewerScreen({super.key, required this.pdfUrl, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//         backgroundColor: const Color(0xFF00707E),
//       ),
//       body: SfPdfViewer.network(pdfUrl, enableDoubleTapZooming: true),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'project_siswa.dart';

class MyProjectScreen extends StatelessWidget {
  const MyProjectScreen({super.key});

  // fungsi untuk ambil public URL pdf dari supabase
  Future<String> _getPdfUrl(String fileName) async {
    final supabase = Supabase.instance.client;
    final response = supabase.storage
        .from('univecos')
        .getPublicUrl('templates/$fileName');
    return response;
  }

  void _openPdf(BuildContext context, String fileName) async {
    final url = await _getPdfUrl(fileName);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PdfViewerScreen(pdfUrl: url, title: fileName),
      ),
    );
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
                      "My Project",
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
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header konten
                        // const Center(
                        //   child: Icon(
                        //     Icons.work_outline,
                        //     size: 48,
                        //     color: Color(0xFF00707E),
                        //   ),
                        // ),
                        // const SizedBox(height: 16),
                        // const Center(
                        //   child: Text(
                        //     "Kelola Proyek Saya",
                        //     style: TextStyle(
                        //       fontSize: 20,
                        //       fontWeight: FontWeight.bold,
                        //       color: Color(0xFF00707E),
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(height: 8),
                        // Center(
                        //   child: Text(
                        //     "Unggah dan kelola dokumen proyek Anda",
                        //     style: TextStyle(
                        //       fontSize: 14,
                        //       color: Colors.grey[700],
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(height: 24),

                        // Section Rancangan
                        _buildSectionHeader("Rancangan"),
                        const SizedBox(height: 12),
                        _buildActionCard(
                          context,
                          "Download Format Rancangan",
                          Icons.download,
                          Colors.blue,
                          () {
                            _openPdf(context, "rancangan.pdf");
                          },
                        ),
                        const SizedBox(height: 8),
                        _buildActionCard(
                          context,
                          "Upload Rancangan",
                          Icons.upload,
                          Colors.green,
                          () {
                            // upload file rancangan
                          },
                        ),

                        const SizedBox(height: 24),

                        // Section Laporan Akhir
                        _buildSectionHeader("Laporan Akhir"),
                        const SizedBox(height: 12),
                        _buildActionCard(
                          context,
                          "Download Format Laporan",
                          Icons.download,
                          Colors.blue,
                          () {
                            _openPdf(context, "laporan.pdf");
                          },
                        ),
                        const SizedBox(height: 8),
                        _buildActionCard(
                          context,
                          "Upload Laporan",
                          Icons.upload,
                          Colors.green,
                          () {
                            // upload file laporan akhir
                          },
                        ),

                        const SizedBox(height: 24),

                        // Section Project
                        _buildSectionHeader("Project"),
                        const SizedBox(height: 12),
                        _buildActionCard(
                          context,
                          "Lihat Project Saya",
                          Icons.folder_open,
                          Colors.orange,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ProjectSiswaScreen(),
                              ),
                            );
                          },
                        ),

                        const Spacer(),

                        // Footer informasi
                        const Center(
                          child: Text(
                            "Format file: PDF, DOCX, Gambar (JPG, PNG)",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF00707E).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF00707E).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00707E),
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.2), width: 1),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[500]),
            ],
          ),
        ),
      ),
    );
  }
}

/// layar viewer pdf
class PdfViewerScreen extends StatelessWidget {
  final String pdfUrl;
  final String title;

  const PdfViewerScreen({super.key, required this.pdfUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF00707E),
        foregroundColor: Colors.white,
      ),
      body: SfPdfViewer.network(pdfUrl, enableDoubleTapZooming: true),
    );
  }
}
