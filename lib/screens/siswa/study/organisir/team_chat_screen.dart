// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class TeamChatScreen extends StatefulWidget {
//   final String team;
//   const TeamChatScreen({super.key, required this.team});

//   @override
//   State<TeamChatScreen> createState() => _TeamChatScreenState();
// }

// class _TeamChatScreenState extends State<TeamChatScreen> {
//   final SupabaseClient supabase = Supabase.instance.client;
//   final TextEditingController _messageController = TextEditingController();
//   List<Map<String, dynamic>> messages = [];
//   late final RealtimeChannel _channel;

//   @override
//   void initState() {
//     super.initState();
//     _loadMessages();
//     _subscribeRealtime();
//   }

//   @override
//   void dispose() {
//     _channel.unsubscribe();
//     super.dispose();
//   }

//   Future<void> _loadMessages() async {
//     final response = await supabase
//         .from('chat_team')
//         .select()
//         .eq('team', widget.team)
//         .order('created_at', ascending: true);

//     setState(() {
//       messages = List<Map<String, dynamic>>.from(response);
//     });
//   }

//   void _subscribeRealtime() {
//     _channel = supabase.channel('chat_team-${widget.team}');

//     _channel
//         .onPostgresChanges(
//           event: PostgresChangeEvent.insert,
//           schema: 'public',
//           table: 'chat_team',
//           filter: PostgresChangeFilter(
//             type: PostgresChangeFilterType.eq,
//             column: 'team',
//             value: widget.team,
//           ),
//           callback: (payload) {
//             setState(() {
//               messages.add(payload.newRecord);
//             });
//           },
//         )
//         .subscribe();
//   }

//   Future<void> _sendMessage() async {
//     if (_messageController.text.trim().isEmpty) return;

//     final userId = supabase.auth.currentUser?.id;
//     if (userId == null) return;

//     // Ambil nama dari tabel profiles
//     final profileResponse = await supabase
//         .from('profiles')
//         .select('name')
//         .eq('id', userId)
//         .single();

//     final userName = profileResponse['name'] ?? 'Anonim';

//     await supabase.from('chat_team').insert({
//       'team': widget.team,
//       'sender_id': userId,
//       'username': userName, // simpan username ke tabel chat_team
//       'message': _messageController.text.trim(),
//     });

//     _messageController.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Team Chat - ${widget.team}")),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 final msg = messages[index];
//                 return ListTile(
//                   title: Text(msg['username'] ?? 'Anonim'),
//                   subtitle: Text(msg['message']),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: const InputDecoration(
//                       hintText: "Ketik pesan...",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: _sendMessage,
//                   icon: const Icon(Icons.send),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TeamChatScreen extends StatefulWidget {
  final String team;
  const TeamChatScreen({super.key, required this.team});

  @override
  State<TeamChatScreen> createState() => _TeamChatScreenState();
}

class _TeamChatScreenState extends State<TeamChatScreen> {
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
        .from('chat_team')
        .select()
        .eq('team', widget.team)
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
    _channel = supabase.channel('chat_team-${widget.team}');

    _channel
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'chat_team',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'team',
            value: widget.team,
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

    await supabase.from('chat_team').insert({
      'team': widget.team,
      'sender_id': userId,
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
                    Expanded(
                      child: Text(
                        "Team Chat - ${widget.team}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // Icon Chat Team
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                margin: const EdgeInsets.only(bottom: 16),
                child: const Center(
                  child: Icon(
                    Icons.group,
                    size: 80,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),

              // Chat Area
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
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
                                        "Mulai percakapan dengan tim",
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
                                        msg['sender_id'] ==
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
                                              backgroundColor: const Color(
                                                0xFF00707E,
                                              ),
                                              child: Text(
                                                msg['username']
                                                        ?.toString()
                                                        .substring(0, 1)
                                                        .toUpperCase() ??
                                                    'A',
                                                style: const TextStyle(
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
                                                        ? const Color(
                                                          0xFF00707E,
                                                        )
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
                                              backgroundColor: const Color(
                                                0xFFA9F67F,
                                              ),
                                              child: Text(
                                                msg['username']
                                                        ?.toString()
                                                        .substring(0, 1)
                                                        .toUpperCase() ??
                                                    'A',
                                                style: const TextStyle(
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
                                  color: Colors.grey[100]?.withOpacity(0.3),
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
                                      icon: const Icon(
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
