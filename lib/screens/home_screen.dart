import 'package:classlog/theme/colors.dart';
import 'package:classlog/theme/settings.dart';
import 'package:classlog/widgets/constants/app_decorations.dart';
import 'package:classlog/widgets/course_card.dart';
import 'package:flutter/material.dart';

// Dashboard page
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 60,
        leading: Padding(
          padding: const EdgeInsets.only(left: Gaps.md),
          child: CircleAvatar(
            backgroundColor: lineColor,
          ),
        ),
        title: Text(
          'Dashboard',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: Gaps.md),
            child: Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(Gaps.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Clases de Hoy
            Text(
              'Clases de Hoy',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Gaps.szBoxV10,
            SizedBox(
              width: double.infinity,
              child: DecoratedBox(
                decoration: AppDecorations.card,
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.size16),
                  child: Column(
                    spacing: Sizes.size16,
                    children: [
                      CourseCard(
                        courseName: 'Desarrollo de Interfaces',
                        time: '15:00 - 18:00',
                        status: 'Presente',
                        icon: Icons.video_stable_rounded,
                        iconColor: Color(0xFF3434B8),
                        iconBgColor: Color(0x153434B8),
                      ),
                      CourseCard(
                        courseName: 'Programación Multimedia',
                        time: '18:00 - 21:00',
                        status: 'Pendiente',
                        icon: Icons.code_rounded,
                        iconColor: Color(0xFF2FA7B2),
                        iconBgColor: Color(0x152FA7B2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Gaps.szBoxV20,
            SizedBox(
              width: double.infinity,
              child: DecoratedBox(
                decoration: AppDecorations.card,
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.size16),
                  child: Column(
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
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
