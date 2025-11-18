// lib/services/photo_service.dart

import 'dart:convert';
import 'dart:io' show Platform;              // 그대로 두되
import 'package:flutter/foundation.dart';    // kIsWeb
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class PhotoService {
  static String get baseUrl {
    // 🔹 웹(Chrome)일 때
    if (kIsWeb) {
      // 여기에는 실제 서버 주소로 바꿔도 됨
      return 'http://localhost:8000';
      // 예: return 'http://192.168.0.5:8000';
    }

    // 🔹 안드로이드 에뮬레이터일 때
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000';
    }

    // 🔹 iOS 시뮬레이터 / 데스크탑 등
    return 'http://localhost:8000';
  }

  final _storage = const FlutterSecureStorage();

  Future<List<String>> getMyPhotos() async {
    final accessToken = await _storage.read(key: 'access_token');
    if (accessToken == null) {
      throw Exception("로그인이 필요합니다.");
    }

    final uri = Uri.parse('$baseUrl/api/v1/photos/me');
    final res = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (res.statusCode != 200) {
      throw Exception('사진 목록 불러오기 실패: ${res.body}');
    }

    final data = jsonDecode(res.body);
    final List<dynamic> photos = data['photos'];
    return photos.map<String>((p) => p['image_url'] as String).toList();
  }

  Future<String> uploadPhoto(XFile file) async {
    final accessToken = await _storage.read(key: 'access_token');
    if (accessToken == null) {
      throw Exception("로그인이 필요합니다.");
    }

    final uri = Uri.parse('$baseUrl/api/v1/photos/upload');
    final request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $accessToken';
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        file.path,
      ),
    );

    final streamedRes = await request.send();
    final res = await http.Response.fromStream(streamedRes);

    if (res.statusCode != 201) {
      throw Exception('사진 업로드 실패: ${res.body}');
    }

    final data = jsonDecode(res.body);
    return data['image_url'] as String;
  }
}
