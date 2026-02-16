import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Variables de entorno
class Environment {
  // App Configuration
  static get appName => dotenv.env['APP_NAME'];
  static get debug => dotenv.env['APP_DEBUG'] == 'true';
  static get apiSana => dotenv.env['API_SANA'] ?? 'http://localhost:3000/v1/';
}
