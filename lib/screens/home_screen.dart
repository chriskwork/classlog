import 'package:classlog/screens/calendar_screen.dart';
import 'package:classlog/screens/dashboard_screen.dart';
import 'package:classlog/theme/colors.dart';
import 'package:classlog/theme/settings.dart';
import 'package:classlog/widgets/constants/appbar_notification.dart';
import 'package:classlog/widgets/constants/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

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
          leadingWidth: 60,
          leading: Icon(FeatherIcons.arrowLeft),
          title: Text(
            'Calendario',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          actions: [
            AppBarNotification(),
          ],
        );
      case 2:
        return AppBar(
          leadingWidth: 60,
          leading: Icon(FeatherIcons.arrowLeft),
          title: Text(
            'Mis Cursos',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          actions: [
            AppBarNotification(),
          ],
        );
      case 3:
        return AppBar(
          leadingWidth: 60,
          leading: Icon(FeatherIcons.arrowLeft),
          title: Text(
            'Configuración',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          actions: [
            AppBarNotification(),
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
            Center(child: Text('Mis Cursos')),
            Center(child: Text('Configuración')),
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
