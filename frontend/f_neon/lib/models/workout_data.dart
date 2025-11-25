//운동 하나 하나의 데이터를 담는 모델 클래스

class WorkoutData {
  final int id;
  final String name;
  final String description;
  final String bodyPart;
  final String intensity;
  final String image;
  final String youtubeUrl;
  final String detailDescription;

  const WorkoutData({
    required this.id,
    required this.name,
    required this.description,
    required this.bodyPart,
    required this.intensity,
    required this.image,
    required this.youtubeUrl,
    required this.detailDescription,
  });

  /// JSON → Dart
  factory WorkoutData.fromJson(Map<String, dynamic> json) {
    return WorkoutData(
      id: int.parse(json['id'].toString()),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      bodyPart: json['body_part']?.toString() ?? "",       // snake_case 대응
      intensity: json['intensity']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      youtubeUrl: json['youtube_url']?.toString() ?? '',   // snake_case 대응
      detailDescription: json['detail_description']?.toString() ?? '',
    );
  }

  /// Dart → JSON
  /// 백엔드에 보낼 때는 snake_case가 일반적 //but 거의 안씀
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'body_part': bodyPart,
      'intensity': intensity,
      'image': image,
      'youtube_url': youtubeUrl,
      'detail_description': detailDescription,
    };
  }
}
