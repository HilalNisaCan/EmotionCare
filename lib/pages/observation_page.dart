import 'dart:async';
import 'package:emotioncare/pages/dashboard/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// 👇 GÜNLÜK KASASINI ÇAĞIRIYORUZ
import 'diary/diary_provider.dart';
import 'diary/diary_page.dart';

class ObservationPage extends ConsumerStatefulWidget {
  final String moodLabel;

  const ObservationPage({super.key, required this.moodLabel});

  @override
  ConsumerState<ObservationPage> createState() => _ObservationPageState();
}

class _ObservationPageState extends ConsumerState<ObservationPage> {
  final TextEditingController _noteController = TextEditingController();
  
  // Sayaç Değişkenleri
  Timer? _timer;
  int _remainingSeconds = 300; // 5 Dakika (300 saniye)
  bool _isTimerRunning = false;

  @override
  void dispose() {
    _timer?.cancel();
    _noteController.dispose();
    super.dispose();
  }

  // --- ⏱️ SAYAÇ MANTIĞI ---
  void _toggleTimer() {
    if (_isTimerRunning) {
      _timer?.cancel();
      setState(() => _isTimerRunning = false);
    } else {
      setState(() => _isTimerRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            timer.cancel();
            _isTimerRunning = false;
            _showTimeUpDialog();
          }
        });
      });
    }
  }

  void _showTimeUpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Süre Doldu! 🔔"),
        content: const Text("Şimdi etrafında fark ettiğin detayları yazma zamanı."),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Tamam"))],
      ),
    );
  }

  String _formatTime(int seconds) {
    int m = seconds ~/ 60;
    int s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  // --- 💾 KAYDETME İŞLEMİ ---
  void _saveObservation() {
    if (_noteController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen neler gördüğünü kısaca yaz ✍️")),
      );
      return;
    }

    // Günlüğe "Gözlem" olarak kaydediyoruz
    ref.read(diaryProvider.notifier).addEntry(
      "Gözlem", // Mod yerine "Gözlem" yazacak
      _noteController.text, // Yazdığı notlar
      null, // Fotoğraf yok (İstersen ekleyebiliriz)
      "👁️" // Özel emoji
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Gözlemlerin Günlüğe Eklendi! 🌿"), backgroundColor: Colors.teal),
    );

    // Günlüğe Git
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const DiaryPage()),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECEFF1), // Sakin gri-mavi tonu
      appBar: AppBar(
        title: Text("Gözlem Zamanı", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // --- 1. SAYAÇ ALANI ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Column(
                children: [
                  const Icon(Icons.visibility, size: 50, color: Colors.blueGrey),
                  const SizedBox(height: 10),
                  Text(
                    "Çevrene Odaklan",
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                  ),
                  Text(
                    "Işığı, renkleri ve dokuları incele...",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _formatTime(_remainingSeconds),
                    style: GoogleFonts.robotoMono(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blueGrey.shade700),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _toggleTimer,
                    icon: Icon(_isTimerRunning ? Icons.pause : Icons.play_arrow),
                    label: Text(_isTimerRunning ? "Durdur" : "Başlat"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- 2. NOT ALANI ---
            Text(
              "Neler Fark Ettin?",
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey.shade800),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _noteController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Örn: Duvardaki gölgeyi, yaprağın üzerindeki damlayı gördüm...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              ),
            ),

            const SizedBox(height: 30),

            // --- 3. KAYDET BUTONU ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveObservation,
                icon: const Icon(Icons.save),
                label: const Text("Gözlemi Günlüğe Kaydet"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}