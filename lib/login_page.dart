import 'package:flutter/material.dart';
import 'home_page.dart'; // HomePage import ediliyor.
import 'user_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final UserService _userService = UserService();
  List<Map<String, String>> _passwordControlList = [];

  @override
  void initState() {
    super.initState();
    _loadPasswordControlList();
  }

  // Firebase'den kullanıcı verilerini alıp passwordControlList'i oluşturuyoruz.
  Future<void> _loadPasswordControlList() async {
    final passwordList = await _userService.getPasswordControlList();
    setState(() {
      _passwordControlList = passwordList;
    });
  }

  // Giriş işlemi
  void _login() {
    final email = _emailController.text;
    final password = _passwordController.text;

    // Veritabanındaki kullanıcı ile eşleşen email ve şifreyi kontrol ediyoruz
    final user = _passwordControlList.firstWhere(
          (user) => user['email'] == email && user['password'] == password,
      orElse: () => {},
    );

    if (user.isEmpty) {
      // Eğer kullanıcı veya şifre yanlışsa
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Hata'),
          content: const Text('Geçersiz kullanıcı adı veya şifre.'),
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
    } else {
      // Eğer giriş başarılıysa
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
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
              decoration: InputDecoration(labelText: 'Kullanıcı adı', border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Colors.grey))),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Şifre', border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Colors.grey))),
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
