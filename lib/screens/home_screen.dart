import 'package:classlog/theme/colors.dart';
import 'package:classlog/theme/settings.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          backgroundColor: greyColor,
        ),
        title: Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Gaps.lg),
        child: Column(
          children: [
            Text(
              'Clases de Hoy',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
