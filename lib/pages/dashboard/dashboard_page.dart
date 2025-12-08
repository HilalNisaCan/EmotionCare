import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// Sayfa importları
import '../mood/mood_page.dart';
import '../auth/login_page.dart';
import '../music/music_page.dart';
import '../diary/diary_page.dart';
import '../diary/diary_provider.dart';

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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFE6EF), Color(0xFFFFF6FB)],
          ),
        ),
        child: Stack(
          children: [
            const Positioned(top: -10, left: -10, child: Opacity(opacity: 0.1, child: Text("🌸", style: TextStyle(fontSize: 100)))),
            const Positioned(top: 100, right: -20, child: Opacity(opacity: 0.1, child: Text("📊", style: TextStyle(fontSize: 80)))),
            const Positioned(bottom: 50, left: -10, child: Opacity(opacity: 0.1, child: Text("✨", style: TextStyle(fontSize: 90)))),

            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    child: ListView(
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 20),

                        // ⭐ YENİ DİLİMLİ GRAFİK KARTI
                        _buildStackedTimelineCard(diaryEntries),

                        const SizedBox(height: 20),
                        
                        _buildFeatureCard(
                          context: context,
                          title: "Müzik Dinle",
                          badge: "🎧",
                          color: const Color(0xFFE1BEE7),
                          icon: Icons.headphones,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MusicPage())),
                        ),
                        const SizedBox(height: 15),
                        _buildFeatureCard(
                          context: context,
                          title: "Günlük Yaz",
                          badge: "📝",
                          color: const Color(0xFFFFF3CD),
                          icon: Icons.edit_note,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DiaryPage())),
                        ),
                        const SizedBox(height: 15),
                        _buildFeatureCard(
                          context: context,
                          title: "Mood Kaydet",
                          badge: "💚",
                          color: const Color(0xFFC8E6C9),
                          icon: Icons.mood,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MoodPage())),
                        ),

                        const SizedBox(height: 30),
                        const Center(child: Text("Kendine iyi bak 💜", style: TextStyle(color: Colors.grey))),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("EmotionCare", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.purple)),
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.purpleAccent),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false,
            );
          },
        ),
      ],
    );
  }

  // --- ⭐ WIDGET: DİLİMLİ (STACKED) GRAFİK ---
  Widget _buildStackedTimelineCard(List<dynamic> allEntries) {
    int daysToShow = _selectedPeriod == 'Haftalık' ? 7 : 30;
    final now = DateTime.now();
    
    // Günleri oluştur
    List<DateTime> datesToShow = List.generate(daysToShow, (index) {
      return now.subtract(Duration(days: (daysToShow - 1) - index));
    });

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)]),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Duygu Dağılımı", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
              Container(
                decoration: BoxDecoration(color: Colors.white54, borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: [
                    _buildFilterButton("Haftalık"),
                    _buildFilterButton("Aylık"),
                  ],
                ),
              )
            ],
          ),
          
          const SizedBox(height: 10),
          const Text("Çubukların renkleri o günkü hislerini gösterir.", style: TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 30),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true, // Sağdan başla
            child: SizedBox(
              height: 180, 
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: datesToShow.map((date) {
                  
                  // O güne ait TÜM kayıtları bul
                  var entriesForDay = _findEntriesForDate(allEntries, date);
                  bool hasData = entriesForDay.isNotEmpty;
                  
                  String dayLabel = _selectedPeriod == 'Haftalık'
                      ? DateFormat('E', 'tr_TR').format(date)
                      : DateFormat('d', 'tr_TR').format(date);
                  
                  String fullDate = DateFormat('d MMMM', 'tr_TR').format(date);

                  // Tooltip metnini oluştur (Örn: "2 Mutlu, 1 Stresli")
                  String tooltipText = "$fullDate\n";
                  if (!hasData) {
                    tooltipText += "Veri Yok";
                  } else {
                     Map<String, int> counts = {};
                     for (var e in entriesForDay) {
                       counts[e.moodLabel] = (counts[e.moodLabel] ?? 0) + 1;
                     }
                     counts.forEach((key, value) {
                       tooltipText += "$key: $value\n";
                     });
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // --- DİLİMLİ ÇUBUK ---
                        Tooltip(
                          message: tooltipText.trim(),
                          triggerMode: TooltipTriggerMode.tap,
                          child: Container(
                            width: 16,
                            height: 120, // Çubuk yüksekliği sabit
                            decoration: BoxDecoration(
                              color: Colors.white38, // Arka plan (boşsa gri görünür)
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: hasData 
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Column(
                                    children: entriesForDay.map((entry) {
                                      // Her bir kayıt için eşit parça
                                      // (Örn: 3 kayıt varsa her biri yüksekliğin 1/3'ü)
                                      return Expanded(
                                        child: Container(
                                          color: _getMoodColor(entry.moodLabel),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                )
                              : null, // Veri yoksa boş kalır
                          ),
                        ),
                        
                        const SizedBox(height: 10),

                        Text(
                          dayLabel, 
                          style: TextStyle(
                            fontSize: 12, 
                            fontWeight: FontWeight.bold, 
                            color: date.day == now.day ? Colors.blueAccent : Colors.blueGrey
                          )
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
          const SizedBox(height: 15),
          // Renk Açıklamaları (Mini Legend)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                 _buildLegendItem("Mutlu", Colors.orange),
                 _buildLegendItem("Stresli", Colors.red),
                 _buildLegendItem("Sakin", Colors.green),
                 _buildLegendItem("Üzgün", Colors.blue),
                 _buildLegendItem("Yorgun", Colors.brown),
                 _buildLegendItem("Enerjik", Colors.purple),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text) {
    bool isSelected = _selectedPeriod == text;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPeriod = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : [],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.blueAccent : Colors.blueGrey,
          ),
        ),
      ),
    );
  }

  // --- YARDIMCI FONKSİYONLAR ---

  // O güne ait TÜM kayıtları listeler
  List<dynamic> _findEntriesForDate(List<dynamic> entries, DateTime date) {
    return entries.where((e) => 
      e.date.year == date.year && 
      e.date.month == date.month && 
      e.date.day == date.day
    ).toList();
  }

  Color _getMoodColor(String mood) {
    switch (mood) {
      case 'Mutlu': return Colors.orange;
      case 'Sakin': return Colors.green;
      case 'Üzgün': return Colors.blue;
      case 'Stresli': return Colors.red;
      case 'Yorgun': return Colors.brown;
      case 'Enerjik': return Colors.purple;
      default: return Colors.grey;
    }
  }

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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(padding: const EdgeInsets.all(10), decoration: const BoxDecoration(color: Colors.white54, shape: BoxShape.circle), child: Icon(icon, color: Colors.black54)),
            const SizedBox(width: 15),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            Text(badge, style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}