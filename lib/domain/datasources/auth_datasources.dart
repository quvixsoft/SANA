//Paso Numero 2

import 'package:sana/domain/entities/auth.dart';

abstract class AuthDatasource {
  Future<Login> login(String email, String password);
}
