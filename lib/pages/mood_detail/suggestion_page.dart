import 'dart:convert'; // Listeyi JSON yapmak için
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart'; // YouTube için
import 'package:shared_preferences/shared_preferences.dart';

// 👇 SAYFA İMPORTLARI
import '../../mood_detail_state.dart';
import '../breathing_page.dart';
import '../activity_timer_page.dart';
import '../memory_page.dart';
import '../observation_page.dart';
import '../music/music_page.dart'; // Müzik sayfası eklendi
import '../diary/diary_page.dart'; // Günlük sayfası eklendi

class SuggestionsPage extends ConsumerStatefulWidget {
  final String moodLabel;

  const SuggestionsPage({super.key, required this.moodLabel});

  @override
  ConsumerState<SuggestionsPage> createState() => _SuggestionsPageState();
}

class _SuggestionsPageState extends ConsumerState<SuggestionsPage> {
  // Arkadaş Listesi
  List<Map<String, String>> _friendsList = [];

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  // --- 💾 HAFIZA İŞLEMLERİ (REHBER) ---
  Future<void> _loadFriends() async {
    final prefs = await SharedPreferences.getInstance();
    final String? friendsString = prefs.getString('friends_list');
    
    if (friendsString != null) {
      List<dynamic> decoded = jsonDecode(friendsString);
      setState(() {
        _friendsList = decoded.map((item) => Map<String, String>.from(item)).toList();
      });
    }
  }

  Future<void> _saveFriends() async {
    final prefs = await SharedPreferences.getInstance();
    String encoded = jsonEncode(_friendsList);
    await prefs.setString('friends_list', encoded);
  }

  void _addFriend(String name, String number) {
    setState(() {
      _friendsList.add({'name': name, 'number': number});
    });
    _saveFriends();
  }

  void _removeFriend(int index) {
    setState(() {
      _friendsList.removeAt(index);
    });
    _saveFriends();
  }

