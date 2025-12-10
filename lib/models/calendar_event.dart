enum EventType {
  asistencia,
  examen,
  autoEval,
  proyecto,
}

enum AttendanceStatus {
  presente,
  tarde,
  ausente,
}

class CalendarEvent {
  final DateTime date;
  final EventType type;
  final AttendanceStatus? status; // presente, tarde, ausente
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

  // TODO: API + later
  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      date: DateTime.parse(json['date']),
      type: EventType.values.byName(json['type']),
      status: json['status'] != null
          ? AttendanceStatus.values.byName(json['status'])
          : null,
      courseId: json['course_id'],
      courseName: json['course_name'],
      timeRange: json['time_range'],
    );
  }
}
