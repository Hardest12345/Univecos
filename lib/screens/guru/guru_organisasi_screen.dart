import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GuruOrganisasiScreen extends StatefulWidget {
  final String kelas;
  const GuruOrganisasiScreen({super.key, required this.kelas});

  @override
  State<GuruOrganisasiScreen> createState() => _GuruOrganisasiScreenState();
}

class _GuruOrganisasiScreenState extends State<GuruOrganisasiScreen> {
  final supabase = Supabase.instance.client;
  Map<String, List<Map<String, dynamic>>> teamMessages = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTeamChats();
  }

  Future<void> _loadTeamChats() async {
    final res = await supabase
        .from("chat_team")
        .select()
        .order("created_at", ascending: true);

    final grouped = <String, List<Map<String, dynamic>>>{};
    for (var msg in res) {
      grouped.putIfAbsent(msg["team"], () => []);
      grouped[msg["team"]]!.add(msg);
    }

    setState(() {
      teamMessages = grouped;
      _loading = false;
    });
  }

  Widget _buildTeamChats() {
    if (teamMessages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.group, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              "Belum ada diskusi organisasi tim",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children:
          teamMessages.entries.map((entry) {
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ExpansionTile(
                leading: const Icon(Icons.group, color: Color(0xFF00707E)),
                title: Text(
                  "Team ${entry.key}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                children:
                    entry.value.map((msg) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: const Color(
                                0xFF00707E,
                              ).withOpacity(0.2),
                              child: Text(
                                (msg["username"]
                                        ?.toString()
                                        .substring(0, 1)
                                        .toUpperCase() ??
                                    "A"),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF00707E),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    msg["username"] ?? "Anonim",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    msg["message"],
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    msg["created_at"].toString().substring(
                                      0,
                                      16,
                                    ),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            );
          }).toList(),
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
                        "Organisasi Tim - ${widget.kelas}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: _loadTeamChats,
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
                          : _buildTeamChats(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
