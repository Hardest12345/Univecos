// // lib/screens/teacher/report_upload_screen.dart
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ReportUploadScreen extends StatefulWidget {
//   const ReportUploadScreen({super.key});

//   @override
//   State<ReportUploadScreen> createState() => _ReportUploadScreenState();
// }

// class _ReportUploadScreenState extends State<ReportUploadScreen> {
//   final supabase = Supabase.instance.client;

//   String? selectedStudentId;
//   List<Map<String, dynamic>> students = [];
//   final TextEditingController percentCtrl = TextEditingController();
//   File? selectedFile;
//   bool loading = false;
//   bool loadingStudents = true;
//   String? teacherClass;

//   @override
//   void initState() {
//     super.initState();
//     _initData();
//   }

//   Future<void> _initData() async {
//     await _fetchTeacherClassAndStudents();
//   }

//   Future<void> _fetchTeacherClassAndStudents() async {
//     setState(() {
//       loadingStudents = true;
//       students = [];
//     });

//     try {
//       final currentUser = supabase.auth.currentUser;
//       if (currentUser == null) {
//         throw Exception('User belum login');
//       }

//       // 1) Ambil kelas guru dari tabel profiles
//       final prof = await supabase
//           .from('profiles')
//           .select('class')
//           .eq('id', currentUser.id)
//           .maybeSingle();

//       teacherClass = (prof != null && prof['class'] != null)
//           ? prof['class'] as String
//           : null;

//       // 2) Ambil daftar siswa berdasarkan class guru (jika ada)
//       PostgrestFilterBuilder q = supabase.from('profiles').select('id, name').eq('role', 'siswa');

//       if (teacherClass != null && teacherClass!.isNotEmpty) {
//         q = q.eq('class', teacherClass!);
//       }

//       final res = await q.order('name', ascending: true);

//       final list = List<Map<String, dynamic>>.from(res ?? []);
//       setState(() {
//         students = list;
//       });
//     } catch (e) {
//       // fallback: ambil semua siswa bila terjadi error
//       try {
//         final fallback = await supabase
//             .from('profiles')
//             .select('id, name')
//             .eq('role', 'siswa')
//             .order('name', ascending: true);
//         setState(() {
//           students = List<Map<String, dynamic>>.from(fallback ?? []);
//         });
//       } catch (_) {
//         debugPrint('Gagal load students: $e');
//       }
//     } finally {
//       if (mounted) setState(() => loadingStudents = false);
//     }
//   }

//   Future<void> _pickFile() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf'],
//     );
//     if (result != null && result.files.single.path != null) {
//       setState(() {
//         selectedFile = File(result.files.single.path!);
//       });
//     }
//   }

//   Future<void> _openTemplateRapor() async {
//     final url = supabase.storage.from('univecos').getPublicUrl('templates/rapor.pdf');
//     final uri = Uri.parse(url);
//     if (!await launchUrl(uri)) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal membuka template (pastikan URL valid)')));
//     }
//   }

//   Future<void> _uploadReport() async {
//     // validasi
//     if (selectedStudentId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pilih siswa terlebih dahulu")));
//       return;
//     }
//     if (percentCtrl.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Masukkan persentase pencapaian")));
//       return;
//     }
//     final parsed = double.tryParse(percentCtrl.text.trim());
//     if (parsed == null || parsed < 0 || parsed > 100) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Persentase harus angka 0 - 100")));
//       return;
//     }
//     if (selectedFile == null) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pilih file PDF rapor terlebih dahulu")));
//       return;
//     }

//     setState(() => loading = true);

//     try {
//       final teacherId = supabase.auth.currentUser?.id;

//       final ts = DateTime.now().millisecondsSinceEpoch;
//       final path = 'reports/$selectedStudentId/rapor-$ts.pdf';

//       // Upload ke bucket 'univecos' (path reports/...)
//       await supabase.storage.from('univecos').upload(
//             path,
//             selectedFile!,
//             fileOptions: const FileOptions(upsert: true),
//           );

//       final publicUrl = supabase.storage.from('univecos').getPublicUrl(path);

//       // Simpan ke tabel reports (kolom: student_id, teacher_id, achievement_percent, file_url)
//       await supabase.from('reports').insert({
//         'student_id': selectedStudentId,
//         'teacher_id': teacherId,
//         'achievement_percent': parsed,
//         'file_url': publicUrl,
//         'created_at': DateTime.now().toIso8601String(),
//       });

//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Rapor berhasil diupload")));
//       // reset form
//       setState(() {
//         selectedFile = null;
//         percentCtrl.clear();
//         selectedStudentId = null;
//       });
//     } on PostgrestException catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("DB Error: ${e.message}")));
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
//     } finally {
//       if (mounted) setState(() => loading = false);
//     }
//   }

//   @override
//   void dispose() {
//     percentCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Make Report (Upload Rapor)"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: loadingStudents
//             ? const Center(child: CircularProgressIndicator())
//             : Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   // Info kelas (jika ada)
//                   if (teacherClass != null)
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 12.0),
//                       child: Text('Kelas (guru): $teacherClass', style: const TextStyle(fontWeight: FontWeight.w600)),
//                     ),
//                   DropdownButtonFormField<String>(
//                     value: selectedStudentId,
//                     decoration: const InputDecoration(labelText: 'Pilih Siswa'),
//                     items: students
//                         .map((s) => DropdownMenuItem(
//                               value: s['id']?.toString(),
//                               child: Text((s['name'] ?? '(no name)').toString()),
//                             ))
//                         .toList(),
//                     onChanged: (v) => setState(() => selectedStudentId = v),
//                   ),
//                   const SizedBox(height: 12),
//                   TextField(
//                     controller: percentCtrl,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                       labelText: 'Achievement Percent (%)',
//                       hintText: 'Contoh: 85.5',
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton.icon(
//                           onPressed: _pickFile,
//                           icon: const Icon(Icons.upload_file),
//                           label: Text(selectedFile == null ? 'Pilih File PDF' : 'File: ${selectedFile!.path.split('/').last}'),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       ElevatedButton.icon(
//                         onPressed: _openTemplateRapor,
//                         icon: const Icon(Icons.download),
//                         label: const Text('Template Rapor'),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: loading ? null : _uploadReport,
//                     child: loading ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Simpan Rapor'),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportUploadScreen extends StatefulWidget {
  const ReportUploadScreen({super.key});

  @override
  State<ReportUploadScreen> createState() => _ReportUploadScreenState();
}

