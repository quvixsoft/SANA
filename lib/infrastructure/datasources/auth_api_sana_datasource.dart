import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
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
        final message = e.response!.data['message'] ?? 'errors.unknown'.tr();

        switch (statusCode) {
          case 400:
            throw Exception('errors.invalid_data'.tr(args: ['$message']));
          case 401:
            throw Exception('errors.invalid_credentials'.tr());
          case 404:
            throw Exception('errors.endpoint_not_found'.tr());
          case 500:
            throw Exception('errors.server_error'.tr());
          default:
            throw Exception(
              'errors.http_error'.tr(args: ['$statusCode', '$message']),
            );
        }
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('errors.timeout'.tr());
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('errors.connection_error'.tr());
      } else {
        throw Exception('errors.network_error'.tr(args: ['${e.message}']));
      }
    } catch (e) {
      throw Exception('errors.unexpected_error'.tr(args: ['$e']));
    }
  }

  @override
  Future<Login> register(
    String email,
    String password,
    String name,
    bool disclaimerAccepted,
    int roleId,
  ) async {
    try {
      // 1. Registrar al usuario
      final response = await HttpImplementer.post<Map<String, dynamic>>(
        connection,
        '/users',
        data: {
          'email': email,
          'password': password,
          'name': name,
          'disclaimerAccepted': disclaimerAccepted,
          'roleId': roleId,
        },
      );
      debugPrint('response: API SANA REGISTER $response');

      // 2. Login automático con las mismas credenciales
      return await login(email, password);
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final message = e.response!.data['message'] ?? 'errors.unknown'.tr();

        if (statusCode == 400 && message is List) {
          throw Exception(message.join(', '));
        }
        debugPrint('El error code es : $statusCode');
        switch (statusCode) {
          case 400:
            throw Exception('errors.invalid_data'.tr(args: ['$message']));
          case 409:
            throw Exception('errors.user_already_exists'.tr());
          case 500:
            throw Exception('errors.server_error'.tr());
          default:
            throw Exception(
              'errors.http_error'.tr(args: ['$statusCode', '$message']),
            );
        }
      } else {
        throw Exception(
          'errors.connection_error_generic'.tr(args: ['${e.message}']),
        );
      }
    } catch (e) {
      throw Exception('errors.unexpected_error'.tr(args: ['$e']));
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await HttpImplementer.post<Map<String, dynamic>>(
        connection,
        '/auth/forgot-password',
        data: {'email': email},
      );
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final message = e.response!.data['message'] ?? 'errors.unknown'.tr();

        switch (statusCode) {
          case 400:
            throw Exception('errors.invalid_data'.tr(args: ['$message']));
          case 404:
            throw Exception('errors.endpoint_not_found'.tr());
          case 500:
            throw Exception('errors.server_error'.tr());
          default:
            throw Exception(
              'errors.http_error'.tr(args: ['$statusCode', '$message']),
            );
        }
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('errors.timeout'.tr());
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('errors.connection_error'.tr());
      } else {
        throw Exception('errors.network_error'.tr(args: ['${e.message}']));
      }
    } catch (e) {
      throw Exception('errors.unexpected_error'.tr(args: ['$e']));
    }
  }
}
