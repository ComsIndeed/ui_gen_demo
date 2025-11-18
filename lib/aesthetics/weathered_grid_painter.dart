import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Custom painter for weathered grid pattern backdrop
class WeatheredGridPainter extends CustomPainter {
  final math.Random random = math.Random(42); // Fixed seed for consistency

  @override
  void paint(Canvas canvas, Size size) {
    // Draw base color
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color.fromARGB(255, 6, 11, 7),
    );

    const gridSize = 150.0;
    const lineWidth = 1.0;
    const double alpha = 15;

    final gridPaint = Paint()
      ..strokeWidth = lineWidth
      ..color = Colors.white.withAlpha(20);

    // Draw vertical lines
    for (double x = 0; x <= size.width; x += gridSize) {
      // Randomly skip some lines to create weathered effect
      if (random.nextDouble() > 0.15) {
        // Further random opacity variation for worn appearance
        final opacityVariation = 0.5 + (random.nextDouble() * 0.5);
        gridPaint.color = Colors.white.withAlpha(
          (alpha * opacityVariation).toInt(),
        );

        // Occasionally draw broken/partial lines
        if (random.nextDouble() > 0.8) {
          // Draw partial line
          final startY = random.nextDouble() * size.height * 0.3;
          final endY = startY + (size.height * 0.4);
          canvas.drawLine(Offset(x, startY), Offset(x, endY), gridPaint);
        } else {
          // Draw full line
          canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
        }
      }
    }

    // Draw horizontal lines
    for (double y = 0; y <= size.height; y += gridSize) {
      // Randomly skip some lines to create weathered effect
      if (random.nextDouble() > 0.15) {
        // Further random opacity variation for worn appearance
        final opacityVariation = 0.5 + (random.nextDouble() * 0.5);
        gridPaint.color = Colors.white.withAlpha(
          (alpha * opacityVariation).toInt(),
        );

        // Occasionally draw broken/partial lines
        if (random.nextDouble() > 0.8) {
          // Draw partial line
          final startX = random.nextDouble() * size.width * 0.3;
          final endX = startX + (size.width * 0.4);
          canvas.drawLine(Offset(startX, y), Offset(endX, y), gridPaint);
        } else {
          // Draw full line
          canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
        }
      }
    }

    // Add subtle noise/grain for extra weathered effect
    const noiseSize = 2.0;
    // Avoid deprecated withOpacity; use Color.fromRGBO to set alpha precisely
    final noisePaint = Paint()
      ..color = const Color.fromRGBO(255, 255, 255, 0.02);
    for (int i = 0; i < 200; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      canvas.drawCircle(Offset(x, y), noiseSize, noisePaint);
    }
  }

  @override
  bool shouldRepaint(WeatheredGridPainter oldDelegate) => false;
}
