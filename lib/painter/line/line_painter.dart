import 'dart:ui';

import 'package:flutter/material.dart';

class LinePainter extends CustomPainter {

  double startX = 0, startY = 0, x, y;
  LinePainter(this.startX, this.startY, this.x, this.y);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 6;
    paint.color = Colors.black87;
    paint.strokeCap = StrokeCap.square;

    if(startX == x && startY == y) {
      canvas.drawPoints(PointMode.points, [ Offset(x, y) ], paint);
    }
    else {
      canvas.drawLine(Offset(startX, startY), Offset(x, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;


}