// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class AiChatScreen extends StatefulWidget {
//   const AiChatScreen({super.key});

//   @override
//   State<AiChatScreen> createState() => _AiChatScreenState();
// }

// class _AiChatScreenState extends State<AiChatScreen> {
//   final TextEditingController _controller = TextEditingController();
//   final List<Map<String, String>> _messages = [];
//   bool _isLoading = false;

//   // Masukkan API KEY kamu di sini
//   final String apiKey = "AIzaSyCvwak3ZEaShlpVEw8DAHd0KaeTU3kvCzQ";

//   Future<void> sendMessage(String userMessage) async {
//     setState(() {
//       _messages.add({"role": "user", "text": userMessage});
//       _isLoading = true;
//     });

//     final url = Uri.parse(
//       "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$apiKey",
//     );

//     final headers = {"Content-Type": "application/json"};

//     final body = jsonEncode({
//       "contents": [
//         {
//           "parts": [
//             {"text": userMessage},
//           ],
//         },
//       ],
//     });

//     try {
//       final response = await http.post(url, headers: headers, body: body);

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final reply =
//             data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"] ??
//             "Tidak ada balasan dari AI";

//         setState(() {
//           _messages.add({"role": "ai", "text": reply});
//         });
//       } else {
//         setState(() {
//           _messages.add({
//             "role": "ai",
//             "text": "Error ${response.statusCode}: ${response.body}",
//           });
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _messages.add({"role": "ai", "text": "Terjadi kesalahan: $e"});
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("AI Chat")),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(8),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final message = _messages[index];
//                 final isUser = message["role"] == "user";
//                 return Align(
//                   alignment:
//                       isUser ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     padding: const EdgeInsets.all(10),
//                     margin: const EdgeInsets.symmetric(vertical: 4),
//                     decoration: BoxDecoration(
//                       color: isUser ? Colors.blue : Colors.grey[300],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Text(
//                       message["text"] ?? "",
//                       style: TextStyle(
//                         color: isUser ? Colors.white : Colors.black,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           if (_isLoading)
//             const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: CircularProgressIndicator(),
//             ),
//           Padding(
//             padding: const EdgeInsets.all(8),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: const InputDecoration(
//                       hintText: "Tulis pesan...",
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: () {
//                     final text = _controller.text.trim();
//                     if (text.isNotEmpty) {
//                       sendMessage(text);
//                       _controller.clear();
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  // Masukkan API KEY kamu di sini
  final String apiKey = "AIzaSyCvwak3ZEaShlpVEw8DAHd0KaeTU3kvCzQ";

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

  Future<void> sendMessage(String userMessage) async {
    setState(() {
      _messages.add({"role": "user", "text": userMessage});
      _isLoading = true;
      _scrollToBottom();
    });

    final url = Uri.parse(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$apiKey",
    );

    final headers = {"Content-Type": "application/json"};

    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": userMessage},
          ],
        },
      ],
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply =
            data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"] ??
            "Tidak ada balasan dari AI";

        setState(() {
          _messages.add({"role": "ai", "text": reply});
          _scrollToBottom();
        });
      } else {
        setState(() {
          _messages.add({
            "role": "ai",
            "text": "Error ${response.statusCode}: ${response.body}",
          });
          _scrollToBottom();
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({"role": "ai", "text": "Terjadi kesalahan: $e"});
        _scrollToBottom();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                      "AI Assistant",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Icon AI
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                margin: const EdgeInsets.only(bottom: 16),
                child: const Center(
                  child: Icon(
                    Icons.smart_toy,
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
                            _messages.isEmpty
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
                                        "Tanyakan sesuatu kepada AI assistant",
                                        style: TextStyle(
                                          color: const Color.fromARGB(255, 255, 255, 255),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                : ListView.builder(
                                  controller: _scrollController,
                                  padding: const EdgeInsets.all(16),
                                  itemCount: _messages.length,
                                  itemBuilder: (context, index) {
                                    final message = _messages[index];
                                    final isUser = message["role"] == "user";

                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            isUser
                                                ? MainAxisAlignment.end
                                                : MainAxisAlignment.start,
                                        children: [
                                          if (!isUser)
                                            CircleAvatar(
                                              backgroundColor: Color(
                                                0xFF00707E,
                                              ),
                                              child: const Icon(
                                                Icons.smart_toy,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          if (!isUser) const SizedBox(width: 8),
                                          Flexible(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 12,
                                                  ),
                                              decoration: BoxDecoration(
                                                color:
                                                    isUser
                                                        ? Color(0xFF00707E)
                                                        : Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  if (!isUser)
                                                    Text(
                                                      "AI Assistant",
                                                      style: TextStyle(
                                                        color: Colors.grey[700],
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  if (!isUser)
                                                    const SizedBox(height: 4),
                                                  Text(
                                                    message["text"] ?? "",
                                                    style: TextStyle(
                                                      color:
                                                          isUser
                                                              ? Colors.white
                                                              : Colors.black87,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          if (isUser) const SizedBox(width: 8),
                                          if (isUser)
                                            CircleAvatar(
                                              backgroundColor: Color(
                                                0xFFA9F67F,
                                              ),
                                              child: Text(
                                                "You"
                                                    .substring(0, 1)
                                                    .toUpperCase(),
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

                      // Loading Indicator
                      if (_isLoading)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF00707E),
                            ),
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
                                  controller: _controller,
                                  decoration: InputDecoration(
                                    hintText: "Tanyakan sesuatu...",
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 14,
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        final text = _controller.text.trim();
                                        if (text.isNotEmpty) {
                                          sendMessage(text);
                                          _controller.clear();
                                        }
                                      },
                                      icon: Icon(
                                        Icons.send,
                                        color: Color(0xFF00707E),
                                      ),
                                    ),
                                  ),
                                  onSubmitted: (_) {
                                    final text = _controller.text.trim();
                                    if (text.isNotEmpty) {
                                      sendMessage(text);
                                      _controller.clear();
                                    }
                                  },
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
