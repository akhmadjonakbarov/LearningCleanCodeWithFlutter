// lib/services/secure_storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageKeys {
  static const token = 'token', lang = 'lang', user = 'user';
}

class SecureStorageService {
  static final SecureStorageService _instance =
      SecureStorageService._internal();

  factory SecureStorageService() => _instance;

  SecureStorageService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _write(SecureStorageKeys.token, token);
  }

  Future<String?> getToken() async {
    String? token = await _read(SecureStorageKeys.token);
    return token == null || token == '' ? null : token;
  }

  Future<void> deleteToken() async {
    await _delete(SecureStorageKeys.token);
  }

  Future<void> saveLang(String lang) async {
    await _storage.write(key: SecureStorageKeys.lang, value: lang);
  }

  Future<String?> getLang() async {
    return await _read(SecureStorageKeys.lang);
  }

  Future<void> deleteLang() async {
    await _delete(SecureStorageKeys.lang);
  }

  Future<void> saveUser(String value) async {
    await _write(SecureStorageKeys.user, value);
  }

  /// NEW: get stored user JSON string (or null)
  Future<String?> getUser() async {
    return await _read(SecureStorageKeys.user);
  }

  Future<void> deleteUser() async {
    await _delete(SecureStorageKeys.user);
  }

  Future<void> _write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      // LogHelper.error("Saving $key: $e");
    }
  }

  Future<String?> _read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      // LogHelper.error("Reading $key: $e");
      return null;
    }
  }

  Future<void> _delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      // LogHelper.error("Deleting $key: $e");
    }
  }
}
