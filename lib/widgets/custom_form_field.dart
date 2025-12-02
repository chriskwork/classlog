import 'package:classlog/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/fa.dart';

class CustomFormField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Iconify? suffixIcon;
  final bool isPassword;

  const CustomFormField({
    super.key,
    required this.labelText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    required this.validator,
    this.suffixIcon,
    this.isPassword = false,
    required bool obscureText,
  });

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  bool obscureText = false; // ✅ 바로 초기화

  @override
  void initState() {
    super.initState();
    obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: widget.controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: lineColor)),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: mainColor),
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                    icon: Iconify(
                      obscureText ? Fa.eye : Fa.eye_slash,
                      size: 18,
                      color: textSecondaryColor,
                    ),
                  )
                : null,
          ),
          keyboardType: TextInputType.emailAddress,
          validator: widget.validator,
        ),
      ],
    );
  }
}
