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
    final notifier = ref.read(moodDetailProvider.notifier);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFEDF6),
              Color(0xFFEAD9FF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              /// 🔙 HEADER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Color(0xFF8E24AA),
                        size: 20,
                      ),
                      // 👇 DEĞİŞİKLİK BURADA YAPILDI:
                      // Eski: onPressed: () => Navigator.pop(context),
                      // Yeni: Ana sayfaya (Dashboard) kadar tüm pencereleri kapatır.
                      onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.label,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6A1B9A),
                      ),
                    ),
                  ],
                ),
              ),

              /// 🔽 CONTENT
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),

                      /// EMOJI
                      Container(
                        padding: const EdgeInsets.all(26),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.15),
                              blurRadius: 18,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Text(
                          widget.emoji,
                          style: const TextStyle(fontSize: 60),
                        ),
                      ),

                      const SizedBox(height: 26),

                      /// QUESTION
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Neden böyle hissediyorsun?",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6A1B9A),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// INPUT
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _explanationController,
                            maxLines: null,
                            expands: true,
                            onChanged: notifier.updateExplanation,
                            decoration: InputDecoration(
                              hintText:
                                  "Duygularını burada açıklayabilirsin...",
                              hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 13,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              /// 🔥 BUTTON (SABİT)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      notifier.submitMood();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              SuggestionsPage(moodLabel: widget.label),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBB3FDD), // KOYU PEMBE
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      "Gönder ve Önerileri Gör",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
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