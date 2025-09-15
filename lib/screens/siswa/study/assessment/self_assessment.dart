// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class SelfAssessmentScreen extends StatefulWidget {
//   const SelfAssessmentScreen({Key? key}) : super(key: key);

//   @override
//   State<SelfAssessmentScreen> createState() => _SelfAssessmentScreenState();
// }

// class _SelfAssessmentScreenState extends State<SelfAssessmentScreen> {
//   final supabase = Supabase.instance.client;
//   int? selectedScore;
//   bool isLoading = false;
//   String? userTeam;

//   @override
//   void initState() {
//     super.initState();
//     fetchUserTeam();
//   }

//   Future<void> fetchUserTeam() async {
//     final userId = supabase.auth.currentUser!.id;

//     final profile =
//         await supabase
//             .from('profiles')
//             .select('team')
//             .eq('id', userId)
//             .single();

//     setState(() {
//       userTeam = profile['team'];
//     });
//   }

//   Future<void> submitAssessment() async {
//     if (selectedScore == null || userTeam == null) return;

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final userId = supabase.auth.currentUser!.id;

//       await supabase.from('assessments').insert({
//         'from_user': userId,
//         'target_team': userTeam,
//         'score': selectedScore,
//         'type': 'self',
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Penilaian diri berhasil dikirim!')),
//       );

//       setState(() {
//         selectedScore = null;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Error mengirim penilaian: $e')));
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Widget buildScoreSelector() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           const Text(
//             "Pilih Skor Penilaian",
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF00707E),
//             ),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(5, (i) {
//               final score = i + 1;
//               return GestureDetector(
//                 onTap: () => setState(() => selectedScore = score),
//                 child: Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 8),
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color:
//                         selectedScore != null && selectedScore! >= score
//                             ? const Color(0xFFFFD700)
//                             : Colors.grey[300],
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color:
//                           selectedScore != null && selectedScore! >= score
//                               ? const Color(0xFFFFC107)
//                               : Colors.grey[400]!,
//                       width: 2,
//                     ),
//                   ),
//                   child: Text(
//                     score.toString(),
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color:
//                           selectedScore != null && selectedScore! >= score
//                               ? Colors.black
//                               : Colors.grey[600],
//                     ),
//                   ),
//                 ),
//               );
//             }),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             "1 = Sangat Kurang, 5 = Sangat Baik",
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey,
//               fontStyle: FontStyle.italic,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [Color(0xFF00707E), Color(0xFFA9F67F)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           image: DecorationImage(
//             image: AssetImage("assets/images/background.png"),
//             fit: BoxFit.cover,
//             colorFilter: ColorFilter.mode(
//               Colors.black.withOpacity(0.2),
//               BlendMode.darken,
//             ),
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               // Header dengan tombol back
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 8,
//                 ),
//                 child: Row(
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.arrow_back, color: Colors.white),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                     const SizedBox(width: 8),
//                     const Text(
//                       "Self Assessment",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Konten utama
//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.7),
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(32),
//                       topRight: Radius.circular(32),
//                     ),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(24),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Header konten
//                         const Center(
//                           child: Icon(
//                             Icons.self_improvement,
//                             size: 48,
//                             color: Color(0xFF00707E),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         const Center(
//                           child: Text(
//                             "Penilaian Diri",
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF00707E),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         const Text(
//                           "Berikan penilaian terhadap kontribusi dan performa Anda dalam tim",
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.black87,
//                             height: 1.5,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 24),

//                         // Info Team
//                         Container(
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF00707E).withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(16),
//                             border: Border.all(
//                               color: const Color(0xFF00707E),
//                               width: 1,
//                             ),
//                           ),
//                           child: Row(
//                             children: [
//                               const Icon(Icons.group, color: Color(0xFF00707E)),
//                               const SizedBox(width: 12),
//                               Expanded(
//                                 child: Text(
//                                   "Tim Anda: ${userTeam ?? 'Loading...'}",
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: Color(0xFF00707E),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),

//                         const SizedBox(height: 24),

//                         // Score Selector
//                         buildScoreSelector(),

//                         const SizedBox(height: 24),

//                         // Submit Button
//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton(
//                             onPressed: isLoading ? null : submitAssessment,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF00707E),
//                               padding: const EdgeInsets.symmetric(vertical: 16),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               disabledBackgroundColor: Colors.grey[400],
//                             ),
//                             child:
//                                 isLoading
//                                     ? const CircularProgressIndicator(
//                                       color: Colors.white,
//                                     )
//                                     : const Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Icon(
//                                           Icons.check_circle,
//                                           color: Colors.white,
//                                         ),
//                                         SizedBox(width: 8),
//                                         Text(
//                                           "Submit Penilaian",
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                           ),
//                         ),

//                         const SizedBox(height: 16),

