import 'package:classlog/models/dashboard_res.dart';
import 'package:classlog/services/api_service.dart';
import 'package:classlog/theme/colors.dart';
import 'package:classlog/theme/settings.dart';
import 'package:classlog/widgets/constants/app_decorations.dart';
import 'package:classlog/widgets/course_card.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();
  DashboardData? _dashboardData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final res = await _apiService.get('cl-student?action=dashboard&id=1');
      final dashboardResponse = DashboardResponse.fromJson(res);

      setState(() {
        _dashboardData = dashboardResponse.data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  // String → IconData 변환
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'video_stable':
        return Icons.video_stable_rounded;
      case 'code':
        return Icons.code_rounded;
      case 'calculate':
        return Icons.calculate_rounded;
      case 'science':
        return Icons.science_rounded;
      case 'language':
        return Icons.language_rounded;
      case 'palette':
        return Icons.palette_rounded;
      default:
        return Icons.book_rounded;
    }
  }

  // HEX String → Color 변환
  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error'),
            ElevatedButton(
              onPressed: _loadDashboard,
              child: Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_dashboardData == null) {
      return Center(
        child: Text('No hay datos'),
      );
    } else {
      return SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(Gaps.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Clases de Hoy TODO -> change to ListView

            Text(
              'Clases de Hoy',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Gaps.szBoxH10,
            SizedBox(
              width: double.infinity,
              child: DecoratedBox(
                decoration: AppDecorations.card,
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.size16),
                  child: Column(
                    spacing: Sizes.size16,
                    children: [
                      ..._dashboardData!.todaySchedule.map((schedule) {
                        return CourseCard(
                          courseName: schedule.cursoNombre,
                          time: '${schedule.horaInicio} - ${schedule.horaFin}',
                          icon: _getIconData(schedule.icono),
                          iconColor: _hexToColor(schedule.color),
                          iconBgColor: _hexToColor(schedule.color)
                              .withValues(alpha: 0.15),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),

            Gaps.szBoxH20,

            SizedBox(
              width: double.infinity,
              child: DecoratedBox(
                decoration: AppDecorations.card,
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.size16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '% de Asistencia',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text(
                                'Período Actual',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: secondaryColor,
                                    ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.calendar_today_rounded,
                              color: mainColor,
                            ),
                          )
                        ],
                      ),
                      Gaps.szBoxH20,
                      Row(
                        spacing: Sizes.size16,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircularPercentage(percentage: 93),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '¡Sigue así!',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                Gaps.szBoxH4,
                                Text(
                                  'Tu asistencia está por encima del promedio.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: textSecondaryColor,
                                      ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),

            Gaps.szBoxH20,

            // Proximas fechas limite
            Text(
              "Próximas Fechas Límite",
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            Gaps.szBoxH10,

            SizedBox(
              width: double.infinity,
              child: DecoratedBox(
                decoration: AppDecorations.card,
                child: Padding(
                  padding: EdgeInsets.all(Sizes.size16),
                  child: Column(
                    spacing: Sizes.size16,
                    // TODO -> change to ListView
                    children: [
                      Row(
                        spacing: Sizes.size12,
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: warningColor,
                              borderRadius: BorderRadius.circular(Sizes.size16),
                            ),
                            child: const SizedBox(
                              width: 6,
                              height: 40,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Entrega Tarea Final"),
                              Text(
                                "Mañana, 23:59",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: secondaryColor,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        spacing: Sizes.size12,
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: warningColor,
                              borderRadius: BorderRadius.circular(Sizes.size16),
                            ),
                            child: const SizedBox(
                              width: 6,
                              height: 40,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Examen de Modulo"),
                              Text(
                                "23 de Noviembre, 15:00",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: secondaryColor,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ));
    }
  }
}

// % graph de asistencia
class CircularPercentage extends StatefulWidget {
  final int percentage;
  final double size;
  final Duration duration;

  const CircularPercentage({
    super.key,
    required this.percentage,
    this.size = 80,
    this.duration = const Duration(milliseconds: 1200),
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
                  fontSize: widget.size * 0.35,
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
