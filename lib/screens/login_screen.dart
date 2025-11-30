import 'package:classlog/screens/register_screen.dart';
import 'package:classlog/theme/settings.dart';
import 'package:classlog/widgets/role_toggle_btn.dart';
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Padding(
        padding: const EdgeInsets.all(Gaps.md),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: Sizes.size64),
              Image.asset('assets/images/classlog_logo_white.png', width: 160),
              const SizedBox(height: Sizes.size10),
              Text(
                'Sistema de Gestión Estudiantil',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall!.copyWith(color: Colors.white),
              ),
              const SizedBox(height: Sizes.size32),

              // Login form
              SizedBox(
                width: double.infinity,
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        spacing: Sizes.size12,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Iniciar Sesión',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          RoleSegmentToggle(
                            selectedIndex: selectedIndex,
                            onChanged: (index) {
                              setState(() => selectedIndex = index);
                            },
                          ),

                          // Email
                          TextFormField(
                            controller: _emailContoller,
                            decoration: const InputDecoration(
                              labelText: 'Correo electrónico',
                              labelStyle: TextStyle(
                                fontSize: 12,
                                letterSpacing: -0.1,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
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
                          TextFormField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Contraseña(Más de 6 caracteres)',
                              labelStyle: TextStyle(
                                fontSize: 12,
                                letterSpacing: -0.1,
                              ),
                            ),
                            obscureText: true, //
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
                                  // TODO: login
                                }
                              },
                              child: const Text(
                                'Iniciar sesión',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
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
          style: const TextStyle(color: Colors.white54, fontSize: 10),
        ),
      ),
    );
  }
}
