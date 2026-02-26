import 'package:flutter/material.dart';
import 'dart:math';
import 'register_child.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;

  Widget _buildMusicalWord({
    required bool isM,
    required String rest,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Transform.translate(
          offset: const Offset(0, 2),
          child: SizedBox(
            width: 34,
            height: 50,
            child: CustomPaint(
              painter: isM ? MusicalNoteMPainter() : MusicalNoteVPainter(),
            ),
          ),
        ),
        const SizedBox(width: 0.5),
        Text(
          rest,
          style: const TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B4CCF),
            fontFamily: 'Roboto',
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    // Fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeController.forward();

    // Navigate to main app after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => RegisterChildScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFFE8F0F8), // Light desaturated blue
                  const Color(0xFFE8E0F5), // Soft cool lavender
                  const Color(0xFFF5E8F0), // Pale pink/lilac blend
                ],
              ),
            ),
          ),

          // Decorative stars and sparkles
          Positioned.fill(
            child: CustomPaint(
              painter: StarsPainter(),
            ),
          ),

          // Main content
          Center(
            child: FadeTransition(
              opacity: _fadeController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  // Text with musical-note M and V
                  _buildMusicalWord(
                    isM: true,
                    rest: 'elodic',
                  ),
                  _buildMusicalWord(
                    isM: false,
                    rest: 'oice',
                  ),

                  const SizedBox(height: 24),

                  // Subtitle
                  Text(
                    'AI Speech Therapy',
                    style: TextStyle(
                      fontSize: 16,
                      color: const Color(0xFF2F4A7A).withOpacity(0.7),
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Roboto',
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Loading indicator
                  const CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF2F4A7A)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for musical note M
class MusicalNoteMPainter extends CustomPainter {
  static const Color noteColor = Color(0xFFD46A8C);

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = noteColor
      ..strokeWidth = 3.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final fill = Paint()
      ..color = noteColor
      ..style = PaintingStyle.fill;

    final leftX = size.width * 0.2;
    final rightX = size.width * 0.8;
    final topY = size.height * 0.12;
    final stemBottom = size.height * 0.72;

    // Left and right stems
    canvas.drawLine(Offset(leftX, topY), Offset(leftX, stemBottom), stroke);
    canvas.drawLine(Offset(rightX, topY), Offset(rightX, stemBottom), stroke);

    // Note heads
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(leftX - 1, size.height * 0.78),
        width: size.width * 0.22,
        height: size.height * 0.18,
      ),
      fill,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(rightX - 1, size.height * 0.78),
        width: size.width * 0.22,
        height: size.height * 0.18,
      ),
      fill,
    );

    // Curved center stroke to mimic note-style "M"
    final mCurve = Path()
      ..moveTo(leftX, size.height * 0.36)
      ..quadraticBezierTo(
        size.width * 0.36,
        size.height * 0.56,
        size.width * 0.48,
        size.height * 0.62,
      )
      ..quadraticBezierTo(
        size.width * 0.6,
        size.height * 0.42,
        rightX,
        size.height * 0.36,
      );
    canvas.drawPath(mCurve, stroke);

    // Top flag stroke similar to reference
    final flag = Path()
      ..moveTo(size.width * 0.49, size.height * 0.6)
      ..cubicTo(
        size.width * 0.52,
        size.height * 0.34,
        size.width * 0.71,
        size.height * 0.33,
        rightX,
        size.height * 0.14,
      );
    canvas.drawPath(flag, stroke);
  }

  @override
  bool shouldRepaint(MusicalNoteMPainter oldDelegate) => false;
}

// Custom painter for musical note V
class MusicalNoteVPainter extends CustomPainter {
  static const Color noteColor = Color(0xFFD46A8C);

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = noteColor
      ..strokeWidth = 3.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final fill = Paint()
      ..color = noteColor
      ..style = PaintingStyle.fill;

    // V body
    final vPath = Path()
      ..moveTo(size.width * 0.12, size.height * 0.16)
      ..lineTo(size.width * 0.5, size.height * 0.92)
      ..lineTo(size.width * 0.88, size.height * 0.16);
    canvas.drawPath(vPath, stroke);

    // Treble-clef style overlay
    final clef = Path()
      ..moveTo(size.width * 0.62, size.height * 0.06)
      ..cubicTo(
        size.width * 0.33,
        size.height * 0.12,
        size.width * 0.26,
        size.height * 0.45,
        size.width * 0.55,
        size.height * 0.46,
      )
      ..cubicTo(
        size.width * 0.76,
        size.height * 0.47,
        size.width * 0.66,
        size.height * 0.74,
        size.width * 0.42,
        size.height * 0.68,
      )
      ..cubicTo(
        size.width * 0.22,
        size.height * 0.63,
        size.width * 0.2,
        size.height * 0.86,
        size.width * 0.37,
        size.height * 0.85,
      );
    canvas.drawPath(clef, stroke);

    canvas.drawCircle(Offset(size.width * 0.36, size.height * 0.85), size.width * 0.02, fill);

    // Clef stem crossing the V
    canvas.drawLine(
      Offset(size.width * 0.63, size.height * 0.2),
      Offset(size.width * 0.4, size.height * 0.9),
      stroke,
    );

    // Small top note head
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.72, size.height * 0.14),
        width: size.width * 0.12,
        height: size.height * 0.12,
      ),
      fill,
    );
  }

  @override
  bool shouldRepaint(MusicalNoteVPainter oldDelegate) => false;
}

// Custom painter for decorative stars and sparkles
class StarsPainter extends CustomPainter {
  final random = Random(42); // Fixed seed for consistency

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.4)
      ..style = PaintingStyle.fill;

    // Draw stars at fixed positions for consistency
    final starPositions = [
      Offset(size.width * 0.1, size.height * 0.15),
      Offset(size.width * 0.85, size.height * 0.2),
      Offset(size.width * 0.15, size.height * 0.8),
      Offset(size.width * 0.9, size.height * 0.75),
      Offset(size.width * 0.2, size.height * 0.35),
      Offset(size.width * 0.8, size.height * 0.5),
    ];

    for (final pos in starPositions) {
      _drawStar(canvas, pos, 8, paint);
    }

    // Add small sparkles
    final sparklePositions = [
      Offset(size.width * 0.12, size.height * 0.25),
      Offset(size.width * 0.88, size.height * 0.4),
      Offset(size.width * 0.25, size.height * 0.6),
      Offset(size.width * 0.75, size.height * 0.85),
    ];

    final sparklePaint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.5);

    for (final pos in sparklePositions) {
      canvas.drawCircle(pos, 3, sparklePaint);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 4 * 3.14159265 / 5) - 3.14159265 / 2;
      final x = center.dx + size * cos(angle);
      final y = center.dy + size * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(StarsPainter oldDelegate) => false;
}
