import 'package:classlog/home_screen.dart';
import 'package:classlog/core/providers/auth_provider.dart';
import 'package:classlog/core/theme/app_settings.dart';
import 'package:classlog/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  // controllers
  final _formKey = GlobalKey<FormState>();
  final _emailContoller = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void dispose() {
    _emailContoller.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: SingleChildScrollView(
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
                        // Nombre
                        CustomFormField(
                          labelText: 'Nombre',
                          controller: _nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nombre requerido';
                            }
                            return null;
                          },
                          obscureText: false,
                        ),

                        // Apellidos
                        CustomFormField(
                          labelText: 'Apellidos',
                          controller: _lastNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Apellidos requeridos';
                            }
                            return null;
                          },
                          obscureText: false,
                        ),

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
                          labelText: 'Contraseña (Más de 6 caracteres)',
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

                        // Register button
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
                                          .register(
                                            email: _emailContoller.text.trim(),
                                            password: _passwordController.text,
                                            nombre: _nameController.text.trim(),
                                            apellidos:
                                                _lastNameController.text.trim(),
                                          );

                                      if (!mounted) return;

                                      if (success) {
                                        navigator.pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) => HomeScreen(),
                                          ),
                                        );
                                      } else {
                                        final error =
                                            ref.read(authProvider).error;
                                        messenger.showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                error ?? 'Error al registrar'),
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
                                : const Text('Registrar'),
                          ),
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
