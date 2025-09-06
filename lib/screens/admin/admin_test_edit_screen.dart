import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminTestEditScreen extends StatefulWidget {
  final Map<String, dynamic> question;

  const AdminTestEditScreen({super.key, required this.question});

  @override
  State<AdminTestEditScreen> createState() => _AdminTestEditScreenState();
}

class _AdminTestEditScreenState extends State<AdminTestEditScreen> {
  final supabase = Supabase.instance.client;
  late TextEditingController questionCtrl;
  late List<TextEditingController> optionCtrls;
  int correctIndex = 0;

  @override
  void initState() {
    super.initState();
    questionCtrl = TextEditingController(text: widget.question['question_text']);
    final options = List<String>.from(widget.question['options']);
    optionCtrls = options.map((o) => TextEditingController(text: o)).toList();
    correctIndex = widget.question['correct_index'];
  }

  Future<void> updateQuestion() async {
    final updatedOptions = optionCtrls.map((c) => c.text).toList();
    await supabase.from('test_questions').update({
      'question_text': questionCtrl.text,
      'options': updatedOptions,
      'correct_index': correctIndex,
    }).eq('id', widget.question['id']);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Soal")),
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
              onPressed: updateQuestion,
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
