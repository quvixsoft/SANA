import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Servicio para almacenar datos sensibles de forma segura (tokens JWT)
/// Usa flutter_secure_storage que encripta los datos en el dispositivo
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  // Keys para almacenamiento
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userDataKey = 'user_data';

  /// Guarda el access token
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  /// Obtiene el access token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// Guarda el refresh token
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  /// Obtiene el refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Guarda datos del usuario (como JSON string)
  Future<void> saveUserData(String userData) async {
    await _storage.write(key: _userDataKey, value: userData);
  }

  /// Obtiene datos del usuario
  Future<String?> getUserData() async {
    return await _storage.read(key: _userDataKey);
  }

  /// Elimina todos los datos almacenados (logout)
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Elimina solo los tokens
  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }
}
