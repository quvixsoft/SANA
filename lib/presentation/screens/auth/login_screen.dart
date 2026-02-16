import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sana/core/config/theme/app_theme.dart';
import 'package:sana/presentation/widgets/buttons/primary_button.dart';
import 'package:sana/presentation/screens/dashboard/home/home_screen.dart';
import 'package:sana/presentation/providers/auth_provider.dart';
import 'package:sana/presentation/providers/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/presentation/screens/auth/forgot_password_screen.dart';
import 'package:sana/presentation/screens/auth/register_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const String routePath = '/auth/login';
  static const String routeName = 'login';

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
    _attemptAutoLogin();
  }

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } catch (e) {
      canCheckBiometrics = false;
    }
    if (!mounted) return;
    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _attemptAutoLogin() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final prefs = await SharedPreferences.getInstance();
    final bool useBiometrics = prefs.getBool('use_biometrics') ?? false;

    if (useBiometrics && _canCheckBiometrics) {
      await _authenticate();
    }
  }

  Future<void> _authenticate() async {
    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'login.biometric_prompt'.tr(),
      );
      if (didAuthenticate) {
        if (!mounted) return;
        _onLoginSuccess();
      }
    } catch (e) {
      debugPrint("Auth error: $e");
    }
  }

  void _onLoginSuccess() {
    if (mounted) {
      context.go(HomeScreen.routePath);
    }
  }

  /// Validación de email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'login.email_required'.tr();
    }
    // Regex para validar formato de email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'login.email_invalid'.tr();
    }
    return null;
  }

  /// Validación de password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'login.password_required'.tr();
    }
    if (value.length < 8) {
      return 'login.password_min_length'.tr();
    }
    return null;
  }

  Future<void> _handleLogin() async {
    // Validar formulario
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Llamar al provider para hacer login
      await ref
          .read(authNotifierProvider.notifier)
          .login(_emailController.text.trim(), _passwordController.text);

      // Escuchar el estado para manejar éxito/error
      final authState = ref.read(authNotifierProvider);

      if (authState is AuthStateAuthenticated) {
        // Login exitoso
        if (!mounted) return;

        final prefs = await SharedPreferences.getInstance();
        final bool useBiometrics = prefs.getBool('use_biometrics') ?? false;

        if (!useBiometrics && _canCheckBiometrics) {
          // Preguntar si quiere habilitar biometría
          _showBiometricDialog(prefs);
        } else {
          _onLoginSuccess();
        }
      } else if (authState is AuthStateError) {
        // Mostrar error
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authState.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showBiometricDialog(SharedPreferences prefs) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('login.enable_biometric_title'.tr()),
        content: Text('login.enable_biometric_message'.tr()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _onLoginSuccess();
            },
            child: Text('login.no'.tr()),
          ),
          TextButton(
            onPressed: () async {
              await prefs.setBool('use_biometrics', true);
              if (context.mounted) {
                Navigator.pop(context);
                _onLoginSuccess();
              }
            },
            child: Text('login.yes_enable'.tr()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Escuchar cambios en el estado de autenticación
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next is AuthStateError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message), backgroundColor: Colors.red),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(60),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.health_and_safety,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Título
                  Text(
                    'login.title'.tr(),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkNavy,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'login.subtitle'.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.darkNavy.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                    decoration: InputDecoration(
                      labelText: 'login.email'.tr(),
                      hintText: 'login.email_hint'.tr(),
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    validator: _validatePassword,
                    decoration: InputDecoration(
                      labelText: 'login.password'.tr(),
                      hintText: 'login.password_hint'.tr(),
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        context.push(ForgotPasswordScreen.routePath);
                      },
                      child: Text(
                        'login.forgot_password'.tr(),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login Button
                  PrimaryButton(
                    text: 'login.button'.tr(),
                    onPressed: _isLoading ? null : _handleLogin,
                    expand: true,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 24),

                  // Biometric Login (if available)
                  if (_canCheckBiometrics)
                    Column(
                      children: [
                        Text(
                          'login.or'.tr(),
                          style: TextStyle(
                            color: AppColors.darkNavy.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 16),
                        IconButton(
                          onPressed: _authenticate,
                          icon: const Icon(Icons.fingerprint),
                          iconSize: 48,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),

                  // Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'login.no_account'.tr(),
                        style: TextStyle(
                          color: AppColors.darkNavy.withOpacity(0.6),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.push(RegisterScreen.routePath);
                        },
                        child: Text(
                          'login.register'.tr(),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
