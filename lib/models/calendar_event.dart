enum EventType {
  asistencia,
  examen,
  autoEval,
  proyecto,
}

class CalendarEvent {
  final DateTime date;
  final EventType type;
  final String? status; // presente, tarde, ausente
  final String? courseId;
  final String? courseName;

  CalendarEvent({
    required this.date,
    required this.type,
    this.status,
    this.courseId,
    this.courseName,
  });

  // TODO: API + later
  // factory CalendarEvent.fromJson(Map<String, dynamic> json) {
  //   return CalendarEvent(
  //     date: DateTime.parse(json['date']),
  //     type: EventType.values.byName(json['type']),
  //     status: json['status'],
  //     courseId: json['course_id'],
  //     courseName: json['course_name'],
  //   );
  // }
}
