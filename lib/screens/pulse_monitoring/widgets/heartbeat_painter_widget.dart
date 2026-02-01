import 'dart:math';

import 'package:flutter/material.dart';

class HeartbeatPainter extends CustomPainter {
  final double progress;

  HeartbeatPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromRGBO(204, 68, 92, 1)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final path = Path();
    final midY = size.height / 2;
    final width = size.width;
    const double baseAmplitude = 18;
    const double waveLength = 1.2;

    final double dynamicAmp = (baseAmplitude + sin(progress * 2 * pi) * 3)
        .clamp(0, 40);

    path.moveTo(0, midY);

    for (double x = 0; x <= width; x += 12) {
      // fewer points
      final double normalizedX = x / width;
      final double y =
          midY +
          sin((normalizedX * 2 * pi * waveLength) + (progress * 2 * pi)) *
              dynamicAmp *
              0.8 +
          sin((normalizedX * 4 * pi) + (progress * 2 * pi * 0.7)) * 4;

      path.lineTo(x, y); // lineTo is much lighter than cubicTo
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant HeartbeatPainter oldDelegate) => true;
}
