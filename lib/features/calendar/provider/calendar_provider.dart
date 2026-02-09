import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classlog/shared/network/api_service.dart';
import 'package:classlog/features/calendar/models/calendar_event.dart';
import 'package:classlog/features/auth/provider/auth_provider.dart';

final calendarEventsProvider =
    FutureProvider.autoDispose<List<CalendarEvent>>((ref) async {
  final apiService = ApiService();

  // check id de usuario actual
  final authState = ref.watch(authProvider);
  final userId = authState.user?.id;

  if (userId == null) {
    return [];
  }

  // obtener datos de eventos para usuario actual
  final response =
      await apiService.get('cl-student?action=calendar&id=$userId');

  if (response['success'] == true && response['data'] != null) {
    final List<dynamic> eventsJson = response['data'];
    return eventsJson.map((json) => CalendarEvent.fromJson(json)).toList();
  }

  return [];
});
