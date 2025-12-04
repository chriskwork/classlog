import 'package:flutter/material.dart';

class AppDecorations {
  AppDecorations._();

  static const card = BoxDecoration(
    color: Color(0xFFFFFFFF),
    border: Border.fromBorderSide(
      BorderSide(
        width: 1,
        color: Color(0xFFD9E0E8),
      ),
    ),
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );
}
