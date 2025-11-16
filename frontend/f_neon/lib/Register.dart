import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_service.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _svc = LoginService();
  final _idController = TextEditingController();
  final _pwController = TextEditingController();
  final _pwCheckController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  String? _msg;

  // 회원가입 함수
  Future<void> _registerUser() async {
    setState(() {
      _msg = null;
    });

    try {
      final id = _idController.text.trim();
      final pw = _pwController.text;
      final pw2 = _pwCheckController.text;
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final phone = _phoneController.text.trim();

      if (id.isEmpty) {
        throw Exception('ID를 입력해 주세요.');
      }
      if (pw.isEmpty) {
        throw Exception('비밀번호를 입력해 주세요.');
      }
      if (pw != pw2) {
        throw Exception('비밀번호가 일치하지 않습니다.');
      }
      if (name.isEmpty) {
        throw Exception('이름을 입력해 주세요.');
      }
      if (email.isEmpty) {
        throw Exception('이메일을 입력해 주세요.');
      }
      if (phone.isEmpty) {
        throw Exception('휴대폰 번호를 입력해 주세요.');
      }

      final msg = await _svc.signup(id, pw, name, phone, email);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      Navigator.pop(context, true);
    } catch (e) {
      setState(() => _msg = e.toString().replaceFirst('Exception: ', ''));
    }
  } //회원가입 함수

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    _pwCheckController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  //UI 빌드
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // 키보드 올라와도 공간 확보
      backgroundColor: const Color.fromARGB(255, 233, 230, 230),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(40),
          keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag, // 스크롤 시 키보드 닫힘
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단 타이틀
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 20),
                    onPressed: () {
                      Navigator.pop(context); // 이전 화면으로 돌아가기
                    },
                  ),

                  const SizedBox(width: 16),
                  const Text(
                    "회원가입",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // 아이디 입력 + 중복확인
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: _idController,
                      decoration: const InputDecoration(
                        labelText: "아이디",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 50,
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        print("중복확인");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 87, 87),
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(fontSize: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("중복확인", maxLines: 1),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              TextField(
                controller: _pwController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "비밀번호",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _pwCheckController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "비밀번호 확인",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "이름",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "휴대폰 번호(010-)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "이메일",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 50,
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        print("휴대번호");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 87, 87),
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(fontSize: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("인증요청", maxLines: 1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    _registerUser();
                    print("계정생성");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 87, 87),
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("계정 생성"),
                ),
              ),
              const SizedBox(height: 30), // 하단 여백
            ],
          ),
        ),
      ),
    );
  }
}
