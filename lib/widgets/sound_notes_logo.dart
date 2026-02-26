import 'package:flutter/material.dart';

class SoundNotesLogo extends StatefulWidget {
  final double size;
  final bool animated;

  const SoundNotesLogo({
    super.key,
    this.size = 200,
    this.animated = true,
  });

  @override
  State<SoundNotesLogo> createState() => _SoundNotesLogoState();
}

class _SoundNotesLogoState extends State<SoundNotesLogo>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;

  @override
  void initState() {
    super.initState();
    _animationControllers = List.generate(
      4,
      (index) => AnimationController(
        duration: Duration(milliseconds: 1500 + (index * 200)),
        vsync: this,
      )..repeat(reverse: true),
    );
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size * 1.2,
      child: Stack(
        children: [
          // Staff lines (5 lines for musical staff)
          Positioned.fill(
            child: CustomPaint(
              painter: StaffLinesPainter(),
            ),
          ),

          // Note 1 - S (Red/Pink) - High
          Positioned(
            left: widget.size * 0.05,
            top: widget.size * 0.25,
            child: widget.animated
                ? AnimatedBuilder(
                    animation: _animationControllers[0],
                    builder: (context, child) {
                      return Transform.translate(
                        offset:
                            Offset(0, -25 * _animationControllers[0].value),
                        child: child,
                      );
                    },
                    child: _buildNote('S', 'Sss', Colors.red.shade400),
                  )
                : _buildNote('S', 'Sss', Colors.red.shade400),
          ),

          // Note 2 - M (Blue) - Mid-High
          Positioned(
            left: widget.size * 0.3,
            top: widget.size * 0.4,
            child: widget.animated
                ? AnimatedBuilder(
                    animation: _animationControllers[1],
                    builder: (context, child) {
                      return Transform.translate(
                        offset:
                            Offset(0, -20 * _animationControllers[1].value),
                        child: child,
                      );
                    },
                    child: _buildNote('M', 'Mmm', Colors.blue.shade400),
                  )
                : _buildNote('M', 'Mmm', Colors.blue.shade400),
          ),

          // Note 3 - L (Green) - Mid-Low
          Positioned(
            left: widget.size * 0.55,
            top: widget.size * 0.25,
            child: widget.animated
                ? AnimatedBuilder(
                    animation: _animationControllers[2],
                    builder: (context, child) {
                      return Transform.translate(
                        offset:
                            Offset(0, -25 * _animationControllers[2].value),
                        child: child,
                      );
                    },
                    child: _buildNote('L', 'Lll', Colors.green.shade400),
                  )
                : _buildNote('L', 'Lll', Colors.green.shade400),
          ),

          // Note 4 - A (Orange) - Low
          Positioned(
            left: widget.size * 0.75,
            top: widget.size * 0.5,
            child: widget.animated
                ? AnimatedBuilder(
                    animation: _animationControllers[3],
                    builder: (context, child) {
                      return Transform.translate(
                        offset:
                            Offset(0, -15 * _animationControllers[3].value),
                        child: child,
                      );
                    },
                    child: _buildNote('A', 'Aaa', Colors.orange.shade400),
                  )
                : _buildNote('A', 'Aaa', Colors.orange.shade400),
          ),
        ],
      ),
    );
  }

  Widget _buildNote(String letter, String sound, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Note head (filled circle)
        Container(
          width: 28,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Text(
              letter,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        // Note stem
        Container(
          width: 3,
          height: 45,
          color: Colors.black87,
        ),
        // Note flags
        CustomPaint(
          size: const Size(25, 20),
          painter: NoteFlagPainter(color: color),
        ),
        // Sound label
        Text(
          sound,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class NoteFlagPainter extends CustomPainter {
  final Color color;

  NoteFlagPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // First flag
    final path1 = Path();
    path1.moveTo(2, 0);
    path1.quadraticBezierTo(20, 5, 18, 12);
    path1.quadraticBezierTo(5, 8, 2, 10);
    path1.close();
    canvas.drawPath(path1, paint);

    // Second flag
    final path2 = Path();
    path2.moveTo(2, 10);
    path2.quadraticBezierTo(20, 15, 18, 22);
    path2.quadraticBezierTo(5, 18, 2, 20);
    path2.close();
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(NoteFlagPainter oldDelegate) {
    return color != oldDelegate.color;
  }
}

class StaffLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 2;

    // Draw 5 staff lines
    const lineCount = 5;
    final spacing = size.height / (lineCount + 1);

    for (int i = 1; i <= lineCount; i++) {
      final y = spacing * i;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(StaffLinesPainter oldDelegate) => false;
}
