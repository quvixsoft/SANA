import 'package:sana/core/config/network/adapters/http_client.dart';
import 'package:dio/dio.dart';

/// Implementador para realizar peticiones HTTP con opción de autenticación.
/// Maneja llamadas a endpoints según métodos HTTP y gestiona interceptores.
/// Preferible usar este implementador en lugar de los clientes directamente.
class HttpImplementer {
  /// Realiza una petición GET
  static Future<Response<T>> get<T>(
    String connection,
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    String? token,
  }) {
    final httpClient = HttpClient.instance(connection);
    final requestOptions = _buildOptions(options, token);

    return httpClient.get(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// Realiza una petición POST
  static Future<Response<T>> post<T>(
    String connection,
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    String? token,
  }) {
    final httpClient = HttpClient.instance(connection);
    final requestOptions = _buildOptions(options, token);

    return httpClient.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// Realiza una petición PUT
  static Future<Response<T>> put<T>(
    String connection,
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    String? token,
  }) {
    final httpClient = HttpClient.instance(connection);
    final requestOptions = _buildOptions(options, token);

    return httpClient.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// Realiza una petición DELETE
  static Future<Response<T>> delete<T>(
    String connection,
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    String? token,
  }) {
    final httpClient = HttpClient.instance(connection);
    final requestOptions = _buildOptions(options, token);

    return httpClient.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
  }

  /// Construye las opciones de la petición incluyendo el token si está presente
  static Options _buildOptions(Options? options, String? token) {
    if (token == null) return options ?? Options();

    final headers = <String, dynamic>{
      ...?options?.headers,
      'Authorization': 'Bearer $token',
    };

    return options?.copyWith(headers: headers) ?? Options(headers: headers);
  }
}
