import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // ← 반드시 추가!
import 'login.dart'; // LoginPage 클래스가 있는 파일
import 'main_page.dart'; // MainScreen 파일

void main() async {
  // ✅ Flutter 엔진 초기화 (비동기 호출 전 필수)
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ 한국어 날짜 포맷 초기화 (LocaleDataException 해결)
  await initializeDateFormatting('ko_KR', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '프로해빗',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      // ✅ 로그인 화면 혹은 메인 화면으로 연결
      home: const MainScreen(), // 또는 const LoginPage()
    );
  }
}
