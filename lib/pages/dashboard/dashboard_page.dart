import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../ai_chat_page.dart';
import '../auth/login_page.dart';
import '../diary/diary_page.dart';
import '../diary/diary_provider.dart';
import '../mood/mood_page.dart';
import '../music/music_page.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  String _selectedPeriod = 'Haftalık';

  @override
  Widget build(BuildContext context) {
    final diaryEntries = ref.watch(diaryProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFBB3FDD),
        child: const Icon(Icons.chat_bubble_rounded, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AiChatPage()),
          );
        },
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFD9E8), Color(0xFFFFF4F8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                children: [
                  _buildHeader(),
                  const SizedBox(height: 18),
                  
                  // 👇 GÜNCELLENEN GRAFİK ALANI
                  _buildTimelineCard(diaryEntries),
                  
                  const SizedBox(height: 24),

                  _buildFeatureCard(
                    title: "Müzik Dinle",
                    badge: "🎧",
                    gradientColors: const [
                      Color(0xFFD9B3FF),
                      Color(0xFFB983FF),
                    ],
                    icon: Icons.headphones,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MusicPage(
                          showSaveButton: false,
                          mood: "",
                          actionName: "",
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildFeatureCard(
                    title: "Günlük Yaz",
                    badge: "📝",
                    gradientColors: const [
                      Color(0xFFFFE29A),
                      Color(0xFFFFC857),
                    ],
                    icon: Icons.edit_note,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DiaryPage()),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildFeatureCard(
                    title: "Mood Kaydet",
                    badge: "💚",
                    gradientColors: const [
                      Color(0xFFB7E4C7),
                      Color(0xFF74C69D),
                    ],
                    icon: Icons.mood,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MoodPage()),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Center(
                    child: Text(
                      "Bugün kendine nazik ol 💕",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {
    final user = FirebaseAuth.instance.currentUser;
    final name = user?.displayName?.split(' ').first ?? "";

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "EmotionCare",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF8E24AA),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFBB3FDD).withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Bugün nasılsın, $name?",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6A1B9A),
                  ),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.logout, color: Color(0xFFBB3FDD)),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (_) => false,
            );
          },
        ),
      ],
    );
  }

  // ================= TIMELINE (GÜNCELLENDİ) =================
  Widget _buildTimelineCard(List<DiaryEntry> allEntries) {
    final daysToShow = _selectedPeriod == 'Haftalık' ? 7 : 30;
    final now = DateTime.now();

    final dates = List.generate(
      daysToShow,
      (i) => now.subtract(Duration(days: daysToShow - 1 - i)),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFB3D9FF), Color(0xFF90CAF9)],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                "Duygu Dağılımı",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0D47A1),
                ),
              ),
            ),
            const SizedBox(width: 6),
            _smallFilter("Hf"),
            const SizedBox(width: 4),
            _smallFilter("Ay"),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          "Günlere göre ruh hali",
          style: TextStyle(fontSize: 12, color: Color(0xFF1A237E)),
        ),
        const SizedBox(height: 14),

        // GRAFİK ALANI
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end, // Sütunları aşağı hizala
            children: dates.map((date) {
              final entries = _findEntriesForDate(allEntries, date);
              
              // O gün hiç kayıt yoksa boş placeholder göster
              if (entries.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    children: [
                      Container(
                        width: 20,
                        height: 50, // Boş günler daha kısa
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        DateFormat('E', 'tr_TR').format(date),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF263238),
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Kayıt varsa: Renkleri ve oranları hesapla
              final Map<String, int> moodCounts = {};
              for (var e in entries) {
                moodCounts[e.moodLabel] = (moodCounts[e.moodLabel] ?? 0) + 1;
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Column(
                  children: [
                    // STACKED BAR SÜTUNU
                    Container(
                      width: 20,
                      height: 110, // Dolu günler tam boy
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Column(
                          // Flex ile oranlı bölme
                          children: moodCounts.entries.map((e) {
                            return Expanded(
                              flex: e.value, // Bastığın sayı kadar yer kapla
                              child: Container(
                                color: _getMoodColor(e.key),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      DateFormat('E', 'tr_TR').format(date),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF263238),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 12),

        Wrap(
          spacing: 10,
          runSpacing: 6,
          children: const [
            _LegendItem(color: Color(0xFFFFA726), label: "Mutlu"),
            _LegendItem(color: Color(0xFFE53935), label: "Stresli"),
            _LegendItem(color: Color(0xFF43A047), label: "Sakin"),
            _LegendItem(color: Color(0xFF1E88E5), label: "Üzgün"),
            _LegendItem(color: Color(0xFF8E24AA), label: "Enerjik"),
            _LegendItem(color: Color(0xFF6D6D6D), label: "Yorgun"),
          ],
        ),
      ]),
    );
  }

  Widget _smallFilter(String label) {
    final selected =
        _selectedPeriod == (label == "Hf" ? "Haftalık" : "Aylık");

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPeriod = label == "Hf" ? "Haftalık" : "Aylık";
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFBB3FDD) : Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: selected ? Colors.white : Colors.black54,
          ),
        ),
      ),
    );
  }

  List<DiaryEntry> _findEntriesForDate(
    List<DiaryEntry> allEntries,
    DateTime date,
  ) =>
      allEntries
          .where((e) =>
              e.date.year == date.year &&
              e.date.month == date.month &&
              e.date.day == date.day)
          .toList();

  Color _getMoodColor(String mood) {
    switch (mood) {
      case "Mutlu":
        return const Color(0xFFFFA726);
      case "Stresli":
        return const Color(0xFFE53935);
      case "Sakin":
        return const Color(0xFF43A047);
      case "Üzgün":
        return const Color(0xFF1E88E5);
      case "Enerjik":
        return const Color(0xFF8E24AA);
      case "Yorgun":
        return const Color(0xFF6D6D6D);
      default:
        return Colors.grey.shade300;
    }
  }

  Widget _buildFeatureCard({
    required String title,
    required String badge,
    required List<Color> gradientColors,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 82,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradientColors.last.withOpacity(0.25),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          Text(badge, style: const TextStyle(fontSize: 18)),
        ]),
      ),
    );
  }
}

// ================= LEGEND =================
class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: 9,
        height: 9,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 4),
      Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFF263238),
        ),
      ),
    ]);
  }
}