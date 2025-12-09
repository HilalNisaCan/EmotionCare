import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFE6EF), Color(0xFFFFF6FB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 20),

                  // PREMIUM GRAFIK KARTI
                  _buildStackedTimelineCard(diaryEntries),
                  const SizedBox(height: 24),

                  _buildFeatureCard(
                    context: context,
                    title: "Müzik Dinle",
                    badge: "🎧",
                    color: const Color(0xFFE1BEE7),
                    icon: Icons.headphones,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MusicPage()),
                    ),
                  ),
                  const SizedBox(height: 14),

                  _buildFeatureCard(
                    context: context,
                    title: "Günlük Yaz",
                    badge: "📝",
                    color: const Color(0xFFFFF3CD),
                    icon: Icons.edit_note,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DiaryPage()),
                    ),
                  ),
                  const SizedBox(height: 14),

                  _buildFeatureCard(
                    context: context,
                    title: "Mood Kaydet",
                    badge: "💚",
                    color: const Color(0xFFC8E6C9),
                    icon: Icons.mood,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MoodPage()),
                    ),
                  ),

                  const SizedBox(height: 40),
                  const Center(
                    child: Text(
                      "Bugün kendine nazik ol 🐾",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // HEADER ------------------------------------------------
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "EmotionCare",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.purpleAccent),
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

  // PREMIUM GRAFIK ---------------------------------------
  Widget _buildStackedTimelineCard(List<dynamic> allEntries) {
    int daysToShow = _selectedPeriod == 'Haftalık' ? 7 : 30;
    final now = DateTime.now();

    List<DateTime> dates = List.generate(daysToShow, (i) {
      return now.subtract(Duration(days: daysToShow - 1 - i));
    });

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient:
            const LinearGradient(colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)]),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık ve filtre
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Duygu Dağılımı",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    _buildFilterButton("Haftalık"),
                    _buildFilterButton("Aylık"),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Text(
            "Her çubuk o güne ait duygu kayıtlarını gösterir ✨",
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 20),

          // ÇUBUK GRAFİK
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: dates.map((date) {
                var entries = _findEntriesForDate(allEntries, date);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    children: [
                      Tooltip(
                        message: _buildTooltip(date, entries),
                        triggerMode: TooltipTriggerMode.tap,
                        child: Container(
                          width: 18,
                          height: 120,
                          decoration: BoxDecoration(
                            color:
                                entries.isEmpty ? Colors.white70 : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: entries.isEmpty
                              ? null
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Column(
                                    children: entries.map((e) {
                                      return Expanded(
                                        child: Container(
                                          color: _getMoodColor(e.moodLabel),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        DateFormat(_selectedPeriod == 'Haftalık' ? 'E' : 'd', 'tr_TR')
                            .format(date),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 14),

          // Mini Legend
          Row(
            children: [
              _legend("Mutlu", Colors.orange),
              _legend("Stresli", Colors.red),
              _legend("Sakin", Colors.green),
              _legend("Üzgün", Colors.blue),
              _legend("Enerjik", Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  String _buildTooltip(DateTime date, List<dynamic> entries) {
    String result = DateFormat("d MMMM", "tr_TR").format(date) + "\n";

    if (entries.isEmpty) return result + "Veri Yok";

    Map<String, int> count = {};
    for (var e in entries) {
      count[e.moodLabel] = (count[e.moodLabel] ?? 0) + 1;
    }

    count.forEach((key, value) {
      result += "$key: $value\n";
    });

    return result.trim();
  }

  Widget _legend(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  // Filtre Butonları
  Widget _buildFilterButton(String label) {
    bool selected = _selectedPeriod == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedPeriod = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.blueAccent : Colors.blueGrey,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // Duygu renkleri
  Color _getMoodColor(String mood) {
    switch (mood) {
      case "Mutlu":
        return Colors.orange;
      case "Sakin":
        return Colors.green;
      case "Üzgün":
        return Colors.blue;
      case "Stresli":
        return Colors.red;
      case "Enerjik":
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  // Find entries for a specific date
  List<dynamic> _findEntriesForDate(List<dynamic> allEntries, DateTime date) {
    return allEntries.where((entry) {
      return entry.date.year == date.year &&
          entry.date.month == date.month &&
          entry.date.day == date.day;
    }).toList();
  }

  // Feature Kartı
  Widget _buildFeatureCard({
    required BuildContext context,
    required String title,
    required String badge,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 85,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white54,
              child: Icon(icon, color: Colors.black54),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Text(badge, style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}