import 'package:go_router/go_router.dart';
import 'package:sana/presentation/layouts/app_layout.dart';
import 'package:sana/presentation/layouts/auth_layout.dart';
import 'package:sana/presentation/screens/auth/login_screen.dart';
import 'package:sana/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:sana/presentation/screens/onboarding/onboarding_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      name: OnboardingScreen.name,
      builder: (context, state) => OnboardingScreen(),
    ),

    // GoRoute(
    //   path: '/dashboard',
    //   name: Dashboard.name,
    //   builder: (context, state) => const Dashboard(),
    // ),

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
              path: Dashboard.routePath,
              name: Dashboard.routeName,
              builder: (context, state) => const Dashboard(),
            ),
          ],
        ),
        // 1: History
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/history',
              name: 'history',
              builder: (context, state) => const Dashboard(),
            ),
          ],
        ),
        // 2: Chat (Middle)
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/chat',
              name: 'chat',
              builder: (context, state) => const Dashboard(),
            ),
          ],
        ),
        // 3: Lab (Science)
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/labs',
              name: 'labs',
              builder: (context, state) => const Dashboard(),
            ),
          ],
        ),
        // 4: Profile
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) => const Dashboard(),
            ),
          ],
        ),
      ],
    ),
  ],
);
