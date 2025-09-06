import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GuruSeePracticeResultScreen extends StatefulWidget {
  final String kelas;
  const GuruSeePracticeResultScreen({super.key, required this.kelas});

  @override
  State<GuruSeePracticeResultScreen> createState() =>
      _GuruSeePracticeResultScreenState();
}

class _GuruSeePracticeResultScreenState
    extends State<GuruSeePracticeResultScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final supabase = Supabase.instance.client;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<List<Map<String, dynamic>>> fetchResults(String testType) async {
    final response = await supabase
        .from('profiles')
        .select('id, name, tests!inner(score, test_type, created_at)')
        .eq('role', 'siswa')
        .eq('class', widget.kelas)
        .eq('tests.test_type', testType)
        .order(
          'created_at',
          ascending: false,
          nullsFirst: false,
        );

    if (response.isEmpty) return [];

    final Map<String, Map<String, dynamic>> latestScores = {};
    for (final row in response) {
      final id = row['id'];
      final tests = row['tests'] as List<dynamic>;
      if (tests.isNotEmpty && !latestScores.containsKey(id)) {
        final latest = tests.first;
        latestScores[id] = {
          'name': row['name'],
          'score': latest['score'],
          'test_type': testType
        };
      }
    }
    return latestScores.values.toList();
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return const Color(0xFF4CAF50);
    if (score >= 60) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }

  String _getScoreMessage(int score) {
    if (score >= 80) return "Excellent";
    if (score >= 60) return "Good";
    return "Need Improvement";
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Hasil Tes - ${widget.kelas}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Tab Bar
              Container(
                color: Colors.white,
                child: TabBar(
                  controller: _tabController,
                  labelColor: const Color(0xFF00707E),
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: const Color(0xFF00707E),
                  tabs: const [
                    Tab(text: "Pre-Test"),
                    Tab(text: "Post-Test"),
                  ],
                ),
              ),

              // Konten utama
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildResultContent("pre"),
                      _buildResultContent("post"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultContent(String testType) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchResults(testType),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00707E)),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error: ${snapshot.error}",
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final data = snapshot.data ?? [];
        
        if (data.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.assignment,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                const Text(
                  "Belum ada nilai siswa",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(16),
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
                    Icon(
                      testType == "pre" ? Icons.assignment : Icons.assignment_turned_in,
                      color: const Color(0xFF00707E),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        testType == "pre" 
                          ? "Hasil Pre-Test Siswa" 
                          : "Hasil Post-Test Siswa",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00707E),
                        ),
                      ),
                    ),
                    Text(
                      "${data.length} Siswa",
                      style: const TextStyle(
                        color: Color(0xFF00707E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),

              // Student Results List
              Column(
                children: data.map((siswa) {
                  final score = siswa['score'] as int;
                  final scoreColor = _getScoreColor(score);
                  final scoreMessage = _getScoreMessage(score);
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFF00707E).withOpacity(0.1),
                        child: Text(
                          siswa['name'].toString().substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFF00707E),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        siswa['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        scoreMessage,
                        style: TextStyle(
                          color: scoreColor,
                          fontSize: 12,
                        ),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: scoreColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: scoreColor),
                        ),
                        child: Text(
                          "$score%",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: scoreColor,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // Statistics Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF00707E).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF00707E).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard(
                      "Rata-rata",
                      _calculateAverage(data),
                      Icons.bar_chart,
                    ),
                    _buildStatCard(
                      "Tertinggi",
                      _calculateHighest(data),
                      Icons.arrow_upward,
                    ),
                    _buildStatCard(
                      "Terendah",
                      _calculateLowest(data),
                      Icons.arrow_downward,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, int value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF00707E)),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        Text(
          "$value%",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00707E),
          ),
        ),
      ],
    );
  }

  int _calculateAverage(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return 0;
    final total = data.fold(0, (sum, siswa) => sum + (siswa['score'] as int));
    return (total / data.length).round();
  }

  int _calculateHighest(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return 0;
    return data.fold(0, (max, siswa) => 
      (siswa['score'] as int) > max ? siswa['score'] : max
    );
  }

  int _calculateLowest(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return 0;
    return data.fold(100, (min, siswa) => 
      (siswa['score'] as int) < min ? siswa['score'] : min
    );
  }
}