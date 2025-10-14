import 'package:flutter/material.dart';
import 'accept.dart';
import 'login.dart'; // LoginPage 클래스가 있는 파일 import

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
      home: const AcceptPage(), // 여기에 LoginPage 연결!
      debugShowCheckedModeBanner: false, // 상단 debug 배너 제거
    );
  }
}
