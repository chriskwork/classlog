import 'package:classlog/theme/colors.dart';
import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const CustomFormField({
    super.key,
    required this.labelText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: lineColor)),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: mainColor))),
          keyboardType: TextInputType.emailAddress,
          validator: validator,
        ),
      ],
    );
  }
}
