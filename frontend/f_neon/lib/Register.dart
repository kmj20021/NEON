import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

final TextEditingController idController = TextEditingController();
final TextEditingController pwController = TextEditingController();
final TextEditingController pwCheckController = TextEditingController();
final TextEditingController nameController = TextEditingController();
final TextEditingController phoneController = TextEditingController();

class _RegisterState extends State<Register> {
  void registerUser() async {
    final response = await http.post(
      Uri.parse('http://yourserver.com/api/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': idController.text,
        'password': pwController.text,
        'name': nameController.text,
        'phone': phoneController.text,
      }),
    );

    if (response.statusCode == 200) {
      print('회원가입 성공: ${response.body}');
    } else {
      print('회원가입 실패: ${response.statusCode}');
      print('에러 메시지: ${response.body}');
    }
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
                    registerUser();
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
