import 'package:flutter/material.dart';
import '../diary/diary_page.dart'; // ⭐ Günlük sayfasını import ettik

class MoodPage extends StatelessWidget {
  MoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFE6EF),
      appBar: AppBar(
        title: const Text("EmotionCare"),
        backgroundColor: Colors.purpleAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Merhaba 🌙",
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.purple.shade900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Bugün nasıl hissediyorsun?",
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.purple.shade400,
              ),
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Text(
                "✨ Unutma, küçük adımlar büyük değişimlerin başlangıcıdır.",
                style: TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: const [
                  MoodCard(emoji: "😊", label: "Mutlu"),
                  MoodCard(emoji: "😌", label: "Sakin"),
                  MoodCard(emoji: "😣", label: "Stresli"),
                  MoodCard(emoji: "😴", label: "Yorgun"),
                  MoodCard(emoji: "😢", label: "Üzgün"),
                  MoodCard(emoji: "⚡", label: "Enerjik"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ⭐ Günlük sayfasına gitme butonu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DiaryPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "Günlüğe Git",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class MoodCard extends StatelessWidget {
  final String emoji;
  final String label;

  const MoodCard({super.key, required this.emoji, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
