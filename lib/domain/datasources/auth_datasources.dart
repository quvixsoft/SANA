//Paso Numero 2

import 'package:sana/domain/entities/auth.dart';

abstract class AuthDatasource {
  Future<Login> login(String email, String password);
  Future<Login> register(
    String email,
    String password,
    String name,
    bool disclaimerAccepted,
    int roleId,
  );
  Future<void> forgotPassword(String email);
}
