// lib/models/saved_routine.dart

class SavedRoutine {
  /// 루틴 고유 ID (백엔드에서 생성해 준 값)
  final String id;

  /// 사용자가 붙인 루틴 이름 (예: '상체 루틴', '하체 폭발 루틴')
  final String name;

  /// 이 루틴에 포함된 운동들의 ID 목록
  /// 예: [1, 5, 6]
  final List<int> workoutIds;

  /// 루틴이 생성된 시간
  final DateTime createdAt;

  const SavedRoutine({
    required this.id,
    required this.name,
    required this.workoutIds,
    required this.createdAt,
  });

  /// JSON → SavedRoutine
  /// 백엔드에서 이런 형태로 응답한다고 가정:
  /// {
  ///   "id": "abc123",
  ///   "name": "상체 루틴",
  ///   "workout_ids": [1, 5, 6],
  ///   "created_at": "2025-11-23T08:30:00Z"
  /// }
  // 팩토리 생성자 서버에서 가져온 JSON 데이터를 SavedRoutine 객체로 변환
  factory SavedRoutine.fromJson(Map<String, dynamic> json) {
    return SavedRoutine(
      id: json['id'].toString(),
      name: json['name']?.toString() ?? '',
      workoutIds: (json['workout_ids'] as List<dynamic>?)
              ?.map((e) => int.parse(e.toString()))
              .toList() ??
          <int>[],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
    );
  }

  /// SavedRoutine → JSON
  /// 백엔드로 보낼 때 이런 형태로 보내기:
  /// {
  ///   "id": "abc123",
  ///   "name": "상체 루틴",
  ///   "workout_ids": [1, 5, 6],
  ///   "created_at": "2025-11-23T08:30:00Z"
  /// }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'workout_ids': workoutIds,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// 변경된 값만 살짝 바꾸고 싶을 때 사용 (불변 객체 패턴)
  SavedRoutine copyWith({
    String? id,
    String? name,
    List<int>? workoutIds,
    DateTime? createdAt,
  }) {
    return SavedRoutine(
      id: id ?? this.id,
      name: name ?? this.name,
      workoutIds: workoutIds ?? this.workoutIds,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
