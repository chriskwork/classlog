// lib/widgets/course_detail_sheet.dart
import 'package:flutter/material.dart';
import 'package:classlog/theme/colors.dart';

class CourseDetailSheet extends StatelessWidget {
  final Map<String, dynamic> course;

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
            // 드래그 핸들
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // 스크롤 가능한 콘텐츠
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 헤더: 아이콘 + 제목
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: course['iconBgColor'],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            course['icon'],
                            color: course['iconColor'],
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course['name'],
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text(
                                course['time'],
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

                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),

                    // 정보 섹션
                    _buildInfoRow(
                        context, Icons.person, 'Profesor', course['profesor']),
                    const SizedBox(height: 12),
                    _buildInfoRow(context, Icons.room, 'Aula', course['aula']),
                    const SizedBox(height: 12),
                    _buildInfoRow(context, Icons.check_circle, 'Asistencia',
                        '${(course['asistencia'] * 100).toInt()}%'),

                    const SizedBox(height: 24),

                    // 출석률 프로그레스 바
                    Text(
                      'Progreso de Asistencia',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: course['asistencia'],
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        course['asistencia'] >= 0.8
                            ? Colors.green
                            : Colors.orange,
                      ),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),

                    const SizedBox(height: 32),

                    // 액션 버튼들
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // TODO: 출석 기록 보기
                            },
                            icon: const Icon(Icons.history),
                            label: const Text('Historial'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () {
                              // TODO: 과목 상세 페이지로 이동
                            },
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text('Ver más'),
                          ),
                        ),
                      ],
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
