import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MyAchievementScreen extends StatefulWidget {
  const MyAchievementScreen({super.key});

  @override
  State<MyAchievementScreen> createState() => _MyAchievementScreenState();
}

class _MyAchievementScreenState extends State<MyAchievementScreen> {
  final supabase = Supabase.instance.client;

  double? achievementPercent;
  String? pdfUrl;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadAchievement();
  }

  Future<void> _loadAchievement() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final res =
        await supabase
            .from('reports')
            .select()
            .eq('student_id', user.id)
            .order('created_at', ascending: false)
            .limit(1)
            .maybeSingle();

    if (mounted) {
      setState(() {
        if (res != null) {
          achievementPercent = (res['achievement_percent'] as num?)?.toDouble();
          pdfUrl = res['file_url'] as String?;
        }
        loading = false;
      });
    }
  }

  Future<void> _openPdf() async {
    if (pdfUrl == null) return;

    final uri = Uri.parse(pdfUrl!);
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tidak dapat membuka PDF")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error membuka PDF: $e")));
      }
    }
  }

  String _getAchievementMessage(double percent) {
    if (percent >= 90) return "Excellent! Pencapaian luar biasa! 🎉";
    if (percent >= 75) return "Great job! Terus pertahankan! 👍";
    if (percent >= 60) return "Good! Tingkatkan lagi! 💪";
    return "Keep learning! Jangan menyerah! 🌟";
  }

  Color _getAchievementColor(double percent) {
    if (percent >= 90) return const Color(0xFF4CAF50);
    if (percent >= 75) return const Color(0xFFFF9800);
    if (percent >= 60) return const Color(0xFF2196F3);
    return const Color(0xFFF44336);
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
                      "My Achievement",
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
                    child:
                        loading
                            ? const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF00707E),
                                ),
                              ),
                            )
                            : achievementPercent == null
                            ? _buildEmptyState()
                            : _buildAchievementContent(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emoji_events, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            "Belum Ada Pencapaian",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00707E),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Lanjutkan pembelajaran untuk mendapatkan pencapaian pertama Anda",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementContent() {
    final percent = achievementPercent!;
    final achievementColor = _getAchievementColor(percent);
    final achievementMessage = _getAchievementMessage(percent);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Achievement Icon
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: achievementColor.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: achievementColor, width: 3),
          ),
          child: Icon(Icons.emoji_events, size: 48, color: achievementColor),
        ),

        const SizedBox(height: 24),

        // Achievement Title
        const Text(
          "Pencapaian Terbaru",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00707E),
          ),
        ),

        const SizedBox(height: 16),

        // Circular Progress Indicator
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 180,
              height: 180,
              child: CircularProgressIndicator(
                value: percent / 100,
                strokeWidth: 12,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(achievementColor),
              ),
            ),
            Column(
              children: [
                Text(
                  "${percent.toStringAsFixed(1)}%",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: achievementColor,
                  ),
                ),
                Text(
                  "Completed",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Achievement Message
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: achievementColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: achievementColor.withOpacity(0.3)),
          ),
          child: Text(
            achievementMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: achievementColor,
            ),
          ),
        ),

        const SizedBox(height: 32),

        // PDF Report Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: pdfUrl != null ? _openPdf : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00707E),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.picture_as_pdf, color: Colors.white),
                const SizedBox(width: 8),
                const Text(
                  "Lihat Laporan PDF",
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

        // Refresh Button
        TextButton(
          onPressed: _loadAchievement,
          child: const Text(
            "Refresh Pencapaian",
            style: TextStyle(color: Color(0xFF00707E)),
          ),
        ),
      ],
    );
  }
}
