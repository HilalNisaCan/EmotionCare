import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../mood_detail_state.dart';
import 'suggestion_page.dart'; 

class MoodDetailPage extends ConsumerStatefulWidget {
  final String emoji;
  final String label;

  const MoodDetailPage({super.key, required this.emoji, required this.label});

  @override
  ConsumerState<MoodDetailPage> createState() => _MoodDetailPageState();
}

class _MoodDetailPageState extends ConsumerState<MoodDetailPage> {
  final TextEditingController _explanationController = TextEditingController();

  @override
  void dispose() {
    _explanationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(moodDetailProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFFFE6EF),
      appBar: AppBar(title: Text(widget.label), backgroundColor: Colors.purpleAccent),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(child: Text(widget.emoji, style: const TextStyle(fontSize: 60))),
            const SizedBox(height: 20),
            const Text(
              'Neden böyle hissediyorsun?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.purple),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _explanationController,
              maxLines: 5,
              onChanged: (text) => notifier.updateExplanation(text),
              decoration: InputDecoration(
                hintText: 'Açıklamanı buraya yaz...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            
            // --- GÖNDER BUTONU ---
            ElevatedButton(
              onPressed: () {
                // 1. Veriyi kaydet
                notifier.submitMood(); 
                
                // 2. ÖNERİLER SAYFASINA GİT
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SuggestionsPage(moodLabel: widget.label),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text('Gönder ve Önerileri Gör', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}