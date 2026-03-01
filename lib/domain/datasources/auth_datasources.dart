//Paso Numero 2

import 'package:sana/domain/entities/auth.dart';

abstract class AuthDatasource {
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
