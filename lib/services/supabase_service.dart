// import 'dart:typed_data';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class SupabaseService {
//   final SupabaseClient client;

//   SupabaseService(this.client);

//   /// Upload PDF ke bucket `univecos`
//   Future<String?> uploadPdf(String path, String fileName, Uint8List fileBytes) async {
//     try {
//       final res = await client.storage
//           .from('univecos')
//           .uploadBinary(fileName, fileBytes, fileOptions: const FileOptions(upsert: true));
//       return res; // return path file di Supabase
//     } catch (e) {
//       print('Error upload PDF: $e');
//       return null;
//     }
//   }

//   /// Get URL file PDF dari Supabase
//   String getPublicUrl(String fileName) {
//     return client.storage.from('univecos').getPublicUrl(fileName);
//   }

//   /// Get list semua PDF dari bucket
//   Future<List<FileObject>> listPdfs() async {
//     try {
//       final res = await client.storage.from('univecos').list();
//       return res;
//     } catch (e) {
//       print('Error list PDF: $e');
//       return [];
//     }
//   }
// Future<List<Map<String, dynamic>>> getPdfFilesWithSummary(String bucket) async {
//   final response = await supabase.storage.from(bucket).list();

//   List<Map<String, dynamic>> pdfs = [];
//   for (var item in response) {
//     if (item.name.endsWith(".pdf")) {
//       final url = supabase.storage.from(bucket).getPublicUrl(item.name);
      
//       // ambil summary dari tabel `summaries`
//       final summaryResponse = await supabase
//           .from("summaries")
//           .select("summary")
//           .eq("filename", item.name)
//           .maybeSingle();

//       pdfs.add({
//         "name": item.name,
//         "url": url,
//         "summary": summaryResponse?["summary"] ?? "Summary tidak tersedia",
//       });
//     }
//   }
//   return pdfs;
// }

//   /// Get summary (dari database Supabase, misalnya tabel `summaries`)
//   Future<String?> getSummary(String fileName) async {
//     try {
//       final res = await client
//           .from('summaries')
//           .select('summary')
//           .eq('file_name', fileName)
//           .maybeSingle();

//       return res?['summary'] as String?;
//     } catch (e) {
//       print('Error get summary: $e');
//       return null;
//     }
//   }

//   /// Simpan summary ke tabel `summaries`
//   Future<void> saveSummary(String fileName, String summary) async {
//     try {
//       await client.from('summaries').upsert({
//         'file_name': fileName,
//         'summary': summary,
//       });
//     } catch (e) {
//       print('Error save summary: $e');
//     }
//   }
// }
