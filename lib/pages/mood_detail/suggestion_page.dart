import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../mood_detail_state.dart';
import '../breathing_page.dart';
import '../activity_timer_page.dart';
import '../memory_page.dart';
import '../observation_page.dart';
import '../music/music_page.dart';
import '../diary/diary_page.dart';

class SuggestionsPage extends ConsumerStatefulWidget {
  final String moodLabel;

  const SuggestionsPage({super.key, required this.moodLabel});

  @override
  ConsumerState<SuggestionsPage> createState() => _SuggestionsPageState();
}

class _SuggestionsPageState extends ConsumerState<SuggestionsPage> {
  List<Map<String, String>> _friendsList = [];

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('friends_list');
    if (data != null) {
      final decoded = jsonDecode(data);
      setState(() {
        _friendsList = decoded
            .map<Map<String, String>>((e) => Map<String, String>.from(e))
            .toList();
      });
    }
  }

  Future<void> _saveFriends() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('friends_list', jsonEncode(_friendsList));
  }

  void _addFriend(String name, String number) {
    setState(() => _friendsList.add({'name': name, 'number': number}));
    _saveFriends();
  }

  void _removeFriend(int index) {
    setState(() => _friendsList.removeAt(index));
    _saveFriends();
  }

  Future<void> _makeCall(String number) async {
    final uri = Uri(scheme: "tel", path: number);
    await launchUrl(uri);
  }

  Future<void> _launchYoutubeDance() async {
    final uri = Uri.parse(
        "https://www.youtube.com/results?search_query=dance+workout+15+min");
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  // ==========================================================
  // 📞 En Yakınım
  // ==========================================================
  void _showPhonebookManager() {
    final name = TextEditingController();
    final number = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFFF6EDF9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 💖 BAŞLIK
                Text(
                  "En Yakınım ❤️",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6A1B9A),
                  ),
                ),

                const SizedBox(height: 6),

                /// 📌 ALT AÇIKLAMA
                Text(
                  _friendsList.isEmpty
                      ? "Henüz kimse yok."
                      : "Sana iyi gelen kişiler:",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 12),

                /// 📋 KAYITLI KİŞİLER
                if (_friendsList.isNotEmpty)
                  SizedBox(
                    height: 120,
                    child: ListView.separated(
                      itemCount: _friendsList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 6),
                      itemBuilder: (_, i) {
                        final f = _friendsList[i];
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.person,
                                  size: 18, color: Color(0xFFBB3FDD)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  f["name"]!,
                                  style: GoogleFonts.poppins(fontSize: 14),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    size: 18, color: Colors.redAccent),
                                onPressed: () {
                                  _removeFriend(i);
                                  Navigator.pop(context);
                                  _showPhonebookManager();
                                },
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                const SizedBox(height: 14),

                /// ✏️ İSİM
                TextField(
                  controller: name,
                  decoration: InputDecoration(
                    hintText: "İsim",
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// 📞 NUMARA
                TextField(
                  controller: number,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "Numara",
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔘 BUTONLAR
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Kapat",
                          style: GoogleFonts.poppins(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFBB3FDD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          if (name.text.isNotEmpty && number.text.isNotEmpty) {
                            _addFriend(name.text, number.text);
                            Navigator.pop(context);
                            _showPhonebookManager();
                          }
                        },
                        child: Text(
                          "Ekle",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================================
  // 📞 ARAMA MENÜSÜ
  // ==========================================================
  void _showCallSelectionSheet() {
    if (_friendsList.isEmpty) {
      _showPhonebookManager();
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20),
          children: [
            Text("Kimi aramak istersin?",
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ..._friendsList.map(
              (f) => ListTile(
                leading: const Icon(Icons.phone, color: Colors.green),
                title: Text(f["name"]!),
                subtitle: Text(f["number"]!),
                onTap: () {
                  Navigator.pop(context);
                  _makeCall(f["number"]!);
                },
              ),
            ),
            const Divider(),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showPhonebookManager();
              },
              child: const Text("Rehberi Düzenle"),
            )
          ],
        );
      },
    );
  }

  // ==========================================================
  // 📌 ÖNERİLERİ GETİR
  // ==========================================================
  List<Map<String, dynamic>> _getSuggestions() {
    switch (widget.moodLabel) {
      case 'Mutlu':
        return [
          {
            'title': 'Anı Yakala',
            'sub': 'Bu anı fotoğrafla ölümsüzleştir.',
            'icon': Icons.camera_alt,
            'bg': Colors.orange.shade50,
            'color': Colors.orange
          },
          {
            'title': 'Paylaş',
            'sub': 'Arkadaşını ara.',
            'icon': Icons.phone_in_talk,
            'bg': Colors.blue.shade50,
            'color': Colors.blue
          },
          {
            'title': 'Müzik Dinle',
            'sub': 'Mutlu bir ritim seç.',
            'icon': Icons.music_note,
            'bg': Colors.pink.shade50,
            'color': Colors.pink
          },
        ];

      case 'Enerjik':
        return [
          {
            'title': 'Dans Et',
            'sub': 'Enerjini at!',
            'icon': Icons.sports_gymnastics,
            'bg': Colors.red.shade50,
            'color': Colors.red
          },
          {
            'title': 'Yürüyüş Yap',
            'sub': 'Temiz hava enerji verir.',
            'icon': Icons.directions_walk,
            'bg': Colors.green.shade50,
            'color': Colors.green
          },
          {
            'title': 'Anı Yakala',
            'sub': 'Bu enerjiyi kaydet!',
            'icon': Icons.camera_alt,
            'bg': Colors.orange.shade50,
            'color': Colors.orange
          },
        ];

      case 'Stresli':
        return [
          {
            'title': 'Nefes Egzersizi',
            'sub': '4-7-8 ile rahatla.',
            'icon': Icons.air,
            'bg': Colors.lightBlue.shade50,
            'color': Colors.lightBlue
          },
          {
            'title': 'Yakın Arkadaş',
            'sub': 'Dertleşmek iyi gelir.',
            'icon': Icons.favorite,
            'bg': Colors.red.shade50,
            'color': Colors.red
          },
          {
            'title': 'Müzik Dinle',
            'sub': 'Rahatlatıcı tınılar.',
            'icon': Icons.headphones,
            'bg': Colors.purple.shade50,
            'color': Colors.purple
          },
        ];

      case 'Yorgun':
        return [
          {
            'title': 'Müzik Dinle',
            'sub': 'Kapan gözlerini...',
            'icon': Icons.music_note,
            'bg': Colors.indigo.shade50,
            'color': Colors.indigo
          },
          {
            'title': 'Kısa Uyku',
            'sub': '20 dakika güç toplar.',
            'icon': Icons.timer,
            'bg': Colors.brown.shade50,
            'color': Colors.brown
          },
          {
            'title': 'Nefes Egzersizi',
            'sub': 'Rahat uykuya yardımcı olur.',
            'icon': Icons.air,
            'bg': Colors.teal.shade50,
            'color': Colors.teal
          },
        ];

      case 'Üzgün':
        return [
          {
            'title': 'İçini Dök',
            'sub': 'Yazarak rahatla.',
            'icon': Icons.edit,
            'bg': Colors.orange.shade50,
            'color': Colors.orange
          },
          {
            'title': 'Yakın Arkadaş',
            'sub': 'Birini ara.',
            'icon': Icons.phone,
            'bg': Colors.green.shade50,
            'color': Colors.green
          },
          {
            'title': 'Yürüyüş Yap',
            'sub': 'Açık hava iyi gelir.',
            'icon': Icons.directions_walk,
            'bg': Colors.blue.shade50,
            'color': Colors.blue
          },
        ];

      case 'Sakin':
        return [
          {
            'title': 'Kitap Oku',
            'sub': 'Huzurlu bir mola.',
            'icon': Icons.menu_book,
            'bg': Colors.brown.shade50,
            'color': Colors.brown
          },
          {
            'title': 'Gözlem Yap',
            'sub': 'Kendini dinle.',
            'icon': Icons.visibility,
            'bg': Colors.grey.shade200,
            'color': Colors.grey
          },
          {
            'title': 'Müzik Dinle',
            'sub': 'Sakin melodiler.',
            'icon': Icons.music_note,
            'bg': Colors.purple.shade50,
            'color': Colors.purple
          },
        ];

      default:
        return [
          {
            'title': 'Anı Yakala',
            'sub': 'Bugünü kaydet.',
            'icon': Icons.camera_alt,
            'bg': Colors.purple.shade50,
            'color': Colors.purple
          }
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(moodDetailProvider);
    final explanation = state.explanation;
    final suggestions = _getSuggestions();

    return Scaffold(
      backgroundColor: const Color(0xFFE6D2EA), // 🌸 hafif koyu pembe
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF6A1B9A),
            size: 18,
          ),
          // 👇 DEĞİŞİKLİK BURADA YAPILDI
          // Eski: onPressed: () => Navigator.pop(context),
          // Yeni: Ana sayfaya (Dashboard) kadar geri dön
          onPressed: () =>
              Navigator.popUntil(context, (route) => route.isFirst),
        ),
        title: Text(
          "${widget.moodLabel} için",
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF6A1B9A),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Text(
              "Şu an kendin için küçük ama etkili bir adım seçebilirsin 💜",
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              itemCount: suggestions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (_, i) =>
                  _buildFancyCard(context, suggestions[i], explanation),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // 📌 TIKLANINCA DOĞRU SAYFAYA GÖTÜR
  // ==========================================================
  Widget _buildFancyCard(
      BuildContext context, Map<String, dynamic> item, String explanation) {
    String raw = item['title'];
    String sub = item['sub'];
    String displayTitle = raw;

    final mood = widget.moodLabel;

    // Güven çemberi özelleştirme
    if (raw == "Yakın Arkadaş" && _friendsList.isNotEmpty) {
      if (_friendsList.length == 1) {
        displayTitle = "${_friendsList.first['name']}’i Ara 📞";
      } else {
        displayTitle = "Sana En İyi Geleni Ara 📞";
        sub = "${_friendsList.length} kişi kayıtlı";
      }
    }

    return GestureDetector(
      onTap: () {
        // 📞 ARAMA
        if (raw == 'Yakın Arkadaş' || raw == 'Paylaş') {
          _showCallSelectionSheet();
          return;
        }

        // 📸 ANI YAKALA
        if (raw == 'Anı Yakala') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MemoryPage(
                showSaveButton: true,
                mood: mood,
                actionName: "fotoğraf çekildi 📸",
                explanation: explanation,
              ),
            ),
          );
          return;
        }

        // 🌬 NEFES
        if (raw == 'Nefes Egzersizi') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BreathingPage(
                showSaveButton: true,
                actionName: "Nefes egzersizi yapıldı 🌬️",
                mood: mood,
              ),
            ),
          );
          return;
        }

        // 💃 DANS
        if (raw == 'Dans Et') {
          _launchYoutubeDance();
          return;
        }

        // 📖 KİTAP OKU
        if (raw == 'Kitap Oku') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ActivityTimerPage(
                title: "Kitap Okuma",
                description: "Sayfaların arasında kaybol...",
                durationMinutes: 15,
                color: Colors.brown,
                icon: Icons.menu_book,
                showSaveButton: true,
                mood: mood,
                actionName: "kitap okundu",
              ),
            ),
          );
          return;
        }

        // 🚶‍♀️ YÜRÜYÜŞ
        if (raw == 'Yürüyüş Yap') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ActivityTimerPage(
                title: "Yürüyüş Molası",
                description: "Temiz hava zihnini açar.",
                durationMinutes: 20,
                color: Colors.green,
                icon: Icons.directions_walk,
                showSaveButton: true,
                mood: mood,
                actionName: "yürüyüş yapıldı",
              ),
            ),
          );
          return;
        }

        // 👀 GÖZLEM
        if (raw == 'Gözlem Yap') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ObservationPage(
                moodLabel: mood,
              ),
            ),
          );
          return;
        }

        // 😴 KISA UYKU
        if (raw == 'Kısa Uyku') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ActivityTimerPage(
                title: "Güç Uykusu",
                description: "20 dakika mini enerji yenileme",
                durationMinutes: 20,
                color: Colors.indigo,
                icon: Icons.bed,
                showSaveButton: true,
                mood: mood,
                actionName: "dinlenildi",
              ),
            ),
          );
          return;
        }

        // 🎵 MÜZİK
        if (raw == 'Müzik Dinle') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MusicPage(
                showSaveButton: true,
                actionName: "Müzik dinlendi 🎵",
                mood: mood,
              ),
            ),
          );
          return;
        }

        // ✍️ GÜNLÜK
        if (raw == 'İçini Dök') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const DiaryPage(),
            ),
          );
          return;
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: item['bg'],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(item['icon'], color: item['color'], size: 26),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayTitle,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sub,
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 18, color: Colors.grey.shade300),
          ],
        ),
      ),
    );
  }
}