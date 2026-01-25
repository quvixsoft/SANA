import 'package:go_router/go_router.dart';
import 'package:sana/presentation/screens/auth/login_screen.dart';
import 'package:sana/presentation/screens/onboarding/onboarding_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      name: OnboardingScreen.name,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      name: LoginScreen.name,
      builder: (context, state) => const LoginScreen(),
    ),
  ],
);
