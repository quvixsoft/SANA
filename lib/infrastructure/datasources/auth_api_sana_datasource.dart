import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sana/core/config/network/adapters/http_implementer.dart';
import 'package:sana/domain/datasources/auth_datasources.dart';
import 'package:sana/domain/entities/auth.dart';
import 'package:sana/infrastructure/mappers/auth_mapper.dart';
import 'package:sana/infrastructure/models/auth_model.dart';

class AuthApiSanaDatasource extends AuthDatasource {
  final String connection = 'api-sana';

  @override
  Future<Login> login(String email, String password) async {
    try {
      final response = await HttpImplementer.post<Map<String, dynamic>>(
        connection,
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      debugPrint('response: API SANA $response');
      // Convertir respuesta JSON a modelo
      final loginModel = LoginResponseModel.fromJson(response.data!);

      // Convertir modelo a entidad usando el mapper
      return AuthMapper.loginResponseToEntity(loginModel);
    } on DioException catch (e) {
      // Manejo de errores específicos de Dio
      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final message = e.response!.data['message'] ?? 'Error desconocido';

        switch (statusCode) {
          case 400:
            throw Exception('Datos inválidos: $message');
          case 401:
            throw Exception('Credenciales incorrectas');
          case 404:
            throw Exception('Endpoint no encontrado');
          case 500:
            throw Exception('Error del servidor');
          default:
            throw Exception('Error HTTP $statusCode: $message');
        }
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Tiempo de espera agotado. Verifica tu conexión.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Error de conexión. Verifica tu internet.');
      } else {
        throw Exception('Error de red: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error inesperado: $e');
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
      final response = await HttpImplementer.post<Map<String, dynamic>>(
        connection,
        '/users',
        data: {
          'email': email,
          'password': password,
          'name': name,
          'birthDate': birthDate,
          'disclaimerAccepted': disclaimerAccepted,
          'roleId': roleId,
        },
      );
      debugPrint('response: API SANA REGISTER $response');
      // Convertir respuesta JSON a modelo de usuario
      final userModel = UserModel.fromJson(response.data!);

      // Convertir modelo a entidad usando el mapper
      return AuthMapper.userModelToEntity(userModel);
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final message = e.response!.data['message'] ?? 'Error desconocido';

        if (statusCode == 400 && message is List) {
          throw Exception(message.join(', '));
        }

        switch (statusCode) {
          case 400:
            throw Exception('Datos inválidos: $message');
          case 409:
            throw Exception('El usuario ya existe');
          case 500:
            throw Exception('Error del servidor');
          default:
            throw Exception('Error HTTP $statusCode: $message');
        }
      } else {
        throw Exception('Error de conexión: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}
