import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/config/theme/app_theme.dart';
import 'package:sana/presentation/screens/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sana/presentation/widgets/share/selector/language_selector.dart';

class OnboardingScreen extends StatefulWidget {
  static const name = 'onboarding_screen';
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Steps cargados dinámicamente según el idioma
  List<Map<String, dynamic>> get _steps => [
    {
      "title": "onboarding.step1.title".tr(),
      "description": "onboarding.step1.description".tr(),
      "icon": Icons.security_outlined,
      "color": AppColors.primary,
    },
    {
      "title": "onboarding.step2.title".tr(),
      "description": "onboarding.step2.description".tr(),
      "icon": Icons.psychology_outlined,
      "color": AppColors.primary,
    },
    {
      "title": "onboarding.step3.title".tr(),
      "description": "onboarding.step3.description".tr(),
      "icon": Icons.assignment_outlined,
      "color": AppColors.successGreen,
    },
  ];

  void _handleNext() async {
    if (_currentStep < _steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      // Mark onboarding as completed
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('has_completed_onboarding', true);
      if (mounted) {
        context.go(LoginScreen.routePath);
      }
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentStep = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Force rebuild when locale changes
    final currentLocale = context.locale;

    return Scaffold(
      key: ValueKey(currentLocale),
      backgroundColor: AppColors.darkNavy,
      body: Column(
        children: [
          // Header Section (Dark Blue)
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.darkNavy,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // Top Logo Bar
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 16,
                        bottom: 20,
                        left: 24,
                        right: 24,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.small,
                                  ),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.medical_services,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Sana',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                          // Language Selector
                          const LanguageSelector(),
                        ],
                      ),
                    ),

                    // Centered Illustration Icon
                    Expanded(
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            key: ValueKey<int>(_currentStep),
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.05),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                _steps[_currentStep]['icon'],
                                size: 60,
                                color: _steps[_currentStep]["color"],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),

          // Content Section (White)
          Expanded(
            flex: 5,
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      itemCount: _steps.length,
                      itemBuilder: (context, index) {
                        final step = _steps[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 40),
                                Text(
                                  step['title'],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.darkNavy,
                                    letterSpacing: -0.5,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  step['description'],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.grey,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Footer Controls
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 0, 32, 50),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Indicators
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_steps.length, (index) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: index == _currentStep ? 32 : 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: index == _currentStep
                                    ? AppColors.primary
                                    : AppColors.grey200,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 40),
                        // Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () =>
                                  context.go(LoginScreen.routePath),
                              child: Text(
                                'onboarding.skip'.tr(),
                                style: const TextStyle(
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _handleNext,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.large,
                                  ),
                                ),
                                elevation: 4,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    'onboarding.next'.tr(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward, size: 20),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
