import 'package:flutter/material.dart';

class CustomQRIcon extends StatelessWidget {
  final double size;
  final Color color;

  const CustomQRIcon({
    super.key,
    this.size = 24,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: QRIconPainter(color: color),
    );
  }
}

class QRIconPainter extends CustomPainter {
  final Color color;

  QRIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08;

    // Draw outer frame corners
    _drawCorner(canvas, strokePaint, size, 0, 0, true, true); // Top-left
    _drawCorner(canvas, strokePaint, size, size.width, 0, false, true); // Top-right
    _drawCorner(canvas, strokePaint, size, 0, size.height, true, false); // Bottom-left
    _drawCorner(canvas, strokePaint, size, size.width, size.height, false, false); // Bottom-right

    // Draw QR code pattern in center
    final centerSize = size.width * 0.4;
    final centerOffset = (size.width - centerSize) / 2;
    
    // Draw center squares pattern
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if ((i + j) % 2 == 0) {
          final squareSize = centerSize / 3;
          final x = centerOffset + (j * squareSize);
          final y = centerOffset + (i * squareSize);
          
          canvas.drawRect(
            Rect.fromLTWH(x, y, squareSize * 0.8, squareSize * 0.8),
            paint,
          );
        }
      }
    }

    // Draw small dots around center
    final dotSize = size.width * 0.04;
    final positions = [
      Offset(size.width * 0.2, size.width * 0.3),
      Offset(size.width * 0.8, size.width * 0.3),
      Offset(size.width * 0.3, size.width * 0.7),
      Offset(size.width * 0.7, size.width * 0.7),
    ];

    for (final pos in positions) {
      canvas.drawCircle(pos, dotSize, paint);
    }
  }

  void _drawCorner(Canvas canvas, Paint paint, Size size, double x, double y, bool isLeft, bool isTop) {
    final cornerSize = size.width * 0.25;
    final path = Path();

    if (isLeft && isTop) {
      // Top-left corner
      path.moveTo(x, y + cornerSize);
      path.lineTo(x, y);
      path.lineTo(x + cornerSize, y);
    } else if (!isLeft && isTop) {
      // Top-right corner
      path.moveTo(x - cornerSize, y);
      path.lineTo(x, y);
      path.lineTo(x, y + cornerSize);
    } else if (isLeft && !isTop) {
      // Bottom-left corner
      path.moveTo(x, y - cornerSize);
      path.lineTo(x, y);
      path.lineTo(x + cornerSize, y);
    } else {
      // Bottom-right corner
      path.moveTo(x - cornerSize, y);
      path.lineTo(x, y);
      path.lineTo(x, y - cornerSize);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}