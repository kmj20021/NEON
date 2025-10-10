import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  static const String baseUrl = 'http://localhost:8000'; // 안드로이드 에뮬레이터 기준

  Future<String> login(String id, String pw) async {
    final res = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id, 'pw': pw}),
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body)['message'];
    } else {
      throw Exception(jsonDecode(res.body)['detail']);
    }
  }
}
