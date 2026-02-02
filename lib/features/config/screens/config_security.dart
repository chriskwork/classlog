import 'package:classlog/features/auth/provider/auth_provider.dart';
import 'package:classlog/app/theme/app_spacing.dart';
import 'package:classlog/shared/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfigSecurity extends ConsumerStatefulWidget {
  const ConfigSecurity({super.key});

  @override
  ConsumerState<ConfigSecurity> createState() => _ConfigSecurityState();
}

class _ConfigSecurityState extends ConsumerState<ConfigSecurity> {
  final _formKey = GlobalKey<FormState>();
  final _emailContoller = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // current email
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authProvider).user;
      if (user != null) {
        _emailContoller.text = user.email;
      }
    });
  }

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
                          labelText:
                              'Nueva Contraseña (opcional, mínimo 6 caracteres)',
                          controller: _passwordController,
                          obscureText: true,
                          validator: (value) {
                            if (value != null &&
                                value.isNotEmpty &&
                                value.length < 6) {
                              return 'Mínimo 6 caracteres';
                            }
                            return null;
                          },
                          isPassword: true,
                        ),

                        // Confirmar Password
                        CustomFormField(
                          labelText: 'Confirmar Nueva Contraseña',
                          controller: _confirmPasswordController,
                          obscureText: true,
                          validator: (value) {
                            if (_passwordController.text.isNotEmpty) {
                              if (value != _passwordController.text) {
                                return 'Las contraseñas no coinciden';
                              }
                            }
                            return null;
                          },
                          isPassword: true,
                        ),

                        SizedBox(
                          height: Sizes.size4,
                        ),

                        // Save
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: FilledButton(
                            onPressed: ref.watch(authProvider).isLoading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      final navigator = Navigator.of(context);
                                      final messenger =
                                          ScaffoldMessenger.of(context);

                                      final currentUser =
                                          ref.read(authProvider).user;
                                      if (currentUser == null) return;

                                      final emailChanged =
                                          _emailContoller.text.trim() !=
                                              currentUser.email;
                                      final passwordChanged =
                                          _passwordController.text.isNotEmpty;

                                      if (!emailChanged && !passwordChanged) {
                                        messenger.showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'No hay cambios para guardar'),
                                            backgroundColor: Colors.orange,
                                          ),
                                        );
                                        return;
                                      }

                                      final success = await ref
                                          .read(authProvider.notifier)
                                          .updateSecurity(
                                            email: emailChanged
                                                ? _emailContoller.text.trim()
                                                : null,
                                            password: passwordChanged
                                                ? _passwordController.text
                                                : null,
                                          );

                                      if (!mounted) return;

                                      if (success) {
                                        messenger.showSnackBar(
                                          SnackBar(
                                            content:
                                                Text('Seguridad actualizada'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                        navigator.pop();
                                      } else {
                                        final error =
                                            ref.read(authProvider).error;
                                        messenger.showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                error ?? 'Error al actualizar'),
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
                                : const Text('Guardar'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))));
  }
}
