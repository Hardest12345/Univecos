import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

/// Widget utama: daftar bubble chat
class ChatBubbleList extends StatefulWidget {
  const ChatBubbleList({super.key});

  @override
  State<ChatBubbleList> createState() => _ChatBubbleListState();
}

class _ChatBubbleListState extends State<ChatBubbleList> {
  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _subscribeMessages();
  }

  Future<void> _loadMessages() async {
    final response = await supabase
        .from("chats")
        .select()
        .eq("chat_type", "class")
        .order("created_at");
    setState(() {
      _messages.addAll(response);
    });
  }

  void _subscribeMessages() {
    supabase.channel("chats-class")
      .onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: "public",
        table: "chats",
        callback: (payload) {
          setState(() {
            _messages.add(payload.newRecord!);
          });
        },
      )
      .subscribe();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final msg = _messages[index];
        final isMe = msg["sender"] == supabase.auth.currentUser?.id;
        return ChatBubble(
          message: msg["message"] ?? "",
          isMe: isMe,
        );
      },
    );
  }
}

/// Komponen kecil: bubble pesan tunggal
class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue[200] : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(message),
      ),
    );
  }
}

/// Input field untuk kirim pesan
class ChatInputField extends StatefulWidget {
  const ChatInputField({super.key});

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty) return;
    await supabase.from("chats").insert({
      "sender": supabase.auth.currentUser?.id,
      "chat_type": "class",
      "message": _controller.text,
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Ketik pesan...",
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(12),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          )
        ],
      ),
    );
  }
}
