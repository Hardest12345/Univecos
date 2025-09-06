// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class PeerAssessmentScreen extends StatefulWidget {
//   const PeerAssessmentScreen({Key? key}) : super(key: key);

//   @override
//   State<PeerAssessmentScreen> createState() => _PeerAssessmentScreenState();
// }

// class _PeerAssessmentScreenState extends State<PeerAssessmentScreen> {
//   final supabase = Supabase.instance.client;
//   String? selectedTeam;
//   int? selectedScore;
//   bool isLoading = false;
//   List<String> teams = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchTeams();
//   }

//   Future<void> fetchTeams() async {
//     final userId = supabase.auth.currentUser!.id;

//     // Ambil tim user saat ini
//     final userProfile = await supabase
//         .from('profiles')
//         .select('team')
//         .eq('id', userId)
//         .single();

//     final currentTeam = userProfile['team'];

//     // Ambil semua tim lain selain tim user
//     final response =
//         await supabase.from('profiles').select('team').neq('team', currentTeam);

//     final uniqueTeams = response.map((e) => e['team'] as String).toSet().toList();

//     setState(() {
//       teams = uniqueTeams;
//     });
//   }

//   Future<void> submitAssessment() async {
//     if (selectedTeam == null || selectedScore == null) return;

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final userId = supabase.auth.currentUser!.id;

//       await supabase.from('assessments').insert({
//         'from_user': userId,
//         'target_team': selectedTeam,
//         'score': selectedScore,
//         'type': 'peer',
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Peer assessment submitted!')),
//       );

//       setState(() {
//         selectedTeam = null;
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
//       appBar: AppBar(title: const Text('Peer Assessment')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             DropdownButtonFormField<String>(
//               decoration: const InputDecoration(labelText: 'Select Team'),
//               value: selectedTeam,
//               items: teams
//                   .map((t) => DropdownMenuItem(value: t, child: Text(t)))
//                   .toList(),
//               onChanged: (val) => setState(() => selectedTeam = val),
//             ),
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

class PeerAssessmentScreen extends StatefulWidget {
  const PeerAssessmentScreen({Key? key}) : super(key: key);

  @override
  State<PeerAssessmentScreen> createState() => _PeerAssessmentScreenState();
}

class _PeerAssessmentScreenState extends State<PeerAssessmentScreen> {
  final supabase = Supabase.instance.client;
  String? selectedTeam;
  int? selectedScore;
  bool isLoading = false;
  List<String> teams = [];

  @override
  void initState() {
    super.initState();
    fetchTeams();
  }

  Future<void> fetchTeams() async {
    final userId = supabase.auth.currentUser!.id;

    // Ambil tim user saat ini
    final userProfile =
        await supabase
            .from('profiles')
            .select('team')
            .eq('id', userId)
            .single();

    final currentTeam = userProfile['team'];

    // Ambil semua tim lain selain tim user
    final response = await supabase
        .from('profiles')
        .select('team')
        .neq('team', currentTeam);

    final uniqueTeams =
        response.map((e) => e['team'] as String).toSet().toList();

    setState(() {
      teams = uniqueTeams;
    });
  }

  Future<void> submitAssessment() async {
    if (selectedTeam == null || selectedScore == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final userId = supabase.auth.currentUser!.id;

      await supabase.from('assessments').insert({
        'from_user': userId,
        'target_team': selectedTeam,
        'score': selectedScore,
        'type': 'peer',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Penilaian peer berhasil dikirim!')),
      );

      setState(() {
        selectedTeam = null;
        selectedScore = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Widget buildScoreSelector() {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.grey[100]?.withOpacity(0.5),
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(color: Colors.grey[300]!),
  //     ),
  //     child: Column(
  //       children: [
  //         const Text(
  //           "Beri Nilai",
  //           style: TextStyle(
  //             fontSize: 16,
  //             fontWeight: FontWeight.bold,
  //             color: Color(0xFF00707E),
  //           ),
  //         ),
  //         const SizedBox(height: 12),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: List.generate(5, (i) {
  //             final score = i + 1;
  //             return IconButton(
  //               onPressed: () => setState(() => selectedScore = score),
  //               icon: Icon(
  //                 Icons.star,
  //                 size: 36,
  //                 color:
  //                     selectedScore != null && selectedScore! >= score
  //                         ? Colors.amber
  //                         : Colors.grey[400],
  //               ),
  //             );
  //           }),
  //         ),
  //         const SizedBox(height: 8),
  //         Text(
  //           selectedScore != null
  //               ? "Nilai: $selectedScore/5"
  //               : "Pilih nilai 1-5",
  //           style: TextStyle(
  //             color: selectedScore != null ? Colors.green : Colors.grey[600],
  //             fontWeight: FontWeight.w500,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
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
                      "Peer Assessment",
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
                            Icons.group,
                            size: 48,
                            color: Color(0xFF00707E),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Center(
                          child: Text(
                            "Penilaian Teman Sebaya",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00707E),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Berikan penilaian untuk tim lain berdasarkan kolaborasi dan kontribusi mereka",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Dropdown Team Selection
                        const Text(
                          "Pilih Tim",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00707E),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              hintText: "Pilih tim untuk dinilai",
                            ),
                            value: selectedTeam,
                            items:
                                teams
                                    .map(
                                      (t) => DropdownMenuItem(
                                        value: t,
                                        child: Text(
                                          t,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    )
                                    .toList(),
                            onChanged:
                                (val) => setState(() => selectedTeam = val),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Score Selector
                        buildScoreSelector(),

                        const SizedBox(height: 32),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                (selectedTeam != null &&
                                        selectedScore != null &&
                                        !isLoading)
                                    ? submitAssessment
                                    : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00707E),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child:
                                isLoading
                                    ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                    : const Text(
                                      "Kirim Penilaian",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                          ),
                        ),

                        const Spacer(),

                        // Informasi
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00707E).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Penilaian bersifat anonim dan akan digunakan untuk evaluasi kolaborasi tim",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF00707E),
                            ),
                            textAlign: TextAlign.center,
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
