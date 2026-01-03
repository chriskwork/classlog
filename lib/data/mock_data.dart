import '../core/features/calendar/calendar_event.dart';

class MockCalendarData {
  static List<CalendarEvent> getEvents() {
    return [
      CalendarEvent(
        date: DateTime(2025, 11, 3),
        type: EventType.asistencia,
        status: AttendanceStatus.presente,
        courseName: 'Desarrollo de Interfaces',
        timeRange: '15:00 - 18:00',
      ),
      CalendarEvent(
        date: DateTime(2025, 11, 4),
        type: EventType.asistencia,
        status: AttendanceStatus.presente,
        courseName: 'Programación Multimedia',
        timeRange: '09:00 - 12:00',
      ),
      CalendarEvent(
        date: DateTime(2025, 11, 5),
        type: EventType.asistencia,
        status: AttendanceStatus.tarde,
        courseName: 'Acceso a Datos',
        timeRange: '12:00 - 14:00',
      ),
      CalendarEvent(
        date: DateTime(2025, 11, 6),
        type: EventType.asistencia,
        status: AttendanceStatus.tarde,
        courseName: 'Desarrollo de Interfaces',
        timeRange: '15:00 - 18:00',
      ),
      CalendarEvent(
        date: DateTime(2025, 11, 9),
        type: EventType.asistencia,
        status: AttendanceStatus.ausente,
        courseName: 'Programación Multimedia',
        timeRange: '09:00 - 12:00',
      ),
      CalendarEvent(
        date: DateTime(2025, 11, 10),
        type: EventType.asistencia,
        status: AttendanceStatus.ausente,
        courseName: 'Acceso a Datos',
        timeRange: '12:00 - 14:00',
      ),
      CalendarEvent(
        date: DateTime(2025, 11, 11),
        type: EventType.asistencia,
        status: AttendanceStatus.presente,
        courseName: 'Desarrollo de Interfaces',
        timeRange: '15:00 - 18:00',
      ),
      CalendarEvent(
        date: DateTime(2025, 11, 12),
        type: EventType.asistencia,
        status: AttendanceStatus.presente,
        courseName: 'Desarrollo de Interfaces',
        timeRange: '15:00 - 18:00',
      ),
      CalendarEvent(
        date: DateTime(2025, 11, 12),
        type: EventType.asistencia,
        status: AttendanceStatus.presente,
        courseName: 'Programación Multimedia',
        timeRange: '09:00 - 12:00',
      ),

      // 시험 데이터
      CalendarEvent(
        date: DateTime(2025, 11, 20),
        type: EventType.examen,
        courseName: 'Acceso a Datos',
        timeRange: '10:00 - 12:00',
      ),
      CalendarEvent(
        date: DateTime(2025, 11, 25),
        type: EventType.examen,
        courseName: 'Desarrollo de Interfaces',
        timeRange: '15:00 - 17:00',
      ),

      // 자가평가
      CalendarEvent(
        date: DateTime(2025, 11, 18),
        type: EventType.autoEval,
        courseName: 'Programación Multimedia',
      ),
    ];
  }
}
