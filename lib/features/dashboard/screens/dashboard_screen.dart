import 'package:classlog/app/theme/app_colors.dart';
import 'package:classlog/app/theme/app_spacing.dart';
import 'package:classlog/shared/constants/app_decorations.dart';
import 'package:classlog/shared/widgets/course_card.dart';
import 'package:classlog/features/dashboard/widgets/circular_percentage.dart';
import 'package:flutter/material.dart';
import 'package:classlog/features/dashboard/provider/dashboard_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  // String → IconData TODO: more icons & add input option in FS
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

  // Colores depende del evento
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

  // Demostrar la fecha del limite y logic para calcular hoy/mañana
  String _formatEventDate(String fechaLimite) {
    try {
      final parts = fechaLimite.split(' ');
      final dateParts = parts[0].split('-');
      final timeParts = parts[1].split(':');

      final eventDate = DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
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

      if (eventDay == today) {
        return 'Hoy, $timeStr';
      } else if (eventDay == tomorrow) {
        return 'Mañana, $timeStr';
      } else if (eventDay.difference(today).inDays < 7) {
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
      } else {
        return '${eventDate.day} de ${meses[eventDate.month - 1]}, $timeStr';
      }
    } catch (e) {
      return fechaLimite;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Traer los datos via provider
    final dashboardAsync = ref.watch(dashboardProvider);

    // error handler
    return dashboardAsync.when(
      // loading
      loading: () => Center(child: CircularProgressIndicator()),

      // error
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $error'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(dashboardProvider); // refresh
              },
              child: Text('Reintentar'),
            ),
          ],
        ),
      ),

      // hasData
      data: (dashboardData) => SingleChildScrollView(
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
                        ...dashboardData.todaySchedule.map((schedule) {
                          return CourseCard(
                            courseName: schedule.cursoNombre,
                            time:
                                '${schedule.horaInicio.substring(0, 5)} - ${schedule.horaFin.substring(0, 5)}',
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

              // 📜 % de asistencia
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
                                      .copyWith(color: secondaryColor),
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
                                  dashboardData.attendanceStats?.percentage ??
                                      0,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '¡Sigue así!',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  Gaps.szBoxH4,
                                  Text(
                                    'Tu asistencia está por encima del promedio.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: textSecondaryColor),
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
                      children: dashboardData.upcomingEvents.isEmpty
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
                              ...dashboardData.upcomingEvents.map((event) {
                                return Row(
                                  spacing: Sizes.size12,
                                  children: [
                                    DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: _getEventColor(event.tipo),
                                        borderRadius:
                                            BorderRadius.circular(Sizes.size16),
                                      ),
                                      child:
                                          const SizedBox(width: 6, height: 40),
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
        ),
      ),
    );
  }
}
