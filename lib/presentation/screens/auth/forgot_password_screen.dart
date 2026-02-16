import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/config/theme/app_theme.dart';
import 'package:sana/presentation/widgets/buttons/primary_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routePath = '/auth/forgot-password';
  static const String routeName = 'forgot-password';

  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSendInstructions() {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('forgot-password.valid_email'.tr())),
      );
      return;
    }

    // Mock logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('forgot-password.forgot-button-message'.tr())),
    );
    context.pop();
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
                'forgot-password.title'.tr(),
                style: AppTextStyles.h1.copyWith(color: AppColors.darkNavy),
              ),
              const SizedBox(height: 12),
              Text(
                'forgot-password.description'.tr(),
                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.grey),
              ),
              const SizedBox(height: 48),

              _buildTextField(
                controller: _emailController,
                label: 'forgot-password.email'.tr(),
                placeholder: 'forgot-password.email_placeholder'.tr(),
                icon: Icons.email_outlined,
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'forgot-password.title'.tr(),
                  onPressed: _handleSendInstructions,
                  icon: Icons.arrow_forward,
                  expand: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 20,
                  ),
                ),
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
