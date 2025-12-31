// % graph de asistencia
import 'package:classlog/theme/colors.dart';
import 'package:flutter/material.dart';

// Widget de circulo que demuestra % de asistencia
// Porcentaje de asistencia: (Clases asistidas / Total de clases a la fecha) * 100
class CircularPercentage extends StatefulWidget {
  final int percentage;
  final double size;
  final Duration duration;

  const CircularPercentage({
    super.key,
    required this.percentage,
    this.size = 90, // tamaño circulo
    this.duration = const Duration(milliseconds: 1200), // tiempo de animation
  });

  @override
  State<CircularPercentage> createState() => _CircularPercentageState();
}

class _CircularPercentageState extends State<CircularPercentage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = IntTween(
      begin: 0,
      end: widget.percentage,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _CircularPercentagePainter(_animation.value),
            child: Center(
              child: Text(
                "${_animation.value}",
                style: TextStyle(
                  fontSize: widget.size * 0.35, // tamaño de texto
                  fontWeight: FontWeight.bold,
                  color: mainColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CircularPercentagePainter extends CustomPainter {
  final int percentage;

  _CircularPercentagePainter(this.percentage);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final bgPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    canvas.drawCircle(center, radius - 4, bgPaint);

    final progressPaint = Paint()
      ..color = Color(0xff2563EB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * -3.14159 * (percentage / 100);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 4),
      -3.14159 / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
