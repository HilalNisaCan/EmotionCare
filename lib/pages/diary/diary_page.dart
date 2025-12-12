// 📂 lib/pages/diary/diary_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'diary_provider.dart';
import 'diary_detail_page.dart';

class DiaryPage extends ConsumerStatefulWidget {
  const DiaryPage({super.key});

  @override
  ConsumerState<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends ConsumerState<DiaryPage> {
  String selectedFilter = "Hepsi";

  @override
  Widget build(BuildContext context) {
    final entries = ref.watch(diaryProvider);
    final filteredEntries = _filterEntries(entries);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFD4EC), Color(0xFFE8C4FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 10),
              _buildFilterChips(),
              const SizedBox(height: 10),
              Expanded(
                child: filteredEntries.isEmpty
                    ? _buildEmptyView()
                    : _buildDiaryList(filteredEntries),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildAddButton(context),
    );
  }

  // HEADER
  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.purple),
          onPressed: () => Navigator.pop(context),
        ),
        Text(
          "Günlüğüm 📖",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.purple.shade800,
          ),
        ),
      ],
    );
  }

  // FILTER CHIPS
  Widget _buildFilterChips() {
    final filters = ["Hepsi", "Bugün", "Bu Hafta", "Bu Ay"];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final selected = selectedFilter == filter;

          return ChoiceChip(
            label: Text(
              filter,
              style:
                  TextStyle(color: selected ? Colors.white : Colors.purple[700]),
            ),
            selected: selected,
            selectedColor: Colors.purple,
            backgroundColor: Colors.purple.shade100,
            onSelected: (_) => setState(() => selectedFilter = filter),
          );
        },
      ),
    );
  }

  // FILTER LOGIC
  List<DiaryEntry> _filterEntries(List<DiaryEntry> entries) {
    final now = DateTime.now();

    switch (selectedFilter) {
      case "Bugün":
        return entries.where((e) =>
            e.date.year == now.year &&
            e.date.month == now.month &&
            e.date.day == now.day).toList();
      case "Bu Hafta":
        final weekAgo = now.subtract(const Duration(days: 7));
        return entries.where((e) => e.date.isAfter(weekAgo)).toList();
      case "Bu Ay":
        return entries.where(
            (e) => e.date.year == now.year && e.date.month == now.month).toList();
      default:
        return entries;
    }
  }

  // EMPTY VIEW
  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu_book_rounded, size: 80, color: Colors.purple.shade300),
          const SizedBox(height: 12),
          Text("Henüz bir günlüğün yok",
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple.shade700)),
          const SizedBox(height: 6),
          Text("Bugün nasıl hissettiğini kaydedebilirsin 🌙",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }

  // LIST BUILDER
  Widget _buildDiaryList(List<DiaryEntry> entries) {
    return ListView.builder(
      padding: const EdgeInsets.all(18),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final dateStr =
            DateFormat('d MMMM yyyy • HH:mm', 'tr_TR').format(entry.date);

        return Container(
          margin: const EdgeInsets.only(bottom: 22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.85),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.15),
                blurRadius: 18,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Column(
            children: [
              ListTile(
                leading: Text(entry.emoji, style: const TextStyle(fontSize: 34)),
                title: Text(entry.moodLabel,
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.purple.shade800)),
                subtitle: Text(dateStr,
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: Colors.grey.shade600)),
                trailing: PopupMenuButton(
                  icon: const Icon(Icons.more_vert, color: Colors.purple),
                  onSelected: (value) {
                    final notifier = ref.read(diaryProvider.notifier);

                    if (value == 'edit') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DiaryDetailPage(entry: entry),
                        ),
                      );
                    }

                    if (value == 'delete') {
                      notifier.deleteEntry(entry);
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18, color: Colors.purple),
                          SizedBox(width: 8),
                          Text("Düzenle")
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete,
                              size: 18, color: Colors.redAccent),
                          SizedBox(width: 8),
                          Text("Sil")
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              if (entry.explanation.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Text(entry.explanation,
                      style: GoogleFonts.poppins(fontSize: 15, height: 1.4)),
                ),

              if (entry.imagePath != null)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      File(entry.imagePath!),
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // ADD BUTTON
  Widget _buildAddButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.purple,
      child: const Icon(Icons.add, color: Colors.white),
      onPressed: _showAddDiaryModal,
    );
  }

  // ADD ENTRY MODAL
  void _showAddDiaryModal() {
    final moodController = TextEditingController();
    final explanationController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              left: 20,
              right: 20,
              top: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Yeni Günlük Ekle",
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.bold)),

              const SizedBox(height: 12),

              TextField(
                controller: moodController,
                decoration:
                    const InputDecoration(labelText: "Duygu (Örn: Mutlu 😊)"),
              ),

              TextField(
                controller: explanationController,
                maxLines: 3,
                decoration:
                    const InputDecoration(labelText: "Günlük Notun"),
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    selectedDate = picked;
                    setState(() {});
                  }
                },
                child: Text(
                  "Tarih Seç: ${DateFormat('d MMM yyyy').format(selectedDate)}",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(height: 12),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 25),
                ),
                onPressed: () {
                  ref.read(diaryProvider.notifier).addEntry(
                        moodController.text,
                        explanationController.text,
                        null,
                        "📝",
                        date: selectedDate,
                      );
                  Navigator.pop(context);
                },
                child: const Text("Kaydet",
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }
}
