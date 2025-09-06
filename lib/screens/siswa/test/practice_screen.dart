// import 'package:flutter/material.dart';
// import 'quiz_screen.dart';

// class StudentTestMenu extends StatelessWidget {
//   const StudentTestMenu({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final tests = [
//       {"label": "Pre Test", "type": "pre"},
//       {"label": "Post Test", "type": "post"},
//       {"label": "Practice", "type": "practice"},
//     ];

//     return Scaffold(
//       appBar: AppBar(title: const Text("Let's Practice")),
//       body: GridView.builder(
//         padding: const EdgeInsets.all(16),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16),
//         itemCount: tests.length,
//         itemBuilder: (context, index) {
//           final test = tests[index];
//           return GestureDetector(
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(
//                 builder: (_) => QuizScreen(testType: test["type"]!),
//               ));
//             },
//             child: Card(
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//               elevation: 4,
//               child: Center(
//                 child: Text(
//                   test["label"]!,
//                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class StudentTestMenu extends StatelessWidget {
  const StudentTestMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final tests = [
      {
        "label": "Pre-Test",
        "type": "pre",
        "icon": Icons.assignment_turned_in,
        "color": Color(0xFF00707E),
        "description": "",
      },
      {
        "label": "Post-Test",
        "type": "post",
        "icon": Icons.assignment,
        "color": Color(0xFF4CAF50),
        "description": "",
      },
      {
        "label": "Practice Questions",
        "type": "practice",
        "icon": Icons.quiz,
        "color": Color(0xFFFF9800),
        "description": "",
      },
    ];

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00707E), Color(0xFFA9F67F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header dengan tombol back
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Let's Practice",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Konten utama
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header konten
                        const Center(
                          child: Icon(
                            Icons.quiz,
                            size: 48,
                            color: Color(0xFF00707E),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Center(
                          child: Text(
                            "Latihan dan Evaluasi",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00707E),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Pilih jenis tes atau latihan yang ingin Anda kerjakan:",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),

                        // Grid Menu
                        // List Menu (Flex kebawah)
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 16),
                            itemCount: tests.length,
                            itemBuilder: (context, index) {
                              final test = tests[index];
                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 16,
                                ), // jarak antar card
                                child: _buildTestCard(
                                  context,
                                  test["label"] as String, // casting ke String
                                  test["icon"]
                                      as IconData, // casting ke IconData
                                  test["color"] as Color, // casting ke Color
                                  test["description"]
                                      as String, // casting ke String
                                  () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => QuizScreen(
                                              testType:
                                                  test["type"]
                                                      as String, // casting ke String
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestCard(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    String description,
    VoidCallback onTap,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 28, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
                const SizedBox(height: 8),
                const Icon(Icons.arrow_forward, size: 16, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
