import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Data class for flickering line segments
class _FlickerSegment {
  final Offset start;
  final Offset end;
  final double flickerPhase; // 0-1, determines when this segment flickers
  final double flickerSpeed; // How fast it flickers
  final double flickerIntensity; // Max brightness boost
  final double baseAlpha;

  _FlickerSegment({
    required this.start,
    required this.end,
    required this.flickerPhase,
    required this.flickerSpeed,
    required this.flickerIntensity,
    required this.baseAlpha,
  });
}

/// Custom painter for weathered grid pattern backdrop
class WeatheredGridPainter extends CustomPainter {
  final double animationProgress; // 0 to 1, for shockwave effect
  final double flickerTime; // Continuous time value for flickering
  final double
  flickerIntensity; // 0 to 1, how intense the flicker effect is (decays over time)
  final math.Random random = math.Random(42); // Fixed seed for consistency

  // Cache for flicker segments - generated once per size
  static List<_FlickerSegment>? _cachedSegments;
  static Size? _cachedSize;

  WeatheredGridPainter({
    this.animationProgress = 0.0,
    this.flickerTime = 0.0,
    this.flickerIntensity = 1.0,
  });

  /// Generates flickering line segments with varied properties
  List<_FlickerSegment> _generateFlickerSegments(Size size) {
    final segments = <_FlickerSegment>[];
    final segmentRandom = math.Random(42); // Consistent seed

    const gridSize = 150.0;
    const segmentLength = 30.0; // Length of individual flickering segments

    // Generate vertical line segments
    for (double x = 0; x <= size.width; x += gridSize) {
      if (segmentRandom.nextDouble() > 0.15) {
        // Break line into segments
        for (
          double y = 0;
          y < size.height;
          y += segmentLength + segmentRandom.nextDouble() * 20
        ) {
          if (segmentRandom.nextDouble() > 0.4) {
            // Some gaps
            final endY = (y + segmentLength + segmentRandom.nextDouble() * 40)
                .clamp(0.0, size.height);
            segments.add(
              _FlickerSegment(
                start: Offset(x, y),
                end: Offset(x, endY),
                flickerPhase: segmentRandom.nextDouble(),
                flickerSpeed:
                    8.0 +
                    segmentRandom.nextDouble() *
                        25.0, // Much faster, more varied
                flickerIntensity:
                    100 + segmentRandom.nextDouble() * 150, // Higher intensity
                baseAlpha: 8 + segmentRandom.nextDouble() * 12,
              ),
            );
          }
        }
      }
    }

    // Generate horizontal line segments
    for (double y = 0; y <= size.height; y += gridSize) {
      if (segmentRandom.nextDouble() > 0.15) {
        // Break line into segments
        for (
          double x = 0;
          x < size.width;
          x += segmentLength + segmentRandom.nextDouble() * 20
        ) {
          if (segmentRandom.nextDouble() > 0.4) {
            // Some gaps
            final endX = (x + segmentLength + segmentRandom.nextDouble() * 40)
                .clamp(0.0, size.width);
            segments.add(
              _FlickerSegment(
                start: Offset(x, y),
                end: Offset(endX, y),
                flickerPhase: segmentRandom.nextDouble(),
                flickerSpeed:
                    8.0 +
                    segmentRandom.nextDouble() *
                        25.0, // Much faster, more varied
                flickerIntensity:
                    100 + segmentRandom.nextDouble() * 150, // Higher intensity
                baseAlpha: 8 + segmentRandom.nextDouble() * 12,
              ),
            );
          }
        }
      }
    }

    return segments;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Draw base color
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color.fromARGB(255, 6, 11, 7),
    );

    // Regenerate segments if size changed
    if (_cachedSize != size) {
      _cachedSegments = _generateFlickerSegments(size);
      _cachedSize = size;
    }

    final segments = _cachedSegments ?? _generateFlickerSegments(size);

    const lineWidth = 1.0;

    // Shockwave properties
    final center = Offset(size.width * 0.3, size.height * 0.5);
    final maxRadius = size.width * 1.5;
    final currentRadius = animationProgress * maxRadius;
    const shockwaveWidth = 300.0;

    final gridPaint = Paint()
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;

    // Draw flickering segments
    for (final segment in segments) {
      final segmentCenter = Offset(
        (segment.start.dx + segment.end.dx) / 2,
        (segment.start.dy + segment.end.dy) / 2,
      );

      // Calculate shockwave intensity
      final distanceFromCenter = (center - segmentCenter).distance;
      final radiusDiff = (distanceFromCenter - currentRadius).abs();
      final shockwaveIntensity = radiusDiff < shockwaveWidth
          ? (1.0 - (radiusDiff / shockwaveWidth)) * animationProgress
          : 0.0;

      // Calculate flicker effect - only active when drawer is opening and intensity > 0
      double flickerBoost = 0.0;
      if (animationProgress > 0 && flickerIntensity > 0) {
        // Create varied flicker patterns using sin waves with different phases
        final flickerValue = math.sin(
          (flickerTime * segment.flickerSpeed) +
              (segment.flickerPhase * math.pi * 2),
        );
        // Pulse effect - some segments light up, some stay dim
        final pulseValue = math.sin(
          (flickerTime * segment.flickerSpeed * 0.5) +
              (segment.flickerPhase * math.pi * 4),
        );

        // Combine effects: base flicker + random intensity spikes, scaled by flickerIntensity
        if (flickerValue > 0.3) {
          flickerBoost =
              (flickerValue *
              segment.flickerIntensity *
              animationProgress *
              flickerIntensity);
        }
        // Add occasional bright flashes
        if (pulseValue > 0.8 && random.nextDouble() > 0.7) {
          flickerBoost +=
              segment.flickerIntensity *
              0.5 *
              animationProgress *
              flickerIntensity;
        }
      }

      // Calculate final alpha
      final finalAlpha =
          segment.baseAlpha + (shockwaveIntensity * 120) + flickerBoost;

      gridPaint.color = Colors.lightGreenAccent.withAlpha(
        finalAlpha.clamp(0, 255).toInt(),
      );

      canvas.drawLine(segment.start, segment.end, gridPaint);
    }

    // Add subtle noise/grain for extra weathered effect
    const noiseSize = 2.0;
    final noisePaint = Paint()
      ..color = const Color.fromRGBO(255, 255, 255, 0.02);
    for (int i = 0; i < 200; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      canvas.drawCircle(Offset(x, y), noiseSize, noisePaint);
    }
  }

  @override
  bool shouldRepaint(WeatheredGridPainter oldDelegate) =>
      oldDelegate.animationProgress != animationProgress ||
      oldDelegate.flickerTime != flickerTime ||
      oldDelegate.flickerIntensity != flickerIntensity;
}
