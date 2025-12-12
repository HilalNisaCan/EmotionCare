import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';

// Sayfalar
import 'pages/auth/login_page.dart';
import 'pages/dashboard/dashboard_page.dart';
import 'pages/music/music_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase başlat
  await Firebase.initializeApp();

  // Tarih formatları (tr_TR)
  await initializeDateFormatting('tr_TR', null);

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EmotionCare',

      // ✨ LIGHT TEMA
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFFFE6EF),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),

      // 🌙 DARK TEMA
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F12),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: const ColorScheme.dark(
          primary: Colors.purple,
          secondary: Colors.tealAccent,
        ),
      ),

      // 🔥 Sistem temasına göre otomatik
      themeMode: ThemeMode.system,

      // ROUTES
      routes: {
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardPage(),
      '/music': (context) => const MusicPage(
      showSaveButton: false,
      mood: "",
      actionName: "",
),
      },

      // 📌 İlk açılış LoginPage
      home: const LoginPage(),
    );
  }
}
