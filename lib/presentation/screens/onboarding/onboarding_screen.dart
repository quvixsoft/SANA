import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SlideInfo {
  final String title;
  final String caption; // "Tu Asistente de Salud" etc
  final String description;
  final IconData icon;

  SlideInfo(
    this.title,
    this.caption,
    this.description,
    this.icon,
  );
}

final slides = <SlideInfo>[
  SlideInfo(
    'Bienvenido/a a\nMedi-IA',
    'Tu Asistente de Salud',
    'Diagnósticos rápidos,\nprecisos y personalizados.',
    Icons.security_outlined,
  ),
  SlideInfo(
    'Describe tus Síntomas',
    'Chat de Síntomas',
    'Chatea con nuestra IA\nResponde preguntas sencillas\npara la análisis preliminar.', // Grammar from image: "para la análisis" (sic)
    Icons.psychology_outlined,
  ),
  SlideInfo(
    'Obtén Recomendaciones',
    'Paso 2: Obtén',
    'Recibe orientación y asesoría\nNo reemplaza un médico, pero\nda información valiosa.',
    Icons.assignment_outlined,
  ),
];

class OnboardingScreen extends StatefulWidget {
  static const name = 'onboarding_screen';
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  bool endReached = false;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final page = _pageController.page ?? 0;
      if (!endReached && page >= (slides.length - 1.5)) {
        setState(() {
          endReached = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            children: slides
                .map((slide) => _Slide(
                      title: slide.title,
                      caption: slide.caption,
                      description: slide.description,
                      icon: slide.icon,
                    ))
                .toList(),
          ),
          Positioned(
              bottom: 30,
              left: 30,
              right: 30,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dots
                  Builder(builder: (context) {
                    // We need a simple AnimatedBuilder to repaint dots or use setState.
                    // Since I used a listener to set state only at end, dots won't update?
                    // I should use AnimatedBuilder for dots or setState on page change.
                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, _) {
                        double page = _pageController.hasClients ? (_pageController.page ?? 0) : 0;
                        int currentPage = page.round();
                        
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(slides.length, (index) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              width: (index == currentPage) ? 12 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: (index == currentPage)
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey.shade300,
                                shape: BoxShape.circle,
                              ),
                            );
                          }),
                        );
                      },
                    );
                  }),

                  const SizedBox(height: 30),

                  AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double page = _pageController.hasClients ? (_pageController.page ?? 0) : 0;
                      bool isLast = page >= 1.5; // Simple check for slide 3

                      return FilledButton(
                        onPressed: () {
                          if (isLast) {
                            context.go('/login');
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn,
                            );
                          }
                        },
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: Text(isLast ? 'Empezar' : 'Siguiente'),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  TextButton(
                    onPressed: () {
                      context.go('/login');
                    },
                    child: const Text('Omitir'), // Using a cleaner text
                  )
                ],
              ))
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final String title;
  final String caption;
  final String description;
  final IconData icon;

  const _Slide({
    required this.title,
    required this.caption,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
          color: const Color(0xFF1E293B), // Dark blue/grey
          fontWeight: FontWeight.bold,
        );
    final captionStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          color: const Color(0xFF334155),
          fontWeight: FontWeight.w600,
        );
    final descStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: const Color(0xFF64748B),
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Top Title (Only checking if slide has top title or center title?)
            // Image 1: Top: Bienvenido...
            // Image 2: Top Banner: "Describe tus Síntomas" (Dark bar) - Wait looking at image 2.
            // Image 2 has a Dark Blue Bar at top with "Describe tus Síntomas".
            // Image 3 has a Dark Blue Bar at top with "Obtén Recomendaciones".
            // Image 1 does NOT have a top bar, just text "Bienvenido/a a Medi-IA".
            
            // Refinement: The design is slightly different per slide.
            // Slide 1: No AppBar. Title in body.
            // Slide 2: AppBar-like top bar.
            // Slide 3: AppBar-like top bar.
            
            // To keep it simple in one Generic Slide widget, I'll put the top title in the body for now,
            // or I conditionally show an AppBar-like container?
            // The user said "enfocandote en el color que estoy usando".
            // Adding a dark blue header for slide 2 and 3 would match the design better.
            
            // Let's adjust the _Slide widget to handle the Title position.
            // Actually, `PageView` is usually full screen.
            // If I want to match exactly, I should check if title is "AppBar" style or "Body" style.
            
            // For now, I will render simply centered content.
            // Re-reading image 2/3: The dark bar looks like an AppBar.
            // But PageView is inside Scaffold body usually.
            // I'll stick to a simple clean layout first. If needed I can add the header bar.
            
            Text(title, style: titleStyle, textAlign: TextAlign.center),
            const SizedBox(height: 40),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue.withOpacity(0.3), width: 2), // Light blue border
                boxShadow: [
                    BoxShadow(
                        color: Colors.blue.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                    )
                ]
              ),
              child: Icon(icon, size: 80, color: Theme.of(context).primaryColor),
            ),
            const SizedBox(height: 40),
            Text(caption, style: captionStyle, textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Text(description, style: descStyle, textAlign: TextAlign.center),
            const SizedBox(height: 100), // Space for buttons
          ],
        ),
      ),
    );
  }
}
