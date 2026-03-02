import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/config/theme/app_theme.dart';
import 'package:sana/presentation/providers/auth_provider.dart';
import 'package:sana/presentation/providers/auth_state.dart';
import 'package:sana/presentation/widgets/buttons/primary_button.dart';
import 'package:sana/presentation/widgets/form/text_field.dart';
import 'package:sana/presentation/widgets/share/toast/custom_toast.dart';
import 'package:sana/presentation/screens/dashboard/home/home_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  static const String routePath = '/auth/register';
  static const String routeName = 'register';

  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      CustomToast.show(
        context: context,
        message: 'register.error_password_match'.tr(),
        type: ToastType.warning,
      );
      return;
    }

    setState(() => _isLoading = true);

    // Llamada al provider para registrar
    await ref
        .read(authNotifierProvider.notifier)
        .register(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          name: _nameController.text.trim(),
          disclaimerAccepted: true, // Asumimos true por ahora
          roleId: 2, // 2 = Patient/User por defecto (ajustar según backend)
        );

    // Verificar el estado después de intentar registrar
    final authState = ref.read(authNotifierProvider);

    if (authState is AuthStateError) {
      debugPrint('Error al registrar: ${authState.message}');
      if (mounted) {
        CustomToast.show(
          context: context,
          message: authState.message,
          type: ToastType.error,
        );
      }
    } else if (authState is AuthStateAuthenticated) {
      // Éxito: el usuario fue registrado e inició sesión automáticamente
      if (mounted) {
        CustomToast.show(
          context: context,
          message: 'register.register_success'.tr(),
          type: ToastType.success,
        );
        // Esperar 3 segundos para que el usuario vea el mensaje
        await Future.delayed(const Duration(seconds: 3));
        if (mounted) {
          // Navegar al dashboard
          context.go(HomeScreen.routePath);
        }
      }
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  /// Validación de nombre
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'register.name_required'.tr();
    }
    return null;
  }

  /// Validación de email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'register.email_required'.tr();
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'register.email_invalid'.tr();
    }
    return null;
  }

  /// Validación de password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'register.password_required'.tr();
    }
    if (value.length < 8) {
      return 'register.password_min_length'.tr();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkNavy),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'register.title'.tr(),
                  style: AppTextStyles.h1.copyWith(color: AppColors.darkNavy),
                ),
                const SizedBox(height: 12),
                Text(
                  'register.subtitle'.tr(),
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 32),

                CustomTextField(
                  controller: _nameController,
                  label: 'register.name'.tr(),
                  placeholder: 'register.name_placeholder'.tr(),
                  icon: Icons.person_outline,
                  validator: _validateName,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _emailController,
                  label: 'register.email'.tr(),
                  placeholder: 'register.email_placeholder'.tr(),
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _passwordController,
                  label: 'register.password'.tr(),
                  placeholder: 'register.password_placeholder'.tr(),
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
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _confirmPasswordController,
                  label: 'register.confirm_password'.tr(),
                  placeholder: 'register.confirm_password_placeholder'.tr(),
                  icon: Icons.lock_outline,
                  isPassword: true,
                  isVisible: _isConfirmPasswordVisible,
                  onVisibilityChanged: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),

                const SizedBox(height: 32),

                PrimaryButton(
                  text: 'register.register_button'.tr(),
                  onPressed: _isLoading ? null : _handleRegister,
                  expand: true,
                  isLoading: _isLoading,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'register.already_have_account'.tr(),
                      style: const TextStyle(color: AppColors.grey),
                    ),
                    TextButton(
                      onPressed: () => context.pop(),
                      child: Text(
                        'register.login_link'.tr(),
                        style: const TextStyle(
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
}
