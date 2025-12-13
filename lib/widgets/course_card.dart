import 'package:classlog/theme/colors.dart';
import 'package:classlog/theme/settings.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String courseName;
  final String time;
  final String? status;
  final VoidCallback? onTap;

  const CourseCard({
    super.key,
    required this.courseName,
    required this.time,
    this.status,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: Gaps.sm,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: iconBgColor,
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                icon,
                color: iconColor,
                size: 30,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  courseName, // DB - class title
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  time, // DB - time here
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: secondaryColor,
                      ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 4,
          ),
          if (status != null)
            DecoratedBox(
              decoration: BoxDecoration(
                color: switch (status) {
                  "Presente" => Colors.greenAccent[100],
                  "Ausencia" => Colors.red[200],
                  _ => Colors.grey[200],
                },
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  status!,
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: secondaryColor,
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
