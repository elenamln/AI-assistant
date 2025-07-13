import 'package:ai_assistant/api/constant.dart';
import 'package:ai_assistant/gemini_api.dart';
import 'package:flutter/material.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final _controller = TextEditingController();
  final List<_Message> _messages = [];
  final GeminiApi _geminiApi = GeminiApi(apiKey);

  bool _isLoading = false;

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_Message(text, isUser: true));
      _isLoading = true;
    });
    _controller.clear();

    try {
      final response = await _geminiApi.sendPrompt(text);
      setState(() {
        _messages.add(_Message(response, isUser: false));
      });
    } catch (e) {
      setState(() {
        _messages.add(_Message('Error: $e', isUser: false));
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
      backgroundColor: const Color.fromARGB(255, 185, 208, 238),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120), // a bit taller for image header
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'lib/assets/header.png',  // your header image here
                fit: BoxFit.cover,
              ),
              // Optional: add a translucent overlay to improve contrast
              Container(
                color: Colors.black.withOpacity(0),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return Align(
                    alignment: msg.isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 14),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: msg.isUser
                            ? Colors.yellow
                            : const Color.fromARGB(255, 226, 203, 134),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        msg.text,
                        style: TextStyle(
                          color: msg.isUser ? Colors.black : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_isLoading) const LinearProgressIndicator(),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: const InputDecoration(
                        hintText: 'Type your question...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _isLoading ? null : _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Move _Message to top-level
class _Message {
  final String text;
  final bool isUser;
  _Message(this.text, {required this.isUser});
}