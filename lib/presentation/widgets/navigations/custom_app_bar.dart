import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sana/core/config/theme/app_theme.dart';
import 'package:sana/presentation/widgets/share/selector/language_selector.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      title: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Image.asset('assets/img/sana_logo_background.png', height: 80),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: const LanguageSelector(),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
