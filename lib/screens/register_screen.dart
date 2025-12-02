import 'package:classlog/theme/colors.dart';
import 'package:classlog/theme/settings.dart';
import 'package:classlog/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int selectedIndex = 0;

  final _formKey = GlobalKey<FormState>();
  final _emailContoller = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  // final bool _isLoading = false;

  @override
  void dispose() {
    _emailContoller.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    // debugPrint('registracion disposed');
    super.dispose();
  }

  // Future<void> _onSubmit() async {
  //   if(!_formKey.currentState!.validate()){
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Por favor, revisa los campos del formulario')),
  //     );
  //     return;
  //   }
  // }

  // setState(() => _isLoading = true);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: bgLightColor,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.chevron_left_rounded),
          ),
          title: Text(
            'Registrar',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          backgroundColor: bgLightColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Gaps.lg),
            child: Column(
              children: [
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
                          labelText: 'Contraseña(Más de 6 caracteres)',
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
                        ),

                        // Confirmar Password
                        CustomFormField(
                          labelText: 'Confirmar Contraseña',
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
                        ),
                        SizedBox(
                          height: Sizes.size4,
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
      ),
    );
  }
}
