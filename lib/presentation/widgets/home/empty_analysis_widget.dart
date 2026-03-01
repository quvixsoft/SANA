import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sana/core/config/theme/app_theme.dart';

/// Widget that displays an empty state when the user has no analyses.
///
/// Shows a dashed-circle folder icon, decorative dots,
/// a motivational message, and a CTA button.
class EmptyAnalysisWidget extends StatelessWidget {
  /// Callback when the user taps the "Start my first analysis" button.
  final VoidCallback? onStartAnalysis;

  const EmptyAnalysisWidget({super.key, this.onStartAnalysis});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          const SizedBox(height: 40),

          // ── Dashed circle with folder icon + decorative dots ──
          SizedBox(
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Small cyan dot – top left
                Positioned(
                  top: 28,
                  left: 20,
                  child: _dot(10, AppColors.primary),
                ),
                // Small cyan dot – bottom right
                Positioned(
                  bottom: 40,
                  right: 16,
                  child: _dot(12, AppColors.primary),
                ),
                // Dashed circle
                CustomPaint(
                  size: const Size(150, 150),
                  painter: _DashedCirclePainter(
                    color: AppColors.grey200,
                    strokeWidth: 2,
                    dashLength: 6,
                    gapLength: 4,
                  ),
                ),
                // Folder icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.folder_open_rounded,
                    size: 40,
                    color: AppColors.grey300,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Badge label ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(AppRadius.rounded),
              border: Border.all(color: AppColors.grey100),
            ),
            child: Text(
              'NO HAY ANÁLISIS ACTIVOS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: AppColors.grey400,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ── Title ──
          Text(
            'Comencemos tu viaje de salud',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.darkNavy,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 12),

          // ── Description ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Aún no tienes registros. Inicia un análisis para encontrar la causa raíz de tus síntomas.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.grey300,
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // ── CTA Button ──
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: onStartAnalysis,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 4,
                shadowColor: AppColors.primary.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.large),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'INICIAR MI PRIMER ANÁLISIS',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      letterSpacing: 0.5,
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

  /// Builds a small decorative dot.
  Widget _dot(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

/// CustomPainter that draws a dashed circle.
class _DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;

  _DashedCirclePainter({
    required this.color,
    this.strokeWidth = 2,
    this.dashLength = 6,
    this.gapLength = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final circumference = 2 * pi * radius;
    final totalDashAndGap = dashLength + gapLength;
    final dashCount = (circumference / totalDashAndGap).floor();

    for (int i = 0; i < dashCount; i++) {
      final startAngle = (i * totalDashAndGap / circumference) * 2 * pi;
      final sweepAngle = (dashLength / circumference) * 2 * pi;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
