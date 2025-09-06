import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../guru/guru_discuss_forum_screen.dart';
import '../guru/guru_test_result_screen.dart';
import '../guru/make_report_screen.dart';
import '../guru/guru_suggestion_screen.dart';
import '../guru/modul_ajar_preview.dart';

class HomeGuru extends StatefulWidget {
  const HomeGuru({super.key});

  @override
  State<HomeGuru> createState() => _HomeGuruState();
}

class _HomeGuruState extends State<HomeGuru> {
  final supabase = Supabase.instance.client;

  final List<Map<String, dynamic>> menu = const [
    {
      "title": "See Discuss Forum",
      "icon": Icons.forum,
      "color": Color(0xFF00707E),
      "description": "",
    },
    {
      "title": "See Practice Result",
      "icon": Icons.assignment,
      "color": Color(0xFF4CAF50),
      "description": "",
    },
    {
      "title": "Make Report",
      "icon": Icons.bar_chart,
      "color": Color(0xFFFF9800),
      "description": "",
    },
    {
      "title": "Make Suggestion",
      "icon": Icons.feedback,
      "color": Color.fromARGB(255, 255, 55, 0),
      "description": "",
    },
  ];

  List<String> _kelasList = [];
  bool _loadingKelas = false;

  Future<void> _fetchKelas() async {
    setState(() => _loadingKelas = true);
    try {
      final rows = await supabase.from('chats').select('kelas');
      final all =
          (rows as List)
              .map((e) => (e['kelas'] as String?)?.trim())
              .whereType<String>();
      final unique = {...all}.toList()..sort();
      setState(() {
        _kelasList = unique;
      });
    } catch (e) {
      debugPrint('Gagal fetch kelas: $e');
    } finally {
      setState(() => _loadingKelas = false);
    }
  }

  Future<void> _openKelasPicker(
    BuildContext context, {
    required String forMenu,
  }) async {
    if (_kelasList.isEmpty && !_loadingKelas) {
      await _fetchKelas();
    }

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Pilih Kelas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00707E),
                  ),
                ),
                const SizedBox(height: 12),
                if (_loadingKelas)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_kelasList.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('Belum ada kelas terdaftar.\nMasukkan manual.'),
                  )
                else
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: _kelasList.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final k = _kelasList[index];
                        return ListTile(
                          leading: Icon(Icons.class_, color: Color(0xFF00707E)),
                          title: Text(k),
                          onTap: () {
                            Navigator.pop(context);
                            if (forMenu == "forum") {
                              _goToDiscuss(k);
                            } else if (forMenu == "result") {
                              _goToResult(k);
                            }
                          },
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () => _enterKelasManual(context, forMenu: forMenu),
                  icon: const Icon(Icons.edit),
                  label: const Text('Masukkan Kelas Manual'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00707E),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _enterKelasManual(
    BuildContext context, {
    required String forMenu,
  }) async {
    Navigator.pop(context);
    final controller = TextEditingController();
    final kelas = await showDialog<String>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Masukkan Nama Kelas'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'mis. keanekaragaman_hayati',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, controller.text.trim()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00707E),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Pakai'),
              ),
            ],
          ),
    );

    if (kelas != null && kelas.isNotEmpty) {
      if (forMenu == "forum") {
        _goToDiscuss(kelas);
      } else if (forMenu == "result") {
        _goToResult(kelas);
      }
    }
  }

  void _goToDiscuss(String kelas) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => GuruDiscussForumScreen(kelas: kelas)),
    );
  }

  void _goToResult(String kelas) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GuruSeePracticeResultScreen(kelas: kelas),
      ),
    );
  }

  void _handleMenuTap(String title) {
    switch (title) {
      case "See Discuss Forum":
        _openKelasPicker(context, forMenu: "forum");
        break;
      case "See Practice Result":
        _openKelasPicker(context, forMenu: "result");
        break;
      case "Make Report":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ReportUploadScreen()),
        );
        break;
      case "Make Suggestion":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GuruSuggestionScreen()),
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final userName = user?.userMetadata?['name'] ?? 'Guru';

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset("assets/images/logo_univecos.png", height: 50),
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

              const SizedBox(height: 24),

              // Menu Grid
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
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
                        const SizedBox(height: 16),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
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
                                  onTap: () => _handleMenuTap(item['title']),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          item['icon'],
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          item['title'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        // const SizedBox(height: 8),

                                        // const SizedBox(height: 12),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF00707E), Color(0xFFA9F67F)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent, // transparan biar gradient kelihatan
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PdfPreviewPage(
                                      pdfPath: 'assets/pdf/modul_ajar.pdf',
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                "Unduh Modul Ajar Guru",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )

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
