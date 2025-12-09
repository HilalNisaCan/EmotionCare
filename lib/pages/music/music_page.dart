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
      backgroundColor: const Color(0xFFF3E5F5),
      appBar: AppBar(
        title: const Text("Sakinleştirici Müzikler"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: ListView.builder(
        itemCount: musics.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: const Icon(Icons.music_note, color: Colors.purple),
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