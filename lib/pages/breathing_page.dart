import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'diary/diary_provider.dart';
import 'music/music_page.dart';

class BreathingPage extends ConsumerStatefulWidget {
  final bool showSaveButton;   // Mood’dan mı geldi?
  final String mood;           // Mutlu, Üzgün, Stresli...
  final String actionName;     // Günlüğe yazılacak aktivite adı

  const BreathingPage({
    super.key,
    required this.showSaveButton,
    required this.mood,
    required this.actionName,
  });

  @override
  ConsumerState<BreathingPage> createState() => _BreathingPageState();
}

class _BreathingPageState extends ConsumerState<BreathingPage> {
  Timer? _timer;
  int _counter = 4;
  String _instruction = "Hazırlan...";
  String _phase = "inhale";
  double _circleSize = 150.0;

  @override
  void initState() {
    super.initState();
    _startBreathingCycle();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // --- NEFES DÖNGÜLERİ ---
  void _startBreathingCycle() {
    if (!mounted) return;
    setState(() {
      _phase = "inhale";
      _counter = 4;
      _instruction = "Burnundan Nefes Al 🌸";
      _circleSize = 300;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter > 1) {
        setState(() => _counter--);
      } else {
        timer.cancel();
        _startHoldPhase();
      }
    });
  }

  void _startHoldPhase() {
    setState(() {
      _phase = "hold";
      _counter = 7;
      _instruction = "Tut... 😶";
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter > 1) {
        setState(() => _counter--);
      } else {
        timer.cancel();
        _startExhalePhase();
      }
    });
  }

  void _startExhalePhase() {
    setState(() {
      _phase = "exhale";
      _counter = 8;
      _instruction = "Yavaşça Ver... 💨";
      _circleSize = 150;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter > 1) {
        setState(() => _counter--);
      } else {
        timer.cancel();
        _showRatingDialog();
      }
    });
  }

  // --- PUANLAMA DİYALOĞU ---
  void _showRatingDialog() {
    int selectedRating = 0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) {
        return StatefulBuilder(
          builder: (c, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text("Nasıl Hissediyorsun?",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Rahatlayabildin mi?", style: GoogleFonts.poppins()),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) {
                      return IconButton(
                        icon: Icon(
                          i < selectedRating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 40,
                        ),
                        onPressed: () {
                          setDialogState(() => selectedRating = i + 1);
                        },
                      );
                    }),
                  )
                ],
              ),
              actions: [
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12)),
                    onPressed: () {
                      if (selectedRating == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Lütfen puan verin ⭐")),
                        );
                      } else {
                        Navigator.pop(context);
                        _handleRating(selectedRating);
                      }
                    },
                    child: Text("Tamamla",
                        style: GoogleFonts.poppins(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            );
          },
        );
      },
    );
  }

  // --- PUANLAMA SONUCU ---
  void _handleRating(int rating) {
    // ⭐ Günlüğe kaydetme
    if (widget.showSaveButton) {
      ref.read(diaryProvider.notifier).addEntry(
        widget.mood,
        widget.actionName,
        null,
        "🌬️",
      );
    }

    // Kullanıcı kötü hissettiyse → müzik aç
    if (rating <= 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MusicPage(
            showSaveButton: false,
            mood: widget.mood,
            actionName: "Rahatlamak için müzik dinledi 🎵",
          ),
        ),
      );
      return;
    }

    // İyi hissettiyse → Ana sayfa
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  // --- ARAYÜZ ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4FC3F7),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Nefes Egzersizi",
            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(seconds: _phase == "hold" ? 0 : 4),
              curve: Curves.easeInOut,
              width: _circleSize,
              height: _circleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.3),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Center(
                child: Text(
                  "$_counter",
                  style: GoogleFonts.poppins(
                      fontSize: 60, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 60),
            Text(
              _instruction,
              style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.w600, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
