import 'package:classlog/core/features/courses/course.dart';
import 'package:classlog/core/features/courses/course_detail_sheet.dart';
import 'package:classlog/core/providers/courses_provider.dart';
import 'package:classlog/core/theme/app_colors.dart';
import 'package:classlog/core/theme/app_settings.dart';
import 'package:classlog/widgets/course_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyCoursesScreen extends ConsumerStatefulWidget {
  const MyCoursesScreen({super.key});

  @override
  ConsumerState<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends ConsumerState<MyCoursesScreen> {
  int selectedDay = 0; // Dias..

  // Filter courses by selected day
  List<Course> filterCoursesByDay(List<Course> courses, int dayIndex) {
    return courses
        .where((course) => course.dayIndices.contains(dayIndex))
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
    final coursesAsync = ref.watch(coursesProvider);

    return coursesAsync.when(
      data: (courses) => _buildCoursesContent(courses),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              'Error al cargar cursos',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoursesContent(List<Course> allCourses) {
    final filteredCourses = filterCoursesByDay(allCourses, selectedDay);

    return Column(
      children: [
        DaySelector(
          selectedIndex: selectedDay,
          onChanged: (index) {
            setState(() => selectedDay = index);
          },
        ),
        Expanded(
          child: filteredCourses.isEmpty
              ? Center(
                  child: Text(
                    'No hay clases este día',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                )
              : ListView.separated(
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 8),
                        child: CourseCard(
                          courseName: course.name,
                          time: course.timeRange,
                          icon: course.iconData,
                          iconColor: course.colorValue,
                          iconBgColor: course.lightColorValue,
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
