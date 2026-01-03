import 'package:classlog/core/features/calendar/calendar_screen.dart';
import 'package:classlog/core/features/config/config_screen.dart';
import 'package:classlog/core/features/dashboard/dashboard_screen.dart';
import 'package:classlog/core/features/courses/my_courses_screen.dart';
import 'package:classlog/core/theme/app_colors.dart';
import 'package:classlog/core/theme/app_settings.dart';
import 'package:classlog/widgets/constants/appbar_notification.dart';
import 'package:classlog/widgets/constants/bottom_navbar.dart';
import 'package:flutter/material.dart';

// Dashboard page
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  PreferredSizeWidget _getAppBar() {
    switch (_currentIndex) {
      case 0:
        return AppBar(
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
            AppBarNotification(),
          ],
        );
      case 1:
        return AppBar(
          title: Text(
            'Calendario',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        );
      case 2:
        return AppBar(
          title: Text(
            'Mis Cursos',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        );
      case 3:
        return AppBar(
          title: Text(
            'Configuración',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        );

      default:
        return AppBar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _getAppBar(),
        body: IndexedStack(
          index: _currentIndex,
          children: const [
            DashboardScreen(),
            CalendarScreen(),
            MyCoursesScreen(),
            ConfigScreen(),
          ],
        ),

        // Bottom Navigation Bar
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() {
            _currentIndex = index;
          }),
        ));
  }
}
