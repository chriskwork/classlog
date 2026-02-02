import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classlog/shared/network/api_service.dart';
import 'package:classlog/features/calendar/models/calendar_event.dart';
import 'package:classlog/features/auth/provider/auth_provider.dart';

final calendarEventsProvider =
    FutureProvider.autoDispose<List<CalendarEvent>>((ref) async {
  final apiService = ApiService();

  // Get the logged-in user's ID
  final authState = ref.watch(authProvider);
  final userId = authState.user?.id;

  // If no user is logged in, return empty list
  if (userId == null) {
    return [];
  }

  // API call to get calendar events for the logged-in user
  final response = await apiService.get('cl-student?action=calendar&id=$userId');

  // Parse the response
  if (response['success'] == true && response['data'] != null) {
    final List<dynamic> eventsJson = response['data'];
    return eventsJson
        .map((json) => CalendarEvent.fromJson(json))
        .toList();
  }

  return [];
});
