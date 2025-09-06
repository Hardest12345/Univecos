import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfPreviewPage extends StatelessWidget {
  final String pdfPath;

  const PdfPreviewPage({super.key, required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preview Modul Ajar"),
      ),
      body: SfPdfViewer.asset(pdfPath),
    );
  }
}
