import 'package:sana/domain/datasources/auth_datasources.dart';
import 'package:sana/domain/entities/auth.dart';
import 'package:sana/domain/repositories/auth_repository.dart';

/// Implementación concreta del repositorio de autenticación
class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl(this.datasource);

  @override
  Future<Login> login(String email, String password) async {
    try {
      return await datasource.login(email, password);
    } catch (e) {
      // Re-lanzar la excepción para que sea manejada por el provider
      rethrow;
    }
  }

  @override
  Future<User> register(
    String email,
    String password,
    String name,
    String birthDate,
    bool disclaimerAccepted,
    int roleId,
  ) async {
    try {
      return await datasource.register(
        email,
        password,
        name,
        birthDate,
        disclaimerAccepted,
        roleId,
      );
    } catch (e) {
      rethrow;
    }
  }
}
