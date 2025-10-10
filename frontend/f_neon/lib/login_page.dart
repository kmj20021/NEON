import 'package:flutter/material.dart';
import 'login_service.dart';

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
    try {
      final res = await service.login(idCtrl.text.trim(), pwCtrl.text);
      setState(() => message = res);
    } catch (e) {
      setState(() => message = '로그인 실패: $e');
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
            ElevatedButton(onPressed: _login, child: const Text('로그인')),
            const SizedBox(height: 12),
            if (message != null) Text(message!),
          ],
        ),
      ),
    );
  }
}
