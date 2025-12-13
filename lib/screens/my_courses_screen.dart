import 'package:classlog/data/mock_course.dart';
import 'package:classlog/screens/course_detail_sheet.dart';
import 'package:classlog/theme/colors.dart';
import 'package:classlog/theme/settings.dart';
import 'package:classlog/widgets/course_card.dart';
import 'package:flutter/material.dart';

class MyCoursesScreen extends StatelessWidget {
  const MyCoursesScreen({super.key});

  //
  void _showCourseDetail(BuildContext context, Map<String, dynamic> course) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GestureDetector(
        onTap: () => Navigator.pop(context),
        behavior: HitTestBehavior.opaque,
        child: GestureDetector(
            onTap: () {}, child: CourseDetailSheet(course: course)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: const EdgeInsets.all(Gaps.lg),
        itemCount: courses.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final course = courses[index];
          return DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: lineColor,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: CourseCard(
                courseName: course['name'],
                time: course['time'],
                icon: course['icon'],
                iconColor: course['iconColor'],
                iconBgColor: course['iconBgColor'],
                onTap: () => _showCourseDetail(context, course),
              ),
            ),
          );
        });
  }
}
