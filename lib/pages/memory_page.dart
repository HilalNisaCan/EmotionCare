import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

// 👇 KASAYI ÇAĞIRIYORUZ (Dosya yoluna dikkat et)
import 'diary/diary_provider.dart'; 
import 'diary/diary_page.dart';

class MemoryPage extends ConsumerStatefulWidget {
  final String moodLabel;
  final String explanation;

  const MemoryPage({
    super.key,
    required this.moodLabel,
    required this.explanation,
  });

  @override
  ConsumerState<MemoryPage> createState() => _MemoryPageState();
}

class _MemoryPageState extends ConsumerState<MemoryPage> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  // --- 💾 KAYIT İŞLEMİ ---
  void _saveMemory() {
    // 1. Emoji Seçimi
    String emoji = "😐";
    if (widget.moodLabel == "Mutlu") emoji = "😊";
    else if (widget.moodLabel == "Üzgün") emoji = "😢";
    else if (widget.moodLabel == "Stresli") emoji = "😣";
    else if (widget.moodLabel == "Sakin") emoji = "😌";
    else if (widget.moodLabel == "Yorgun") emoji = "😴";
    else if (widget.moodLabel == "Enerjik") emoji = "⚡";

    // 2. KASAYA EKLE (İşte burası eksikti!)
    // Kullanıcının yazdığı explanation'ı buraya ekliyoruz
    ref.read(diaryProvider.notifier).addEntry(
      widget.moodLabel, 
      widget.explanation, // Notu buraya ekledik
      _selectedImage?.path, 
      emoji
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Anı Günlüğüne Eklendi! 🎉"), backgroundColor: Colors.green),
    );

    // 3. Günlüğe Git
    Navigator.pushAndRemoveUntil(
      context, 
      MaterialPageRoute(builder: (context) => const DiaryPage()), 
      (route) => route.isFirst, 
    );
  }

  @override
  Widget build(BuildContext context) {
    // main.dart'ta yüklediğimiz için burada tekrar yüklemeye gerek yok
    String formattedDate = DateFormat('d MMMM yyyy', 'tr_TR').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        title: Text("Anı Yakala", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orangeAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        image: _selectedImage != null
                            ? DecorationImage(image: FileImage(_selectedImage!), fit: BoxFit.cover)
                            : null,
                      ),
                      child: _selectedImage == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                                const SizedBox(height: 10),
                                Text("Fotoğraf Seç", style: GoogleFonts.poppins(color: Colors.grey)),
                              ],
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formattedDate, style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
                      Chip(label: Text(widget.moodLabel), backgroundColor: Colors.orange.shade100),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.explanation.isEmpty ? "Not yok..." : widget.explanation,
                    style: GoogleFonts.handlee(fontSize: 18, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _saveMemory,
              icon: const Icon(Icons.save),
              label: const Text("Günlüğe Kaydet"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}