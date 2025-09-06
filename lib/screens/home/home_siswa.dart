import 'package:flutter/material.dart';
import '../siswa/study/study_menu_screen.dart';
import '../siswa/study/cptp_screen.dart';
import '../siswa/chat_siswa.dart';
import '../siswa/test/practice_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeSiswa extends StatelessWidget {
  const HomeSiswa({super.key});

  final List<Map<String, dynamic>> menu = const [
    {"title": "Let's Study", "icon": Icons.menu_book, "color": Color(0xFF00707E)},
    {"title": "Let's Chat", "icon": Icons.chat, "color": Color(0xFF4CAF50)},
    {"title": "Let's Practice", "icon": Icons.edit, "color": Color(0xFFFF9800)},
    {"title": "Achievement", "icon": Icons.star, "color": Color(0xFFF44336)},
  ];

  void _navigateToMenu(BuildContext context, String title) {
    if (title == "Achievement") {
      Navigator.pushNamed(context, "/achievement");
    } else if (title == "Let's Study") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CpTpScreen()),
      );
    } else if (title == "Let's Chat") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ChatSiswaScreen(kelas: "a")),
      );
    } else if (title == "Let's Practice") {
      Navigator.pushNamed(context, "/practice");
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    // Mengambil username dari user_metadata, jika tidak ada gunakan nama dari email
    final userName = user?.userMetadata?['name'] ?? 'Siswa';

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header dengan logo dan user info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/images/logo_univecos.png",
                      height: 50,
                    ),
                    Text(
                      userName,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, "/login");
                      },
                    ),
                  ],
                ),
              ),

              // Welcome section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/welcome_to.png", height: 100),
                    Image.asset("assets/images/logo_univecos.png", height: 150),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Menu Grid
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.9,
                            ),
                            itemCount: menu.length,
                            itemBuilder: (context, index) {
                              final item = menu[index];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 4,
                                child: InkWell(
                                  onTap: () => _navigateToMenu(context, item['title']),
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          item['color'],
                                          item['color'].withOpacity(0.7),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          item['icon'],
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                        SizedBox(height: 12),
                                        Text(
                                          item['title'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
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