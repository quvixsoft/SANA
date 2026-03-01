import 'package:sana/domain/entities/auth.dart';

/// Repositorio abstracto para autenticación
/// Define el contrato que debe cumplir cualquier implementación
abstract class AuthRepository {
  Future<Login> login(String email, String password);
  Future<User> register(
    String email,
    String password,
    String name,
    String birthDate,
    bool disclaimerAccepted,
    int roleId,
  );
  Future<void> forgotPassword(String email);
}
