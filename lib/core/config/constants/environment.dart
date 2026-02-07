import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Variables de entorno
class Environment {
  static get appName => dotenv.env['APP_NAME'];
  static get debug => dotenv.env['APP_DEBUG'] == 'true';
}
