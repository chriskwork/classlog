import 'package:classlog/screens/course_detail_sheet.dart';
import 'package:classlog/theme/colors.dart';
import 'package:classlog/theme/settings.dart';
import 'package:classlog/widgets/course_card.dart';
import 'package:flutter/material.dart';

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});

  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {
  int selectedDay = 0; // Dias..
  final days = ["L", "M", "X", "J", "V"];

  // Temporary dummy data
  final List<Course> allCourses = [
    Course(
      name: 'Desarrollo de Interfaces',
      time: '15:00 - 17:30',
      aula: 'Aula 2',
      days: [0, 2],
      icon: Icons.widgets_outlined,
      iconColor: mainColor,
      iconBgColor: mainLightColor,
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut in massa nec purus ultricies laoreet eu eu odio. Proin nibh velit, feugiat id nisi et, bibendum elementum felis. Etiam nunc nunc, malesuada nec molestie quis, posuere non metus.',
      profesor: 'Profesor X',
    ), // L, X
    Course(
      name: 'Acceso a Datos',
      time: '18:00 - 19:30',
      aula: 'Aula 2',
      days: [0, 3],
      icon: Icons.storage_outlined,
      iconColor: mainColor,
      iconBgColor: mainLightColor,
      profesor: 'Maria Garcia',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut in massa nec purus ultricies laoreet eu eu odio. Proin nibh velit, feugiat id nisi et, bibendum elementum felis. Etiam nunc nunc, malesuada nec molestie quis, posuere non metus.',
      asistencia: 0.93,
    ),

    Course(
      name: 'Proyecto',
      time: '20:00 - 21:30',
      aula: 'Aula 2',
      days: [0, 1, 4],
      icon: Icons.computer_outlined,
      iconColor: mainColor,
      iconBgColor: mainLightColor,
      profesor: 'Virginia Fernandez',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut in massa nec purus ultricies laoreet eu eu odio. Proin nibh velit, feugiat id nisi et, bibendum elementum felis. Etiam nunc nunc, malesuada nec molestie quis, posuere non metus.',
    ),
  ];

  // Filtering selected day
  List<Course> get filteredCourses {
    return allCourses
        .where((course) => course.days.contains(selectedDay))
        .toList();
  }

  void _showCourseDetail(BuildContext context, Course course) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GestureDetector(
        onTap: () => Navigator.pop(context),
        behavior: HitTestBehavior.opaque,
        child: GestureDetector(
          onTap: () {},
          child: CourseDetailSheet(course: course),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DaySelector(
          selectedIndex: selectedDay,
          onChanged: (index) {
            setState(() => selectedDay = index);
          },
        ),
        Expanded(
          child: ListView.separated(
              padding: const EdgeInsets.all(Gaps.lg),
              itemCount: filteredCourses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final course = filteredCourses[index];
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: lineColor,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: CourseCard(
                      courseName: course.name,
                      time: course.time,
                      icon: course.icon,
                      iconColor: course.iconColor,
                      iconBgColor: course.iconBgColor,
                      onTap: () => _showCourseDetail(context, course),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}

class Course {
  final String name;
  final String time;
  final String aula;
  final List<int> days;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String description;
  final String profesor;
  final double asistencia;

  Course({
    required this.name,
    required this.time,
    required this.aula,
    required this.days,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.description,
    required this.profesor,
    this.asistencia = 0.0,
  });
}

class DaySelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const DaySelector({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final days = ['L', 'M', 'X', 'J', 'V'];

    return Container(
      margin: const EdgeInsets.only(top: 20, left: Gaps.lg, right: Gaps.lg),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(days.length, (index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onChanged(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? mainColor : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                days[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
