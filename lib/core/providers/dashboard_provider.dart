import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classlog/core/network/api_service.dart';
import 'package:classlog/core/features/dashboard/models/dashboard_res.dart';
import 'package:classlog/core/providers/auth_provider.dart';

final dashboardProvider =
    FutureProvider.autoDispose<DashboardData>((ref) async {
  final apiService = ApiService();

  final authState = ref.watch(authProvider);
  final userId = authState.user?.id;

  if (userId == null) {
    throw Exception('No hay usuario con $userId');
  }

  // API
  final response =
      await apiService.get('cl-student?action=dashboard&id=$userId');
  final dashboardResponse = DashboardResponse.fromJson(response);

  return dashboardResponse.data;
});
