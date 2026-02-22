import 'package:sana/domain/entities/auth.dart';
import 'package:sana/infrastructure/models/auth_model.dart';

/// Mapper para convertir modelos de infraestructura a entidades de dominio
/// Sigue el principio de Clean Architecture: la capa de dominio no conoce la infraestructura
class AuthMapper {
  /// Convierte LoginResponseModel (DTO) a Login (Entity)
  static Login loginResponseToEntity(LoginResponseModel model) {
    return Login(
      accessToken: model.accessToken,
      refreshToken: model.refreshToken,
      user: userModelToEntity(model.user),
    );
  }

  /// Convierte UserModel (DTO) a User (Entity)
  static User userModelToEntity(UserModel model) {
    return User(
      id: model.id,
      email: model.email,
      name: model.name,
      role: model.role,
    );
  }
}
