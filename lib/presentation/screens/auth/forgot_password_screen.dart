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

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  static const String routePath = '/auth/forgot-password';
  static const String routeName = 'forgot-password';

  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSendInstructions() async {
    if (_emailController.text.trim().isEmpty) {
      CustomToast.show(
        context: context,
        message: 'forgot-password.valid_email'.tr(),
        type: ToastType.warning,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref
          .read(authNotifierProvider.notifier)
          .forgotPassword(_emailController.text.trim());

      final authState = ref.read(authNotifierProvider);

      if (authState is AuthStateUnauthenticated) {
        if (mounted) {
          CustomToast.show(
            context: context,
            message: 'forgot-password.forgot-button-message'.tr(),
            type: ToastType.success,
          );
          context.pop();
        }
      } else if (authState is AuthStateError) {
        if (mounted) {
          CustomToast.show(
            context: context,
            message: authState.message,
            type: ToastType.error,
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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

              CustomTextField(
                controller: _emailController,
                label: 'forgot-password.email'.tr(),
                placeholder: 'forgot-password.email_placeholder'.tr(),
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 32),

              PrimaryButton(
                text: 'forgot-password.forgot-button'.tr(),
                onPressed: _isLoading ? null : _handleSendInstructions,
                icon: Icons.arrow_forward,
                expand: true,
                isLoading: _isLoading,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
