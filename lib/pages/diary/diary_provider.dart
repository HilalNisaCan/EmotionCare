import 'package:flutter_riverpod/flutter_riverpod.dart';

// MODEL
class DiaryEntry {
  final DateTime date;
  final String moodLabel;
  final String emoji;
  final String explanation;
  final String? imagePath;

  DiaryEntry({
    required this.date,
    required this.moodLabel,
    required this.emoji,
    required this.explanation,
    this.imagePath,
  });

  DiaryEntry copyWith({
    DateTime? date,
    String? moodLabel,
    String? emoji,
    String? explanation,
    String? imagePath,
  }) {
    return DiaryEntry(
      date: date ?? this.date,
      moodLabel: moodLabel ?? this.moodLabel,
      emoji: emoji ?? this.emoji,
      explanation: explanation ?? this.explanation,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}

// NOTIFIER
class DiaryNotifier extends StateNotifier<List<DiaryEntry>> {
  DiaryNotifier() : super([]);

  void addEntry(
    String mood,
    String explanation,
    String? image,
    String emoji, {
    DateTime? date,
  }) {
    state = [
      DiaryEntry(
        moodLabel: mood,
        explanation: explanation,
        imagePath: image,
        emoji: emoji,
        date: date ?? DateTime.now(),
      ),
      ...state,
    ];
  }

  void deleteEntry(DiaryEntry entry) {
    state = state.where((e) => e != entry).toList();
  }

  void updateEntry(DiaryEntry oldEntry, DiaryEntry newEntry) {
    state = [
      for (final e in state)
        if (e == oldEntry) newEntry else e
    ];
  }
}

// PROVIDER
final diaryProvider =
    StateNotifierProvider<DiaryNotifier, List<DiaryEntry>>((ref) {
  return DiaryNotifier();
});
