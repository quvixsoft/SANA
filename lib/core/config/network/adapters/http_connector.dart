/// Los conectores almacenan la información de acceso a las APIs
class HttpConnector {
  final String url;
  final Map<String, String> header;

  HttpConnector({required this.url, this.header = const {}});
}
