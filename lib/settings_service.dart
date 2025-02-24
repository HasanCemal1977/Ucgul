import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Şifresiz giriş tercihini almak
  Future<bool> getPasswordlessPreference() async {
    String? passwordless = await _storage.read(key: 'passwordless');
    return passwordless != null && passwordless == 'true';
  }

  // Şifresiz giriş tercihini saklamak
  Future<void> setPasswordlessPreference(bool value) async {
    await _storage.write(key: 'passwordless', value: value ? 'true' : 'false');
  }
}
