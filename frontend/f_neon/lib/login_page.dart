import 'package:flutter/material.dart';
import 'login_service.dart';
import 'signup_page.dart'; // <-- 추가

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final service = LoginService();
  final idCtrl = TextEditingController();
  final pwCtrl = TextEditingController();
  String? message;

  Future<void> _login() async {
    setState(() => message = null);
    try {
      final res = await service.login(idCtrl.text.trim(), pwCtrl.text);
      final me = await service.fetchMe();
      setState(() => message = "$res\nME: ${me['id']}");
    } catch (e) {
      setState(() => message = '로그인 실패: $e');
    }
  }

  Future<void> _logout() async {
    await service.logout();
    setState(() => message = '로그아웃 완료');
  }

  Future<void> _goSignUp() async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const SignUpPage()),
    );

    // 회원가입 성공 후 돌아왔을 때 UX (선택)
    if (created == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('회원가입이 완료되었습니다. 로그인해 주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('로그인')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: idCtrl, decoration: const InputDecoration(labelText: 'ID')),
            TextField(controller: pwCtrl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(onPressed: _login, child: const Text('로그인')),
                const SizedBox(width: 12),
                OutlinedButton(onPressed: _logout, child: const Text('로그아웃')),
                const SizedBox(width: 12),
                TextButton(onPressed: _goSignUp, child: const Text('회원가입')), // <-- 추가
              ],
            ),
            const SizedBox(height: 12),
            if (message != null) Text(message!),
          ],
        ),
      ),
    );
  }
}
