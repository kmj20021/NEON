import 'package:flutter/material.dart';
import 'login.dart'; // LoginPage 클래스가 있는 파일 import
import 'ai_main.dart';
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
      home: const LoginPage(), // 로그인 페이지를 앱 시작 화면으로 설정
      debugShowCheckedModeBanner: false, // 상단 debug 배너 제거
    );
  }
}


// import 'package:flutter/material.dart';
// import 'login.dart'; // LoginPage 클래스가 있는 파일 import
// import 'ai_main.dart';
// import 'ai_workout2.dart';
// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Login Demo',
//       theme: ThemeData(primarySwatch: Colors.red),
//       home: WorkoutScreen(
//         onBack: () {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const LoginPage()),
//           );
//         },
//         navigateToPage: (name) {
//           if (name == '마이 페이지') {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const MainScreen()),
//             );
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Navigate: $name')),
//             );
//           }
//         },
//         onSaveRoutine: (routine) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('루틴 저장됨: ${routine.name}')),
//           );
//         },
//         onStartWorkout: (ids) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('운동 시작: ${ids.length}개')),
//           );
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const MainScreen()),
//           );
//         },
//       ),
//       debugShowCheckedModeBanner: false, // 상단 debug 배너 제거
//     );
//   }
// }
