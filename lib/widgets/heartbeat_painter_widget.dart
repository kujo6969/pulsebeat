import 'package:flutter/material.dart';

class HeartbeatPainter extends CustomPainter {
  final List<double> points;
  final double dx;

  HeartbeatPainter({required this.points, this.dx = 2});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    final path = Path();

    if (points.isEmpty) return;

    path.moveTo(0, points[0]);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(i * dx, points[i]);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant HeartbeatPainter oldDelegate) => true;
}