  // --- 📞 ARAMA YAPMA ---
  Future<void> _makeCall(String number) async {
    final Uri launchUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Arama yapılamadı.")));
    }
  }

  // --- 📺 YOUTUBE AÇMA (DANS İÇİN) ---
  Future<void> _launchYoutubeDance() async {
    // Dans egzersizleri araması açar
    final Uri url = Uri.parse('https://www.youtube.com/results?search_query=dance+workout+15+min');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
       if (!mounted) return;
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("YouTube açılamadı.")));
    }
  }

  // --- 📋 REHBER YÖNETİM PENCERESİ ---
  void _showPhonebookManager() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController numberController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text("Güven Çemberim ❤️"),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_friendsList.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text("Henüz kimseyi eklemedin.", style: TextStyle(color: Colors.grey)),
                    )
                  else
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _friendsList.length,
                        itemBuilder: (context, index) {
                          final friend = _friendsList[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.purple.shade100,
                              child: Text(friend['name']![0].toUpperCase()),
                            ),
                            title: Text(friend['name']!),
                            subtitle: Text(friend['number']!),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () {
                                setState(() { _removeFriend(index); });
                                setStateDialog(() {});
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  const Divider(),
                  const Text("Yeni Kişi Ekle", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(controller: nameController, decoration: const InputDecoration(labelText: "İsim (Örn: Annem)", icon: Icon(Icons.person))),
                  TextField(controller: numberController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: "Numara", icon: Icon(Icons.phone))),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Kapat")),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty && numberController.text.isNotEmpty) {
                    setState(() { _addFriend(nameController.text, numberController.text); });
                    setStateDialog(() { nameController.clear(); numberController.clear(); });
                  }
                },
                child: const Text("Ekle"),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- 📞 ARAMA SEÇİM EKRANI ---
  void _showCallSelectionSheet() {
    if (_friendsList.isEmpty) {
      _showPhonebookManager();
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Kimi Aramak İstersin?", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ..._friendsList.map((friend) => ListTile(
                leading: const Icon(Icons.phone_in_talk, color: Colors.green),
                title: Text(friend['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(friend['number']!),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context);
                  _makeCall(friend['number']!);
                },
              )),
              const Divider(),
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _showPhonebookManager();
                },
                icon: const Icon(Icons.edit),
                label: const Text("Listeyi Düzenle"),
              )
            ],
          ),
        );
      },
    );
  }

  // --- 🔥 GÜNCELLENMİŞ MANTIKLI ÖNERİ LİSTESİ ---
  List<Map<String, dynamic>> _getSuggestions() {
    switch (widget.moodLabel) {
      case 'Mutlu':
        return [
          {'title': 'Anı Yakala', 'sub': 'Bu anı fotoğrafla ölümsüzleştir.', 'icon': Icons.camera_alt, 'color': Colors.orangeAccent, 'bg': Colors.orange.shade50},
          {'title': 'Paylaş', 'sub': 'Arkadaşını ara, mutluluğunu paylaş.', 'icon': Icons.phone_in_talk, 'color': Colors.blueAccent, 'bg': Colors.blue.shade50},
          {'title': 'Müzik Dinle', 'sub': 'Mutluluğuna eşlik edecek şarkılar.', 'icon': Icons.music_note, 'color': Colors.pink, 'bg': Colors.pink.shade50},
        ];
      case 'Enerjik':
        return [
           // 👇 YENİ: Enerjik biri için Dans ve Spor
           {'title': 'Dans Et', 'sub': 'Enerjini at! YouTube\'da dans et.', 'icon': Icons.sports_gymnastics, 'color': Colors.red, 'bg': Colors.red.shade50},
           {'title': 'Yürüyüş Yap', 'sub': 'Tempolu bir yürüyüşe çık.', 'icon': Icons.directions_walk, 'color': Colors.green, 'bg': Colors.green.shade50},
           {'title': 'Anı Yakala', 'sub': 'Bu enerjik halini kaydet.', 'icon': Icons.camera_alt, 'color': Colors.orange, 'bg': Colors.orange.shade50},
        ];
      case 'Stresli':
        return [
          {'title': 'Nefes Egzersizi', 'sub': '4-7-8 tekniği ile rahatla.', 'icon': Icons.air, 'color': Colors.lightBlue, 'bg': Colors.lightBlue.shade50},
          {'title': 'Yakın Arkadaş', 'sub': 'Bir dosta anlatmak iyi gelir.', 'icon': Icons.favorite, 'color': Colors.redAccent, 'bg': Colors.red.shade50},
          {'title': 'Müzik Dinle', 'sub': 'Rahatlatıcı tınılar.', 'icon': Icons.headphones, 'color': Colors.purple, 'bg': Colors.purple.shade50},
        ];
      case 'Yorgun':
        return [
          // 👇 YENİ: Yorgun biri için Uyku ve Müzik
          {'title': 'Müzik Dinle', 'sub': 'Gözlerini kapat ve dinle.', 'icon': Icons.bed, 'color': Colors.indigo, 'bg': Colors.indigo.shade50},
          {'title': 'Kısa Uyku', 'sub': '20 dakikalık güç uykusu.', 'icon': Icons.timer, 'color': Colors.brown, 'bg': Colors.brown.shade50},
          {'title': 'Nefes Egzersizi', 'sub': 'Uykuya geçişi kolaylaştır.', 'icon': Icons.air, 'color': Colors.teal, 'bg': Colors.teal.shade50},
        ];
      case 'Üzgün':
        return [
          // 👇 YENİ: Üzgün biri için Günlük ve Dertleşme
          {'title': 'İçini Dök', 'sub': 'Günlüğüne yazmak iyi gelecek.', 'icon': Icons.edit, 'color': Colors.orangeAccent, 'bg': Colors.orange.shade50},
          {'title': 'Yakın Arkadaş', 'sub': 'Yalnız değilsin, ara.', 'icon': Icons.phone, 'color': Colors.green, 'bg': Colors.green.shade50},
          {'title': 'Yürüyüş Yap', 'sub': 'Biraz hava almak zihnini açar.', 'icon': Icons.directions_walk, 'color': Colors.blue, 'bg': Colors.blue.shade50},
        ];
      case 'Sakin':
        return [
          {'title': 'Kitap Oku', 'sub': 'Huzurlu anını kitapla taçlandır.', 'icon': Icons.menu_book, 'color': Colors.brown, 'bg': Colors.brown.shade50},
          {'title': 'Gözlem Yap', 'sub': 'Çevreni fark et ve not al.', 'icon': Icons.visibility, 'color': Colors.blueGrey, 'bg': Colors.blueGrey.shade50},
           {'title': 'Müzik Dinle', 'sub': 'Sakinliğini koru.', 'icon': Icons.music_note, 'color': Colors.purple, 'bg': Colors.purple.shade50},
        ];
      default:
        return [
          {'title': 'Anı Yakala', 'sub': 'Bugünü kaydet.', 'icon': Icons.camera_alt, 'color': Colors.purple, 'bg': Colors.purple.shade50},
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(moodDetailProvider);
    final userExplanation = state.explanation;
    final suggestions = _getSuggestions();

    return Scaffold(
      backgroundColor: const Color(0xFFFDF0F6),
      appBar: AppBar(
        title: Text("${widget.moodLabel} İçin Öneriler", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.purpleAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("🎯 Sana İyi Gelecek Şeyler", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF880E4F))),
            const SizedBox(height: 5),
            Text("Senin için seçtiğimiz aktiviteler:", style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade700)),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: suggestions.length,
                separatorBuilder: (context, index) => const SizedBox(height: 15),
                itemBuilder: (context, index) {
                  final item = suggestions[index];
                  return _buildFancyCard(context, item, userExplanation);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFancyCard(BuildContext context, Map<String, dynamic> item, String userExplanation) {
    String title = item['title'];
    String sub = item['sub'];

    if ((title == 'Yakın Arkadaş' || title == 'Paylaş') && _friendsList.isNotEmpty) {
      if (_friendsList.length == 1) {
        title = "${_friendsList.first['name']}'i Ara 📞";
      } else {
        title = "Güven Çemberini Ara 📞";
        sub = "${_friendsList.length} kişi kayıtlı.";
      }
    }

    return GestureDetector(
      onLongPress: () {
        if (item['title'] == 'Yakın Arkadaş' || item['title'] == 'Paylaş' || title.contains("Ara")) {
          _showPhonebookManager();
        }
      },
      onTap: () {
        // --- 🚀 YÖNLENDİRMELER (YENİLENDİ) ---
        
        // 1. ARAMA / PAYLAŞ
        if (item['title'] == 'Yakın Arkadaş' || item['title'] == 'Paylaş' || title.contains("Ara")) {
          _showCallSelectionSheet();
        }

        // 2. ANI YAKALA
        else if (item['title'] == 'Anı Yakala') {
           Navigator.push(context, MaterialPageRoute(
              builder: (context) => MemoryPage(moodLabel: widget.moodLabel, explanation: userExplanation))); 
        }
        
        // 3. NEFES EGZERSİZİ
        else if (item['title'] == 'Nefes Egzersizi') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const BreathingPage()));
        } 
        
        // 4. KİTAP OKUMA
        else if (item['title'] == 'Kitap Oku') {
           Navigator.push(context, MaterialPageRoute(builder: (context) => const ActivityTimerPage(
                title: "Kitap Okuma Vakti", description: "Sayfaların arasında kaybol...", durationMinutes: 15, color: Colors.brown, icon: Icons.menu_book)));
        }

        // 5. YÜRÜYÜŞ
        else if (item['title'] == 'Yürüyüş Yap' || item['title'] == 'Kısa Yürüyüş') {
           Navigator.push(context, MaterialPageRoute(builder: (context) => const ActivityTimerPage(
                title: "Yürüyüş Molası", description: "Temiz hava zihnini açar.", durationMinutes: 20, color: Colors.green, icon: Icons.directions_walk)));
        }
         
        // 6. GÖZLEM YAP
        else if (item['title'] == 'Gözlem Yap') {
           Navigator.push(context, MaterialPageRoute(
             builder: (context) => ObservationPage(moodLabel: widget.moodLabel)
           ));
        }

        // 7. DANS ET (YOUTUBE) 🎵
        else if (item['title'] == 'Dans Et') {
           _launchYoutubeDance();
        }

        // 8. KISA UYKU (TIMER) 😴
        else if (item['title'] == 'Kısa Uyku') {
           Navigator.push(context, MaterialPageRoute(builder: (context) => const ActivityTimerPage(
                title: "Güç Uykusu", description: "20 dakika sonra zımba gibi kalk!", durationMinutes: 20, color: Colors.indigo, icon: Icons.bed)));
        }

        // 9. MÜZİK DİNLE 🎧
        else if (item['title'] == 'Müzik Dinle' || item['title'] == 'Dinlen (Müzik)') {
           Navigator.push(context, MaterialPageRoute(builder: (context) => const MusicPage()));
        }

        // 10. GÜNLÜK (İÇİNİ DÖK) 📝
        else if (item['title'] == 'İçini Dök') {
           Navigator.push(context, MaterialPageRoute(builder: (context) => const DiaryPage()));
        }

      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.purple.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: item['bg'], borderRadius: BorderRadius.circular(15)),
              child: Icon(item['icon'], color: item['color'], size: 30),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
                  const SizedBox(height: 4),
                  Text(sub, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade600)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.grey.shade300),
          ],
        ),
      ),
    );
  }
}