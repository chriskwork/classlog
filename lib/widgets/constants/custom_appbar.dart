import 'package:classlog/core/theme/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class CustomAppBar extends StatelessWidget {
  final String text;

  const CustomAppBar({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 60,
      leading: Icon(FeatherIcons.arrowLeft),
      title: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: Gaps.md),
          child: Icon(Icons.notifications_none_rounded),
        ),
      ],
    );
  }
}
