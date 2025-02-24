import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'settings_service.dart'; // SettingsService'yi import et

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  String _oldPassword = '';  // Eski şifre
  String _newPassword = '';  // Yeni şifre
  String _errorMessage = '';
  bool _passwordless = false; // Şifresiz giriş durumu
  final SettingsService _settingsService = SettingsService();

  @override
  void initState() {
    super.initState();
    // Şifresiz giriş tercihini Flutter Secure Storage'dan alıyoruz
    _loadPasswordlessPreference();
  }

  // Şifresiz giriş tercihini almak
  Future<void> _loadPasswordlessPreference() async {
    bool passwordless = await _settingsService.getPasswordlessPreference();
    setState(() {
      _passwordless = passwordless;
    });
  }

  // Şifresiz giriş durumunu güncelleme
  Future<void> _updatePasswordlessStatus() async {
    try {
      await _settingsService.setPasswordlessPreference(_passwordless);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Şifresiz giriş durumu güncellendi")),
      );
    } catch (e) {
      setState(() {
        _errorMessage = "Hata: $e";
      });
    }
  }

  // Şifreyi değiştirme fonksiyonu
  Future<void> _changePassword() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        setState(() {
          _errorMessage = "Kullanıcı giriş yapmamış.";
        });
        return;
      }

      // Eski şifreyi doğrulamak için mevcut kullanıcıyı şifre ile yeniden doğruluyoruz
      final AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: _oldPassword,
      );

      // Mevcut şifreyi doğrulama
      await user.reauthenticateWithCredential(credential);

      // Şifre doğrulandıktan sonra yeni şifreyi ayarlıyoruz
      await user.updatePassword(_newPassword);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Şifre başarıyla değiştirildi")),
      );
    } catch (e) {
      setState(() {
        _errorMessage = "Hata: $e";  // Hata mesajını göster
      });
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
            // Eski şifre girişi
            TextField(
              obscureText: true,
              decoration: const InputDecoration(labelText: "Eski Şifre"),
              onChanged: (value) {
                setState(() {
                  _oldPassword = value;
                });
              },
            ),
            const SizedBox(height: 20),
            // Yeni şifre girişi
            TextField(
              obscureText: true,
              decoration: const InputDecoration(labelText: "Yeni Şifre"),
              onChanged: (value) {
                setState(() {
                  _newPassword = value;
                });
              },
            ),
            const SizedBox(height: 20),
            // Şifreyi değiştir butonu
            ElevatedButton(
              onPressed: _changePassword,
              child: const Text('Şifreyi Değiştir'),
            ),
            const SizedBox(height: 20),
            // Şifresiz giriş durumu (Switch)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Şifresiz Giriş"),
                CupertinoSwitch(
                  value: _passwordless,
                  onChanged: (bool value) {
                    setState(() {
                      _passwordless = value;
                    });
                    _updatePasswordlessStatus(); // Şifresiz giriş durumunu güncelle
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Hata mesajı
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
