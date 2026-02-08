import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/config/theme/app_theme.dart';
import 'package:sana/presentation/screens/dashboard/home/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String routePath = '/auth/register';
  static const String routeName = 'register';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    // Mock logic
    context.go(HomeScreen.routePath);
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Crear Cuenta',
                style: AppTextStyles.h1.copyWith(color: AppColors.darkNavy),
              ),
              const SizedBox(height: 12),
              Text(
                'Crea una cuenta para comenzar a gestionar tu salud.',
                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.grey),
              ),
              const SizedBox(height: 32),

              _buildTextField(
                controller: _nameController,
                label: 'Nombre Completo',
                placeholder: 'Juan Pérez',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _emailController,
                label: 'Correo Electrónico',
                placeholder: 'ejemplo@correo.com',
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _passwordController,
                label: 'Contraseña',
                placeholder: '********',
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _confirmPasswordController,
                label: 'Confirmar Contraseña',
                placeholder: '********',
                icon: Icons.lock_outline,
                isPassword: true,
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.large),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'REGISTRARSE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '¿Ya tienes una cuenta?',
                    style: TextStyle(color: AppColors.grey),
                  ),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text(
                      'Iniciar Sesión',
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
