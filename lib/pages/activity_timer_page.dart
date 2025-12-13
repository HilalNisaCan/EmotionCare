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

  final bool showSaveButton;
  final String mood;
  final String actionName;

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
  ConsumerState<ActivityTimerPage> createState() =>
      _ActivityTimerPageState();
}

class _ActivityTimerPageState
    extends ConsumerState<ActivityTimerPage> {
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
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) {
          if (!mounted) return;

          if (_remainingSeconds > 0) {
            setState(() => _remainingSeconds--);
          } else {
            timer.cancel();
            setState(() => _isRunning = false);
            _showCompletionDialog();
          }
        },
      );
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          "Tebrikler 🌙",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "${widget.title} tamamlandı.",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.color,
                shape: const StadiumBorder(),
              ),
              onPressed: () {
                if (widget.showSaveButton) {
                  ref.read(diaryProvider.notifier).addEntry(
                        widget.mood,
                        widget.actionName,
                        null,
                        "⏳",
                      );
                }
                Navigator.pop(context);
                Navigator.popUntil(context, (r) => r.isFirst);
              },
              child: const Text(
                "Tamam",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final progress =
        _remainingSeconds / (widget.durationMinutes * 60);

    return Scaffold(
      /// 🌸 SABİT, SOFT ARKA PLAN 
      backgroundColor: const Color(0xFFE9E3FF),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF6A6FD6),
        foregroundColor: Colors.white,
        title: Text(
          widget.title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              size: 64,
              color: widget.color,
            ),

            const SizedBox(height: 18),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                widget.description,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 48),

            /// ⏳ DAİRESEL SAYAÇ
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 14,
                    color: widget.color,
                    backgroundColor:
                        widget.color.withOpacity(0.2),
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

            const SizedBox(height: 48),

            /// ▶️ BAŞLAT / DURAKLAT
            ElevatedButton.icon(
              onPressed: _toggleTimer,
              icon: Icon(
                _isRunning ? Icons.pause : Icons.play_arrow,
              ),
              label: Text(
                _isRunning ? "Duraklat" : "Başlat",
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 42,
                  vertical: 16,
                ),
                shape: const StadiumBorder(),
                textStyle: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
