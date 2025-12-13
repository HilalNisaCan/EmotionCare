import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AiChatService {
  static const String _apiUrl =
      "https://openrouter.ai/api/v1/chat/completions";

  static Future<String> sendMessage(String message) async {
    // ✅ ENV ARTIK BURADA OKUNUYOR
    final apiKey = dotenv.env['OPENROUTER_API_KEY'];

    print("ENV KEY => $apiKey");

    if (apiKey == null || apiKey.isEmpty) {
      return "AI anahtarı bulunamadı 😢";
    }

    try {
      final response = await http
          .post(
            Uri.parse(_apiUrl),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $apiKey",
              "HTTP-Referer": "https://emotioncare.app",
              "X-Title": "EmotionCare",
            },
            body: jsonEncode({
              "model": "openai/gpt-3.5-turbo",
              "messages": [
                {
                  "role": "system",
                  "content":
                      "Sen empatik, nazik ve yargılamayan bir duygusal destek asistanısın."
                },
                {
                  "role": "user",
                  "content": message
                }
              ],
              "max_tokens": 200,
              "temperature": 0.6
            }),
          )
          .timeout(const Duration(seconds: 12));

      print("STATUS => ${response.statusCode}");
      print("BODY => ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["choices"][0]["message"]["content"];
      } else {
        return "Şu an cevap vermekte zorlanıyorum… Birazdan tekrar dener miyiz? 💜";
      }
    } catch (e) {
      print("ERROR => $e");
      return "Bir sorun oluştu ama yanındayım 🌸";
    }
  }
}
