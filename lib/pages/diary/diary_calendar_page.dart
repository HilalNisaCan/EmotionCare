import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'diary_detail_page.dart';

class DiaryCalendarPage extends StatelessWidget {
  final Map<String, List<String>> diaryData;

  const DiaryCalendarPage({super.key, required this.diaryData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Takvim")),
      body: ListView(
        children: diaryData.keys.map((dateKey) {
          DateTime date = DateTime.parse(dateKey);

          return ListTile(
            leading: const Icon(Icons.book),
            title: Text(DateFormat("dd MMMM yyyy").format(date)),
            subtitle: Text("${diaryData[dateKey]!.length} kayıt"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DiaryDetailPage(
                    date: dateKey,
                    entries: diaryData[dateKey]!,
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
