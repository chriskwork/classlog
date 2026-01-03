import 'package:classlog/core/theme/app_settings.dart';
import 'package:classlog/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConfigEditProfile extends StatefulWidget {
  const ConfigEditProfile({super.key});

  @override
  State<ConfigEditProfile> createState() => _ConfigEditProfileState();
}

class _ConfigEditProfileState extends State<ConfigEditProfile> {
  final _formKey = GlobalKey<FormState>();
  final _nombreContoller = TextEditingController();
  final _apellidosController = TextEditingController();
  final _telefonoController = TextEditingController();
  // final bool _isLoading = false;

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
