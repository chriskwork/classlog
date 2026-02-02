import 'package:classlog/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class CustomFormField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final IconData? suffixIcon;
  final bool isPassword;
  final List<TextInputFormatter>? inputFomatters;

  const CustomFormField({
    super.key,
    required this.labelText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    required this.validator,
    this.suffixIcon,
    this.isPassword = false,
    required bool obscureText,
    this.inputFomatters,
  });

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  bool obscureText = false;

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
          ),
        ),
        SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: widget.controller,
          obscureText: obscureText,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFomatters,
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
                    icon: obscureText
                        ? Icon(
                            FeatherIcons.eye,
                            size: 18,
                            color: textSecondaryColor,
                          )
                        : Icon(
                            FeatherIcons.eyeOff,
                            size: 18,
                            color: textSecondaryColor,
                          ),
                  )
                : null,
          ),
          validator: widget.validator,
        ),
      ],
    );
  }
}
