import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth importu
import 'home_page.dart'; // HomePage import ediliyor

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Giriş işlemi
  void _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      // Firebase ile giriş yapmayı deniyoruz
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Eğer giriş başarılıysa
      if (userCredential.user != null) {
        // Giriş başarılı, HomePage'e yönlendiriyoruz
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Firebase hata durumlarını kontrol ediyoruz
      String errorMessage = '';

      if (e.code == 'user-not-found') {
        errorMessage = 'Kullanıcı bulunamadı.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Geçersiz şifre.';
      } else {
        errorMessage = 'Bir hata oluştu. Lütfen tekrar deneyin.';
      }

      // Hata mesajını gösteriyoruz
      _showErrorDialog(errorMessage);
    }
  }

  // Hata mesajını gösterme fonksiyonu
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hata'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/ucgul.png'),
            TextField(
              autofocus: true,
              controller: _emailController,
              decoration: InputDecoration(
                  labelText: 'Kullanıcı adı',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Colors.grey),
                  )),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Şifre',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Giriş Yap'),
            ),
          ],
        ),
      ),
    );
  }
}
