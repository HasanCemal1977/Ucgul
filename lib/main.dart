import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase'i başlat

  // Şifresiz giriş tercihini kontrol et
  final settingsService = SettingsService();
  bool isPasswordless = await settingsService.getPasswordlessPreference();

  runApp(MyApp(isPasswordless: isPasswordless));
}

class MyApp extends StatelessWidget {
  final bool isPasswordless;

  MyApp({required this.isPasswordless});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Üçgül Forever',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isPasswordless ? HomePage() : LoginPage(),
    );
  }
}
