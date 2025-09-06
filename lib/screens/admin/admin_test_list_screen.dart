import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'admin_test_edit_screen.dart';
import 'admin_test_add_screen.dart';

class AdminTestListScreen extends StatefulWidget {
  final String testType; // "pre", "post", "practice"

  const AdminTestListScreen({super.key, required this.testType});

  @override
  State<AdminTestListScreen> createState() => _AdminTestListScreenState();
}

class _AdminTestListScreenState extends State<AdminTestListScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> questions = [];

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    final response = await supabase
        .from('test_questions')
        .select()
        .eq('test_type', widget.testType)
        .order('created_at');
    setState(() {
      questions = List<Map<String, dynamic>>.from(response);
    });
  }

  Future<void> deleteQuestion(String id) async {
    await supabase.from('test_questions').delete().eq('id', id);
    fetchQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Soal ${widget.testType.toUpperCase()}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AdminTestAddScreen(testType: widget.testType),
                ),
              ).then((_) => fetchQuestions());
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final q = questions[index];
          final options = List<String>.from(q['options']);
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(q['question_text']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < options.length; i++)
                    Text(
                      "${String.fromCharCode(65 + i)}. ${options[i]}",
                      style: TextStyle(
                        fontWeight:
                            i == q['correct_index'] ? FontWeight.bold : FontWeight.normal,
                        color:
                            i == q['correct_index'] ? Colors.green : Colors.black,
                      ),
                    ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdminTestEditScreen(question: q),
                        ),
                      ).then((_) => fetchQuestions());
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteQuestion(q['id']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
