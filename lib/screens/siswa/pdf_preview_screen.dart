import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:http/http.dart' as http;

class PdfPreviewScreen extends StatefulWidget {
  final String title;
  final String url; // URL PDF dari Supabase Storage

  const PdfPreviewScreen({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  PdfController? _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      final response = await http.get(Uri.parse(widget.url));
      if (response.statusCode == 200) {
        setState(() {
          _controller = PdfController(
            document: PdfDocument.openData(response.bodyBytes),
          );
          _isLoading = false;
        });
      } else {
        throw Exception('Gagal mengambil PDF (${response.statusCode})');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _controller != null
              ? PdfView(controller: _controller!)
              : const Center(child: Text("PDF tidak bisa dimuat")),
    );
  }
}
