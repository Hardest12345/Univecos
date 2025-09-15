import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'organisir/team_chat_screen.dart';
import 'organisir/smartbooks_screen.dart';
import 'organisir/ai_chat_screen.dart';
import 'organisir/metaverse_screen.dart';

class OrganizerScreen extends StatefulWidget {
  const OrganizerScreen({super.key});

  @override
  State<OrganizerScreen> createState() => _OrganizerScreenState();
}

class _OrganizerScreenState extends State<OrganizerScreen> {
  String? _team;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final response =
        await Supabase.instance.client
            .from('profiles')
            .select('team')
            .eq('id', user.id)
            .single();

    setState(() {
      _team = response['team'] as String?;
      _loading = false;
    });
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
                      "Mengorganisasi Siswa Untuk Belajar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
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
                            Icons.people,
                            size: 48,
                            color: Color(0xFF00707E),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Center(
                          child: Text(
                            "Organisasi Pembelajaran",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00707E),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Kelola pembelajaran dan kolaborasi dengan tim Anda:",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),

                        // Info Team
                        if (_team != null)
                          Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 20),
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
                                Icon(Icons.group, color: Color(0xFF00707E)),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    "Tim Anda: $_team",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF00707E),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Menu Grid
                        Expanded(
                          child: GridView(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 0.9,
                                ),
                            children: [
                              _buildMenuCard(
                                context,
                                "Chat Tim",
                                Icons.chat,
                                _team == null
                                    ? null
                                    : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) =>
                                                  TeamChatScreen(team: _team!),
                                        ),
                                      );
                                    },
                              ),
                              _buildMenuCard(
                                context,
                                "E-Books",
                                Icons.menu_book,
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const SmartbooksScreen(),
                                    ),
                                  );
                                },
                              ),
                              _buildMenuCard(
                                context,
                                "AI Chatbot",
                                Icons.smart_toy,
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const AiChatScreen(),
                                    ),
                                  );
                                },
                              ),
                              _buildMenuCard(
                                context,
                                "Metaverse",
                                Icons.public,
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const MetaverseScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
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

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback? onTap,
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
              colors: [
                const Color(0xFF00707E),
                const Color(0xFF00707E).withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              if (onTap == null)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    "Belum ada tim",
                    style: TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
