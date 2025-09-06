import 'package:flutter/material.dart';

class CapaianScreen extends StatelessWidget {
  const CapaianScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Capaian Belajar")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            leading: Icon(Icons.check_circle, color: Colors.green),
            title: Text("Mengenal Keanekaragaman Hayati"),
            subtitle: Text("Status: Belum dikerjakan"),
          ),
          ListTile(
            leading: Icon(Icons.check_circle, color: Colors.green),
            title: Text("Menganalisis Interaksi Ekosistem"),
            subtitle: Text("Status: Belum dikerjakan"),
          ),
        ],
      ),
    );
  }
}
