import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import '../diary/diary_provider.dart';

class MusicPage extends ConsumerStatefulWidget {
  final bool showSaveButton;      // ✔ Mood’dan geliyorsa kaydet göster
  final String mood;              // ✔ Hangi mood içindi
  final String actionName;        // ✔ Günlüğe yazılacak metin

  const MusicPage({
    super.key,
    required this.showSaveButton,
    required this.mood,
    required this.actionName,
  });

  @override
  ConsumerState<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends ConsumerState<MusicPage> {
  final AudioPlayer player = AudioPlayer();
  String? currentlyPlaying;

  final List<Map<String, String>> musics = [
    {"title": "🌙 Meditasyon", "file": "meditation.mp3"},
    {"title": "🎹 Piyano", "file": "piano.mp3"},
    {"title": "💤 Uyku", "file": "sleep.mp3"},
    {"title": "🌊 Doğa", "file": "ambient.mp3"},
    {"title": "🧘 Odak", "file": "focus.mp3"},
    {"title": "✨ Rahatlama", "file": "relaxing.mp3"},
  ];

  @override
  void initState() {
    super.initState();
    _setupAudioSession();
  }

  Future<void> _setupAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
  }

  Future<void> playMusic(String fileName) async {
    try {
      // Eğer aynı müzik çalıyorsa durdur
      if (currentlyPlaying == fileName && player.playing) {
        await player.pause();
        setState(() => currentlyPlaying = null);
        return;
      }

      await player.setAsset("assets/music/$fileName");
      player.play();
      setState(() => currentlyPlaying = fileName);
    } catch (e) {
      print("🎵 HATA: $e");
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: widget.showSaveButton
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  ref.read(diaryProvider.notifier).addEntry(
                        widget.mood,
                        widget.actionName,
                        null,
                        "🎵",
                      );

                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text(
                  "Kaydet ve Ana Sayfaya Dön",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            )
          : null, // ❌ Ana sayfadan gelindiyse buton yok
      

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF4DDFD),
              Color(0xFFE8C9FF),
              Color(0xFFD9B9FF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: musics.length,
            itemBuilder: (context, index) {
              final title = musics[index]["title"]!;
              final file = musics[index]["file"]!;
              final isPlaying = currentlyPlaying == file;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: isPlaying
                          ? Colors.purpleAccent.withOpacity(0.4)
                          : Colors.black12,
                      blurRadius: isPlaying ? 20 : 10,
                      spreadRadius: isPlaying ? 2 : 0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(title.substring(0, 2), style: const TextStyle(fontSize: 34)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        title.substring(2),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => playMusic(file),
                      child: Icon(
                        isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        size: 40,
                        color: Colors.purpleAccent,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