class _ReportUploadScreenState extends State<ReportUploadScreen> {
  final supabase = Supabase.instance.client;

  String? selectedStudentId;
  List<Map<String, dynamic>> students = [];
  final TextEditingController percentCtrl = TextEditingController();
  File? selectedFile;
  bool loading = false;
  bool loadingStudents = true;
  String? teacherClass;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await _fetchTeacherClassAndStudents();
  }

  Future<void> _fetchTeacherClassAndStudents() async {
    setState(() {
      loadingStudents = true;
      students = [];
    });

    try {
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User belum login');
      }

      // 1) Ambil kelas guru dari tabel profiles
      final prof = await supabase
          .from('profiles')
          .select('class')
          .eq('id', currentUser.id)
          .maybeSingle();

      teacherClass = (prof != null && prof['class'] != null)
          ? prof['class'] as String
          : null;

      // 2) Ambil daftar siswa berdasarkan class guru (jika ada)
      PostgrestFilterBuilder q = supabase.from('profiles').select('id, name').eq('role', 'siswa');

      if (teacherClass != null && teacherClass!.isNotEmpty) {
        q = q.eq('class', teacherClass!);
      }

      final res = await q.order('name', ascending: true);

      final list = List<Map<String, dynamic>>.from(res ?? []);
      setState(() {
        students = list;
      });
    } catch (e) {
      // fallback: ambil semua siswa bila terjadi error
      try {
        final fallback = await supabase
            .from('profiles')
            .select('id, name')
            .eq('role', 'siswa')
            .order('name', ascending: true);
        setState(() {
          students = List<Map<String, dynamic>>.from(fallback ?? []);
        });
      } catch (_) {
        debugPrint('Gagal load students: $e');
      }
    } finally {
      if (mounted) setState(() => loadingStudents = false);
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _openTemplateRapor() async {
    final url = supabase.storage.from('univecos').getPublicUrl('templates/rapor.pdf');
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal membuka template (pastikan URL valid)')));
    }
  }

  Future<void> _uploadReport() async {
    // validasi
    if (selectedStudentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pilih siswa terlebih dahulu")));
      return;
    }
    if (percentCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Masukkan persentase pencapaian")));
      return;
    }
    final parsed = double.tryParse(percentCtrl.text.trim());
    if (parsed == null || parsed < 0 || parsed > 100) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Persentase harus angka 0 - 100")));
      return;
    }
    if (selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pilih file PDF rapor terlebih dahulu")));
      return;
    }

    setState(() => loading = true);

    try {
      final teacherId = supabase.auth.currentUser?.id;

      final ts = DateTime.now().millisecondsSinceEpoch;
      final path = 'reports/$selectedStudentId/rapor-$ts.pdf';

      // Upload ke bucket 'univecos' (path reports/...)
      await supabase.storage.from('univecos').upload(
            path,
            selectedFile!,
            fileOptions: const FileOptions(upsert: true),
          );

      final publicUrl = supabase.storage.from('univecos').getPublicUrl(path);

      // Simpan ke tabel reports (kolom: student_id, teacher_id, achievement_percent, file_url)
      await supabase.from('reports').insert({
        'student_id': selectedStudentId,
        'teacher_id': teacherId,
        'achievement_percent': parsed,
        'file_url': publicUrl,
        'created_at': DateTime.now().toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Rapor berhasil diupload")));
      // reset form
      setState(() {
        selectedFile = null;
        percentCtrl.clear();
        selectedStudentId = null;
      });
    } on PostgrestException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("DB Error: ${e.message}")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    percentCtrl.dispose();
    super.dispose();
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
                    const Text(
                      "Buat Laporan Siswa",
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
                    child: loadingStudents
                        ? const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00707E)),
                            ),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header
                                const Center(
                                  child: Icon(
                                    Icons.bar_chart,
                                    size: 48,
                                    color: Color(0xFF00707E),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Center(
                                  child: Text(
                                    "Upload Laporan Siswa",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF00707E),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                
                                // Info kelas
                                if (teacherClass != null)
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    margin: const EdgeInsets.only(bottom: 20),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF00707E).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFF00707E),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.class_, color: Color(0xFF00707E)),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            "Kelas: $teacherClass",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF00707E),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                
                                const SizedBox(height: 16),
                                
                                // Form Input
                                _buildFormField(),
                                
                                const SizedBox(height: 24),
                                
                                // Tombol Aksi
                                _buildActionButtons(),
                              ],
                            ),
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

  Widget _buildFormField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Dropdown Siswa
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedStudentId,
              isExpanded: true,
              hint: const Text("Pilih Siswa"),
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF00707E)),
              items: students
                  .map((s) => DropdownMenuItem(
                        value: s['id']?.toString(),
                        child: Text(
                          (s['name'] ?? '(no name)').toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => selectedStudentId = v),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Input Persentase
        TextField(
          controller: percentCtrl,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Persentase Pencapaian (%)',
            hintText: 'Contoh: 85.5',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // File Info
        if (selectedFile != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF4CAF50)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Color(0xFF4CAF50)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "File: ${selectedFile!.path.split('/').last}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Tombol Pilih File dan Template
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _pickFile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00707E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.upload_file, color: Colors.white),
                label: const Text(
                  "Pilih File PDF",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: _openTemplateRapor,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9800),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.download, color: Colors.white),
              label: const Text(
                "Template",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Tombol Simpan
        ElevatedButton(
          onPressed: loading ? null : _uploadReport,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50),
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            disabledBackgroundColor: Colors.grey[400],
          ),
          child: loading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  "Simpan Laporan",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ],
    );
  }
}