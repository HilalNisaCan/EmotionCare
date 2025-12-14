import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'firebase_options.dart';

// Sayfalar
import 'pages/auth/login_page.dart';
import 'pages/dashboard/dashboard_page.dart';
import 'pages/music/music_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Google Fonts runtime fetching AÇIK
  GoogleFonts.config.allowRuntimeFetching = true;

  // 🔐 ENV
  await dotenv.load(fileName: ".env.example");

  // 🔥 Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 📅 Tarih formatları
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

        // ✅ (PERF) GoogleFonts yerine stabil textTheme
        // (Görünüm çok az değişir ama kasma ciddi azalır)
        textTheme: ThemeData.light().textTheme,
      ),

      // 🌙 DARK TEMA
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F12),
        useMaterial3: true,

        // ✅ (PERF) GoogleFonts yerine stabil textTheme
        textTheme: ThemeData.dark().textTheme,

        colorScheme: const ColorScheme.dark(
          primary: Colors.purple,
          secondary: Colors.tealAccent,
        ),
      ),

      themeMode: ThemeMode.system,

      routes: {
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/music': (context) => const MusicPage(
              showSaveButton: false,
              mood: "",
              actionName: "",
            ),
      },

      home: const LoginPage(),
    );
  }
}
