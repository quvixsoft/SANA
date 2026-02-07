import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF1E82D9);
  static const Color darkNavy = Color(0xFF122640);
  static const Color successGreen = Color(0xFF1BA63D);

  // Secondary Colors
  static const Color lightBlue = Color(0xFF90CAF9);
  static const Color background = Color(0xFFF8FAFC);
  static const Color cardWhite = Color(0xFFFFFFFF);

  // Status Colors
  static const Color error = Color(0xFFD91E1E);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF9C27B0);

  // Greys
  static const Color grey50 = Color(0xFFF1F5F9);
  static const Color grey100 = Color(0xFFE2E8F0);
  static const Color grey200 = Color(0xFFCBD5E1);
  static const Color grey300 = Color(0xFF94A3B8);
  static const Color grey400 = Color(0xFF64748B);
  static const Color grey = Color(0xFF6B7280);
}

class AppTextStyles {
  // Font Family
  static const String fontFamily = 'Inter';

  // Display (Onboarding, Login)
  static const TextStyle displayLarge = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w900,
    letterSpacing: -1,
    color: AppColors.darkNavy,
    fontFamily: fontFamily,
  );

  // Headings
  static const TextStyle h1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w900,
    color: AppColors.darkNavy,
    fontFamily: fontFamily,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.darkNavy,
    fontFamily: fontFamily,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.darkNavy,
    fontFamily: fontFamily,
  );

  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.darkNavy,
    fontFamily: fontFamily,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.darkNavy,
    fontFamily: fontFamily,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.darkNavy,
    fontFamily: fontFamily,
  );

  // Labels & Metadata
  static const TextStyle label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.grey400,
    fontFamily: fontFamily,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w900,
    letterSpacing: 1,
    color: AppColors.grey,
    fontFamily: fontFamily,
  );

  static const TextStyle tiny = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w900,
    color: AppColors.grey,
    fontFamily: fontFamily,
  );

  // Buttons
  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 1,
    fontFamily: fontFamily,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 1,
    fontFamily: fontFamily,
  );

  // Numbers
  static const TextStyle numberDisplay = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w900,
    color: AppColors.darkNavy,
    fontFamily: fontFamily,
  );

  static const TextStyle numberMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w900,
    color: AppColors.darkNavy,
    fontFamily: fontFamily,
  );

  static const TextStyle numberSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w900,
    color: AppColors.darkNavy,
    fontFamily: fontFamily,
  );
}

class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double s = 12;
  static const double m = 16;
  static const double l = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 40;
  static const double huge = 48;
}

class AppRadius {
  static const double small = 8;
  static const double medium = 12;
  static const double large = 16;
  static const double xLarge = 20;
  static const double xxLarge = 24;
  static const double rounded = 40;
}

class AppShadows {
  static List<BoxShadow> subtle = [
    BoxShadow(
      color: Colors.black.withOpacity(0.02),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> medium = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> high = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];
}

class AppTheme {
  ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.large),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primary),
      ),
    );
  }
}
