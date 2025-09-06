import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminTestAddScreen extends StatefulWidget {
  final String testType;
  const AdminTestAddScreen({super.key, required this.testType});

  @override
  State<AdminTestAddScreen> createState() => _AdminTestAddScreenState();
}

class _AdminTestAddScreenState extends State<AdminTestAddScreen> {
  final supabase = Supabase.instance.client;
  final questionCtrl = TextEditingController();
  final List<TextEditingController> optionCtrls =
      List.generate(4, (_) => TextEditingController());
  int correctIndex = 0;

  Future<void> addQuestion() async {
    final options = optionCtrls.map((c) => c.text).toList();
    await supabase.from('test_questions').insert({
      'test_type': widget.testType,
      'question_text': questionCtrl.text,
      'options': options,
      'correct_index': correctIndex,
    });
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Soal")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: questionCtrl,
              decoration: const InputDecoration(labelText: "Pertanyaan"),
            ),
            const SizedBox(height: 16),
            for (int i = 0; i < optionCtrls.length; i++)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: optionCtrls[i],
                      decoration: InputDecoration(labelText: "Opsi ${i + 1}"),
                    ),
                  ),
                  Radio<int>(
                    value: i,
                    groupValue: correctIndex,
                    onChanged: (val) => setState(() => correctIndex = val!),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addQuestion,
              child: const Text("Tambah"),
            ),
          ],
        ),
      ),
    );
  }
}
