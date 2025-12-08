import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. GÜNLÜK MODELİ (Bir sayfada neler olacak?)
class DiaryEntry {
  final DateTime date;
  final String moodLabel; // Mutlu, Üzgün vb.
  final String emoji;     // 😊, 😔
  final String explanation; // Kullanıcının notu
  final String? imagePath; // Fotoğraf yolu (Varsa)

  DiaryEntry({
    required this.date,
    required this.moodLabel,
    required this.emoji,
    required this.explanation,
    this.imagePath,
  });
}

// 2. YÖNETİCİ (Listeyi yöneten sınıf)
class DiaryNotifier extends StateNotifier<List<DiaryEntry>> {
  DiaryNotifier() : super([]); // Başlangıçta liste boş

  // Yeni anı ekleme fonksiyonu
  void addEntry(String mood, String text, String? image, String emoji) {
    final newEntry = DiaryEntry(
      date: DateTime.now(),
      moodLabel: mood,
      explanation: text,
      imagePath: image,
      emoji: emoji
    );
    
    // Listeyi güncelle: Eskilerin üzerine yenisini ekle (En yeni en üstte)
    state = [newEntry, ...state]; 
  }
}

// 3. PROVIDER (Uygulamanın erişim noktası)
final diaryProvider = StateNotifierProvider<DiaryNotifier, List<DiaryEntry>>((ref) {
  return DiaryNotifier();
});