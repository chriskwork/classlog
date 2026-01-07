import 'package:classlog/core/features/calendar/calendar_event.dart';
import 'package:classlog/core/theme/app_colors.dart';
import 'package:classlog/core/theme/app_settings.dart';
import 'package:classlog/core/providers/calendar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  EventType _selectedType = EventType.examen;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  // Get events of selected tag
  List<CalendarEvent> _getEventsForDay(
      DateTime day, List<CalendarEvent> allEvents) {
    return allEvents.where((event) {
      return isSameDay(event.date, day) && event.type == _selectedType;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final calendarEventsAsync = ref.watch(calendarEventsProvider);

    return calendarEventsAsync.when(
      data: (events) => _buildCalendarContent(events),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              'Error al cargar eventos',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarContent(List<CalendarEvent> events) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(Gaps.lg),
        child: Column(
          children: [
            _buildTagSelector(),
            SizedBox(height: Sizes.size8),
            _buildCalendar(events),
            const Divider(
              height: 40,
              color: greyColor,
            ),
            _buildEventList(events),
          ],
        ),
      ),
    );
  }

  // ////////////////////////////////////////////////////////////// widgets
  Widget _buildTagSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: EventType.values.map((type) {
          final isSelected = type == _selectedType;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _buildTagChip(type, isSelected),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTagChip(EventType type, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _getTagColor(type) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? _getTagColor(type) : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Text(
          _getTagLabel(type),
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Color _getTagColor(EventType type) {
    switch (type) {
      case EventType.asistencia:
        return EventColors.asistencia;
      case EventType.examen:
        return EventColors.examen;
      case EventType.autoEval:
        return EventColors.autoEval;
      case EventType.proyecto:
        return EventColors.proyecto;
    }
  }

  String _getTagLabel(EventType type) {
    switch (type) {
      case EventType.asistencia:
        return 'Asistencia';
      case EventType.examen:
        return 'Exámenes';
      case EventType.autoEval:
        return 'Auto-Evals';
      case EventType.proyecto:
        return 'Proyecto';
    }
  }

// Calendar part

  Widget _buildCalendar(List<CalendarEvent> events) {
    return TableCalendar<CalendarEvent>(
      firstDay: DateTime.utc(2024, 1, 1),
      lastDay: DateTime.utc(2026, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      eventLoader: (day) => _getEventsForDay(day, events),
      startingDayOfWeek: StartingDayOfWeek.monday,

      // Header
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
        rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
      ),

      // Weeks
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
        weekendStyle: TextStyle(
          color: Colors.grey.shade400,
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
      ),

      // Days
      calendarStyle: CalendarStyle(
        outsideDaysVisible: true,
        outsideTextStyle: TextStyle(color: Colors.grey.shade300),
        defaultTextStyle: const TextStyle(fontSize: 14),
        weekendTextStyle: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade400,
        ),
        selectedDecoration: BoxDecoration(
          color: _getTagColor(_selectedType),
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: _getTagColor(_selectedType),
            width: 1.5,
          ),
        ),
        todayTextStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        markerDecoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        markersMaxCount: 3,
        markerSize: 6,
        markerMargin: const EdgeInsets.symmetric(horizontal: 1),
      ),

      // Dot markers
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          if (events.isEmpty) return null;

          return Positioned(
            bottom: 1,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: events.take(3).map((event) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getMarkerColor(event),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),

      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
    );
  }

  Widget _buildEventList(List<CalendarEvent> allEvents) {
    final events = _selectedDay != null
        ? _getEventsForDay(_selectedDay!, allEvents)
        : <CalendarEvent>[];

    if (events.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Text(
            'No hay eventos para este día',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 12),
          child: Text(
            _formatSelectedDate(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...events.map((event) => _buildEventCard(event)),
      ],
    );
  }

  Widget _buildEventCard(CalendarEvent event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getTagColor(event.type).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getEventIcon(event.type),
              color: _getTagColor(event.type),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.courseName ?? 'Sin nombre',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (event.timeRange != null)
                  Text(
                    event.timeRange!,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
              ],
            ),
          ),

          // Status badge(solo cuando asistancia)
          if (event.type == EventType.asistencia && event.status != null)
            _buildStatusBadge(event.status!),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(AttendanceStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getStatusColor(status),
          width: 1,
        ),
      ),
      child: Text(
        _getStatusLabel(status),
        style: TextStyle(
          color: _getStatusColor(status),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getMarkerColor(CalendarEvent event) {
    if (event.type == EventType.asistencia && event.status != null) {
      return _getStatusColor(event.status!);
    }
    return _getTagColor(event.type);
  }

  Color _getStatusColor(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.presente:
        return EventColors.statusPresente;
      case AttendanceStatus.tarde:
        return EventColors.statusTarde;
      case AttendanceStatus.ausente:
        return EventColors.statusAusente;
    }
  }

  String _getStatusLabel(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.presente:
        return 'Presente';
      case AttendanceStatus.tarde:
        return 'Tarde';
      case AttendanceStatus.ausente:
        return 'Ausente';
    }
  }

  IconData _getEventIcon(EventType type) {
    switch (type) {
      case EventType.asistencia:
        return Icons.check_circle_outline;
      case EventType.examen:
        return Icons.assignment_outlined;
      case EventType.autoEval:
        return Icons.rate_review_outlined;
      case EventType.proyecto:
        return Icons.feedback_outlined;
    }
  }

  String _formatSelectedDate() {
    if (_selectedDay == null) return '';

    final weekdays = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo'
    ];
    final months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];

    final weekday = weekdays[_selectedDay!.weekday - 1];
    final day = _selectedDay!.day;
    final month = months[_selectedDay!.month - 1];

    return '$weekday, $day de $month';
  }
}
