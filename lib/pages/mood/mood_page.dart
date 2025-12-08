import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 👇 Riverpod Eklendi
import '../diary/diary_provider.dart'; // 👇 Veri kaydı için Provider
import '../diary/diary_page.dart';
import '../mood_detail/mood_detail_page.dart'; 

class MoodPage extends ConsumerStatefulWidget { // ConsumerStatefulWidget yaptık
  const MoodPage({super.key});

  @override
  ConsumerState<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends ConsumerState<MoodPage> {
  int selectedIndex = -1;

  final List<Map<String, String>> moods = [
    {"emoji": "😊", "label": "Mutlu"},
    {"emoji": "😌", "label": "Sakin"},
    {"emoji": "😣", "label": "Stresli"},
    {"emoji": "😴", "label": "Yorgun"},
    {"emoji": "😢", "label": "Üzgün"},
    {"emoji": "⚡", "label": "Enerjik"},
  ];

  // 👉 SEÇENEK 1: Detaylara ve Önerilere Git
  void _continueToDetail() {
    if (selectedIndex == -1) {
      _showWarning();
      return;
    }

    final selectedMood = moods[selectedIndex];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MoodDetailPage(
          emoji: selectedMood['emoji']!,
          label: selectedMood['label']!,
        ),
      ),
    );
  }

  // 👉 SEÇENEK 2: HIZLI KAYDET (Yeni Özellik)
  void _quickSave() {
    if (selectedIndex == -1) {
      _showWarning();
      return;
    }

    final selectedMood = moods[selectedIndex];

    // 1. Günlüğe/İstatistiğe Kaydet
    ref.read(diaryProvider.notifier).addEntry(
      selectedMood['label']!,
      "Hızlı kayıt (Detay girilmedi) ⚡", // Otomatik kısa not
      null, 
      selectedMood['emoji']!
    );

    // 2. Kullanıcıya Bilgi Ver
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${selectedMood['label']} olarak kaydedildi! İstatistiklerine eklendi. 📊"),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    // 3. Ana Ekrana Dön
    Navigator.pop(context);
  }

  void _showWarning() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Lütfen önce bir duygu seçin! 🐾")),
    );
  }

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

            // Üst Bilgi Kartı
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
                "✨ Unutma, hissettiğin her duygu geçerli ve önemlidir.",
                style: TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 30),

            // DUYGU IZGARASI (GRID)
            Expanded(
              child: GridView.builder(
                itemCount: moods.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  final mood = moods[index];
                  final isSelected = selectedIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: MoodCard(
                      emoji: mood['emoji']!,
                      label: mood['label']!,
                      isSelected: isSelected,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // --- BUTONLAR ---
            
            // 1. Buton: DEVAM ET (Detaylı)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _continueToDetail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  "Seç ve Önerileri Gör ->",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            
            const SizedBox(height: 12),

            // 2. Buton: HIZLI KAYDET (İstatistiğe Ekle Çık) - ⭐ YENİ
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _quickSave,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text("Direkt Kaydet (Önerisiz)"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.purple,
                  side: const BorderSide(color: Colors.purpleAccent),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
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
  final bool isSelected;

  const MoodCard({
    super.key,
    required this.emoji,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isSelected ? Colors.purpleAccent.withOpacity(0.2) : Colors.white,
        border: isSelected
            ? Border.all(color: Colors.purpleAccent, width: 2)
            : Border.all(color: Colors.transparent),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? Colors.purple.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
            blurRadius: isSelected ? 15 : 10,
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
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? Colors.purple : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}