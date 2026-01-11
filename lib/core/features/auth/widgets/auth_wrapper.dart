import 'package:classlog/core/features/auth/screens/login_screen.dart';
import 'package:classlog/core/providers/auth_provider.dart';
import 'package:classlog/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    if (authState.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // auth ok -> homescreen
    if (authState.isAuthenticated && authState.user != null) {
      return HomeScreen();
    }

    return const LoginScreen();
  }
}
