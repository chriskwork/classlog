import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classlog/shared/network/api_service.dart';
import 'package:classlog/features/courses/models/course.dart';
import 'package:classlog/features/auth/provider/auth_provider.dart';

final coursesProvider = FutureProvider.autoDispose<List<Course>>((ref) async {
  final apiService = ApiService();

  // chehck user id
  final authState = ref.watch(authProvider);
  final userId = authState.user?.id;

  if (userId == null) {
    return [];
  }

  final response = await apiService.get('cl-student?action=courses&id=$userId');

  if (response['success'] == true && response['data'] != null) {
    final List<dynamic> coursesJson = response['data'];
    return coursesJson.map((json) => Course.fromJson(json)).toList();
  }

  return [];
});
