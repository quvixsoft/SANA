import 'package:sana/core/services/secure_storage_service.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/presentation/layouts/app_layout.dart';
import 'package:sana/presentation/layouts/auth_layout.dart';
import 'package:sana/presentation/screens/auth/forgot_password_screen.dart';
import 'package:sana/presentation/screens/auth/login_screen.dart';
import 'package:sana/presentation/screens/auth/register_screen.dart';
import 'package:sana/presentation/screens/dashboard/chat/chat.dart';
import 'package:sana/presentation/screens/dashboard/home/home_screen.dart';
import 'package:sana/presentation/screens/dashboard/history/history_screen.dart';
import 'package:sana/presentation/screens/dashboard/labs/labs_screen.dart';
import 'package:sana/presentation/screens/dashboard/profile/profile_screen.dart';
import 'package:sana/presentation/screens/onboarding/onboarding_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/onboarding',
  redirect: (context, state) async {
    final path = state.matchedLocation;
    final storage = SecureStorageService();

    // Rutas que no requieren autenticación
    final isAuthRoute = path.startsWith('/auth') || path == '/onboarding';

    // 1. Verificar si ya vio el onboarding
    if (path == '/onboarding') {
      final onboardingCompleted = await storage.isOnboardingCompleted();
      if (!onboardingCompleted) {
        return null; // Mostrar onboarding
      }
    }

    // 2. Verificar si hay sesión activa
    final accessToken = await storage.getAccessToken();
    final hasSession = accessToken != null && accessToken.isNotEmpty;

    if (hasSession && isAuthRoute) {
      // Tiene sesión y está en una ruta de auth → ir al home
      return HomeScreen.routePath;
    }

    if (!hasSession && !isAuthRoute) {
      // No tiene sesión y está en una ruta protegida → ir al login
      return LoginScreen.routePath;
    }

    // 3. Si viene del onboarding completado y no tiene sesión → ir al login
    if (path == '/onboarding') {
      return LoginScreen.routePath;
    }

    return null; // No redirigir
  },
  routes: [
    GoRoute(
      path: '/onboarding',
      name: OnboardingScreen.name,
      builder: (context, state) => const OnboardingScreen(),
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
            GoRoute(
              path: ForgotPasswordScreen.routePath,
              name: ForgotPasswordScreen.routeName,
              builder: (context, state) => const ForgotPasswordScreen(),
            ),
            GoRoute(
              path: RegisterScreen.routePath,
              name: RegisterScreen.routeName,
              builder: (context, state) => const RegisterScreen(),
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
              path: Chat.routePath,
              name: Chat.routeName,
              builder: (context, state) => const Chat(),
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
