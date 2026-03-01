import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/data/data_manager.dart';
import 'package:sana/presentation/providers/auth_provider.dart';
import 'package:sana/presentation/providers/auth_state.dart';
import 'package:sana/presentation/screens/auth/login_screen.dart';

class ProfileScreen extends ConsumerWidget {
  static const String routePath = '/profile';
  static const String routeName = 'profile';

  final DataManager _dataManager = DataManager();

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final userName = authState is AuthStateAuthenticated
        ? authState.user.name
        : _dataManager.userProfile?.name ?? 'Usuario';
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 120),
      child: Column(
        children: [
          // Header / Avatar
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: 112,
                    height: 112,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person,
                        size: 70,
                        color: Color(0xFF90CAF9),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E82D9),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF122640),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'PREMIUM',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E82D9),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'ID: 8492-AB',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Sections
          _buildSectionHeader(Icons.badge, 'Datos Personales'),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey[50]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                _buildInfoItem(
                  'NOMBRE COMPLETO',
                  _dataManager.userProfile?.name ?? '-',
                ),
                const Divider(height: 1, indent: 20, endIndent: 20),
                _buildInfoItem(
                  'EDAD',
                  '${_dataManager.userProfile?.age ?? '-'} años',
                ),
                const Divider(height: 1, indent: 20, endIndent: 20),
                _buildInfoItem(
                  'TIPO DE SANGRE',
                  _dataManager.userProfile?.bloodType ?? '-',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          _buildSectionHeader(Icons.favorite, 'Salud'),
          Column(
            children: [
              _HealthCard(
                icon: Icons.warning,
                title: 'Alergias Conocidas',
                chips: _dataManager.userProfile?.allergies,
                color: Colors.red,
              ),
              const SizedBox(height: 12),
              _HealthCard(
                icon: Icons.monitor_heart,
                title: 'Condiciones',
                chips: _dataManager.userProfile?.conditions,
                color: Colors.blue,
              ),
              SizedBox(height: 12),
              _HealthCard(
                icon: Icons.science,
                title: 'Historial de Laboratorio',
                subtitle: 'Último: Hemograma (12 Nov)',
                color: Colors.purple,
              ),
            ],
          ),

          const SizedBox(height: 24),

          _buildSectionHeader(Icons.tune, 'Configuración'),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey[50]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                _buildConfigItem(
                  Icons.notifications,
                  'Notificaciones',
                  toggle: true,
                ),
                const Divider(height: 1, indent: 20, endIndent: 20),
                _buildConfigItem(
                  Icons.watch,
                  'Dispositivos',
                  subtitle: 'Apple Health conectado',
                ),
                const Divider(height: 1, indent: 20, endIndent: 20),
                _buildConfigItem(
                  Icons.dark_mode,
                  'Apariencia',
                  subtitle: 'Automático',
                ),
                const Divider(height: 1, indent: 20, endIndent: 20),
                _buildConfigItem(
                  Icons.logout,
                  'Cerrar Sesión',
                  isDanger: true,
                  onTap: () async {
                    await ref.read(authNotifierProvider.notifier).logout();
                    if (context.mounted) {
                      context.go(LoginScreen.routePath);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 4),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1E82D9), size: 18),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: Colors.grey,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF122640),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigItem(
    IconData icon,
    String title, {
    String? subtitle,
    bool toggle = false,
    bool isDanger = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: isDanger ? Colors.red : Colors.grey[400]),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDanger ? Colors.red : const Color(0xFF122640),
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
            if (toggle)
              Container(
                width: 40,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E82D9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              )
            else if (!isDanger)
              const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class _HealthCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final List<String>? chips;
  final MaterialColor color;

  const _HealthCard({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.chips,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[50]!),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color[500], size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF122640),
                  ),
                ),
                const SizedBox(height: 4),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[400],
                    ),
                  ),
                if (chips != null)
                  Row(
                    children: chips!
                        .map(
                          (c) => Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red[50],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                c,
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[500],
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
