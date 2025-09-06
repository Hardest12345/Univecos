import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../services/pdf_service.dart';

class PdfUploadScreen extends StatefulWidget {
  const PdfUploadScreen({super.key});

  @override
  State<PdfUploadScreen> createState() => _PdfUploadScreenState();
}

class _PdfUploadScreenState extends State<PdfUploadScreen> {
  final _pdfService = PdfService();
  final _kategoriController = TextEditingController();
  final _titleController = TextEditingController();
  File? _selectedFile;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadPdf() async {
    if (_selectedFile == null ||
        _kategoriController.text.isEmpty ||
        _titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi semua data & pilih file")),
      );
      return;
    }

    try {
      await _pdfService.uploadPdf(
        _selectedFile!,
        _kategoriController.text,
        _titleController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("PDF berhasil diupload")),
      );

      setState(() {
        _selectedFile = null;
        _kategoriController.clear();
        _titleController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload PDF (Admin)")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _kategoriController,
              decoration: const InputDecoration(labelText: "Kategori (mis. ekosistem_sabana)"),
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Judul PDF"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickFile,
              child: const Text("Pilih PDF"),
            ),
            if (_selectedFile != null)
              Text("File: ${_selectedFile!.path.split('/').last}"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _uploadPdf,
              child: const Text("Upload"),
            ),
          ],
        ),
      ),
    );
  }
}
