import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'diary_provider.dart';

class DiaryDetailPage extends ConsumerStatefulWidget {
  final DiaryEntry entry;

  const DiaryDetailPage({super.key, required this.entry});

  @override
  ConsumerState<DiaryDetailPage> createState() => _DiaryDetailPageState();
}

class _DiaryDetailPageState extends ConsumerState<DiaryDetailPage> {
  late TextEditingController moodController;
  late TextEditingController explanationController;

  @override
  void initState() {
    super.initState();
    moodController = TextEditingController(text: widget.entry.moodLabel);
    explanationController =
        TextEditingController(text: widget.entry.explanation);
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(diaryProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Günlüğü Düzenle"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: moodController,
              decoration: const InputDecoration(labelText: "Duygu"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: explanationController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: "Açıklama"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final updated = widget.entry.copyWith(
                  moodLabel: moodController.text,
                  explanation: explanationController.text,
                );

                notifier.updateEntry(widget.entry, updated);

                Navigator.pop(context);
              },
              child: const Text("Kaydet"),
            ),
          ],
        ),
      ),
    );
  }
}
