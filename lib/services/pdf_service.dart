import 'dart:io';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';

class PdfService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Upload file PDF ke Storage + simpan metadata di table
  Future<void> uploadPdf(File file, String kategori, String title) async {
    try {
      final fileExt = path.extension(file.path);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}$fileExt';
      final filePath = '$kategori/$fileName';

      // ✅ Upload ke storage bucket `pdfs`
      final storageResponse = await _client.storage.from('pdfs').upload(
            filePath,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      if (storageResponse.isEmpty) {
        throw Exception("Gagal upload PDF ke storage.");
      }

      // ✅ Dapatkan public URL
      final fileUrl = _client.storage.from('pdfs').getPublicUrl(filePath);

      // ✅ Simpan metadata ke table pdf_files
      await _client.from('pdf_files').insert({
        'kategori': kategori,
        'title': title,
        'file_url': fileUrl,
      });

      print("PDF berhasil diupload: $fileUrl");
    } catch (e) {
      throw Exception("Upload gagal: $e");
    }
  }

  /// Ambil daftar PDF berdasarkan kategori
  Future<List<Map<String, dynamic>>> getPdfByKategori(String kategori) async {
    final response = await _client
        .from('pdf_files')
        .select()
        .eq('kategori', kategori)
        .order('uploaded_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}
