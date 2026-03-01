import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/config/theme/app_theme.dart';
import 'package:sana/presentation/providers/auth_provider.dart';
import 'package:sana/presentation/providers/auth_state.dart';
import 'package:sana/presentation/screens/auth/login_screen.dart';
import 'package:sana/presentation/screens/dashboard/home/home_screen.dart';

class MainNavigationDrawer extends ConsumerWidget {
  const MainNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final userName = authState is AuthStateAuthenticated
        ? authState.user.name
        : 'Usuario';
    final userEmail = authState is AuthStateAuthenticated
        ? authState.user.email
        : '';

    return Drawer(
      backgroundColor: AppColors.background,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(color: AppColors.primary),
                  currentAccountPicture: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40.0,
                      color: AppColors.primary,
                    ),
                  ),
                  accountName: Text(
                    userName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  accountEmail: Text(userEmail),
                  otherAccountsPictures: const [
                    Icon(Icons.notifications_active, color: Colors.white),
                  ],
                ),
                ListTile(
                  leading: const Icon(Icons.home, color: AppColors.primary),
                  title: const Text('Inicio'),
                  onTap: () {
                    context.pop();
                    context.go(HomeScreen.routePath);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.description, color: AppColors.grey),
                  title: const Text('Términos y condiciones'),
                  onTap: () {
                    context.pop();
                    // context.go('/terms');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip, color: AppColors.grey),
                  title: const Text('Privacidad'),
                  onTap: () {
                    context.pop();
                    // context.go('/privacy');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.help, color: AppColors.grey),
                  title: const Text('Soporte'),
                  onTap: () {
                    context.pop();
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: const Text(
              'Cerrar Sesión',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () async {
              context.pop(); // Cerrar drawer
              await ref.read(authNotifierProvider.notifier).logout();
              if (context.mounted) {
                context.go(LoginScreen.routePath);
              }
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
