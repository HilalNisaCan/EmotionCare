import 'package:flutter/material.dart';
import '../mood/mood_page.dart'; // mood ekranı
import '../home/home_page.dart';
import '../auth/login_page.dart';
import '../music/music_page.dart';
import '../diary/diary_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Arka plan: degrade + süsler için Stack
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFE6EF),
              Color(0xFFFFF6FB),
            ],
          ),
        ),
        child: Stack(
          children: [
            // --- ARKA PLAN SÜSLERİ (minimal ama biraz daha ışıltılı) ---
            const Positioned(
              top: -4,
              left: -8,
              child: Opacity(
                opacity: 0.18,
                child: Text(
                  "🌸",
                  style: TextStyle(fontSize: 42),
                ),
              ),
            ),
            const Positioned(
              top: 60,
              right: -8,
              child: Opacity(
                opacity: 0.16,
                child: Text(
                  "✨",
                  style: TextStyle(fontSize: 38),
                ),
              ),
            ),
            const Positioned(
              top: 160,
              left: 12,
              child: Opacity(
                opacity: 0.16,
                child: Text(
                  "💫",
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
            const Positioned(
              bottom: 70,
              left: -4,
              child: Opacity(
                opacity: 0.18,
                child: Text(
                  "🍃",
                  style: TextStyle(fontSize: 38),
                ),
              ),
            ),
            const Positioned(
              bottom: 0,
              right: -6,
              child: Opacity(
                opacity: 0.14,
                child: Icon(
                  Icons.favorite,
                  size: 52,
                  color: Colors.pinkAccent,
                ),
              ),
            ),
            // orta kısma hafif pati izi
            const Positioned(
              bottom: 150,
              right: 24,
              child: Opacity(
                opacity: 0.20,
                child: Text(
                  "🐾",
                  style: TextStyle(fontSize: 28),
                ),
              ),
            ),

            // --- ASIL İÇERİK ---
            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      children: [
                        // ÜST BAŞLIK + GİRİŞ SAYFASINA DÖN BUTONU
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Opacity(
                              opacity: 0.8,
                              child: Text(
                                "🐾",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.favorite_outline,
                                  color: Colors.purpleAccent,
                                  size: 22,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Ana Sayfa",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.purple.shade700,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.star_border_rounded,
                                  color: Colors.purpleAccent,
                                  size: 22,
                                ),
                              ],
                            ),
                            IconButton(
                              tooltip: "Giriş sayfasına dön",
                              icon: const Icon(
                                Icons.logout,
                                color: Colors.purpleAccent,
                              ),
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                  (route) => false,
                                );
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // İnce çizgi
                        Container(
                          height: 1,
                          margin: const EdgeInsets.symmetric(horizontal: 40),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.purpleAccent.withOpacity(0.0),
                                Colors.purpleAccent.withOpacity(0.4),
                                Colors.purpleAccent.withOpacity(0.0),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // 1. KUTU: MOTİVASYON
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 22,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFB3E5FC), // açık mavi
                                Color(0xFFE1BEE7), // lila
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.pink.withOpacity(0.18),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "Harika bir gün seni bekliyor 💜",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      "Derin bir nefes al, yavaş yavaş başla.",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  shape: BoxShape.circle,
                                ),
                                child: const Text(
                                  "🐾",
                                  style: TextStyle(fontSize: 22),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // 2. BÖLÜM: DİKEY KUTULAR (MÜZİK / GÜNLÜK / MOOD)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text(
                              "Bugünün için",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(width: 6),
                            Opacity(
                              opacity: 0.8,
                              child: Text(
                                "✨",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Müzik kartı
                        _featureCard(
                          context: context,
                          background: const Color(0xFFE1BEE7), // lila
                          iconBg: const Color(0xFFF4ECFF),
                          icon: Icons.headphones_rounded,
                          iconColor: Colors.deepPurple,
                          badgeEmoji: "🎧",
                          title: "Sakinleştirici Müzik",
                          subtitle: "Rahatlamak için birkaç parça seç.",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                // MusicPage hazır değilse şimdilik MoodPage:
                                builder: (context) => MoodPage(),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 18),

                        // Günlük kartı
                        _featureCard(
                          context: context,
                          background: const Color(0xFFFFF3CD), // yumuşak sarı
                          iconBg: const Color(0xFFFFF0E5),
                          icon: Icons.edit_note_rounded,
                          iconColor: Colors.orangeAccent,
                          badgeEmoji: "📝",
                          title: "Günlük Yaz",
                          subtitle: "Bugünün düşüncelerini not et.",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DiaryPage(),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 18),

                        // Mood kartı
                        _featureCard(
                          context: context,
                          background: const Color(0xFFC8E6C9), // soft yeşil
                          iconBg: const Color(0xFFE8F5E9),
                          icon: Icons.mood_rounded,
                          iconColor: Colors.green,
                          badgeEmoji: "💚",
                          title: "Moodunu Kaydet",
                          subtitle: "Bugünkü duygunu hızlıca işaretle.",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MoodPage(),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 34),

                        // EN ALTA KEDİ PATİSİ
                        Align(
                          alignment: Alignment.centerRight,
                          child: Opacity(
                            opacity: 0.8,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Bugün kendine nazik ol ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  "🐾",
                                  style: TextStyle(
                                    fontSize: 24,
                                    shadows: [
                                      Shadow(
                                        color:
                                            Colors.pinkAccent.withOpacity(0.3),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
}

/// Dikey özellik kartı
Widget _featureCard({
  required BuildContext context,
  required Color background,
  required Color iconBg,
  required IconData icon,
  required Color iconColor,
  required String badgeEmoji,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
}) {
  return InkWell(
    borderRadius: BorderRadius.circular(26),
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      constraints: const BoxConstraints(
        minHeight: 115, // KUTULARI BÜYÜK YAPTIK
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Opacity(
                      opacity: 0.8,
                      child: Text(
                        badgeEmoji,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.chevron_right_rounded,
            color: Colors.black45,
          ),
        ],
      ),
    ),
  );
}
