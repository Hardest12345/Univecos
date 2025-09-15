import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';

class StudentTestScreen extends StatefulWidget {
  final String testType; // "pre", "post", "practice"
  const StudentTestScreen({super.key, required this.testType});

  @override
  State<StudentTestScreen> createState() => _StudentTestScreenState();
}

class _StudentTestScreenState extends State<StudentTestScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _questions = [];
  Map<String, int> _answers = {}; // key: questionId, value: chosen index
  bool _loading = true;
  int _currentQuestionIndex = 0;
  bool _showResults = false;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    final res = await supabase
        .from('test_questions')
        .select()
        .eq('test_type', widget.testType)
        .order('created_at');

    setState(() {
      _questions = List<Map<String, dynamic>>.from(res);
      _loading = false;
    });
  }

  void _submitAnswers() async {
    int correct = 0;
    for (var q in _questions) {
      final qId = q['id'];
      final correctIndex = q['correct_index'];
      if (_answers[qId] == correctIndex) {
        correct++;
      }
    }

    int score =
        ((_questions.isEmpty ? 0 : (correct / _questions.length)) * 100)
            .round();

    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    // 🔹 hapus hasil lama sebelum insert
    await supabase
        .from("tests")
        .delete()
        .eq("user_id", userId)
        .eq("test_type", widget.testType);

    // 🔹 simpan hasil baru
    await supabase.from("tests").insert({
      'user_id': userId,
      'test_type': widget.testType,
      'score': score,
    });

    setState(() {
      _score = score;
      _showResults = true;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _restartTest() {
    setState(() {
      _answers = {};
      _currentQuestionIndex = 0;
      _showResults = false;
      _score = 0;
    });
  }

  String getTestTypeTitle() {
    switch (widget.testType) {
      case "pre":
        return "Pre-Test";
      case "post":
        return "Post-Test";
      case "practice":
        return "Practice Questions";
      default:
        return "Test";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
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
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      );
    }

    if (_showResults) {
      return _buildResultsScreen();
    }

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
              // Header
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
                    Text(
                      getTestTypeTitle(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "Soal ${_currentQuestionIndex + 1}/${_questions.length}",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),

              // Progress Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: LinearProgressIndicator(
                  value: (_currentQuestionIndex + 1) / _questions.length,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFA9F67F),
                  ),
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
                    child: _buildQuestionCard(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard() {
    if (_questions.isEmpty) return const SizedBox();

    final q = _questions[_currentQuestionIndex];
    final options = List<String>.from(jsonDecode(q['options']));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question Text
        Text(
          "Pertanyaan ${_currentQuestionIndex + 1}",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00707E),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          q['question_text'],
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 24),

        // Options
        Expanded(
          child: ListView.builder(
            itemCount: options.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color:
                    _answers[q['id']] == index
                        ? const Color(0xFF00707E).withOpacity(0.1)
                        : Colors.white,
                child: ListTile(
                  title: Text(
                    options[index],
                    style: TextStyle(
                      color:
                          _answers[q['id']] == index
                              ? const Color(0xFF00707E)
                              : Colors.black87,
                      fontWeight:
                          _answers[q['id']] == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                    ),
                  ),
                  leading: Radio<int>(
                    value: index,
                    groupValue: _answers[q['id']],
                    onChanged: (val) {
                      setState(() {
                        _answers[q['id']] = val!;
                      });
                    },
                    activeColor: const Color(0xFF00707E),
                  ),
                  onTap: () {
                    setState(() {
                      _answers[q['id']] = index;
                    });
                  },
                ),
              );
            },
          ),
        ),

        // Navigation Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: _previousQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00707E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.arrow_back, size: 16),
                  SizedBox(width: 4),
                  Text("Sebelumnya"),
                ],
              ),
            ),
            if (_currentQuestionIndex == _questions.length - 1)
              ElevatedButton(
                onPressed: () {
                  bool allAnswered = _answers.length == _questions.length;
                  if (allAnswered) {
                    _submitAnswers();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Silakan jawab semua soal terlebih dahulu",
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check, size: 16),
                    SizedBox(width: 4),
                    Text("Selesai"),
                  ],
                ),
              )
            else
              ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00707E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Row(
                  children: [
                    Text("Selanjutnya"),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward, size: 16),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildResultsScreen() {
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
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.emoji_events,
                    size: 64,
                    color: _getScoreColor(_score),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Hasil ${getTestTypeTitle()}",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00707E),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Nilai Kamu:",
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$_score%",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: _getScoreColor(_score),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _getScoreMessage(_score),
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00707E),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text("Kembali"),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _restartTest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text("Ulangi Tes"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return const Color(0xFF4CAF50);
    if (score >= 60) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }

  String _getScoreMessage(int score) {
    if (score >= 80) return "Excellent! Kamu menguasai materi dengan baik!";
    if (score >= 60) return "Good job! Tingkatkan lagi pemahamanmu!";
    return "Jangan menyerah! Pelajari lagi materinya!";
  }
}
