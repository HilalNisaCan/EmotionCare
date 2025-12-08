import 'package:flutter/material.dart';

class MusicPage extends StatelessWidget {
  const MusicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E5F5), // Hafif mor bir arka plan
      appBar: AppBar(
        title: const Text("Sakinleştirici Müzikler"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.music_note, size: 80, color: Colors.purple),
            SizedBox(height: 20),
            Text(
              "🎵 Müzik Listesi",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("Buraya yakında müzikler gelecek..."),
          ],
        ),
      ),
    );
  }
}