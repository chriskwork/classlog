import 'package:classlog/core/theme/app_settings.dart';
import 'package:flutter/material.dart';

class AppBarNotification extends StatelessWidget {
  const AppBarNotification({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: Gaps.md),
      child: Icon(Icons.notifications_none_rounded),
    );
  }
}
