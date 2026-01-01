import 'package:classlog/models/dashboard_res.dart';
import 'package:classlog/services/api_service.dart';
import 'package:classlog/theme/colors.dart';
import 'package:classlog/theme/settings.dart';
import 'package:classlog/widgets/constants/app_decorations.dart';
import 'package:classlog/widgets/course_card.dart';
import 'package:classlog/widgets/dashboard/circular_percentage.dart';
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

      // cl-student => custom endpoint de facturascripts
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

  // String → IconData TODO: 나중에 facturascripts에서 옵션 선택하도록 해야할듯?
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

  // HEX String → Color
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
      // dashboard UI
      return SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(Gaps.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📜 Clases de hoy
            Text(
              'Clase(s) de Hoy',
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

            // 📜 % de asistencia: porcentage hasta hoy
            // TODO: 나중에 출석 체크 하면 % 올라가는지 봐야 함!
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
                        ],
                      ),
                      Gaps.szBoxH20,
                      Row(
                        spacing: Sizes.size16,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircularPercentage(
                              percentage:
                                  _dashboardData!.attendanceStats?.percentage ??
                                      0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // TODO: mensaje depende del numero %
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

            // 📜 Proximas fechas limite
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
                    children: _dashboardData!.upcomingEvents.isEmpty
                        ? [
                            Center(
                              child: Padding(
                                padding: EdgeInsets.all(Sizes.size16),
                                child: Text(
                                  'No hay eventos próximos',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: secondaryColor),
                                ),
                              ),
                            )
                          ]
                        : [
                            ..._dashboardData!.upcomingEvents.map((event) {
                              return Row(
                                spacing: Sizes.size12,
                                children: [
                                  DecoratedBox(
                                    decoration: BoxDecoration(
                                      color:
                                          _getEventColor(event.tipo), // 타입별 색상
                                      borderRadius:
                                          BorderRadius.circular(Sizes.size16),
                                    ),
                                    child: const SizedBox(width: 6, height: 40),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(event.titulo),
                                      Text(
                                        _formatEventDate(event.fechaLimite),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(color: secondaryColor),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }),
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

  Color _getEventColor(String tipo) {
    switch (tipo) {
      case 'examen':
        return Color(0xFFEF4444);
      case 'auto-evals':
        return warningColor;
      case 'proyecto':
        return Color(0xFF3B82F6);
      default:
        return Color(0xFF6B7280);
    }
  }

  // 날짜 포맷팅
  String _formatEventDate(String fechaLimite) {
    // "31-12-2025 10:00:00" → "Mañana, 10:00" 또는 "23 de Noviembre, 15:00"

    try {
      // PHP 형식: "31-12-2025 10:00:00"
      final parts = fechaLimite.split(' ');
      final dateParts = parts[0].split('-');
      final timeParts = parts[1].split(':');

      final eventDate = DateTime(
        int.parse(dateParts[0]), // year
        int.parse(dateParts[1]), // month
        int.parse(dateParts[2]), // day
        int.parse(timeParts[0]), // hour
        int.parse(timeParts[1]), // minute
      );

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(Duration(days: 1));
      final eventDay = DateTime(eventDate.year, eventDate.month, eventDate.day);

      final timeStr = '${timeParts[0]}:${timeParts[1]}';

      final meses = [
        'Enero',
        'Febrero',
        'Marzo',
        'Abril',
        'Mayo',
        'Junio',
        'Julio',
        'Agosto',
        'Septiembre',
        'Octubre',
        'Noviembre',
        'Diciembre'
      ];

      final monthName = meses[eventDate.month - 1];

      // 오늘
      if (eventDay == today) {
        return 'Hoy, $timeStr';
      }
      // 내일
      else if (eventDay == tomorrow) {
        return 'Mañana, $timeStr';
      }
      // 일주일 이내
      else if (eventDay.difference(today).inDays < 7) {
        final dias = [
          'Lunes',
          'Martes',
          'Miércoles',
          'Jueves',
          'Viernes',
          'Sábado',
          'Domingo'
        ];

        return '${dias[eventDate.weekday - 1]}, $monthName, $timeStr';
      }
      // 그 이상
      else {
        final meses = [
          'Enero',
          'Febrero',
          'Marzo',
          'Abril',
          'Mayo',
          'Junio',
          'Julio',
          'Agosto',
          'Septiembre',
          'Octubre',
          'Noviembre',
          'Diciembre'
        ];
        return '${eventDate.day} de ${meses[eventDate.month - 1]}, $timeStr';
      }
    } catch (e) {
      return fechaLimite; // 파싱 실패시 원본 반환
    }
  }
}
