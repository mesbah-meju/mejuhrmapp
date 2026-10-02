import 'package:flutter/material.dart';

class BottomWaveWidget extends StatelessWidget {
  final double height;

  const BottomWaveWidget({super.key, this.height = 140});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _WavePainter(),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Layer 1: Soft Light Mint Background Wave
    final paint1 = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFF6EE7B7).withValues(alpha: 0.25),
          const Color(0xFFA7F3D0).withValues(alpha: 0.15),
        ],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ).createShader(Rect.fromLTWH(0, 0, width, height))
      ..style = PaintingStyle.fill;

    final path1 = Path();
    path1.moveTo(0, height * 0.4);
    path1.quadraticBezierTo(width * 0.25, height * 0.85, width * 0.55, height * 0.65);
    path1.quadraticBezierTo(width * 0.8, height * 0.45, width, height * 0.7);
    path1.lineTo(width, height);
    path1.lineTo(0, height);
    path1.close();
    canvas.drawPath(path1, paint1);

    // Layer 2: Middle Emerald Wave with gradient
    final paint2 = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFF10B981).withValues(alpha: 0.45),
          const Color(0xFF34D399).withValues(alpha: 0.3),
        ],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ).createShader(Rect.fromLTWH(0, 0, width, height))
      ..style = PaintingStyle.fill;

    final path2 = Path();
    path2.moveTo(0, height * 0.6);
    path2.quadraticBezierTo(width * 0.2, height * 0.2, width * 0.5, height * 0.55);
    path2.quadraticBezierTo(width * 0.78, height * 0.85, width, height * 0.45);
    path2.lineTo(width, height);
    path2.lineTo(0, height);
    path2.close();
    canvas.drawPath(path2, paint2);

    // Layer 3: Foreground Smooth Accent Line with connecting dot
    final linePaint = Paint()
      ..color = const Color(0xFF059669).withValues(alpha: 0.6)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final linePath = Path();
    linePath.moveTo(0, height * 0.6);
    linePath.quadraticBezierTo(width * 0.2, height * 0.2, width * 0.5, height * 0.55);
    linePath.quadraticBezierTo(width * 0.78, height * 0.85, width, height * 0.45);
    canvas.drawPath(linePath, linePaint);

    // Subtle Accent Dot on the wave curve
    final dotPaint = Paint()
      ..color = const Color(0xFF059669)
      ..style = PaintingStyle.fill;
    final dotOuterPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final dotPoint = Offset(width * 0.82, height * 0.73);
    canvas.drawCircle(dotPoint, 4.5, dotPaint);
    canvas.drawCircle(dotPoint, 4.5, dotOuterPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
