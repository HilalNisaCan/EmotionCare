// 📂 Dosya: lib/pages/diary/diary_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'diary_provider.dart'; // Aynı klasörde olduğu için direkt çağırıyoruz

class DiaryPage extends ConsumerWidget {
  const DiaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diaryEntries = ref.watch(diaryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF3E5F5),
      appBar: AppBar(
        title: Text("Günlüğüm 📖", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.purpleAccent,
      ),
      body: diaryEntries.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.menu_book, size: 80, color: Colors.grey),
                  const SizedBox(height: 10),
                  Text("Henüz bir anı yok...", style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey)),
                  Text("Bugün neler hissettin?", style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: diaryEntries.length,
              itemBuilder: (context, index) {
                final entry = diaryEntries[index];
                final dateStr = DateFormat('d MMMM yyyy - HH:mm', 'tr_TR').format(entry.date);

                return Card(
                  margin: const EdgeInsets.only(bottom: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(entry.emoji, style: const TextStyle(fontSize: 30)),
                                const SizedBox(width: 10),
                                Text(
                                  entry.moodLabel,
                                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple),
                                ),
                              ],
                            ),
                            Text(dateStr, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                        const Divider(),
                        if (entry.explanation.isNotEmpty)
                          Text(entry.explanation, style: GoogleFonts.handlee(fontSize: 16)),
                        if (entry.imagePath != null) ...[
                          const SizedBox(height: 15),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(entry.imagePath!),
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}