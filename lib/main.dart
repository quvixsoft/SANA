import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sana/core/config/constants/environment.dart';
import 'package:sana/core/config/router/app_router.dart';
import 'package:sana/core/config/theme/app_theme.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  //  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: Environment.appName ?? 'SANA',
      debugShowCheckedModeBanner: Environment.debug ?? false,
      theme: AppTheme().getTheme(),
      routerConfig: appRouter,
    );
  }
}
