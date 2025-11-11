import 'package:f_neon/login_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

final _svc = LoginService();
final TextEditingController idController = TextEditingController();
final TextEditingController pwController = TextEditingController();
final TextEditingController pwCheckController = TextEditingController();
final TextEditingController nameController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController allergenController = TextEditingController();

class _RegisterState extends State<Register> {
  bool _loading = false;
  String? _msg;

  // 회원가입 함수
  Future<void> _doSignUp() async {
    setState(() {
      _msg = null;
      _loading = true;
    });

    try {
      final id = idController.text.trim(); // trim() 공백 제거
      final pw = pwController.text;
      final pw2 = pwCheckController.text;
      final name = nameController.text;
      final email = emailController.text;
      final phone = phoneController.text;

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
        throw Exception('이메일을을 입력해 주세요.');
      }
      if (phone.isEmpty) {
        throw Exception('전화 번호호를 입력해 주세요.');
      }

      final msg = await _svc.signup(id, pw, name, email, phone);

      // 성공 시 메시지 표시 후 이전 화면으로 복귀
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      Navigator.pop(context, true); // 로그인 화면으로 복귀
    } catch (e) {
      setState(() => _msg = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      setState(() => _loading = false);
    }
  }

  // 리소스 해제 (자원 정리)
  @override
  void dispose() {
    idController.dispose();
    pwController.dispose();
    pwCheckController.dispose();
    emailController.dispose();
    allergenController.dispose();
    nameController.dispose();

    super.dispose();
  }

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
                      controller: idController,
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
                controller: pwController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "비밀번호",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: pwCheckController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "비밀번호 확인",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
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
                      controller: phoneController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "휴대폰 번호(010-)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
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
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "이메일",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _loading ? null : _doSignUp, // 로딩 중이면 비활성화
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _loading
                        ? Colors.grey
                        : const Color.fromARGB(255, 255, 87, 87),
                    minimumSize: Size(500, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _loading ? '처리 중...' : '회원가입',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
