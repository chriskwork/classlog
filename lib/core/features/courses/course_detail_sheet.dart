import 'package:classlog/core/features/courses/course.dart';
import 'package:flutter/material.dart';
import 'package:classlog/core/theme/app_colors.dart';

class CourseDetailSheet extends StatelessWidget {
  final Course course;

  const CourseDetailSheet({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: course.lightColorValue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            course.iconData,
                            color: course.colorValue,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course.name,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text(
                                course.timeRange,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: secondaryColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    Text(course.description),
                    const SizedBox(height: 24),

                    const Divider(
                      color: greyColor,
                    ),
                    const SizedBox(height: 16),

                    // info
                    _buildInfoRow(context, Icons.person, 'Profesor',
                        course.professorName ?? 'N/A'),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                        context, Icons.room, 'Aula', course.aula ?? 'N/A'),
                    const SizedBox(height: 12),
                    _buildInfoRow(context, Icons.check_circle, 'Asistencia',
                        '${course.attendancePercentage}%'),

                    const SizedBox(height: 24),

                    // profress bar (asistencia)
                    Text(
                      'Progreso de Asistencia',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: course.attendanceTotal > 0
                          ? course.attendancePercentage / 100.0
                          : 0.0,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        course.attendancePercentage >= 80
                            ? Colors.green
                            : Colors.orange,
                      ),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${course.attendancePresent} de ${course.attendanceTotal} clases',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: secondaryColor),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: secondaryColor,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
