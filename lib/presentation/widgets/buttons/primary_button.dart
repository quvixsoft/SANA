import 'package:flutter/material.dart';
import 'package:sana/core/config/theme/app_theme.dart';

/// A reusable primary elevated button styled with the app's design system.
///
/// Use this widget across all screens to keep button styling consistent.
///
/// Example:
/// ```dart
/// PrimaryButton(
///   text: 'Login',
///   onPressed: _handleLogin,
///   icon: Icons.arrow_forward,
///   expand: true,
/// )
/// ```
class PrimaryButton extends StatelessWidget {
  /// The button label text.
  final String text;

  /// Callback when the button is pressed. If `null`, the button is disabled.
  final VoidCallback? onPressed;

  /// Optional trailing icon displayed after the text.
  final IconData? icon;

  /// Whether the button expands to fill the available width.
  /// Defaults to `false`.
  final bool expand;

  /// Background color. Defaults to [AppColors.primary].
  final Color? backgroundColor;

  /// Text and icon color. Defaults to [Colors.white].
  final Color? foregroundColor;

  /// Custom padding inside the button.
  /// If `null`, defaults to `EdgeInsets.symmetric(horizontal: 32, vertical: 16)`.
  final EdgeInsetsGeometry? padding;

  /// Border radius. Defaults to [AppRadius.large].
  final double? borderRadius;

  /// Button elevation. Defaults to `4`.
  final double? elevation;

  /// Whether to show a loading indicator instead of the content.
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.expand = false,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.borderRadius,
    this.elevation,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primary,
        foregroundColor: foregroundColor ?? Colors.white,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.large),
        ),
        elevation: elevation ?? 4,
        disabledBackgroundColor: (backgroundColor ?? AppColors.primary)
            .withValues(alpha: 0.6),
      ),
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  foregroundColor ?? Colors.white,
                ),
              ),
            )
          : Row(
              mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
                if (icon != null) ...[
                  const SizedBox(width: 8),
                  Icon(icon, size: 20),
                ],
              ],
            ),
    );

    if (expand) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}
