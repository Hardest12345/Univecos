import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data'; // Add this import for Uint8List

class FileService {
  final supabase = Supabase.instance.client;

  Future<void> uploadToBucket({
    required String bucket,
    required String path,
    required Uint8List bytes, // Changed from List<int> to Uint8List
  }) async {
    await supabase.storage.from(bucket).uploadBinary(
      path, 
      bytes, 
      fileOptions: const FileOptions(upsert: true)
    );
  }

  String getPublicUrl({required String bucket, required String path}) {
    return supabase.storage.from(bucket).getPublicUrl(path);
  }

  Future<void> insertPdfMetadata({
    required String kategori,
    required String title,
    required String path,
  }) async {
    final url = getPublicUrl(bucket: "univecos", path: path);
    await supabase.from("pdf_files").insert({
      "kategori": kategori.replaceAll(" ", "_").toLowerCase(),
      "title": title,
      "file_url": url,
    });
  }

  Future<List<FileObject>> listFiles({required String bucket, required String prefix}) async {
    final res = await supabase.storage.from(bucket).list(path: prefix);
    return res;
  }
}