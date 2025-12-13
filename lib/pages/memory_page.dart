import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'diary/diary_page.dart';
import 'diary/diary_provider.dart';    

class MemoryPage extends ConsumerStatefulWidget {
  final bool showSaveButton;    // Mood’dan mı geldi?
  final String mood;            // Mutlu, Üzgün vs.
  final String actionName;      // Günlüğe yazılacak metin
  final String explanation;     // Mood açıklaması (zaten vardı)

  const MemoryPage({
    super.key,
    required this.showSaveButton,
    required this.mood,
    required this.actionName,
    required this.explanation,
  });

  @override
  ConsumerState<MemoryPage> createState() => _MemoryPageState();
}

class _MemoryPageState extends ConsumerState<MemoryPage> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pick(ImageSource src) async {
    final XFile? image = await _picker.pickImage(source: src);
    if (image != null) {
      setState(() => _selectedImage = File(image.path));
    }
  }

  void _showImagePickerMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (c) => SafeArea(
        child: Wrap(children: [
          ListTile(
            leading: const Icon(Icons.photo, color: Colors.orange),
            title: const Text("Galeriden Seç"),
            onTap: () {
              Navigator.pop(context);
              _pick(ImageSource.gallery);
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt, color: Colors.orange),
            title: const Text("Fotoğraf Çek"),
            onTap: () {
              Navigator.pop(context);
              _pick(ImageSource.camera);
            },
          ),
        ]),
      ),
    );
  }

  // 📌 KAYDETME
  void _saveMemory() {
    ref.read(diaryProvider.notifier).addEntry(
          widget.mood,
          widget.actionName,
          _selectedImage?.path,
          "📸",
        );

    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('d MMMM yyyy', 'tr_TR').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        title: Text("Anı Yakala",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orangeAccent,
      ),

      // 📌 SADECE MOOD SAYFASINDAN GELİNCE BUTON ÇIKAR
      bottomNavigationBar: widget.showSaveButton
          ? Padding(
              padding: const EdgeInsets.all(18.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: _saveMemory,
                child: const Text(
                  "Kaydet ve Ana Sayfaya Dön",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            )
          : null,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          // FOTO ALANI
          GestureDetector(
            onTap: _showImagePickerMenu,
            child: Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
                image: _selectedImage != null
                    ? DecorationImage(
                        image: FileImage(_selectedImage!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: _selectedImage == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo,
                            size: 50, color: Colors.orange.shade300),
                        const SizedBox(height: 10),
                        Text("Fotoğraf Ekle",
                            style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold)),
                        Text("(Kamera veya Galeri)",
                            style: GoogleFonts.poppins(
                                color: Colors.grey, fontSize: 12)),
                      ],
                    )
                  : null,
            ),
          ),

          const SizedBox(height: 20),

          // TARİH ve MOOD ROZETİ
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(formattedDate,
                  style: GoogleFonts.poppins(color: Colors.grey)),
              Chip(
                label: Text(widget.mood),
                backgroundColor: Colors.orange.shade100,
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Açıklama
          Text(
            widget.explanation.isEmpty
                ? "Bir açıklama bulunmuyor..."
                : widget.explanation,
            style: GoogleFonts.handlee(
                fontSize: 18, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ]),
      ),
    );
  }
}
