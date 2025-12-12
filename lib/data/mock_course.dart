// dummy data for UI
import 'package:flutter/material.dart';

final List<Map<String, dynamic>> courses = const [
  {
    'id': 1,
    'name': 'Programación',
    'time': 'Lun, Mié 09:00-11:00',
    'status': 'Presente',
    'icon': Icons.code,
    'iconColor': Colors.blue,
    'iconBgColor': Color(0xFFE3F2FD),
    'profesor': 'María García',
    'aula': 'Aula 201',
    'asistencia': 0.92,
  },
  {
    'id': 2,
    'name': 'Base de Datos',
    'time': 'Mar, Jue 11:00-13:00',
    'status': 'Ausencia',
    'icon': Icons.storage,
    'iconColor': Colors.orange,
    'iconBgColor': Color(0xFFFFF3E0),
    'profesor': 'Carlos López',
    'aula': 'Aula 105',
    'asistencia': 0.85,
  },
  {
    'id': 3,
    'name': 'Sistemas Informáticos',
    'time': 'Vie 09:00-14:00',
    'status': 'Pendiente',
    'icon': Icons.computer,
    'iconColor': Colors.green,
    'iconBgColor': Color(0xFFE8F5E9),
    'profesor': 'Ana Martínez',
    'aula': 'Aula 302',
    'asistencia': 0.78,
  },
];
