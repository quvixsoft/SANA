/**
 * Paso numero 1. Crear la identidad, el modelo de datos que se va a utilizar en el modulo.
 */
class Login {
  String accessToken;
  String refreshToken;
  User user;

  Login({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });
}

class User {
  int id;
  String email;
  String name;
  String role;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });
}
