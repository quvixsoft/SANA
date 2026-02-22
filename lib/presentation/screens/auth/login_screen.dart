import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sana/core/config/theme/app_theme.dart';
import 'package:sana/core/helpers/encryption_helper.dart';
import 'package:sana/presentation/providers/auth_biometric_provider.dart';
import 'package:sana/presentation/widgets/buttons/primary_button.dart';
import 'package:sana/presentation/screens/dashboard/home/home_screen.dart';
import 'package:sana/presentation/providers/auth_provider.dart';
import 'package:sana/presentation/providers/auth_state.dart';
import 'package:sana/presentation/widgets/form/text_field.dart';
import 'package:sana/presentation/widgets/share/snackBar/customSnackBar.dart';

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
  _SupportState supportState = _SupportState.unknown;

  bool isToogleBiometricEnabled = false;
  bool _isAuthenticatingBiometric = false;
  final storage = const FlutterSecureStorage();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool rememberMe = false;
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  bool get _isFormValid =>
      _emailController.text.trim().isNotEmpty &&
      _passwordController.text.isNotEmpty;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkBiometricSetting() async {
    //await storage.deleteAll();
    final isAuthBiometricSetting =
        await storage.read(key: 'isAuthenticatingBiometric') == 'true';
    if (isAuthBiometricSetting) {
      ref
          .read(toogleBiometricProvider.notifier)
          .changeFingerprintColor(colorFingPrint: Colors.green);
      authenticateWithBiometrics();
    }
    setState(() {
      _isAuthenticatingBiometric = isAuthBiometricSetting;
    });
  }

  Future<void> loadCredentials() async {
    final remember = await storage.read(key: 'rememberMe') == 'true';

    if (remember) {
      final user = await EncryptionHelper.readEncrypted('username') ?? '';
      final pass = await EncryptionHelper.readEncrypted('password') ?? '';
      setState(() {
        _emailController.text = user;
        _passwordController.text = pass;
        rememberMe = true;
      });
    }
  }

  Future<void> saveCredentials() async {
    if (rememberMe) {
      await EncryptionHelper.saveEncrypted('username', _emailController.text);
      await EncryptionHelper.saveEncrypted(
        'password',
        _passwordController.text,
      );
      await storage.write(key: 'rememberMe', value: 'true');
    } else {
      await storage.delete(key: 'rememberMe');
    }
  }

  Future<void> saveCredentialsBiometric() async {
    if (supportState == _SupportState.unknown) {
      if (mounted) {
        CustomSnackBar.show(
          context: context,
          message: 'login.biometric_device_not_supported'.tr(),
          backgroundColor: Colors.red.shade700,
        );
      }
      return;
    }

    // Pedir autenticación para activar
    final authenticated = await LocalAuthentication().authenticate(
      localizedReason: 'login.biometric_activate_reason'.tr(),
    );

    if (authenticated) {
      await storage.write(key: 'isAuthenticatingBiometric', value: 'true');
      await EncryptionHelper.saveEncrypted('username', _emailController.text);
      await EncryptionHelper.saveEncrypted(
        'password',
        _passwordController.text,
      );
      ref.read(toogleBiometricProvider.notifier).reset();
    } else {
      await storage.write(key: 'isAuthenticatingBiometric', value: 'false');
    }
  }

  Future<void> authenticateWithBiometrics() async {
    bool authenticated = false;

    try {
      authenticated = await auth.authenticate(
        localizedReason: 'login.biometric_scan_reason'.tr(),
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      if (authenticated) {
        setState(() => _isLoading = true);
        try {
          final user = await EncryptionHelper.readEncrypted('username') ?? '';
          final pass = await EncryptionHelper.readEncrypted('password') ?? '';
          await ref.read(authNotifierProvider.notifier).login(user, pass);
          // Escuchar el estado para manejar éxito/error
          final authState = ref.read(authNotifierProvider);

          if (mounted && authState is AuthStateAuthenticated) {
            context.go(HomeScreen.routePath);
          }
        } finally {
          if (mounted) {
            setState(() => _isLoading = false); // Ocultar loading
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      return;
    }
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
        if (!mounted) return;

        // Guardar credenciales si "Recuérdame" está activo
        await saveCredentials();

        // Si el toggle biométrico está en estado "pendiente" (naranja),
        // pedir huella para activar la biometría
        final biometricState = ref.read(toogleBiometricProvider);
        if (biometricState.isToogle &&
            biometricState.colorFingPrint == Colors.orange) {
          await saveCredentialsBiometric();
          // Cambiar a verde tras activar biometría exitosamente
          final isActive =
              await storage.read(key: 'isAuthenticatingBiometric') == 'true';
          if (isActive) {
            ref
                .read(toogleBiometricProvider.notifier)
                .changeFingerprintColor(colorFingPrint: Colors.green);
          }
        }

        // Navegar al home
        if (mounted) {
          context.go(HomeScreen.routePath);
        }
      } else if (authState is AuthStateError) {
        if (!mounted) return;
        CustomSnackBar.show(
          context: context,
          message: authState.message,
          backgroundColor: Colors.red.shade700,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
    loadCredentials();
    _checkBiometricSetting();

    auth.isDeviceSupported().then(
      (bool isSupported) => setState(
        () => supportState = isSupported
            ? _SupportState.supported
            : _SupportState.unsupported,
      ),
    );
  }

  void _showBiometricModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (_, controller) => const BiometricModalScreen(),
      ),
    ).then((_) {
      // Recargar estado biométrico al cerrar el modal
      _checkBiometricSetting();
    });
  }

  @override
  Widget build(BuildContext context) {
    final biometricColor = ref.watch(toogleBiometricProvider).colorFingPrint;
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
                  CustomTextField(
                    controller: _emailController,
                    label: 'login.email'.tr(),
                    placeholder: 'login.email_placeholder'.tr(),
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  CustomTextField(
                    controller: _passwordController,
                    label: 'login.password'.tr(),
                    placeholder: 'login.password_placeholder'.tr(),
                    icon: Icons.lock_outline,
                    isPassword: true,
                    isVisible: _isPasswordVisible,
                    onVisibilityChanged: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 12),

                  // Remember Me & Forgot Password
                  Row(
                    children: [
                      // Checkbox "Recuérdame"
                      InkWell(
                        onTap: () => setState(() => rememberMe = !rememberMe),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: rememberMe,
                              onChanged: (value) =>
                                  setState(() => rememberMe = value ?? false),
                              activeColor: AppColors.primary,
                              side: BorderSide(
                                color: AppColors.primary,
                                width: 2,
                              ),
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                            Flexible(
                              child: Text(
                                'login.remember_me'.tr(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.0,
                                  color: AppColors.primary,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Texto "Olvidar contraseña"
                      InkWell(
                        onTap: () {
                          context.push(ForgotPasswordScreen.routePath);
                        },
                        child: Text(
                          'login.forgot_password'.tr(),
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                            overflow: TextOverflow.ellipsis,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25.0),

                  // Login Button + Biometric Button
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          text: 'login.button'.tr(),
                          onPressed: (_isLoading || !_isFormValid)
                              ? null
                              : _handleLogin,
                          expand: true,
                          isLoading: _isLoading,
                        ),
                      ),

                      if (supportState == _SupportState.supported) ...[
                        const SizedBox(width: 4),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            foregroundColor: biometricColor,
                            minimumSize: const Size(1, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                              side: BorderSide(color: biometricColor, width: 2),
                            ),
                          ),
                          onPressed: () {
                            if (biometricColor == Colors.green) {
                              // Verde: autenticar con biometría
                              authenticateWithBiometrics();
                            } else {
                              // Gris u Naranja: abrir modal de configuración
                              _showBiometricModal();
                            }
                          },
                          child: Icon(
                            Icons.fingerprint,
                            size: 32.0,
                            color: biometricColor,
                          ),
                        ),
                      ],
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

class BiometricModalScreen extends ConsumerWidget {
  const BiometricModalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isToogle = ref.watch(toogleBiometricProvider).isToogle;
    return Scaffold(
      appBar: AppBar(
        title: Text('login.biometric_modal_title'.tr()),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Section(
              title: 'login.biometric_about_title'.tr(),
              content: 'login.biometric_about_content'.tr(),
            ),
            const SizedBox(height: 24),
            _buildBiometricRow(
              icon: Icons.fingerprint,
              color: Colors.grey,
              text: 'login.biometric_status_disabled'.tr(),
            ),
            const SizedBox(height: 16),
            _buildBiometricRow(
              icon: Icons.fingerprint,
              color: Colors.orange,
              text: 'login.biometric_status_pending'.tr(),
            ),
            const SizedBox(height: 16),
            _buildBiometricRow(
              icon: Icons.fingerprint,
              color: Colors.green,
              text: 'login.biometric_status_active'.tr(),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Switch(
                  value: isToogle,
                  onChanged: (value) {
                    // Actualizar el estado en el provider
                    ref
                        .read(toogleBiometricProvider.notifier)
                        .biometricEnabled(isToogle: value);
                    if (value) {
                      ref
                          .read(toogleBiometricProvider.notifier)
                          .changeFingerprintColor(
                            colorFingPrint: Colors.orange,
                          );
                    } else {
                      ref
                          .read(toogleBiometricProvider.notifier)
                          .changeFingerprintColor(colorFingPrint: Colors.grey);
                    }
                  },
                  activeThumbColor: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'login.biometric_use_toggle'.tr(),
                  style: TextStyle(fontSize: 13.0, color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: 'login.biometric_accept'.tr(),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBiometricRow({
    required IconData icon,
    required Color color,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 64, color: color),
        const SizedBox(width: 12),
        Expanded(child: Text(text)),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String content;

  const _Section({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(content, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

enum _SupportState { unknown, supported, unsupported }
