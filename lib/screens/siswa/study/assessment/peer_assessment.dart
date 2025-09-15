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
  List<int?> selectedScores = List.filled(10, null);
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
    if (selectedTeam == null || selectedScores.contains(null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap pilih tim dan isi semua penilaian!'),
        ),
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
          'target_team': selectedTeam,
          'score': selectedScores[i],
          // 'question_number': i + 1,
          'type': 'peer',
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Penilaian peer berhasil dikirim!')),
      );

      setState(() {
        selectedTeam = null;
        selectedScores = List.filled(10, null);
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

  Widget buildQuestionCard(int index) {
    final questions = [
      "Tim tersebut menunjukkan kepedulian terhadap makhluk hidup dalam ekosistem yang mengalami gangguan.",
      "Tim tersebut mampu mengekspresikan perasaan yang selaras dengan kondisi makhluk hidup dalam ekosistem.",
      "Tim tersebut berpartisipasi aktif dalam kegiatan bersama untuk menjaga kelangsungan hidup ekosistem.",
      "Tim tersebut dapat menjelaskan konsep ekologi yang abstrak dengan menggunakan contoh nyata yang mudah dipahami.",
      "Tim tersebut dapat menghubungkan konsep ekologi dengan peristiwa nyata di lingkungan sekitar.",
      "Tim tersebut memahami bahwa tindakan manusia yang berbahaya dapat menimbulkan dampak bagi ekosistem.",
      "Tim tersebut dapat mengantisipasi dampak ekologis yang tak terduga dari tindakan manusia.",
      "Tim tersebut dapat merencanakan solusi yang tepat untuk mengurangi dampak ekologis.",
      "Tim tersebut berusaha memahami proses alam dengan melihat bukti nyata dari pengamatan atau data ilmiah.",
      "Tim tersebut dapat menilai apakah suatu proses alam berjalan baik atau terganggu berdasarkan data pengamatan.",
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
                      color:
                          selectedScores[index] == score
                              ? const Color(0xFFFFD700)
                              : Colors.grey[200],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            selectedScores[index] == score
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
                        color:
                            selectedScores[index] == score
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
                          "Berikan penilaian untuk tim lain berdasarkan kolaborasi dan kontribusi mereka dalam aspek ekologi:",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),

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
                                vertical: 12,
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

                        const SizedBox(height: 16),

                        // Questions List (hanya muncul jika tim sudah dipilih)
                        if (selectedTeam != null) ...[
                          const SizedBox(height: 16),
                          const Text(
                            "Penilaian Aspek Ekologi:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00707E),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: List.generate(
                                  10,
                                  (index) => buildQuestionCard(index),
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          const Spacer(),
                          const Center(
                            child: Text(
                              "Pilih tim terlebih dahulu untuk melihat pertanyaan penilaian",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const Spacer(),
                        ],

                        const SizedBox(height: 16),

                        // Submit Button
                        if (selectedTeam != null)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed:
                                  (selectedTeam != null &&
                                          !selectedScores.contains(null) &&
                                          !isLoading)
                                      ? submitAssessment
                                      : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00707E),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
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
                                            "Kirim Penilaian",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                            ),
                          ),

                        const SizedBox(height: 8),

                        // Informasi
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00707E).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Penilaian bersifat anonim dan akan digunakan untuk evaluasi kolaborasi tim dalam aspek ekologi",
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
