import 'package:sana/domain/entities/auth.dart';

/// Estados de autenticación usando sealed classes para pattern matching exhaustivo
sealed class AuthState {
  const AuthState();
}

/// Estado inicial - la app acaba de iniciar
class AuthStateInitial extends AuthState {
  const AuthStateInitial();
}

/// Estado de carga - procesando login/logout
class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

/// Usuario autenticado exitosamente
class AuthStateAuthenticated extends AuthState {
  final User user;
  final String accessToken;

  const AuthStateAuthenticated({required this.user, required this.accessToken});
}

/// Usuario no autenticado (logout o sesión expirada)
class AuthStateUnauthenticated extends AuthState {
  const AuthStateUnauthenticated();
}

/// Error durante autenticación
class AuthStateError extends AuthState {
  final String message;

  const AuthStateError(this.message);
}
