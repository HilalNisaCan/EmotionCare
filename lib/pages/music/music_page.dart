import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:google_fonts/google_fonts.dart';

import '../diary/diary_provider.dart';

class MusicPage extends ConsumerStatefulWidget {
  final bool showSaveButton;
  final String mood;
  final String actionName;

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
    {"title": "Meditasyon", "emoji": "🌙", "file": "meditation.mp3"},
    {"title": "Piyano", "emoji": "🎹", "file": "piano.mp3"},
    {"title": "Uyku", "emoji": "😴", "file": "sleep.mp3"},
    {"title": "Doğa", "emoji": "🌊", "file": "ambient.mp3"},
    {"title": "Odak", "emoji": "🧘‍♀️", "file": "focus.mp3"},
    {"title": "Rahatlama", "emoji": "✨", "file": "relaxing.mp3"},
  ];

  @override
  void initState() {
    super.initState();
    _setupAudio();
  }

  Future<void> _setupAudio() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
  }

  Future<void> playMusic(String file) async {
  if (currentlyPlaying == file && player.playing) {
    await player.pause();
    return;
  }

  // 🔥 ÖNCE state'i set et
  setState(() {
    currentlyPlaying = file;
  });

  await player.stop();
  await player.setAsset("assets/music/$file");
  await player.play();
}


  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E8FF),

      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _miniPlayer(),

          if (widget.showSaveButton)
            Padding(
              padding: const EdgeInsets.all(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {
                  ref.read(diaryProvider.notifier).addEntry(
                        widget.mood,
                        widget.actionName,
                        null,
                        "🎵",
                      );
                  Navigator.popUntil(context, (r) => r.isFirst);
                },
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFBB3FDD), Color(0xFF8E24AA)],
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Text(
                      "Kaydet ve Ana Sayfaya Dön",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            _header(),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                itemCount: musics.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (_, i) {
                  final m = musics[i];
                  final isPlaying = m["file"] == currentlyPlaying;

                  return _musicCard(
                    emoji: m["emoji"]!,
                    title: m["title"]!,
                    isPlaying: isPlaying,
                    onTap: () => playMusic(m["file"]!),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 18, color: Color(0xFF6A1B9A)),
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
          ),
          const SizedBox(width: 6),
          Text(
            "Rahatlatıcı Sesler",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6A1B9A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _musicCard({
    required String emoji,
    required String title,
    required bool isPlaying,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 26)),
          const SizedBox(width: 14),
          Expanded(
            child: Text(title,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
          ),
         StreamBuilder<PlayerState>(
  stream: player.playerStateStream,
  builder: (context, snapshot) {
    final state = snapshot.data;
    final playing = state?.playing ?? false;

    return IconButton(
      icon: Icon(
        playing && isPlaying
            ? Icons.pause_circle_filled
            : Icons.play_circle_fill,
        color: Colors.purpleAccent,
        size: 36,
      ),
      onPressed: onTap,
    );
  },
),

        ],
      ),
    );
  }

  /// ✅ GERÇEK ÇALIŞAN MINI PLAYER
  Widget _miniPlayer() {
    if (currentlyPlaying == null) return const SizedBox.shrink();

    final current =
        musics.firstWhere((m) => m["file"] == currentlyPlaying);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6ECFF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: StreamBuilder<Duration>(
        stream: player.positionStream,
        builder: (context, snapshot) {
          final position = snapshot.data ?? Duration.zero;
          final duration = player.duration ?? Duration.zero;

          return Column(
            children: [
              Row(
                children: [
                  Text(current["emoji"]!, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "${current["title"]} çalıyor",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: const Color(0xFF6A1B9A),
                      ),
                    ),
                  ),
                 StreamBuilder<PlayerState>(
  stream: player.playerStateStream,
  builder: (context, snapshot) {
    final state = snapshot.data;
    final playing = state?.playing ?? false;

    return IconButton(
      icon: Icon(
        playing
            ? Icons.pause_circle_filled
            : Icons.play_circle_fill,
        size: 30,
        color: Colors.purpleAccent,
      ),
      onPressed: () {
        playing ? player.pause() : player.play();
      },
    );
  },
),

                ],
              ),

              if (duration.inSeconds > 0) ...[
                Slider(
                  value: position.inSeconds.toDouble(),
                  max: duration.inSeconds.toDouble(),
                  activeColor: Colors.purpleAccent,
                  onChanged: (v) =>
                      player.seek(Duration(seconds: v.toInt())),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_fmt(position),
                        style: GoogleFonts.poppins(fontSize: 11)),
                    Text(_fmt(duration),
                        style: GoogleFonts.poppins(fontSize: 11)),
                  ],
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  String _fmt(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return "${two(d.inMinutes)}:${two(d.inSeconds.remainder(60))}";
  }
}
