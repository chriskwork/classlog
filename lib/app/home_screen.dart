import 'package:classlog/app/theme/app_spacing.dart';
import 'package:classlog/features/calendar/screens/calendar_screen.dart';
import 'package:classlog/features/config/screens/config_screen.dart';
import 'package:classlog/features/dashboard/screens/dashboard_screen.dart';
import 'package:classlog/features/courses/screens/my_courses_screen.dart';
// import 'package:classlog/shared/constants/appbar_notification.dart';
import 'package:classlog/shared/constants/bottom_navbar.dart';
import 'package:flutter/material.dart';

// Dashboard page
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Cambiar appbar title depende de la nav menu
  PreferredSizeWidget _getAppBar() {
    switch (_currentIndex) {
      case 0:
        return AppBar(
          actionsPadding: EdgeInsets.symmetric(horizontal: Gaps.md),
          title: Text(
            'Dashboard',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          scrolledUnderElevation: 0,
          actions: [
            // AppBarNotification(),
            Icon(Icons.menu),
          ], // 📌 para mas tarde.
        );
      case 1:
        return AppBar(
          actionsPadding: EdgeInsets.symmetric(horizontal: Gaps.md),
          title: Text(
            'Calendario',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          scrolledUnderElevation: 0,
          actions: [
            Icon(Icons.menu),
          ],
        );
      case 2:
        return AppBar(
          actionsPadding: EdgeInsets.symmetric(horizontal: Gaps.md),
          title: Text(
            'Mis Cursos',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          scrolledUnderElevation: 0,
          actions: [
            Icon(Icons.menu),
          ],
        );
      case 3:
        return AppBar(
          actionsPadding: EdgeInsets.symmetric(horizontal: Gaps.md),
          title: Text(
            'Configuración',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          scrolledUnderElevation: 0,
          actions: [
            Icon(Icons.menu),
          ],
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
