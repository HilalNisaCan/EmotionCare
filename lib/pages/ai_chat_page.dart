import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/chat_message.dart';
import '../services/ai_chat_service.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _messages.add(
      ChatMessage(
        role: "assistant",
        content:
            "Merhaba 🌙\nBugün nasılsın?\nİstersen bana içinden geçenleri anlatabilirsin.",
      ),
    );
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(role: "user", content: text));
      _isTyping = true;
    });

    _controller.clear();

    final reply = await AiChatService.sendMessage(text);

    setState(() {
      _messages.add(ChatMessage(role: "assistant", content: reply));
      _isTyping = false;
    });
  }

  Widget _buildBubble(ChatMessage msg) {
    final isUser = msg.role == "user";

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: isUser
              ? const Color(0xFFE1BEE7)
              : Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft:
                isUser ? const Radius.circular(18) : Radius.zero,
            bottomRight:
                isUser ? Radius.zero : const Radius.circular(18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Text(
          msg.content,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7ECFF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFBB3FDD),
        centerTitle: true,
        title: Text(
          "Hadi Biraz Sohbet Edelim 🌙",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
           color: Colors.white,
          ),
        ),
       leading: IconButton(
       icon: const Icon(
       Icons.arrow_back_ios_new_rounded,
       color: Colors.white, // ⬅️
      ),
      onPressed: () => Navigator.pop(context),
      ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _buildBubble(_messages[i]),
            ),
          ),

          if (_isTyping)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                "“Cevap yazıyorum…",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.black45,
                ),
              ),
            ),

          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "İçinden geçen ne varsa yazabilirsin…",
                  hintStyle: GoogleFonts.poppins(fontSize: 13),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _isTyping ? null : _sendMessage,
              child: CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFFBB3FDD),
                child: const Icon(Icons.send_rounded, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
