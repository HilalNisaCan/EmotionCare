import 'package:flutter/material.dart';
// Eğer LoginPage'e geri dönmek için kullanıyorsan (klasör yolunu sizdeki gibi düzelt):
// import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController    = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController  = TextEditingController();

  bool _isPasswordVisible        = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading                = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String value) {
    final emailRegex = RegExp(
      r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$',
    );
    return emailRegex.hasMatch(value);
  }

  Future<void> _onRegisterPressed() async {
    // Form geçerli mi?
    if (!_formKey.currentState!.validate()) return;

    // Loading başlat
    setState(() => _isLoading = true);

    try {
      // 🔹 ŞU AN BURADA SADECE SAHTE BİR BEKLEME VAR
      // Firebase Auth bağlanınca buraya:
      // await FirebaseAuth.instance.createUserWithEmailAndPassword(
      //   email: _emailController.text.trim(),
      //   password: _passwordController.text.trim(),
      // );
      //
      // ve Firestore'a username yazma kodu eklenecek.

      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kayıt başarılı! (Firebase bağlanınca gerçek kayıt yapılacak)'),
        ),
      );

      // Başarılı kayıt sonrası ne yapmak istiyorsan buraya koy:
      // Örnek: login ekranına dön
      // Navigator.pop(context);

      // veya home / dashboard'a geç (class ismini sizdeki dosyaya göre değiştir):
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (_) => const HomePage()),
      // );

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kayıt sırasında bir hata oluştu: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false); // 🔴 HER DURUMDA LOADING KAPANIYOR
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFE6EF),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'EmotionCare',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6C2DB3),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Duygularını takip et, kendine iyi bak 💜',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7D5C9E),
                  ),
                ),
                const SizedBox(height: 32),

                // Beyaz kart
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Kayıt ol',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Kullanıcı adı
                        const Text('Kullanıcı adı'),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.person_outline),
                    
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF7F3FF),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Kullanıcı adı boş olamaz';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        // E-posta
                        const Text('E-posta'),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email_outlined),
                            
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF7F3FF),
                          ),
                          validator: (value) {
                            final text = value?.trim() ?? '';
                            if (text.isEmpty) {
                              return 'E-posta boş olamaz';
                            }
                            if (!_isValidEmail(text)) {
                              return 'Lütfen geçerli bir e-posta gir';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        // Şifre
                        const Text('Şifre'),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF7F3FF),
                          ),
                          validator: (value) {
                            final text = value ?? '';
                            if (text.isEmpty) {
                              return 'Şifre boş olamaz';
                            }
                            if (text.length < 6) {
                              return 'Şifre en az 6 karakter olmalı';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        // Şifre tekrar
                        const Text('Şifre (tekrar)'),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: _confirmController,
                          obscureText: !_isConfirmPasswordVisible,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_reset_outlined),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                           
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF7F3FF),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Lütfen şifreni tekrar gir';
                            }
                            if (value != _passwordController.text) {
                              return 'Şifreler eşleşmiyor';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // KAYIT OL BUTONU
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _onRegisterPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB14DFF),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'Kayıt ol',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Zaten hesabın var mı? Giriş yap
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              // Eğer bu sayfaya login'den Navigator.push ile geliyorsanız:
                              Navigator.pop(context);

                              // Ya da direkt LoginPage'e gitmek istiyorsan:
                              // Navigator.pushReplacement(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (_) => const LoginPage(),
                              //   ),
                              // );
                            },
                            child: RichText(
                              text: TextSpan(
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  color: Colors.grey[700],
                                ),
                                children: const [
                                  TextSpan(text: 'Zaten hesabın var mı? '),
                                  TextSpan(
                                    text: 'Giriş yap',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF6C2DB3),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
