// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class UploadTestScreen extends StatefulWidget {
//   const UploadTestScreen({Key? key}) : super(key: key);

//   @override
//   State<UploadTestScreen> createState() => _UploadTestScreenState();
// }

// class _UploadTestScreenState extends State<UploadTestScreen> {
//   String? selectedType; // pre, post, practice
//   final List<QuestionForm> questions = [];

//   void addQuestion() {
//     setState(() {
//       questions.add(QuestionForm());
//     });
//   }

//   Future<void> submitQuestions() async {
//     final supabase = Supabase.instance.client;

//     for (var q in questions) {
//       await supabase.from('test_questions').insert({
//         'test_type': selectedType,
//         'question_text': q.questionController.text,
//         'options': q.options.map((o) => o.text).toList(),
//         'correct_index': q.correctIndex,
//       });
//     }

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Test berhasil diupload!')),
//     );

//     setState(() {
//       questions.clear();
//       selectedType = null;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Upload Test")),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           children: [
//             DropdownButtonFormField<String>(
//               value: selectedType,
//               hint: Text("Pilih Jenis Test"),
//               items: ['pre', 'post', 'practice']
//                   .map((e) => DropdownMenuItem(value: e, child: Text(e.toUpperCase())))
//                   .toList(),
//               onChanged: (v) => setState(() => selectedType = v),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: questions.length,
//                 itemBuilder: (context, index) {
//                   return questions[index];
//                 },
//               ),
//             ),
//             Row(
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: addQuestion,
//                   icon: Icon(Icons.add),
//                   label: Text("Tambah Soal"),
//                 ),
//                 Spacer(),
//                 ElevatedButton(
//                   onPressed: submitQuestions,
//                   child: Text("Submit"),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class QuestionForm extends StatefulWidget {
//   final TextEditingController questionController = TextEditingController();
//   final List<TextEditingController> options =
//       List.generate(4, (_) => TextEditingController());
//   int correctIndex = 0;

//   @override
//   State<QuestionForm> createState() => _QuestionFormState();
// }

// class _QuestionFormState extends State<QuestionForm> {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 8),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: widget.questionController,
//               decoration: InputDecoration(labelText: "Pertanyaan"),
//             ),
//             ...List.generate(4, (i) {
//               return Row(
//                 children: [
//                   Radio<int>(
//                     value: i,
//                     groupValue: widget.correctIndex,
//                     onChanged: (val) {
//                       setState(() {
//                         widget.correctIndex = val!;
//                       });
//                     },
//                   ),
//                   Expanded(
//                     child: TextField(
//                       controller: widget.options[i],
//                       decoration: InputDecoration(labelText: "Pilihan ${i + 1}"),
//                     ),
//                   ),
//                 ],
//               );
//             }),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'admin_test_list_screen.dart';

class UploadTestScreen extends StatelessWidget {
  const UploadTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> testTypes = [
      {"label": "Kelola Pretest", "value": "pre"},
      {"label": "Kelola Posttest", "value": "post"},
      {"label": "Kelola Practice", "value": "practice"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Kelola Test")),
      body: ListView.builder(
        itemCount: testTypes.length,
        itemBuilder: (context, index) {
          final item = testTypes[index];
          return Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              leading: const Icon(Icons.quiz, color: Colors.green),
              title: Text(item['label']!),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => AdminTestListScreen(testType: item['value']!),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
