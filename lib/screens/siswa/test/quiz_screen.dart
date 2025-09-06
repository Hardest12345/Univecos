import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QuizScreen extends StatefulWidget {
  final String testType;
  const QuizScreen({super.key, required this.testType});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final supabase = Supabase.instance.client;

  List<dynamic> questions = [];
  Map<String, int?> answers = {}; // questionId -> selectedIndex
  bool loading = true;
  int currentQuestionIndex = 0;
  bool showResults = false;
  int score = 0;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    final res = await supabase
        .from("test_questions")
        .select()
        .eq("test_type", widget.testType)
        .order('created_at');
    setState(() {
      questions = res;
      answers = {for (var q in res) q["id"]: null};
      loading = false;
    });
  }

  Future<void> submit() async {
    int correct = 0;
    for (var q in questions) {
      final chosen = answers[q["id"]];
      if (chosen == q["correct_index"]) correct++;
    }
    final calculatedScore = ((correct / questions.length) * 100).round();

    final user = supabase.auth.currentUser;
    if (user == null) return;

    // 🔹 hapus hasil lama sebelum insert
    await supabase
        .from("tests")
        .delete()
        .eq("user_id", user.id)
        .eq("test_type", widget.testType);

    // 🔹 simpan hasil baru
    await supabase.from("tests").insert({
      "user_id": user.id,
      "test_type": widget.testType,
      "score": calculatedScore,
    });

    setState(() {
      score = calculatedScore;
      showResults = true;
    });
  }

  void _nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    }
  }

  void _previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }

  void _restartQuiz() {
    setState(() {
      answers = {for (var q in questions) q["id"]: null};
      currentQuestionIndex = 0;
      showResults = false;
      score = 0;
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
        return "Quiz";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
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

    if (showResults) {
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
                      "Soal ${currentQuestionIndex + 1}/${questions.length}",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),

              // Progress Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: LinearProgressIndicator(
                  value:
                      questions.isEmpty
                          ? 0
                          : (currentQuestionIndex + 1) / questions.length,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
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
    if (questions.isEmpty) return const SizedBox();

    final q = questions[currentQuestionIndex];
    final options = List<String>.from(q["options"]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question Text
        Text(
          "Pertanyaan ${currentQuestionIndex + 1}",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00707E),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          q["question_text"],
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
                    answers[q["id"]] == index
                        ? const Color(0xFF00707E).withOpacity(0.1)
                        : Colors.white,
                child: ListTile(
                  title: Text(
                    options[index],
                    style: TextStyle(
                      color:
                          answers[q["id"]] == index
                              ? const Color(0xFF00707E)
                              : Colors.black87,
                      fontWeight:
                          answers[q["id"]] == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                    ),
                  ),
                  leading: Radio<int>(
                    value: index,
                    groupValue: answers[q["id"]],
                    onChanged: (val) {
                      setState(() {
                        answers[q["id"]] = val;
                      });
                    },
                    activeColor: const Color(0xFF00707E),
                  ),
                  onTap: () {
                    setState(() {
                      answers[q["id"]] = index;
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
                backgroundColor: Colors.white, // ✅ jadi putih
                foregroundColor: const Color(
                  0xFF00707E,
                ), // ✅ teks & ikon jadi biru
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
            if (currentQuestionIndex == questions.length - 1)
              ElevatedButton(
                onPressed: () {
                  bool allAnswered = answers.values.every(
                    (answer) => answer != null,
                  );
                  if (allAnswered) {
                    submit();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Silakan jawab semua soal terlebih dahulu",
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // ✅ jadi putih
                  foregroundColor: const Color(
                    0xFF4CAF50,
                  ), // ✅ teks & ikon hijau
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
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                  const Icon(
                    Icons.emoji_events,
                    size: 64,
                    color: Color(0xFFFFD700),
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
                    "$score%",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: _getScoreColor(score),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed:
                            () => Navigator.popUntil(
                              context,
                              (route) => route.isFirst,
                            ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00707E),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text("Kembali ke Menu"),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _restartQuiz,
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
}
