import 'package:flutter_riverpod/flutter_riverpod.dart';
// mood_detail_state.dart

// Bu sınıf sadece veriyi tutar.
class MoodDetailState {
  final String explanation;
  final bool showSuggestions;

  // Başlangıç değerlerini atamak için constructor
  MoodDetailState({
    this.explanation = '',
    this.showSuggestions = false,
  });

  // 'copyWith' metodu: Mevcut durumun bir kopyasını alıp, 
  // sadece istediğimiz kısımları değiştirerek yeni bir durum oluşturur.
  // Riverpod'da state güncellemenin standart yolu budur.
  MoodDetailState copyWith({
    String? explanation,
    bool? showSuggestions,
  }) {
    return MoodDetailState(
      // Eğer yeni bir değer geldiyse onu kullan, yoksa eskisi kalsın.
      explanation: explanation ?? this.explanation,
      showSuggestions: showSuggestions ?? this.showSuggestions,
    );
  }
}

// StateNotifier, 'MoodDetailState' türünde bir durumu yönetir.
class MoodDetailNotifier extends StateNotifier<MoodDetailState> {
  
  // Constructor: Başlangıç durumunu (boş text, false öneri) belirleriz.
  MoodDetailNotifier() : super(MoodDetailState());

  // 1. İşlem: Kullanıcı metin alanına bir şeyler yazdıkça çalışır.
  void updateExplanation(String newText) {
    // Mevcut state'i kopyalayıp, sadece explanation kısmını güncelliyoruz.
    state = state.copyWith(explanation: newText);
  }

  // 2. İşlem: "Gönder" butonuna basıldığında çalışır.
  void submitMood() {
    // Burada normalde veritabanı işlemleri yapılır.
    // Biz şimdilik sadece önerileri görünür yapıyoruz.
    state = state.copyWith(showSuggestions: true);
  }
  
  // İpucu: İleride "Formu Temizle" gibi bir özellik isterseniz buraya ekleyebilirsiniz.
  void reset() {
    state = MoodDetailState(); // Fabrika ayarlarına dönüş
  }
}
// Bu değişkeni UI tarafında (MoodDetailPage) kullanacağız.
final moodDetailProvider = StateNotifierProvider<MoodDetailNotifier, MoodDetailState>(
  (ref) => MoodDetailNotifier(),
);