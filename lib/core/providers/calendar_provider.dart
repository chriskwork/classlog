import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classlog/core/network/api_service.dart';
import 'package:classlog/core/features/calendar/calendar_event.dart';

final calendarEventsProvider =
    FutureProvider.autoDispose<List<CalendarEvent>>((ref) async {
  final apiService = ApiService();

  // API call to get calendar events
  final response = await apiService.get('cl-student?action=calendar&id=1');

  // Parse the response
  if (response['success'] == true && response['data'] != null) {
    final List<dynamic> eventsJson = response['data'];
    return eventsJson
        .map((json) => CalendarEvent.fromJson(json))
        .toList();
  }

  return [];
});
