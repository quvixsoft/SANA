import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sana/core/config/theme/app_theme.dart';
import 'package:sana/presentation/widgets/buttons/primary_button.dart';
import 'package:sana/presentation/screens/dashboard/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/presentation/screens/auth/forgot_password_screen.dart';
import 'package:sana/presentation/screens/auth/register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routePath = '/auth/login';
  static const String routeName = 'login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
    // Wait for biometric check to complete
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
      // Handle error or cancel
      debugPrint("Auth error: $e");
    }
  }

  void _onLoginSuccess() {
    if (mounted) {
      context.go(HomeScreen.routePath);
    }
  }

  Future<void> _handleLogin() async {
    // Simulate validation
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor llena todos los campos')),
      );
      return;
    }

    // Simulate Login Success
    final prefs = await SharedPreferences.getInstance();
    final bool useBiometrics = prefs.getBool('use_biometrics') ?? false;

    if (!useBiometrics && _canCheckBiometrics) {
      // Ask to enable biometrics
      if (!mounted) return;
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
    } else {
      _onLoginSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.primary, AppColors.darkNavy],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  transform: Matrix4.rotationZ(0.05), // ~3 degrees
                  child: const Center(
                    child: Icon(
                      Icons.psychology,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
                Text(
                  'app.name'.tr(),
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: AppColors.darkNavy,
                    letterSpacing: -1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'app.subtitle'.tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // Form
                Column(
                  children: [
                    _buildTextField(
                      controller: _emailController,
                      label: 'login.email'.tr(),
                      placeholder: 'login.email_placeholder'.tr(),
                      icon: Icons.email,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _passwordController,
                      label: 'login.password'.tr(),
                      placeholder: 'login.password_placeholder'.tr(),
                      icon: Icons.lock,
                      isPassword: true,
                    ),

                    const SizedBox(height: 16),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () =>
                            context.push(ForgotPasswordScreen.routePath),
                        child: Text(
                          'login.forgot_password'.tr(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    PrimaryButton(
                      text: 'login.login_button'.tr(),
                      onPressed: _handleLogin,
                      icon: Icons.arrow_forward,
                      expand: true,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 20,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'login.or_continue_with'.tr(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: AppColors.grey.withOpacity(0.7),
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 32),

                // Google Button
                OutlinedButton(
                  onPressed: _handleLogin,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: AppColors.grey200),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.large),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Text(
                          "G",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'login.google_login'.tr(),
                        style: const TextStyle(
                          color: AppColors.darkNavy,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                if (_canCheckBiometrics) ...[
                  const SizedBox(height: 16),
                  IconButton(
                    icon: const Icon(
                      Icons.fingerprint,
                      size: 40,
                      color: AppColors.primary,
                    ),
                    onPressed: _authenticate,
                    tooltip: 'login.biometric_tooltip'.tr(),
                  ),
                ],

                const SizedBox(height: 32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'login.no_account'.tr(),
                      style: TextStyle(color: AppColors.grey),
                    ),
                    TextButton(
                      onPressed: () => context.push(RegisterScreen.routePath),
                      child: Text(
                        'login.create_account'.tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String placeholder,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.grey200),
        boxShadow: AppShadows.subtle,
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: AppColors.grey,
            letterSpacing: 1,
          ),
          hintText: placeholder,
          hintStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.darkNavy,
          ),
          prefixIcon: Icon(icon, color: AppColors.grey300),
          suffixIcon: isPassword
              ? const Icon(Icons.visibility, color: AppColors.grey)
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }
}
