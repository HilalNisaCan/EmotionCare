import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'diary/diary_provider.dart';
class ActivityTimerPage extends ConsumerStatefulWidget {
  final String title;
  final String description;
  final int durationMinutes;
  final Color color;
  final IconData icon;

  /// 🔥 Yeni eklenen özellikler
  final bool showSaveButton;   // Mood’dan geliyorsa true
  final String mood;           // Günlüğe kaydedilecek mood
  final String actionName;     // "Kitap okudu 📖" gibi

  const ActivityTimerPage({
    super.key,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.color,
    required this.icon,
    required this.showSaveButton,
    required this.mood,
    required this.actionName,
  });

  @override
  ConsumerState<ActivityTimerPage> createState() => _ActivityTimerPageState();
}

class _ActivityTimerPageState extends ConsumerState<ActivityTimerPage> {
  Timer? _timer;
  late int _remainingSeconds;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.durationMinutes * 60;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
    } else {
      setState(() => _isRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;

        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            timer.cancel();
            _isRunning = false;
            _showCompletionDialog();
          }
        });
      });
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Tebrikler! 🎉",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        content: Text(
          "${widget.title} aktivitesini tamamladın!",
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.color,
              ),
              onPressed: () {
                // 🔥 Günlüğe kaydet sadece mood ekranından gelindiyse
                if (widget.showSaveButton) {
                  ref.read(diaryProvider.notifier).addEntry(
                      widget.mood, widget.actionName, null, "⏳");
                }

                Navigator.pop(context);
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text("Tamam", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    int m = seconds ~/ 60;
    int s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    double progress = _remainingSeconds / (widget.durationMinutes * 60);

    return Scaffold(
      backgroundColor: widget.color.withOpacity(0.1),
      appBar: AppBar(
        title: Text(widget.title,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: widget.color,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, size: 60, color: widget.color),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                widget.description,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 50),

            // Sayaç
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 15,
                    color: widget.color,
                    backgroundColor: Colors.grey.shade300,
                  ),
                ),
                Text(
                  _formatTime(_remainingSeconds),
                  style: GoogleFonts.poppins(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: widget.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),

            ElevatedButton.icon(
              onPressed: _toggleTimer,
              icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
              label: Text(_isRunning ? "Duraklat" : "Başlat"),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 15),
                shape: const StadiumBorder(),
                textStyle:
                    GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
