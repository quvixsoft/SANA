import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sana/core/config/theme/app_theme.dart';

class LanguageSelector extends StatelessWidget {
  final Color dropdownColor;
  final Color textColor;
  final Color borderColor;

  const LanguageSelector({
    super.key,
    this.dropdownColor = AppColors.darkNavy,
    this.textColor = Colors.white,
    this.borderColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    // Normalizar el locale para asegurar coincidencia con los items
    final currentLocale = context.locale.languageCode == 'en'
        ? const Locale('en')
        : const Locale('es');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: borderColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor.withValues(alpha: 0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Locale>(
          key: ValueKey(currentLocale),
          value: currentLocale,
          isDense: true,
          icon: Icon(Icons.arrow_drop_down, color: textColor, size: 18),
          dropdownColor: dropdownColor,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          onChanged: (Locale? newLocale) {
            if (newLocale != null) {
              context.setLocale(newLocale);
            }
          },
          items: const [
            DropdownMenuItem(
              value: Locale('es'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [Text("🇪🇸 ES")],
              ),
            ),
            DropdownMenuItem(
              value: Locale('en'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [Text("🇺🇸 EN")],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
