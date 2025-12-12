import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../pages/diary/diary_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class SaveAndBackButton extends ConsumerWidget {
  final String mood;
  final String actionName;

  const SaveAndBackButton({
    super.key,
    required this.mood,
    required this.actionName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () {
          // Günlüğe kaydet
          ref.read(diaryProvider.notifier).addEntry(
            mood,
            actionName,
            null,
            "📝",
          );

          // Ana sayfaya dön
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        child: Text(
          "Kaydet ve Ana Sayfaya Dön",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
