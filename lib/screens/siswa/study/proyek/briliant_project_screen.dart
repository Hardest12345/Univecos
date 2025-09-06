// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'inspiration_project.dart';
// import 'my_project.dart';
// import '../organisir/team_chat_screen.dart';

// class BriliantProjectScreen extends StatefulWidget {
//   const BriliantProjectScreen({super.key});

//   @override
//   State<BriliantProjectScreen> createState() => _BriliantProjectScreenState();
// }

// class _BriliantProjectScreenState extends State<BriliantProjectScreen> {
//   String? _team;
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadProfile();
//   }

//   Future<void> _loadProfile() async {
//     final user = Supabase.instance.client.auth.currentUser;
//     if (user == null) return;

//     final response = await Supabase.instance.client
//         .from('profiles')
//         .select('team')
//         .eq('id', user.id)
//         .single();

//     setState(() {
//       _team = response['team'] as String?;
//       _loading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(title: const Text("Briliant Project")),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           ListTile(
//             title: const Text("Inspiration Project"),
//             subtitle: const Text("Cari inspirasi dari website"),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const InspirationProject()),
//               );
//             },
//           ),
//           ListTile(
//             title: const Text("My Project"),
//             subtitle: const Text("Rancangan, laporan, dan project"),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const MyProjectScreen()),
//               );
//             },
//           ),
//           ListTile(
//             title: const Text("Team Discussion"),
//             subtitle: const Text("Diskusi tim lewat chat"),
//             onTap: _team == null
//                 ? null
//                 : () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => TeamChatScreen(team: _team!),
//                       ),
//                     );
//                   },
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'inspiration_project.dart';
import 'my_project.dart';
import '../organisir/team_chat_screen.dart';

class BriliantProjectScreen extends StatefulWidget {
  const BriliantProjectScreen({super.key});

  @override
  State<BriliantProjectScreen> createState() => _BriliantProjectScreenState();
}

class _BriliantProjectScreenState extends State<BriliantProjectScreen> {
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
                      "Briliant Project",
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
                    // color: Colors.white.withOpacity(0.7),
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
                        // const Center(
                        //   child: Icon(
                        //     Icons.lightbulb,
                        //     size: 48,
                        //     color: Color(0xFFFFD700),
                        //   ),
                        // ),
                        const SizedBox(height: 16),
                        // const Center(
                        //   child: Text(
                        //     "Kelola Proyek Brilian Anda",
                        //     style: TextStyle(
                        //       fontSize: 20,
                        //       fontWeight: FontWeight.bold,
                        //       color: Color(0xFF00707E),
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(height: 12),
                        // const Text(
                        //   "Pilih menu untuk mengembangkan proyek brilian Anda:",
                        //   style: TextStyle(
                        //     fontSize: 14,
                        //     color: Colors.black87,
                        //     height: 1.5,
                        //   ),
                        //   textAlign: TextAlign.center,
                        // ),
                        const SizedBox(height: 24),

                        // Info Team
                        if (_team != null)
                          Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00707E).withOpacity(0.7),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFF00707E),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.group,
                                  color: Color(0xFF00707E),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    "Tim Anda: $_team",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Menu Grid
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.only(bottom: 16),
                            children: [
                              _buildMenuCard(
                                context,
                                "Inspiration Project",
                                Icons.search,
                                Colors.blue,
                                "Cari inspirasi dari website",
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => const InspirationProject(),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                              _buildMenuCard(
                                context,
                                "My Project",
                                Icons.work,
                                Colors.green,
                                "Rancangan, laporan, dan project",
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const MyProjectScreen(),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                              _buildMenuCard(
                                context,
                                "Team Discussion",
                                Icons.chat,
                                Colors.orange,
                                "Diskusi tim lewat chat",
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
    Color color,
    String subtitle,
    VoidCallback? onTap,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity, // biar full lebar
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon Container
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 28, color: Colors.white),
                ),
                const SizedBox(height: 12),

                // Title (langsung pakai Text, tanpa Flexible)
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // Subtitle (juga Text biasa saja)
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                // Lock icon jika disabled
                if (onTap == null)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Icon(
                      Icons.lock_outline,
                      size: 16,
                      color: Colors.white70,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
