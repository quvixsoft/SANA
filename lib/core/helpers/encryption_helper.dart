import 'package:encrypt/encrypt.dart' as encrypt_lib;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionHelper {
  static final _storage = const FlutterSecureStorage();
  static late final encrypt_lib.Encrypter _encrypter;
  static late final encrypt_lib.IV _iv;

  static void initialize({required String encryptionKey}) {
    final key = encrypt_lib.Key.fromUtf8(encryptionKey);
    _encrypter = encrypt_lib.Encrypter(encrypt_lib.AES(key));
    _iv = encrypt_lib.IV.fromLength(16);
  }

  static String encrypt(String plainText) {
    if (plainText.isEmpty) return '';
    try {
      final encrypted = _encrypter.encrypt(plainText, iv: _iv);
      return encrypted.base64;
    } catch (e) {
      print('Error al encriptar: $e');
      return '';
    }
  }

  static String decrypt(String encryptedText) {
    if (encryptedText.isEmpty) return '';
    try {
      return _encrypter.decrypt64(encryptedText, iv: _iv);
    } catch (e) {
      print('Error al desencriptar: $e');
      return '';
    }
  }

  static Future<void> saveEncrypted(String key, String value) async {
    try {
      if (value.isNotEmpty) {
        final encryptedValue = encrypt(value);
        await _storage.write(key: key, value: encryptedValue);
      }
    } catch (e) {
      print('Error al guardar datos encriptados: $e');
    }
  }

  static Future<String?> readEncrypted(String key) async {
    try {
      final encryptedValue = await _storage.read(key: key);
      return encryptedValue?.isNotEmpty == true ? decrypt(encryptedValue!) : null;
    } catch (e) {
      print('Error al leer datos encriptados: $e');
      return null;
    }
  }

  static Future<void> deleteEncrypted(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      print('Error al eliminar datos encriptados: $e');
    }
  }
}
