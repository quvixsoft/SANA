import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/presentation/widgets/navigations/custom_app_bar.dart';
import 'package:sana/presentation/widgets/navigations/custom_bottom_navigation_bar.dart';
import 'package:sana/presentation/widgets/navigations/main_navigation_drawer.dart';

/// Padre por un Scaffold
class AppLayout extends ConsumerWidget {
  final StatefulNavigationShell child;

  const AppLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: const MainNavigationDrawer(),
      body: child,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: child.currentIndex,
        onDestinationSelected: (index) {
          child.goBranch(index, initialLocation: true);
        },
      ),
    );
  }
}
