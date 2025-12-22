import 'package:classlog/theme/settings.dart';
import 'package:classlog/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';

class ConfigSecurity extends StatefulWidget {
  const ConfigSecurity({super.key});

  @override
  State<ConfigSecurity> createState() => _ConfigSecurityState();
}

class _ConfigSecurityState extends State<ConfigSecurity> {
  final _formKey = GlobalKey<FormState>();
  final _emailContoller = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  // final bool _isLoading = false;

  @override
  void dispose() {
    _emailContoller.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Seguridad"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(Gaps.lg),
            child: GestureDetector(
                onTap: FocusScope.of(context).unfocus,
                child: SizedBox(
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
                          isPassword: true,
                        ),

                        // Confirmar Password
                        CustomFormField(
                          labelText: 'Confirmar Contraseña',
                          controller: _confirmPasswordController,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Contraseña requerida';
                            }
                            if (value.length < 6) {
                              return 'Mínimo 6 caracteres';
                            }
                            if (value != _passwordController.text) {
                              return 'Las contraseñas no coinciden';
                            }
                            return null;
                          },
                          isPassword: true,
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
                          height: 48,
                          child: FilledButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                print("ok");
                                // login logis here ###########
                              }
                            },
                            child: const Text(
                              'Guardar',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))));
  }
}
