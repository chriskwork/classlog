import 'package:classlog/features/auth/provider/auth_provider.dart';
import 'package:classlog/app/theme/app_spacing.dart';
import 'package:classlog/shared/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfigEditProfile extends ConsumerStatefulWidget {
  const ConfigEditProfile({super.key});

  @override
  ConsumerState<ConfigEditProfile> createState() => _ConfigEditProfileState();
}

class _ConfigEditProfileState extends ConsumerState<ConfigEditProfile> {
  final _formKey = GlobalKey<FormState>();
  final _nombreContoller = TextEditingController();
  final _apellidosController = TextEditingController();
  final _telefonoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // cargar datos de user
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authProvider).user;
      if (user != null) {
        _nombreContoller.text = user.nombre;
        _apellidosController.text = user.apellidos;
        _telefonoController.text = user.telefono ?? '';
      }
    });
  }

  @override
  void dispose() {
    _nombreContoller.dispose();
    _apellidosController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Editar Perfil"),
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
                          labelText: 'Nombre',
                          controller: _nombreContoller,
                          inputFomatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[^0-9]'))
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nombre requerido';
                            }
                            return null;
                          },
                          obscureText: false,
                        ),

                        // Password
                        CustomFormField(
                          labelText: 'Apellidos',
                          controller: _apellidosController,
                          inputFomatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[^0-9]'))
                          ],
                          obscureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Apellido(s) requerido';
                            }
                            return null;
                          },
                        ),

                        // Confirmar Password
                        CustomFormField(
                          labelText: 'Teléfono',
                          keyboardType: TextInputType.phone,
                          inputFomatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(9),
                          ],
                          controller: _telefonoController,
                          obscureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Teléfono requerido';
                            }
                            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                              return 'Solo números permitidos';
                            }
                            if (value.length != 9) {
                              return 'Debe tener 9 dígitos';
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

                                      final success = await ref
                                          .read(authProvider.notifier)
                                          .updateProfile(
                                            nombre:
                                                _nombreContoller.text.trim(),
                                            apellidos: _apellidosController.text
                                                .trim(),
                                            telefono: _telefonoController.text
                                                    .trim()
                                                    .isEmpty
                                                ? null
                                                : _telefonoController.text
                                                    .trim(),
                                          );

                                      if (!mounted) return;

                                      if (success) {
                                        messenger.showSnackBar(
                                          SnackBar(
                                            content: Text('Perfil actualizado'),
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
