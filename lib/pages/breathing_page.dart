import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Font paketi
import 'music/music_page.dart'; 

class BreathingPage extends StatefulWidget {
  const BreathingPage({super.key});

  @override
  State<BreathingPage> createState() => _BreathingPageState();
}

class _BreathingPageState extends State<BreathingPage> {
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

  void _startBreathingCycle() {
    if (!mounted) return;
    setState(() {
      _phase = "inhale";
      _counter = 4;
      _instruction = "Burnundan Nefes Al 🌸";
      _circleSize = 300.0; 
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) { timer.cancel(); return; }
      setState(() {
        if (_counter > 1) {
          _counter--;
        } else {
          timer.cancel();
          _startHoldPhase();
        }
      });
    });
  }

  void _startHoldPhase() {
    if (!mounted) return;
    setState(() {
      _phase = "hold";
      _counter = 7;
      _instruction = "Tut... 😶";
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) { timer.cancel(); return; }
      setState(() {
        if (_counter > 1) {
          _counter--;
        } else {
          timer.cancel();
          _startExhalePhase();
        }
      });
    });
  }

  void _startExhalePhase() {
    if (!mounted) return;
    setState(() {
      _phase = "exhale";
      _counter = 8;
      _instruction = "Yavaşça Ver... 💨";
      _circleSize = 150.0; 
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) { timer.cancel(); return; }
      setState(() {
        if (_counter > 1) {
          _counter--;
        } else {
          timer.cancel();
          _showRatingDialog();
        }
      });
    });
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        int selectedRating = 0;
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text("Nasıl Hissediyorsun?", style: GoogleFonts.poppins(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Rahatlayabildin mi?", style: GoogleFonts.poppins(fontSize: 14)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < selectedRating ? Icons.star_rounded : Icons.star_outline_rounded,
                          color: Colors.amber,
                          size: 40,
                        ),
                        onPressed: () {
                          setStateDialog(() {
                            selectedRating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                ],
              ),
              actions: [
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    ),
                    onPressed: () {
                      if (selectedRating == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lütfen puan verin ⭐")));
                      } else {
                        _handleRatingResult(selectedRating);
                      }
                    },
                    child: Text("Tamamla", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
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

  void _handleRatingResult(int rating) {
    Navigator.pop(context); 

    if (rating <= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sakinleşmek için seni müziğe yönlendiriyoruz... 🎵"), backgroundColor: Colors.orangeAccent),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => const MusicPage()));
    } else {
      Navigator.pop(context); 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harika! 🌿"), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Arka planın appbar'ın arkasına geçmesi için
      appBar: AppBar(
        title: Text("Nefes Egzersizi", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent, // Şeffaf AppBar
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        // ✨ GÜZEL ARKA PLAN GRADIENT (GEÇİŞLİ RENK)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4FC3F7), // Açık Mavi
              Color(0xFFE1F5FE), // Beyaza yakın mavi
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animasyonlu Daire
              AnimatedContainer(
                duration: Duration(seconds: _phase == 'hold' ? 0 : 4), 
                curve: Curves.easeInOut,
                width: _circleSize,
                height: _circleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.3), // Yarı saydam beyaz
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(color: Colors.blue.withOpacity(0.2), blurRadius: 40, spreadRadius: 10)
                  ],
                ),
                child: Center(
                  child: Text(
                    "$_counter",
                    style: GoogleFonts.poppins(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              
              Text(
                _instruction,
                style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.w600, color: Colors.white, shadows: [
                  const Shadow(offset: Offset(0, 2), blurRadius: 5, color: Colors.black12)
                ]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}