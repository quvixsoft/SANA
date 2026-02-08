import 'package:go_router/go_router.dart';
import 'package:sana/presentation/layouts/app_layout.dart';
import 'package:sana/presentation/layouts/auth_layout.dart';
import 'package:sana/presentation/screens/auth/login_screen.dart';
import 'package:sana/presentation/screens/dashboard/home/home_screen.dart';
import 'package:sana/presentation/screens/dashboard/history/history_screen.dart';
import 'package:sana/presentation/screens/dashboard/labs/labs_screen.dart';
import 'package:sana/presentation/screens/dashboard/profile/profile_screen.dart';
import 'package:sana/presentation/screens/onboarding/onboarding_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      name: OnboardingScreen.name,
      builder: (context, state) => OnboardingScreen(),
    ),

    /// StatefulShellRoute para autenticación (Login, Registro)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AuthLayout(
          child: navigationShell,
        ); // Usamos AuthLayout para el flujo de autenticación
      },
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: LoginScreen.routePath,
              name: LoginScreen.routeName,
              builder: (context, state) => const LoginScreen(),
            ),
          ],
        ),
      ],
    ),

    //Este es el layout principal de la aplicación
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppLayout(child: navigationShell);
      },
      branches: <StatefulShellBranch>[
        // 0: Dashboard (Home)
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: HomeScreen.routePath,
              name: HomeScreen.routeName,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        // 1: History
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: HistoryScreen.routePath,
              name: HistoryScreen.routeName,
              builder: (context, state) => const HistoryScreen(),
            ),
          ],
        ),
        // 2: Chat (Middle)
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/chat',
              name: 'chat',
              builder: (context, state) =>
                  const HomeScreen(), // Placeholder for chat if needed, OR keep as is
            ),
          ],
        ),
        // 3: Lab (Science)
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: LabsScreen.routePath,
              name: LabsScreen.routeName,
              builder: (context, state) => const LabsScreen(),
            ),
          ],
        ),
        // 4: Profile
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: ProfileScreen.routePath,
              name: ProfileScreen.routeName,
              builder: (context, state) => ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
