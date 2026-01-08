import 'package:classlog/home_screen.dart';
import 'package:classlog/core/features/auth/screens/register_screen.dart';
import 'package:classlog/core/providers/auth_provider.dart';
import 'package:classlog/core/theme/app_colors.dart';
import 'package:classlog/core/theme/app_settings.dart';
import 'package:classlog/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // controllers
  final _formKey = GlobalKey<FormState>();
  final _emailContoller = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailContoller.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Gaps.lg),
              child: Column(
                children: [
                  const SizedBox(height: 48),
                  Image.asset('assets/images/classlog_logo_blue.png',
                      width: 220),
                  const SizedBox(height: Sizes.size10),
                  Text(
                    'Centro de Formación Digital Skills',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.copyWith(color: greyColor),
                  ),
                  const SizedBox(height: Sizes.size64),

                  // Login form
                  SizedBox(
                    width: double.infinity,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        spacing: Sizes.size12,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Email
                          CustomFormField(
                            labelText: 'Correo Electrónico',
                            controller: _emailContoller,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Correo requerido';
                              }
                              if (!value.contains('@')) {
                                return 'Correo no válido';
                              }
                              return null;
                            },
                            obscureText: false,
                          ),

                          // Password
                          CustomFormField(
                            labelText: 'Contraseña',
                            controller: _passwordController,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Contraseña requerida';
                              }
                              if (value.length < 6) {
                                return 'Mínimo 6 caracteres';
                              }
                              return null;
                            },
                            isPassword: true,
                          ),
                          SizedBox(
                            height: Sizes.size4,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {},
                              child: Text(
                                '¿Olvidaste tu contraseña?',
                                style: TextStyle(
                                  color: mainColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Sizes.size4,
                          ),

                          // Login button
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: ref.watch(authProvider).isLoading
                                  ? null
                                  : () async {
                                      if (_formKey.currentState!.validate()) {
                                        final navigator = Navigator.of(context);
                                        final messenger =
                                            ScaffoldMessenger.of(context);

                                        final success = await ref
                                            .read(authProvider.notifier)
                                            .login(
                                              _emailContoller.text.trim(),
                                              _passwordController.text,
                                            );

                                        if (!mounted) return;

                                        if (success) {
                                          navigator.pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeScreen(),
                                            ),
                                          );
                                        } else {
                                          final error =
                                              ref.read(authProvider).error;
                                          messenger.showSnackBar(
                                            SnackBar(
                                              content: Text(error ??
                                                  'Error al iniciar sesión'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      }
                                    },
                              child: ref.watch(authProvider).isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('Iniciar sesión'),
                            ),
                          ),

                          SizedBox(
                            height: Sizes.size4,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('¿No tienes cuenta?'),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => RegisterScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Regístrate',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: Sizes.size32),
        child: Text(
          'Classlog ©${DateTime.now().year}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: greyColor, fontSize: 12),
        ),
      ),
    );
  }
}
