import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/config/theme/app_theme.dart';
import 'package:sana/presentation/providers/auth_provider.dart';
import 'package:sana/presentation/providers/auth_state.dart';
import 'package:sana/presentation/widgets/buttons/primary_button.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  static const String routePath = '/auth/register';
  static const String routeName = 'register';

  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('register.error_empty_fields'.tr())),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('register.error_password_match'.tr())),
      );
      return;
    }

    // Llamada al provider para registrar
    await ref
        .read(authNotifierProvider.notifier)
        .register(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          name: _nameController.text.trim(),
          birthDate: DateTime.now()
              .toIso8601String(), // Por defecto hoy, ajustar si hay campo fecha
          disclaimerAccepted: true, // Asumimos true por ahora
          roleId: 2, // 2 = Patient/User por defecto (ajustar según backend)
        );

    // Verificar el estado después de intentar registrar
    final authState = ref.read(authNotifierProvider);

    if (authState is AuthStateError) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authState.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else if (authState is AuthStateUnauthenticated) {
      // Éxito: estado vuelve a unauthenticated (sin error)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registro exitoso. Por favor inicia sesión.'),
            backgroundColor: Colors.green,
          ),
        );
        // Ir al login
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AuthStateLoading;

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
                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.grey),
              ),
              const SizedBox(height: 32),

              _buildTextField(
                controller: _nameController,
                label: 'register.full_name'.tr(),
                placeholder: 'register.name_placeholder'.tr(),
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _emailController,
                label: 'register.email'.tr(),
                placeholder: 'register.email_placeholder'.tr(),
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 16),
              _buildTextField(
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
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _confirmPasswordController,
                label: 'register.confirm_password'.tr(),
                placeholder: 'register.password_placeholder'.tr(),
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
                onPressed: _handleRegister,
                expand: true,
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String placeholder,
    required IconData icon,
    bool isPassword = false,
    bool isVisible = false,
    VoidCallback? onVisibilityChanged,
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
        obscureText: isPassword && !isVisible,
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
              ? IconButton(
                  icon: Icon(
                    isVisible ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.grey,
                  ),
                  onPressed: onVisibilityChanged,
                )
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
