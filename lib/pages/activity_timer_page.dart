import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityTimerPage extends StatefulWidget {
  final String title;      // Örn: "Kitap Okuma Saati"
  final String description; // Örn: "Sayfaların arasında kaybol..."
  final int durationMinutes; // Örn: 15 dakika
  final Color color;       // Örn: Colors.brown
  final IconData icon;     // Örn: Icons.menu_book

  const ActivityTimerPage({
    super.key,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.color,
    required this.icon,
  });

  @override
  State<ActivityTimerPage> createState() => _ActivityTimerPageState();
}

class _ActivityTimerPageState extends State<ActivityTimerPage> {
  Timer? _timer;
  late int _remainingSeconds;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    // Dakikayı saniyeye çeviriyoruz
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
        title: Text("Tebrikler! 🎉", style: GoogleFonts.poppins(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        content: Text("${widget.title} aktivitesini başarıyla tamamladın. Kendinle gurur duy!", textAlign: TextAlign.center),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: widget.color),
              onPressed: () {
                Navigator.pop(context); // Dialog kapat
                Navigator.pop(context); // Sayfadan çık
              },
              child: const Text("Bitir", style: TextStyle(color: Colors.white)),
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
    // İlerleme yüzdesi (Dairenin doluluğu için)
    double progress = _remainingSeconds / (widget.durationMinutes * 60);

    return Scaffold(
      backgroundColor: widget.color.withOpacity(0.1), // Arka plan rengin soft hali
      appBar: AppBar(
        title: Text(widget.title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: widget.color,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // İkon ve Açıklama
            Icon(widget.icon, size: 60, color: widget.color),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                widget.description,
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 50),

            // SAYAÇ DAİRESİ
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

            // BAŞLAT / DURDUR BUTONU
            ElevatedButton.icon(
              onPressed: _toggleTimer,
              icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
              label: Text(_isRunning ? "Duraklat" : "Başlat"),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                shape: const StadiumBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}