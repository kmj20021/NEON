import 'package:flutter/material.dart';
import 'login_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  // 상태 관리
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _svc = LoginService(); // 에뮬레이터에 따라 다른 URL 사용
  final _idCtrl = TextEditingController(); // ID 입력 컨트롤러 (라이브러리)
  final _pwCtrl = TextEditingController(); // 비밀번호 입력 컨트롤러 (라이브러리)
  final _pw2Ctrl = TextEditingController(); // 비밀번호 확인 입력 컨트롤러 (라이브러리)

  // 로딩 상태, 메시지
  bool _loading = false;
  String? _msg;

  // 회원가입 함수
  Future<void> _doSignUp() async {
    setState(() {
      _msg = null;
      _loading = true;
    });

    try {
      final id = _idCtrl.text.trim();
      final pw = _pwCtrl.text;
      final pw2 = _pw2Ctrl.text;

      if (id.isEmpty) {
        throw Exception('ID를 입력해 주세요.');
      }
      if (pw.isEmpty) {
        throw Exception('비밀번호를 입력해 주세요.');
      }
      if (pw != pw2) {
        throw Exception('비밀번호가 일치하지 않습니다.');
      }

      // final msg = await _svc.signup(id, pw,);

      // 성공 시 메시지 표시 후 이전 화면으로 복귀
      if (!mounted) return;
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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
    _idCtrl.dispose();
    _pwCtrl.dispose();
    _pw2Ctrl.dispose();
    super.dispose();
  }

  // UI 빌드
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _idCtrl,
              decoration: const InputDecoration(
                labelText: 'ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _pwCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '비밀번호',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _pw2Ctrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '비밀번호 확인',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _doSignUp,
                child: Text(_loading ? '처리 중...' : '회원가입'),
              ),
            ),
            const SizedBox(height: 8),
            if (_msg != null)
              Text(_msg!, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
