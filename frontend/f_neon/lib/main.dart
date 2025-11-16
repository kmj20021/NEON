import 'package:flutter/material.dart';
import 'login.dart'; // LoginPage 클래스가 있는 파일 import
import 'my_page_screen.dart'; // MyPageScreen 클래스가 있는 파일 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const MyPageScreen(), // 여기에 LoginPage 연결!
      debugShowCheckedModeBanner: false, // 상단 debug 배너 제거
    );
  }
}
