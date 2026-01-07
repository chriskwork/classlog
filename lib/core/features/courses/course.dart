import 'package:flutter/material.dart';

class Course {
  final int id;
  final String name;
  final String description;
  final String? icon;
  final String? color;
  final String? professorName;
  final List<String> days; // L, M, X, J, V
  final String? timeStart;
  final String? timeEnd;
  final String? aula;
  final int attendancePercentage;
  final int attendancePresent;
  final int attendanceTotal;

  Course({
    required this.id,
    required this.name,
    required this.description,
    this.icon,
    this.color,
    this.professorName,
    required this.days,
    this.timeStart,
    this.timeEnd,
    this.aula,
    this.attendancePercentage = 0,
    this.attendancePresent = 0,
    this.attendanceTotal = 0,
  });

  // Convert icon name to IconData
  IconData get iconData {
    switch (icon?.toLowerCase()) {
      case 'calculator':
      case 'calculate':
        return Icons.calculate;
      case 'book':
        return Icons.book;
      case 'code':
        return Icons.code;
      case 'computer':
        return Icons.computer;
      case 'storage':
        return Icons.storage;
      case 'widgets':
        return Icons.widgets;
      default:
        return Icons.school;
    }
  }

  // Convert hex color to Color
  Color get colorValue {
    if (color == null) return Colors.blue;
    try {
      final hexColor = color!.replaceAll('#', '');
      return Color(int.parse('FF$hexColor', radix: 16));
    } catch (e) {
      return Colors.blue;
    }
  }

  // Get light version of color for background
  Color get lightColorValue {
    final c = colorValue;
    return c.withValues(alpha: 0.1);
  }

  // Format time range
  String get timeRange {
    if (timeStart == null || timeEnd == null) return '';
    return '$timeStart - $timeEnd';
  }

  // Convert day letters to day indices (L=0, M=1, X=2, J=3, V=4)
  List<int> get dayIndices {
    return days.map((day) {
      switch (day) {
        case 'L':
          return 0;
        case 'M':
          return 1;
        case 'X':
          return 2;
        case 'J':
          return 3;
        case 'V':
          return 4;
        default:
          return -1;
      }
    }).where((i) => i >= 0).toList();
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    // Parse days from comma-separated string
    List<String> parseDays(String? daysStr) {
      if (daysStr == null || daysStr.isEmpty) return [];
      return daysStr.split(',').map((d) => d.trim()).toList();
    }

    return Course(
      id: int.parse(json['id'].toString()),
      name: json['nombre'] ?? '',
      description: json['descripcion'] ?? '',
      icon: json['icono'],
      color: json['color'],
      professorName: json['profesor_nombre'],
      days: parseDays(json['dias']),
      timeStart: json['hora_inicio'],
      timeEnd: json['hora_fin'],
      aula: json['aula'],
      attendancePercentage: int.parse(json['asistencia_percentage']?.toString() ?? '0'),
      attendancePresent: int.parse(json['asistencia_presente']?.toString() ?? '0'),
      attendanceTotal: int.parse(json['asistencia_total']?.toString() ?? '0'),
    );
  }
}
