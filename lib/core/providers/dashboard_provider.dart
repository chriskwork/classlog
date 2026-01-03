import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classlog/core/network/api_service.dart';
import 'package:classlog/core/features/dashboard/models/dashboard_res.dart';

final dashboardProvider =
    FutureProvider.autoDispose<DashboardData>((ref) async {
  final apiService = ApiService();

  // API
  final response = await apiService.get('cl-student?action=dashboard&id=1');
  final dashboardResponse = DashboardResponse.fromJson(response);

  return dashboardResponse.data;
});
