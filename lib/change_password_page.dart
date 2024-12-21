import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  String _oldPassword = '';  // Kullanıcıdan alınacak eski şifre
  String _newPassword = '';  // Kullanıcıdan alınacak yeni şifre
  String _errorMessage = ''; // Hata mesajı

  // Eski şifreyi kontrol etme ve yeni şifreyi Firestore'a güncelleme fonksiyonu
  Future<void> _changePassword() async {
    try {
      // Firestore'dan kullanıcıyı bulalım
      var collection = FirebaseFirestore.instance.collection('users');

      // Kullanıcıyı Firestore'dan çekiyoruz. Burada, kullanıcı şifresini kontrol edeceğiz.
      var querySnapshot = await collection
          .where('password', isEqualTo: _oldPassword)  // Eski şifreyi kontrol ediyoruz
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userDoc = querySnapshot.docs.first; // Kullanıcıyı bulduk

        // Eski şifre doğruysa, yeni şifreyi kaydedelim
        await userDoc.reference.update({
          'password': _newPassword,  // Yeni şifreyi Firestore'a kaydediyoruz
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Şifre başarıyla değiştirildi")));
      } else {
        setState(() {
          _errorMessage = "Eski şifre yanlış.";
        });
        print('Eski şifre yanlış');
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Hata: $e";
      });
      print('Hata: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Şifre Değiştir"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Eski şifreyi alacak olan TextField
            TextField(
              obscureText: true,
              decoration: const InputDecoration(labelText: "Eski Şifre"),
              onChanged: (value) {
                setState(() {
                  _oldPassword = value; // Eski şifreyi alıyoruz
                });
              },
            ),
            const SizedBox(height: 20),
            // Yeni şifreyi alacak olan TextField
            TextField(
              obscureText: true,
              decoration: const InputDecoration(labelText: "Yeni Şifre"),
              onChanged: (value) {
                setState(() {
                  _newPassword = value; // Yeni şifreyi alıyoruz
                });
              },
            ),
            const SizedBox(height: 20),
            // Şifre değiştirme işlemi için buton
            ElevatedButton(
              onPressed: _changePassword, // Şifreyi değiştirmek için bu fonksiyonu çağırıyoruz
              child: const Text('Şifreyi Değiştir'),
            ),
            const SizedBox(height: 20),
            // Hata mesajını göstermek için
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
