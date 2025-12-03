iimport 'package:flutter/material.dart';

void main() {
  // Burada test print'in durabilir, sorun yok:
  print("Hilal'den test commit!");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EmotionCare',
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EmotionCare'),
      ),
      body: const Center(
        child: Text("Hilal'den ilk iOS build 🎉"),
      ),
    );
  }
}
