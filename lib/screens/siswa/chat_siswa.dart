import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatSiswaScreen extends StatefulWidget {
  final String kelas; // contoh: "keanekaragaman_hayati"
  const ChatSiswaScreen({super.key, required this.kelas});

  @override
  State<ChatSiswaScreen> createState() => _ChatSiswaScreenState();
}

class _ChatSiswaScreenState extends State<ChatSiswaScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> messages = [];
  late final RealtimeChannel _channel;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _subscribeRealtime();
  }

  @override
  void dispose() {
    _channel.unsubscribe();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    final response = await supabase
        .from('chats')
        .select()
        .eq('kelas', widget.kelas)
        .order('created_at', ascending: true);
    setState(() {
      messages = List<Map<String, dynamic>>.from(response);
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _subscribeRealtime() {
    _channel = supabase.channel('chat-${widget.kelas}');

    _channel
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'chats',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'kelas',
            value: widget.kelas,
          ),
          callback: (payload) {
            setState(() {
              messages.add(payload.newRecord);
              _scrollToBottom();
            });
          },
        )
        .subscribe();
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    // Ambil nama dari tabel profiles
    final profileResponse =
        await supabase
            .from('profiles')
            .select('name')
            .eq('id', userId)
            .single();

    final userName = profileResponse['name'] ?? 'Anonim';

    await supabase.from('chats').insert({
      'kelas': widget.kelas,
      'user_id': userId,
      'username': userName,
      'message': _messageController.text.trim(),
    });

    _messageController.clear();
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
                      "Let's Discussion",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Badge Dysclue
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                margin: const EdgeInsets.only(bottom: 16),
                // decoration: BoxDecoration(
                //   color: Colors.white.withOpacity(0.2),
                //   borderRadius: BorderRadius.circular(20),
                // ),
                // child: const Text(
                //   "Dysclue",
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontSize: 14,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
                child: const Center(
                  child: Icon(Icons.chat, size: 80, color: Color.fromARGB(255, 255, 255, 255)),
                ),
              ),

              // Chat Area
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    // color: Colors.white.withOpacity(0.95),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Messages List
                      Expanded(
                        child:
                            messages.isEmpty
                                ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.chat_bubble_outline,
                                        size: 48,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        "Mulai percakapan pertama",
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                : ListView.builder(
                                  controller: _scrollController,
                                  padding: const EdgeInsets.all(16),
                                  itemCount: messages.length,
                                  itemBuilder: (context, index) {
                                    final msg = messages[index];
                                    final isMe =
                                        msg['user_id'] ==
                                        supabase.auth.currentUser?.id;

                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            isMe
                                                ? MainAxisAlignment.end
                                                : MainAxisAlignment.start,
                                        children: [
                                          if (!isMe)
                                            CircleAvatar(
                                              backgroundColor: Color(
                                                0xFF00707E,
                                              ),
                                              child: Text(
                                                msg['username']
                                                        ?.toString()
                                                        .substring(0, 1)
                                                        .toUpperCase() ??
                                                    'A',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          if (!isMe) const SizedBox(width: 8),
                                          Flexible(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 12,
                                                  ),
                                              decoration: BoxDecoration(
                                                color:
                                                    isMe
                                                        ? Color(0xFF00707E)
                                                        : Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  if (!isMe)
                                                    Text(
                                                      msg['username'] ??
                                                          'Anonim',
                                                      style: TextStyle(
                                                        color: Colors.grey[700],
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  if (!isMe)
                                                    const SizedBox(height: 4),
                                                  Text(
                                                    msg['message'],
                                                    style: TextStyle(
                                                      color:
                                                          isMe
                                                              ? Colors.white
                                                              : Colors.black87,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          if (isMe) const SizedBox(width: 8),
                                          if (isMe)
                                            CircleAvatar(
                                              backgroundColor: Color(
                                                0xFFA9F67F,
                                              ),
                                              child: Text(
                                                msg['username']
                                                        ?.toString()
                                                        .substring(0, 1)
                                                        .toUpperCase() ??
                                                    'A',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                      ),

                      // Input Message
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          // color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, -2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[100]?.withOpacity(
                                    0.3,
                                  ), // Menambahkan opacity 0.7
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: TextField(
                                  controller: _messageController,
                                  decoration: InputDecoration(
                                    hintText: "Ketik pesan...",
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 14,
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: _sendMessage,
                                      icon: Icon(
                                        Icons.send,
                                        color: Color(0xFF00707E),
                                      ),
                                    ),
                                  ),
                                  onSubmitted: (_) => _sendMessage(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
}
