import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart'; // Tarih hatası için

// 👇 BAŞLANGIÇ OLARAK LOGIN SAYFASINI ÇAĞIRIYORUZ
import 'pages/auth/login_page.dart'; 

void main() async {
  // 👇 KIRMIZI EKRAN (Locale) HATASINI ÇÖZEN KOD
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR', null); 

  runApp(
    const ProviderScope( // Riverpod Kapsayıcısı
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      // 👇 İŞTE BURASI: Uygulama GİRİŞ EKRANI ile başlasın.
      home: const LoginPage(), 
    );
  }
}