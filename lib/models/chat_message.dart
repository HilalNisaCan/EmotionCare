class ChatMessage {
  final String role; // "user" veya "assistant"
  final String content;

  ChatMessage({
    required this.role,
    required this.content,
  });
}
