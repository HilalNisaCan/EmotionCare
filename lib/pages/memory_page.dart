import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'diary/diary_provider.dart';

class MemoryPage extends ConsumerStatefulWidget {
  final bool showSaveButton;
  final String mood;
  final String actionName;
  final String explanation;

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
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:
                  const Icon(Icons.photo_library, color: Color(0xFF6A6FD6)),
              title: const Text("Galeriden Seç"),
              onTap: () {
                Navigator.pop(context);
                _pick(ImageSource.gallery);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.camera_alt, color: Color(0xFF6A6FD6)),
              title: const Text("Fotoğraf Çek"),
              onTap: () {
                Navigator.pop(context);
                _pick(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

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
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF6A6FD6),
        foregroundColor: Colors.white,
        title: Text(
          "Anı Yakala",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),

      bottomNavigationBar: widget.showSaveButton
          ? Padding(
              padding: const EdgeInsets.all(18),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A6FD6),
                  minimumSize: const Size(double.infinity, 54),
                  shape: const StadiumBorder(),
                ),
                onPressed: _saveMemory,
                child: Text(
                  "Kaydet ve Ana Sayfaya Dön",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          : null,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// 📸 FOTOĞRAF ALANI
            GestureDetector(
              onTap: _showImagePickerMenu,
              child: Container(
                height: 280,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F1FF),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF6A6FD6).withOpacity(0.25),
                  ),
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
                          const Icon(
                            Icons.add_a_photo_outlined,
                            size: 48,
                            color: Color(0xFF6A6FD6),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Fotoğraf Ekle",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF6A6FD6),
                            ),
                          ),
                          Text(
                            "Kamera veya Galeri",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )
                    : null,
              ),
            ),

            const SizedBox(height: 22),

            /// 📅 TARİH & MOOD
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedDate,
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9E3FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.mood,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6A6FD6),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            /// 📝 AÇIKLAMA
            Text(
              widget.explanation.isEmpty
                  ? "Bir açıklama bulunmuyor..."
                  : widget.explanation,
              style: GoogleFonts.handlee(
                fontSize: 18,
                height: 1.4,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
