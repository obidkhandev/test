import 'package:flutter/material.dart';

class BrickBreakerPainter extends CustomPainter {
  final List<List<bool>> bricks;

  BrickBreakerPainter(this.bricks);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.blue;
    double brickWidth = size.width / 5;
    double brickHeight = 20.0;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 5; j++) {
        if (bricks[i][j]) {
          canvas.drawRect(
            Rect.fromLTWH(j * brickWidth, i * brickHeight, brickWidth, brickHeight),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}