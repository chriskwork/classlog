enum EventType {
  examen,
  autoEval,
  proyecto,
  asistencia,
}

enum AttendanceStatus {
  presente,
  tarde,
  ausente,
}

class CalendarEvent {
  final DateTime date;
  final EventType type;
  final AttendanceStatus? status;
  final String? courseId;
  final String? courseName;
  final String? timeRange;

  CalendarEvent({
    required this.date,
    required this.type,
    this.status,
    this.courseId,
    this.courseName,
    this.timeRange,
  });

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    // Parse event type - handle different formats from DB
    EventType parseEventType(String tipo) {
      switch (tipo.toLowerCase()) {
        case 'examen':
          return EventType.examen;
        case 'auto-evals':
        case 'autoevals':
        case 'autoeval':
          return EventType.autoEval;
        case 'proyecto':
          return EventType.proyecto;
        case 'asistencia':
          return EventType.asistencia;
        default:
          return EventType.examen; // default fallback
      }
    }

    return CalendarEvent(
      date: DateTime.parse(json['fecha_limite'] ?? json['date']),
      type: parseEventType(json['tipo'] ?? json['type']),
      status: json['status'] != null
          ? AttendanceStatus.values.byName(json['status'])
          : null,
      courseId: json['curso_id']?.toString() ?? json['course_id'],
      courseName: json['curso_nombre'] ?? json['titulo'] ?? json['course_name'],
      timeRange: json['time_range'],
    );
  }
}
