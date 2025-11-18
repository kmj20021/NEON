import 'package:f_neon/Register.dart';
import 'package:f_neon/login_service.dart';
import 'package:flutter/material.dart';
import 'package:f_neon/main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _svc = LoginService(); // 에뮬레이터에 따라 다른 URL 사용
  final _idCtrl = TextEditingController(); // ID 입력 컨트롤러 (라이브러리)
  final _pwCtrl = TextEditingController(); // 비밀번호 입력 컨트롤러 (라이브러리)
  final _pw2Ctrl = TextEditingController(); // 비밀번호 확인 입력 컨트롤러 (라이브러리)
  String? message;

  // 로딩 상태, 메시지
  bool _loading = false;
  String? _msg;

Future<void> _doLogin() async {
  setState(() {
    _msg = null;
    _loading = true;
  });

  try {
    final id = _idCtrl.text.trim();
    final pw = _pwCtrl.text;

    print('1️⃣ 입력값: id=$id, pw=$pw');

    if (id.isEmpty) {
      throw Exception('ID를 입력해 주세요.');
    }
    if (pw.isEmpty) {
      throw Exception('비밀번호를 입력해 주세요.');
    }

    print('2️⃣ _svc.login 호출 직전');
    final msg = await _svc.login(id, pw);
    print('3️⃣ _svc.login 응답: $msg');

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

    print('4️⃣ Navigator.pushReplacement 호출');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
  } catch (e) {
    print('⚠️ 에러 발생: $e');
    setState(() => _msg = e.toString().replaceFirst('Exception: ', ''));
  } finally {
    setState(() => _loading = false);
  }
}


  // 리소스 해제 (자원 정리)
  @override
  void dispose() {
    _idCtrl.dispose();
    _pwCtrl.dispose();
    _pw2Ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(height: 100),
          buildBody(),
          SizedBox(height: 10),
          id(),
          SizedBox(height: 10),
          pw(),
          SizedBox(height: 50),
          login(context),
          SizedBox(height: 70),
          find(),
          SizedBox(height: 70),
          logo(),
        ],
      ),
    );
  }

  Widget buildBody() {
    return Align(
      alignment: const Alignment(0.0, -0.6),
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/pro.png', width: 100, height: 100),
            const SizedBox(width: 4),
            const Text(
              '프로해빗',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget id() {
    return Align(
      child: Column(
        children: [
          Container(
            width: 500,
            height: 50,
            child: TextField(
              controller: _idCtrl,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: "아이디",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget pw() {
    return Align(
      child: Column(
        children: [
          Container(
            width: 500,
            height: 50,
            child: TextField(
              controller: _pwCtrl,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: '비밀번호',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget login(BuildContext context) {
    return Align(
      child: Column(
        children: [
          InkWell(
            onTap: _loading ? null : _doLogin, // _loading이 true면 비활성화
            child: Container(
              width: 500,
              height: 50,
              decoration: BoxDecoration(
                color: _loading
                    ? Colors
                          .grey // 로딩 중일 때는 회색으로 표시
                    : const Color.fromARGB(255, 255, 87, 87),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                _loading ? '처리 중...' : '로그인',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget find() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              print("회원가입 클릭!");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Register()),
              );
            },
            child: Text('회원가입', style: TextStyle(color: Colors.grey)),
          ),
          SizedBox(width: 16),
          Text('아이디/비밀번호 찾기', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget logo() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/google.png', width: 40, height: 40),
          SizedBox(width: 20),
          Image.asset('assets/ka1.png', width: 40, height: 40),
        ],
      ),
    );
  }
}
