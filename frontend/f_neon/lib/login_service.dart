import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:io' show Platform;

class LoginService {
  // 에뮬레이터 환경에 따라 조정
  static String get baseUrl { //getter (속성처럼 보이는)함수
    if (Platform.isAndroid) return 'http://10.0.2.2:8000'; // Android Emulator → host PC
    return 'http://localhost:8000'; // PC, iOS Simulator
  }

  final _storage = const FlutterSecureStorage();
  static const _kAccess = 'access_token'; 
  static const _kRefresh = 'refresh_token';

  /// 비동기 처리 로그인
  Future<String> login(String id, String pw) async { //Future<String> 나중에 받은 데이터를 String으로 반환
    final res = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id, 'pw': pw}),
    );

    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      await _storage.write(key: _kAccess, value: json['access_token']);
      await _storage.write(key: _kRefresh, value: json['refresh_token']);
      return json['message'] ?? '로그인 성공';
    } else {
      final err = _safeErr(res.body);
      throw Exception(err);
    }
  }

  /// 회원가입
  Future<String> signup(String id, String pw) async {
    final res = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id, 'pw': pw}),
    );

    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      return json['message']?.toString() ?? '회원가입 완료';
    } else {
      final err = _safeErr(res.body);
      throw Exception(err);
    }
  }

  /// 로그아웃
  Future<void> logout() async {
    await _storage.delete(key: _kAccess);
    await _storage.delete(key: _kRefresh);
  }

  /// 인증 헤더 생성
  Future<Map<String, String>> _authHeader() async {
    String? access = await _storage.read(key: _kAccess);
    if (access == null) return {};

    // (선택) Access 만료 시 자동 갱신
    if (JwtDecoder.isExpired(access)) {
      await _refreshAccess();
      access = await _storage.read(key: _kAccess);
    }

    return access != null ? {'Authorization': 'Bearer $access'} : {};
  }

  /// Access 토큰 재발급
  Future<void> _refreshAccess() async {
    final refresh = await _storage.read(key: _kRefresh);
    if (refresh == null) {
      throw Exception('로그인 필요');
    }

    final res = await http.post(
      Uri.parse('$baseUrl/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh_token': refresh}),
    );

    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      await _storage.write(key: _kAccess, value: json['access_token']);
    } else {
      await logout();
      final err = _safeErr(res.body);
      throw Exception('세션 만료: $err');
    }
  }

  /// 보호된 API 예시 (/me)
  Future<Map<String, dynamic>> fetchMe() async {
    final headers = {
      'Content-Type': 'application/json',
      ...await _authHeader(),
    };

    var res = await http.get(Uri.parse('$baseUrl/me'), headers: headers);
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }

    // Access 만료 → 한 번만 refresh 후 재시도
    if (res.statusCode == 401) {
      await _refreshAccess();
      final headers2 = {
        'Content-Type': 'application/json',
        ...await _authHeader(),
      };
      res = await http.get(Uri.parse('$baseUrl/me'), headers: headers2);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
    }

    throw Exception(_safeErr(res.body));
  }

  /// 에러 처리 함수
  String _safeErr(String body) {
    try {
      final json = jsonDecode(body);
      return json['detail']?.toString() ?? '요청 실패';
    } catch (_) {
      return '요청 실패';
    }
  }
}
