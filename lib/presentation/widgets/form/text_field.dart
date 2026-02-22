import 'package:flutter/material.dart';
import 'package:sana/core/config/theme/app_theme.dart';

/// Widget reutilizable de campo de texto con estilo premium para formularios.
///
/// Soporta campos de texto normales y de contraseña con toggle de visibilidad,
/// validación integrada mediante [validator], y un diseño consistente con
/// el sistema de diseño de la aplicación.
class CustomTextField extends StatelessWidget {
  /// Texto que aparece como etiqueta flotante del campo.
  final String label;

  /// Texto de placeholder que se muestra cuando el campo está vacío.
  final String placeholder;

  /// Icono que se muestra al inicio del campo.
  final IconData icon;

  /// Controlador del campo de texto.
  final TextEditingController? controller;

  /// Indica si el campo es de tipo contraseña.
  final bool isPassword;

  /// Controla si el texto es visible (solo aplica cuando [isPassword] es true).
  final bool isVisible;

  /// Callback para alternar la visibilidad del texto en campos de contraseña.
  final VoidCallback? onVisibilityChanged;

  /// Función de validación para [TextFormField].
  final String? Function(String?)? validator;

  /// Tipo de teclado a mostrar.
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    required this.label,
    this.placeholder = '',
    required this.icon,
    this.controller,
    this.isPassword = false,
    this.isVisible = false,
    this.onVisibilityChanged,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: validator != null
          ? (_) => validator!(controller?.text ?? '')
          : null,
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.large),
                border: Border.all(
                  color: state.hasError ? AppColors.error : AppColors.grey200,
                ),
                boxShadow: AppShadows.subtle,
              ),
              child: TextField(
                controller: controller,
                obscureText: isPassword && !isVisible,
                keyboardType: keyboardType,
                onChanged: (_) {
                  state.didChange(controller?.text);
                  // Re-validate to clear error when input becomes valid
                  if (state.hasError) {
                    state.validate();
                  }
                },
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: AppColors.grey,
                    letterSpacing: 1,
                  ),
                  hintText: placeholder,
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey300,
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
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 6),
                child: Text(
                  state.errorText!,
                  style: const TextStyle(color: AppColors.error, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}
