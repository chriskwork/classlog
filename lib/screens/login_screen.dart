import 'package:classlog/screens/register_screen.dart';
import 'package:classlog/theme/colors.dart';
import 'package:classlog/theme/settings.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int selectedIndex = 0;

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
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: bgLightColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Gaps.lg),
            child: Column(
              children: [
                const SizedBox(height: 120),
                Image.asset('assets/images/classlog_logo_blue.png', width: 160),
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
                        ),

                        // Password
                        CustomFormField(
                          labelText: 'Contraseña(Más de 6 caracteres)',
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Contraseña requerida';
                            }
                            if (value.length < 6) {
                              return 'Mínimo 6 caracteres';
                            }
                            return null;
                          },
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
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                debugPrint('role: $selectedIndex');
                                debugPrint('email: ${_emailContoller.text}');
                                debugPrint(
                                  'password: ${_passwordController.text}',
                                );
                                // login logis here ###########
                              }
                            },
                            child: const Text(
                              'Iniciar sesión',
                            ),
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
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: Sizes.size32), // ✅ 수정
          child: Text(
            'Classlog ©${DateTime.now().year}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: greyColor, fontSize: 12),
          ),
        ),
      ),
    );
  }
}

class CustomFormField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const CustomFormField({
    super.key,
    required this.labelText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: lineColor)),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: mainColor))),
          keyboardType: TextInputType.emailAddress,
          validator: validator,
        ),
      ],
    );
  }
}