//                         // Informasi tambahan
//                         const Card(
//                           color: Color(0xFFE8F5E9),
//                           child: Padding(
//                             padding: EdgeInsets.all(12),
//                             child: Text(
//                               "Penilaian ini akan digunakan untuk evaluasi perkembangan "
//                               "individu dalam tim. Berikan penilaian yang jujur dan objektif.",
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Color(0xFF388E3C),
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SelfAssessmentScreen extends StatefulWidget {
  const SelfAssessmentScreen({Key? key}) : super(key: key);

  @override
  State<SelfAssessmentScreen> createState() => _SelfAssessmentScreenState();
}

class _SelfAssessmentScreenState extends State<SelfAssessmentScreen> {
  final supabase = Supabase.instance.client;
  List<int?> selectedScores = List.filled(10, null);
  bool isLoading = false;
  String? userTeam;

  @override
  void initState() {
    super.initState();
    fetchUserTeam();
  }

  Future<void> fetchUserTeam() async {
    final userId = supabase.auth.currentUser!.id;

    final profile =
        await supabase.from('profiles').select('team').eq('id', userId).single();

    setState(() {
      userTeam = profile['team'];
    });
  }

  Future<void> submitAssessment() async {
    if (selectedScores.contains(null) || userTeam == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi semua penilaian!')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final userId = supabase.auth.currentUser!.id;

      // Insert all assessment scores
      for (int i = 0; i < selectedScores.length; i++) {
        await supabase.from('assessments').insert({
          'from_user': userId,
          'target_team': userTeam,
          'score': selectedScores[i],
          // 'question_number': i + 1,
          'type': 'self',
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Penilaian diri berhasil dikirim!')),
      );

      setState(() {
        selectedScores = List.filled(10, null);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error mengirim penilaian: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildQuestionCard(int index) {
    final questions = [
      "Saya merasa sedih ketika melihat makhluk hidup dalam ekosistem mengalami gangguan.",
      "Saya mampu mengekspresikan perasaan yang selaras dengan kondisi makhluk hidup dalam ekosistem, saya merasa senang ketika melihat hewan atau tumbuhan di ekosistem tumbuh sehat, dan merasa prihatin ketika mengalami gangguan.",
      "Saya berpartisipasi aktif dalam kegiatan bersama kelompok untuk menjaga kelangsungan hidup ekosistem.",
      "Saya dapat menjelaskan konsep ekologi yang abstrak dengan menggunakan contoh nyata yang mudah dipahami.",
      "Saya dapat menghubungkan konsep ekologi yang dipelajari dengan peristiwa nyata di lingkungan sekitar.",
      "Saya dapat mengetahui bahwa suatu tindakan manusia yang berbahaya misalnya penggunaan pestisida, pembuangan sampah sembarangan, dapat menimbulkan dampak bagi ekosistem.",
      "Saya dapat mengantisipasi bahwa suatu tindakan manusia bisa menimbulkan dampak ekologis yang tak terduga di kemudian hari.",
      "Saya dapat merencanakan solusi yang tepat untuk mengurangi dampak ekologis yang tak terduga akibat tindakan manusia.",
      "Saya berusaha memahami suatu proses alam dengan melihat bukti nyata dari hasil pengamatan atau data ilmiah.",
      "Saya dapat menilai apakah suatu proses alam berjalan baik atau terganggu dengan mengacu pada data atau bukti hasil pengamatan.",
    ];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${index + 1}. ${questions[index]}",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(5, (i) {
                final score = i + 1;
                return GestureDetector(
                  onTap: () => setState(() => selectedScores[index] = score),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: selectedScores[index] == score
                          ? const Color(0xFFFFD700)
                          : Colors.grey[200],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selectedScores[index] == score
                            ? const Color(0xFFFFC107)
                            : Colors.grey[400]!,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      score.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: selectedScores[index] == score
                            ? Colors.black
                            : Colors.grey[600],
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                "1 = Sangat Kurang, 5 = Sangat Baik",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            image: const AssetImage("assets/images/background.png"),
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
                      "Self Assessment",
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
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header konten
                        const Center(
                          child: Icon(
                            Icons.self_improvement,
                            size: 48,
                            color: Color(0xFF00707E),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Center(
                          child: Text(
                            "Penilaian Diri Ekologi",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00707E),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Berikan penilaian jujur terhadap kemampuan dan sikap Anda terkait ekologi dan lingkungan:",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),

                        // Info Team
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00707E).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF00707E),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.group, color: Color(0xFF00707E), size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Tim: ${userTeam ?? 'Loading...'}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF00707E),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Questions List
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: List.generate(10, (index) => buildQuestionCard(index)),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : submitAssessment,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00707E),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              disabledBackgroundColor: Colors.grey[400],
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.check_circle, color: Colors.white),
                                      SizedBox(width: 8),
                                      Text(
                                        "Submit Penilaian",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Informasi tambahan
                        const Card(
                          color: Color(0xFFE8F5E9),
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              "Penilaian ini membantu evaluasi perkembangan pemahaman ekologi. "
                              "Berikan penilaian yang jujur sesuai dengan kondisi Anda.",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF388E3C),
                              ),
                              textAlign: TextAlign.center,
                            ),
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
}