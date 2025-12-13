import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _pass2Ctrl = TextEditingController();

  bool _loading = false;
  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _pass2Ctrl.dispose();
    super.dispose();
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  String _prettyFirebaseError(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'Bu e-posta zaten kullanılıyor.';
        case 'invalid-email':
          return 'E-posta formatı geçersiz.';
        case 'weak-password':
          return 'Şifre çok zayıf. En az 6 karakter olmalı.';
        case 'operation-not-allowed':
          return 'Email/Password giriş yöntemi Firebase Console’da kapalı. Açman lazım.';
        case 'configuration-not-found':
          return 'Firebase yapılandırması bulunamadı. (google-services.json / firebase_options.dart / init kontrol)';
        default:
          return 'Hata: ${e.message ?? e.code}';
      }
    }
    return 'Beklenmeyen hata: $e';
  }

  Future<void> _register() async {
    final username = _usernameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;
    final pass2 = _pass2Ctrl.text;

    if (username.isEmpty) {
      _snack('Kullanıcı adı boş olamaz.');
      return;
    }
    if (email.isEmpty) {
      _snack('E-posta boş olamaz.');
      return;
    }
    if (pass.length < 6) {
      _snack('Şifre en az 6 karakter olmalı.');
      return;
    }
    if (pass != pass2) {
      _snack('Şifreler uyuşmuyor.');
      return;
    }

    setState(() => _loading = true);

    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      await cred.user?.updateDisplayName(username);

      _snack('Kayıt başarılı! Şimdi giriş yapabilirsin.');

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } catch (e) {
      _snack(_prettyFirebaseError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final purple = const Color.fromARGB(255, 187, 63, 221);


    InputDecoration deco({
      required String label,
      required String hint,
      required IconData icon,
      Widget? suffix,
    }) {
      return InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFFF6F2FF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFE6EF), Color(0xFFFFF6FB)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  children: [
                    Text(
                      'EmotionCare',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: purple,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Duygularını takip et, kendine iyi bak 💜',
                      style: TextStyle(color: Colors.black.withOpacity(0.65)),
                    ),
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 20,
                            color: Colors.black.withOpacity(0.08),
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Kayıt ol',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 14),
                          TextField(
                            controller: _usernameCtrl,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.username],
                            decoration: deco(
                              label: 'Kullanıcı adı',
                              hint: '...',
                              icon: Icons.person_outline,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.email],
                            decoration: deco(
                              label: 'E-posta',
                              hint: '...@gmail.com',
                              icon: Icons.mail_outline,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _passCtrl,
                            obscureText: _obscure1,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.newPassword],
                            decoration: deco(
                              label: 'Şifre',
                              hint: 'en az 6 karakter',
                              icon: Icons.lock_outline,
                              suffix: IconButton(
                                onPressed: () => setState(() => _obscure1 = !_obscure1),
                                icon: Icon(_obscure1 ? Icons.visibility : Icons.visibility_off),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _pass2Ctrl,
                            obscureText: _obscure2,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.newPassword],
                            decoration: deco(
                              label: 'Şifre (tekrar)',
                              hint: 'şifreni tekrar yaz',
                              icon: Icons.lock_reset_outlined,
                              suffix: IconButton(
                                onPressed: () => setState(() => _obscure2 = !_obscure2),
                                icon: Icon(_obscure2 ? Icons.visibility : Icons.visibility_off),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // ✅ BUTON DÜZELTİLDİ: yazı beyaz + disabled halde kaybolmuyor
                          SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: purple,
                                foregroundColor: Colors.white, // ✅ yazı rengi
                                disabledBackgroundColor: Colors.grey.shade300,
                                disabledForegroundColor: Colors.white70, // ✅ disabled yazı görünür
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: _loading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white, // ✅ loading rengi
                                      ),
                                    )
                                  : const Text(
                                      'Kayıt ol',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Zaten hesabın var mı? ',
                                style: TextStyle(color: Colors.black.withOpacity(0.65)),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (_) => const LoginPage()),
                                  );
                                },
                                child: const Text('Giriş yap'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
