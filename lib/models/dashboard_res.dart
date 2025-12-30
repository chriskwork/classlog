class DashboardResponse {
  final bool success;
  final DashboardData data;

  DashboardResponse({
    required this.success,
    required this.data,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
        success: json['success'] ?? false,
        data: DashboardData.fromJson(json['data']));
  }
}

class DashboardData {
  final String studentId;
  final String today;
  final String dayOfWeek;
  final List<TodaySchedule> todaySchedule;
  final List<dynamic> todayAttendance;
  final List<UpcomingEvent> upcomingEvents;

  DashboardData({
    required this.studentId,
    required this.today,
    required this.dayOfWeek,
    required this.todaySchedule,
    required this.todayAttendance,
    required this.upcomingEvents,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      studentId: json['student_id'] ?? '',
      today: json['today'] ?? '',
      dayOfWeek: json['dat_of_week'] ?? '',
      todaySchedule: (json['today_schedule'] as List?)
              ?.map((e) => TodaySchedule.fromJson(e))
              .toList() ??
          [],
      todayAttendance: json['today_attendance'] ?? '',
      upcomingEvents: (json['upcoming_events'] as List?)
              ?.map((e) => UpcomingEvent.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class TodaySchedule {
  final String cursoNombre;
  final String horaInicio;
  final String horaFin;
  final String aula;
  final String icono;
  final String color;

  TodaySchedule({
    required this.cursoNombre,
    required this.horaInicio,
    required this.horaFin,
    required this.aula,
    required this.icono,
    required this.color,
  });

  factory TodaySchedule.fromJson(Map<String, dynamic> json) {
    return TodaySchedule(
      cursoNombre: json['curso_nombre'] ?? '',
      horaInicio: json['hora_inicio'] ?? '',
      horaFin: json['hora_fin'] ?? '',
      aula: json['aula'] ?? '',
      icono: json['icono'] ?? 'book',
      color: json['color'] ?? '#3B82F6',
    );
  }
}

class UpcomingEvent {
  final String titulo;
  final String tipo;
  final String fechaLimite;

  UpcomingEvent({
    required this.titulo,
    required this.tipo,
    required this.fechaLimite,
  });

  factory UpcomingEvent.fromJson(Map<String, dynamic> json) {
    return UpcomingEvent(
      titulo: json['titulo'] ?? '',
      tipo: json['tipo'] ?? '',
      fechaLimite: json['fecha_limite'] ?? '',
    );
  }
}
