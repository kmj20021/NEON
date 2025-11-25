import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/workout_data.dart';
import '../models/saved_routine.dart';
import '/login_service.dart';

class WorkoutService {
  final _auth = LoginService();

  // 운동 목록 가져오기
  Future<List<WorkoutData>> fetchWorkouts() async {
    final headers = {
      'Content-Type': 'application/json',
      ...await _auth.getAuthHeader(),   // 🔥 JWT 자동 포함
    };

    final res = await http.get(
      Uri.parse('${LoginService.baseUrl}/workouts'),
      headers: headers,
    );

    if (res.statusCode == 200) {
      final list = jsonDecode(res.body) as List;
      return list.map((e) => WorkoutData.fromJson(e)).toList();
    } else {
      throw Exception("운동 목록 불러오기 실패");
    }
  }

  // 루틴 저장
  Future<SavedRoutine> saveRoutine(String name, List<int> workoutIds) async {
    final headers = {
      'Content-Type': 'application/json',
      ...await _auth.getAuthHeader(),
    };

    final body = jsonEncode({
      'name': name,
      'workout_ids': workoutIds,
    });

    final res = await http.post(
      Uri.parse('${LoginService.baseUrl}/routines'),
      headers: headers,
      body: body,
    );

    if (res.statusCode == 200) {
      return SavedRoutine.fromJson(jsonDecode(res.body));
    }

    throw Exception("루틴 저장 실패");
  }
}
