import 'package:flutter/material.dart';
import 'login_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _svc = LoginService();
  final _idCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  final _pw2Ctrl = TextEditingController();

  bool _loading = false;
  String? _msg;

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

      final msg = await _svc.signup(id, pw);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      Navigator.pop(context, true); // 로그인 화면으로 복귀
    } catch (e) {
      setState(() => _msg = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      setState(() => _loading = false);
    }
  }

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
      appBar: AppBar(title: const Text('회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _idCtrl,
              decoration: const InputDecoration(labelText: 'ID', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _pwCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: '비밀번호', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _pw2Ctrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: '비밀번호 확인', border: OutlineInputBorder()),
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
            if (_msg != null) Text(_msg!, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
