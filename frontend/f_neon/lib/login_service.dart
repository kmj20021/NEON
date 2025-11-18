import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
// 웹 감지
import 'package:flutter/foundation.dart' show kIsWeb;
// 모바일/데스크톱에서만 사용
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;




class LoginService {
  static const _pcIp = '192.168.226.139'; // 네 PC IP
  static const _useEmulator = false; // true면 에뮬레이터, false면 실기기
    
  static String get baseUrl {
    // 웹일 때
    if (kIsWeb) {
      return 'http://localhost:8000';
    }

    // 안드로이드일 때
    if (Platform.isAndroid) {
      if (_useEmulator) {
        return 'http://10.0.2.2:8000';
      } else {
        // 실기기
        return 'http://$_pcIp:8000';
      }
    }

    // iOS, 기타
    return 'http://$_pcIp:8000';
  }


  final _storage = const FlutterSecureStorage();
  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';

  /// 로그인
  Future<String> login(String id, String pw) async {
  print('🔵 로그인 요청 보냄: $baseUrl/auth/login, id=$id');

  final res = await http.post(
    Uri.parse('$baseUrl/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'id': id, 'pw': pw}),
  );

  print('🟢 응답 코드: ${res.statusCode}');
  print('🟢 응답 바디: ${res.body}');

  if (res.statusCode == 200) {
    try {
      final json = jsonDecode(res.body);
      print('🟢 파싱된 JSON: $json');

      await _storage.write(key: _kAccess, value: json['access_token']);
      await _storage.write(key: _kRefresh, value: json['refresh_token']);
      return json['message'] ?? '로그인 성공';
    } catch (e, st) {
      print('🔴 JSON 파싱 중 에러: $e');
      print(st);
      throw Exception('서버 응답 형식이 올바르지 않습니다.');
    }
  } else {
    final err = _safeErr(res.body);
    print('🔴 에러 응답: $err');
    throw Exception(err);
  }
}

  /// 회원가입
Future<String> signup(
  String id,
  String pw,
  String name,
  String phone,
  String email,
) async {
  print('🟣 baseUrl: $baseUrl');
  print('🟣 회원가입 요청: $baseUrl/users/signup');
  print('🟣 보낸 데이터: id=$id, pw=$pw, name=$name, phone=$phone, email=$email');

  try {
    final res = await http.post(
      Uri.parse('$baseUrl/users/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': id,
        'pw': pw,
        'name': name,
        'phone': phone,
        'email': email,
      }),
    );

    print('🟣 응답 코드: ${res.statusCode}');
    print('🟣 응답 바디: ${res.body}');

    if (res.statusCode == 200) {
      try {
        final json = jsonDecode(res.body);
        print('🟣 파싱된 JSON: $json');

        return json['message']?.toString() ?? '회원가입 완료';
      } catch (e, st) {
        print('🔴 JSON 파싱 중 에러: $e');
        print(st);
        throw Exception('서버 응답 형식 오류(JSON 파싱 실패)');
      }
    } else {
      final err = _safeErr(res.body);
      print('🔴 회원가입 실패: $err');
      throw Exception(err);
    }

  } catch (e, st) {
    print('🔴 signup http.post 에러: $e');
    print(st);
    throw Exception('네트워크 오류: 서버에 연결할 수 없습니다.');
  }
}

  /// 로그아웃
  Future<void> logout() async {
    await _storage.delete(key: _kAccess);
    await _storage.delete(key: _kRefresh);
  }

  // 인증 헤더 생성
  Future<Map<String, String>> _authHeader() async {
    String? access = await _storage.read(key: _kAccess);
    if (access == null) return {};

    if (JwtDecoder.isExpired(access)) {
      await _refreshAccess();
      access = await _storage.read(key: _kAccess);
    }
    return access != null ? {'Authorization': 'Bearer $access'} : {};
  }

  // Access 토큰 재발급
  Future<void> _refreshAccess() async {
    final refresh = await _storage.read(key: _kRefresh);
    if (refresh == null) {
      throw Exception('로그인 필요');
    }

    final res = await http.post(
      Uri.parse('$baseUrl/auth/refresh'),
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

    var res = await http.get(Uri.parse('$baseUrl/auth/me'), headers: headers);
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
      res = await http.get(Uri.parse('$baseUrl/auth/me'), headers: headers2);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
    }

    throw Exception(_safeErr(res.body));
  }

  /// 에러 메시지 파싱
  String _safeErr(String body) {
    try {
      final json = jsonDecode(body);
      return json['detail']?.toString() ?? '요청 실패';
    } catch (_) {
      return '요청 실패';
    }
  }
}
