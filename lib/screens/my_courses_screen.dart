import 'package:classlog/screens/course_detail_sheet.dart';
import 'package:classlog/widgets/course_card.dart';
import 'package:flutter/material.dart';

class MyCoursesScreen extends StatelessWidget {
  const MyCoursesScreen({super.key});

  // dummy data for UI
  final List<Map<String, dynamic>> _courses = const [
    {
      'id': 1,
      'name': 'Programación',
      'time': 'Lun, Mié 09:00-11:00',
      'status': 'Presente',
      'icon': Icons.code,
      'iconColor': Colors.blue,
      'iconBgColor': Color(0xFFE3F2FD),
      'profesor': 'María García',
      'aula': 'Aula 201',
      'asistencia': 0.92,
    },
    {
      'id': 2,
      'name': 'Base de Datos',
      'time': 'Mar, Jue 11:00-13:00',
      'status': 'Ausencia',
      'icon': Icons.storage,
      'iconColor': Colors.orange,
      'iconBgColor': Color(0xFFFFF3E0),
      'profesor': 'Carlos López',
      'aula': 'Aula 105',
      'asistencia': 0.85,
    },
    {
      'id': 3,
      'name': 'Sistemas Informáticos',
      'time': 'Vie 09:00-14:00',
      'status': 'Pendiente',
      'icon': Icons.computer,
      'iconColor': Colors.green,
      'iconBgColor': Color(0xFFE8F5E9),
      'profesor': 'Ana Martínez',
      'aula': 'Aula 302',
      'asistencia': 0.78,
    },
  ];

  //
  void _showCourseDetail(BuildContext context, Map<String, dynamic> course) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CourseDetailSheet(course: course),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _courses.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final course = _courses[index];
          return CourseCard(
            courseName: course['name'],
            time: course['time'],
            status: course['status'],
            icon: course['icon'],
            iconColor: course['iconColor'],
            iconBgColor: course['iconBgColor'],
            onTap: () => _showCourseDetail(context, course),
          );
        });
  }
}
