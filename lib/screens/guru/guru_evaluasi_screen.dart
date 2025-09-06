import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GuruEvaluasiScreen extends StatefulWidget {
  final String kelas;
  const GuruEvaluasiScreen({super.key, required this.kelas});

  @override
  State<GuruEvaluasiScreen> createState() => _GuruEvaluasiScreenState();
}

class _GuruEvaluasiScreenState extends State<GuruEvaluasiScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> teamScores = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTeamScores();
  }

  Future<void> _loadTeamScores() async {
    final res = await supabase.from("assessments").select("target_team, score");

    final grouped = <String, List<int>>{};
    for (var row in res) {
      final team = row["target_team"];
      final score = row["score"] as int;
      grouped.putIfAbsent(team, () => []);
      grouped[team]!.add(score);
    }

    final avgScores =
        grouped.entries.map((e) {
          final avg =
              e.value.isEmpty
                  ? 0
                  : e.value.reduce((a, b) => a + b) / e.value.length;
          return {"team": e.key, "avg_score": avg};
        }).toList();

    setState(() {
      teamScores = avgScores;
      _loading = false;
    });
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return const Color(0xFF4CAF50);
    if (score >= 60) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }

  Widget _buildTeamScores() {
    if (teamScores.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assessment, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              "Belum ada nilai assessment",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: teamScores.length,
      itemBuilder: (context, index) {
        final row = teamScores[index];
        final score = (row["avg_score"] as double);
        final scoreColor = _getScoreColor(score);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: const Icon(Icons.emoji_events, color: Color(0xFF00707E)),
            title: Text(
              "Team ${row["team"]}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: scoreColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: scoreColor),
              ),
              child: Text(
                score.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: scoreColor,
                ),
              ),
            ),
          ),
        );
      },
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
                    Expanded(
                      child: Text(
                        "Evaluasi Nilai - ${widget.kelas}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: _loadTeamScores,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child:
                      _loading
                          ? const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF00707E),
                              ),
                            ),
                          )
                          : _buildTeamScores(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
