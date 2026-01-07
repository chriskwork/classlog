import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:classlog/core/network/api_service.dart';
import 'package:classlog/core/features/courses/course.dart';

final coursesProvider =
    FutureProvider.autoDispose<List<Course>>((ref) async {
  final apiService = ApiService();

  // API call to get courses
  final response = await apiService.get('cl-student?action=courses&id=1');

  // Parse the response
  if (response['success'] == true && response['data'] != null) {
    final List<dynamic> coursesJson = response['data'];
    return coursesJson
        .map((json) => Course.fromJson(json))
        .toList();
  }

  return [];
});
