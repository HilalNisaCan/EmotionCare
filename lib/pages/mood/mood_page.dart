import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../diary/diary_provider.dart';
import '../mood_detail/mood_detail_page.dart';

class MoodPage extends ConsumerStatefulWidget {
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

  void _quickSave() {
    if (selectedIndex == -1) {
      _showWarning();
      return;
    }

    final selectedMood = moods[selectedIndex];

    ref.read(diaryProvider.notifier).addEntry(
      selectedMood['label']!,
      "Hızlı kayıt (Detay girilmedi) ⚡",
      null,
      selectedMood['emoji']!,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${selectedMood['label']} olarak kaydedildi!"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  void _showWarning() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Lütfen bir duygu seç! 🌙")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 🌈 ARKA PLAN GRADIENT — HATASIZ
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFE6EF), Color(0xFFD8B7FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BAŞLIK
                Text(
                  "Merhaba 🌙",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple.shade900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Bugün nasıl hissediyorsun?",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.purple.shade600,
                  ),
                ),

                const SizedBox(height: 20),

                // BİLGİ KUTUSU
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Text(
                    "✨ Hissettiğin her duygu geçerli ve önemlidir.",
                    style: TextStyle(fontSize: 15),
                  ),
                ),

                const SizedBox(height: 25),

                // EMOJİ SEÇİM GRID
                Expanded(
                  child: GridView.builder(
                    itemCount: moods.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemBuilder: (context, i) {
                      final isSelected = selectedIndex == i;
                      final mood = moods[i];

                      return GestureDetector(
                        onTap: () => setState(() => selectedIndex = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(20),
                            border: isSelected
                                ? Border.all(color: Colors.purple, width: 2)
                                : null,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(mood["emoji"]!, style: const TextStyle(fontSize: 42)),
                              const SizedBox(height: 10),
                              Text(
                                mood["label"]!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // DETAYLI BUTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _continueToDetail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purpleAccent,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text("Seç ve Önerileri Gör →",
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 10),

                // HIZLI BUTON
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _quickSave,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text("Direkt Kaydet (Önerisiz)",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
