import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class MusicPage extends StatefulWidget {
  const MusicPage({super.key});

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  final AudioPlayer player = AudioPlayer();

  final List<Map<String, String>> musics = [
    {"title": "🌙 Meditasyon", "file": "meditation.mp3.mp3"},
    {"title": "🎹 Piyano", "file": "piano.mp3.mp3"},
    {"title": "💤 Uyku", "file": "sleep.mp3.mp3"},
    {"title": "🌊 Doğa", "file": "ambient.mp3.mp3"},
    {"title": "🧘 Odak", "file": "focus.mp3.mp3"},
    {"title": "✨ Rahatlama", "file": "relaxing.mp3.mp3"},
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

  void playMusic(String fileName) async {
    try {
      await player.setAsset("assets/music/$fileName");
      player.play();
    } catch (e) {
      print("HATA: $e");
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
      appBar: AppBar(
        title: const Text("Rahatlatıcı Müzikler"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: ListView.builder(
        itemCount: musics.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(musics[index]["title"]!),
              trailing: const Icon(Icons.play_arrow),
              onTap: () => playMusic(musics[index]["file"]!),
            ),
          );
        },
      ),
    );
  }
}
