import 'package:dio/dio.dart';
import 'package:sana/core/config/constants/environment.dart';
import 'package:sana/core/config/network/adapters/http_connector.dart';

/// Este es el cliente que conecta a la salida y entrada de datos de los repositorios
/// En otras palabras los endpoints de los backend conectados
class HttpClient {
  /// Lista de conexiones a diversos backends
  final Map<String, HttpConnector> connections = {
    /// API de sana
    'api-sana': HttpConnector(
      url: Environment.apiSana,
      header: {'Accept': 'application/json'},
    ),
  };

  /// El connector seleccionado
  final String selectedConnector;

  /// La instancia de Dio para el connector seleccionado
  late final Dio _dioInstance;

  /// Constructor que recibe el nombre del connector
  HttpClient(String connector) : selectedConnector = connector {
    if (!connections.containsKey(connector)) {
      throw ArgumentError('Connector $connector not found');
    }

    final connection = connections[connector]!;

    _dioInstance = Dio(
      BaseOptions(
        baseUrl: connection.url,
        headers: connection.header,
        // validateStatus: (status) {
        //   return status == 409 || status == 308 || (status != null && status >= 200 && status < 300);
        // },
      ),
    );
  }

  /// Obtiene la instancia de dio con el conector seleccionado
  Dio get dioInstance => _dioInstance;

  /// Método estático que devuelve una instancia de Dio para el connector especificado
  static Dio instance(String connection) {
    final httpClient = HttpClient(connection);
    return httpClient.dioInstance;
  }
}
