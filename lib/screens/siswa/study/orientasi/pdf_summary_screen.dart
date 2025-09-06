import 'package:flutter/material.dart';

class PdfSummaryScreen extends StatelessWidget {
  final String title;
  final String summary;

  const PdfSummaryScreen({
    super.key,
    required this.title,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Summary: $title")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(summary, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
