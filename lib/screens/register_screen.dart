import 'package:classlog/theme/colors.dart';
import 'package:classlog/theme/settings.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int selectedIndex = 0;

  // final _formKey = GlobalKey();
  final _emailContoller = TextEditingController();
  final _passwordContoller = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  // final bool _isLoading = false;

  @override
  void dispose() {
    _emailContoller.dispose();
    _passwordContoller.dispose();
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Gaps.lg),
          ),
        ),
      ),
    );
  }
}
