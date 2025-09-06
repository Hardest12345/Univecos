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
//         await supabase.from('profiles').select('team').eq('id', userId).single();

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
//         const SnackBar(content: Text('Self assessment submitted!')),
//       );

//       setState(() {
//         selectedScore = null;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error submitting assessment: $e')),
//       );
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Widget buildScoreSelector() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(5, (i) {
//         final score = i + 1;
//         return IconButton(
//           onPressed: () => setState(() => selectedScore = score),
//           icon: Icon(
//             Icons.star,
//             color: selectedScore != null && selectedScore! >= score
//                 ? Colors.amber
//                 : Colors.grey,
//           ),
//         );
//       }),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Self Assessment')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Text("Your Team: ${userTeam ?? 'Loading...'}"),
//             const SizedBox(height: 20),
//             const Text("Select Score"),
//             buildScoreSelector(),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: isLoading ? null : submitAssessment,
//               child: isLoading
//                   ? const CircularProgressIndicator(color: Colors.white)
//                   : const Text("Submit"),
//             ),
//           ],
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
  int? selectedScore;
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
        await supabase
            .from('profiles')
            .select('team')
            .eq('id', userId)
            .single();

    setState(() {
      userTeam = profile['team'];
    });
  }

  Future<void> submitAssessment() async {
    if (selectedScore == null || userTeam == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final userId = supabase.auth.currentUser!.id;

      await supabase.from('assessments').insert({
        'from_user': userId,
        'target_team': userTeam,
        'score': selectedScore,
        'type': 'self',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Penilaian diri berhasil dikirim!')),
      );

      setState(() {
        selectedScore = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error mengirim penilaian: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildScoreSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Pilih Skor Penilaian",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00707E),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final score = i + 1;
              return GestureDetector(
                onTap: () => setState(() => selectedScore = score),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        selectedScore != null && selectedScore! >= score
                            ? const Color(0xFFFFD700)
                            : Colors.grey[300],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          selectedScore != null && selectedScore! >= score
                              ? const Color(0xFFFFC107)
                              : Colors.grey[400]!,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    score.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color:
                          selectedScore != null && selectedScore! >= score
                              ? Colors.black
                              : Colors.grey[600],
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          const Text(
            "1 = Sangat Kurang, 5 = Sangat Baik",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
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
                            Icons.self_improvement,
                            size: 48,
                            color: Color(0xFF00707E),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Center(
                          child: Text(
                            "Penilaian Diri",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00707E),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Berikan penilaian terhadap kontribusi dan performa Anda dalam tim",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),

                        // Info Team
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00707E).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF00707E),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.group, color: Color(0xFF00707E)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "Tim Anda: ${userTeam ?? 'Loading...'}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF00707E),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Score Selector
                        buildScoreSelector(),

                        const SizedBox(height: 24),

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
                            child:
                                isLoading
                                    ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                    : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.white,
                                        ),
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

                        const SizedBox(height: 16),

                        // Informasi tambahan
                        const Card(
                          color: Color(0xFFE8F5E9),
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              "Penilaian ini akan digunakan untuk evaluasi perkembangan "
                              "individu dalam tim. Berikan penilaian yang jujur dan objektif.",
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
