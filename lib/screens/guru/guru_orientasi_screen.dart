import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GuruOrientasiScreen extends StatefulWidget {
  final String kelas;
  const GuruOrientasiScreen({super.key, required this.kelas});

  @override
  State<GuruOrientasiScreen> createState() => _GuruOrientasiScreenState();
}

class _GuruOrientasiScreenState extends State<GuruOrientasiScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> classMessages = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadClassChat();
  }

  Future<void> _loadClassChat() async {
    final res = await supabase
        .from("chats")
        .select()
        .eq("kelas", widget.kelas)
        .order("created_at", ascending: true);

    setState(() {
      classMessages = List<Map<String, dynamic>>.from(res);
      _loading = false;
    });
  }

  Widget _buildChatList() {
    if (classMessages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              "Belum ada diskusi orientasi",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: classMessages.length,
      itemBuilder: (context, index) {
        final msg = classMessages[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF00707E),
                child: Text(
                  (msg["username"]?.toString().substring(0, 1).toUpperCase() ??
                      "A"),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        msg["username"] ?? "Anonim",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00707E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(msg["message"]),
                      const SizedBox(height: 4),
                      Text(
                        msg["created_at"].toString().substring(0, 16),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
                        "Diskusi Orientasi - ${widget.kelas}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: _loadClassChat,
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
                          : _buildChatList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
