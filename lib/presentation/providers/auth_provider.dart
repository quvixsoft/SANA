import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sana/core/services/secure_storage_service.dart';
import 'package:sana/domain/datasources/auth_datasources.dart';
import 'package:sana/domain/repositories/auth_repository.dart';
import 'package:sana/domain/entities/auth.dart';
import 'package:sana/infrastructure/datasources/auth_api_sana_datasource.dart';
import 'package:sana/infrastructure/repositories/auth_repository_impl.dart';
import 'package:sana/presentation/providers/auth_state.dart';
import 'dart:convert';

// Provider para el servicio de almacenamiento seguro
final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

// Provider para el datasource
final authDatasourceProvider = Provider<AuthDatasource>((ref) {
  return AuthApiSanaDatasource();
});

// Provider para el repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final datasource = ref.watch(authDatasourceProvider);
  return AuthRepositoryImpl(datasource);
});

// Notifier para manejar el estado de autenticación (Riverpod 3.x)
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    // Al iniciar, verificar sesión guardada
    _checkAuthStatus();
    return const AuthStateInitial();
  }

  /// Verifica si hay una sesión guardada al iniciar
  Future<void> _checkAuthStatus() async {
    try {
      final storage = ref.read(secureStorageProvider);
      final accessToken = await storage.getAccessToken();
      final userDataJson = await storage.getUserData();

      if (accessToken != null && userDataJson != null) {
        final userData = jsonDecode(userDataJson);
        final user = User(
          id: userData['id'] as int,
          email: userData['email'] as String,
          name: userData['name'] as String,
          role: userData['role'] as String,
        );

        state = AuthStateAuthenticated(user: user, accessToken: accessToken);
      } else {
        state = const AuthStateUnauthenticated();
      }
    } catch (e) {
      state = const AuthStateUnauthenticated();
    }
  }

  /// Login con email y password
  Future<void> login(String email, String password) async {
    state = const AuthStateLoading();
    debugPrint('email: $email');
    debugPrint('password: $password');
    try {
      final repository = ref.read(authRepositoryProvider);
      final loginResponse = await repository.login(email, password);
      debugPrint('loginResponse: $loginResponse');
      // Guardar tokens y datos del usuario
      final storage = ref.read(secureStorageProvider);
      await storage.saveAccessToken(loginResponse.accessToken);
      await storage.saveRefreshToken(loginResponse.refreshToken);
      await storage.saveUserData(
        jsonEncode({
          'id': loginResponse.user.id,
          'email': loginResponse.user.email,
          'name': loginResponse.user.name,
          'role': loginResponse.user.role,
        }),
      );

      // Actualizar estado
      state = AuthStateAuthenticated(
        user: loginResponse.user,
        accessToken: loginResponse.accessToken,
      );
    } catch (e) {
      state = AuthStateError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Registro de usuario
  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String birthDate,
    required bool disclaimerAccepted,
    required int roleId,
  }) async {
    state = const AuthStateLoading();
    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.register(
        email,
        password,
        name,
        birthDate,
        disclaimerAccepted,
        roleId,
      );
      // Tras registro exitoso, no autenticamos automáticamente según requerimiento.
      // El estado vuelve a Unauthenticated para que el usuario haga login.
      // Opcionalmente podríamos hacer login automático aquí si se desea.
      state = const AuthStateUnauthenticated();
    } catch (e) {
      state = AuthStateError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Logout - eliminar sesión
  Future<void> logout() async {
    state = const AuthStateLoading();

    try {
      final storage = ref.read(secureStorageProvider);
      await storage.clearAll();
      state = const AuthStateUnauthenticated();
    } catch (e) {
      state = AuthStateError('Error al cerrar sesión: $e');
    }
  }
}

// Provider principal de autenticación (Riverpod 3.x)
final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
