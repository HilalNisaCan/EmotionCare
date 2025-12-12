import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../mood_detail_state.dart';
import 'suggestion_page.dart';

class MoodDetailPage extends ConsumerStatefulWidget {
  final String emoji;
  final String label;

  const MoodDetailPage({
    super.key,
    required this.emoji,
    required this.label,
  });

  @override
  ConsumerState<MoodDetailPage> createState() => _MoodDetailPageState();
}

class _MoodDetailPageState extends ConsumerState<MoodDetailPage> {
  final TextEditingController _explanationController = TextEditingController();

  @override
  void dispose() {
    _explanationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notifier = ref.read(moodDetailProvider.notifier);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFD6E8),
              Color(0xFFF5C9FF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 🔙 Geri + Başlık
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.purple),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      widget.label,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade800,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 🟣 Emoji Kartı
                Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Text(
                      widget.emoji,
                      style: const TextStyle(fontSize: 70),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // ✨ Soru
                Text(
                  "Neden böyle hissediyorsun?",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.purple.shade700,
                  ),
                ),
                const SizedBox(height: 12),

                // 📝 Açıklama Kutusu
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: TextField(
                    controller: _explanationController,
                    maxLines: 6,
                    onChanged: (text) => notifier.updateExplanation(text),
                    decoration: InputDecoration(
                      hintText: "Duygularını burada açıklayabilirsin...",
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                // 🎯 Gönder Butonu
               ElevatedButton(
  onPressed: () {
    notifier.submitMood();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SuggestionsPage(moodLabel: widget.label),
      ),
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.purple,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    ),
    elevation: 4,
  ),
  child: const Text(
    "Gönder ve Önerileri Gör",
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white, // 🤍 BEYAZ YAZI
    ),
  ),
),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
