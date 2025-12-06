import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE6EF),
      appBar: AppBar(
        title: const Text("EmotionCare"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Center(
        child: Text(
          "Hoş geldin 🌙",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.purple.shade900,
          ),
        ),
      ),
    );
  }
}
