import 'package:flutter/material.dart';
import 'login.dart'; // LoginPage 클래스가 있는 파일 import

import 'ai_main_screen.dart';

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
      home: const MainScreen(), // 로그인 페이지를 앱 시작 화면으로 설정
      debugShowCheckedModeBanner: false, // 상단 debug 배너 제거
    );
  }
}




//운동 선택
// import 'package:flutter/material.dart';
// import 'ai_workout_screen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Workout Demo',
//       theme: ThemeData(primarySwatch: Colors.red),
//       home: const WorkoutTestWrapper(), // WorkoutScreen을 감싸는 래퍼 위젯
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// // WorkoutScreen을 테스트하기 위한 래퍼 위젯
// class WorkoutTestWrapper extends StatefulWidget {
//   const WorkoutTestWrapper({super.key});

//   @override
//   State<WorkoutTestWrapper> createState() => _WorkoutTestWrapperState();
// }

// class _WorkoutTestWrapperState extends State<WorkoutTestWrapper> {
//   List<SavedRoutine> savedRoutines = []; // 저장된 루틴 목록

//   // 뒤로 가기 콜백
//   void handleBack() {
//     print('뒤로 가기 버튼이 눌렸습니다.');
//     // 실제 앱에서는 Navigator.pop(context) 등을 사용
//   }

//   // 페이지 이동 콜백
//   void navigateToPage(String pageName) {
//     print('$pageName 페이지로 이동 요청');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('$pageName 페이지로 이동'),
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   // 루틴 저장 콜백
//   void handleSaveRoutine(SavedRoutine routine) {
//     setState(() {
//       savedRoutines.add(routine);
//     });
//     print('루틴 저장됨: ${routine.name}');
//     print('저장된 운동 개수: ${routine.workouts.length}');
//     print('전체 루틴 개수: ${savedRoutines.length}');
    
//     // 저장된 루틴 정보를 다이얼로그로 표시
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('루틴 저장 완료'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('루틴 이름: ${routine.name}'),
//             Text('운동 개수: ${routine.workouts.length}개'),
//             Text('생성 시간: ${routine.createdAt}'),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('확인'),
//           ),
//         ],
//       ),
//     );
//   }

//   // 운동 시작 콜백
//   void handleStartWorkout(List<int> workoutIds) {
//     print('운동 시작: $workoutIds');
//     print('선택된 운동 개수: ${workoutIds.length}개');
    
//     // 운동 시작 정보를 다이얼로그로 표시
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('운동 시작'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('선택된 운동 개수: ${workoutIds.length}개'),
//             const SizedBox(height: 8),
//             Text('운동 ID: ${workoutIds.join(", ")}'),
//             const SizedBox(height: 16),
//             const Text(
//               '실제 앱에서는 운동 진행 화면으로 이동합니다.',
//               style: TextStyle(fontSize: 12, color: Colors.grey),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('확인'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WorkoutScreen(
//       onBack: handleBack,
//       navigateToPage: navigateToPage,
//       onSaveRoutine: handleSaveRoutine,
//       onStartWorkout: handleStartWorkout,
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'ai_workout_active.dart'; // ActiveWorkoutScreen이 있는 파일

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Workout Test',
//       theme: ThemeData(
//         primarySwatch: Colors.red,
//         useMaterial3: true,
//       ),
//       home: const WorkoutTestWrapper(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// // ActiveWorkoutScreen을 테스트하기 위한 Wrapper 클래스
// class WorkoutTestWrapper extends StatefulWidget {
//   const WorkoutTestWrapper({super.key});

//   @override
//   State<WorkoutTestWrapper> createState() => _WorkoutTestWrapperState();
// }

// class _WorkoutTestWrapperState extends State<WorkoutTestWrapper> {
//   // 테스트용 루틴 데이터
//   final SelectedRoutine testRoutine = SelectedRoutine(
//     id: '1',
//     name: '가슴 + 삼두 루틴',
//     workouts: [1, 2, 3], // 푸쉬업, 스쿼트, 데드리프트
//   );

//   // 또는 개별 운동 목록으로 테스트
//   final List<int> testWorkouts = [1, 2, 4]; // 푸쉬업, 스쿼트, 플랭크

//   bool showRoutineTest = true; // true: 루틴으로 테스트, false: 개별 운동으로 테스트

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('운동 테스트 선택'),
//         backgroundColor: const Color(0xFFFF5757),
//         foregroundColor: Colors.white,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(
//                 Icons.fitness_center,
//                 size: 80,
//                 color: Color(0xFFFF5757),
//               ),
//               const SizedBox(height: 30),
//               const Text(
//                 '운동 화면 테스트',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 40),
              
//               // 루틴으로 테스트
//               SizedBox(
//                 width: double.infinity,
//                 height: 56,
//                 child: ElevatedButton.icon(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ActiveWorkoutScreen(
//                           selectedRoutine: testRoutine,
//                           onBack: () {
//                             Navigator.pop(context);
//                           },
//                           navigateToPage: (String page) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(content: Text('$page 페이지로 이동')),
//                             );
//                           },
//                         ),
//                       ),
//                     );
//                   },
//                   icon: const Icon(Icons.list_alt),
//                   label: const Text(
//                     '루틴으로 시작 (가슴+삼두)',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFFFF5757),
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ),
//               ),
              
//               const SizedBox(height: 16),
              
//               // 개별 운동으로 테스트
//               SizedBox(
//                 width: double.infinity,
//                 height: 56,
//                 child: OutlinedButton.icon(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ActiveWorkoutScreen(
//                           selectedWorkouts: testWorkouts,
//                           onBack: () {
//                             Navigator.pop(context);
//                           },
//                           navigateToPage: (String page) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(content: Text('$page 페이지로 이동')),
//                             );
//                           },
//                         ),
//                       ),
//                     );
//                   },
//                   icon: const Icon(Icons.fitness_center),
//                   label: const Text(
//                     '개별 운동 선택으로 시작',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: const Color(0xFFFF5757),
//                     side: const BorderSide(
//                       color: Color(0xFFFF5757),
//                       width: 2,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ),
//               ),
              
//               const SizedBox(height: 16),
              
//               // 기본값으로 테스트 (파라미터 없이)
//               SizedBox(
//                 width: double.infinity,
//                 height: 56,
//                 child: OutlinedButton.icon(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ActiveWorkoutScreen(
//                           onBack: () {
//                             Navigator.pop(context);
//                           },
//                         ),
//                       ),
//                     );
//                   },
//                   icon: const Icon(Icons.play_circle_outline),
//                   label: const Text(
//                     '기본 설정으로 시작',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: Colors.grey[700],
//                     side: BorderSide(
//                       color: Colors.grey[400]!,
//                       width: 2,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ),
//               ),
              
//               const SizedBox(height: 30),
              
//               // 설명 텍스트
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[100],
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.info_outline,
//                           size: 20,
//                           color: Colors.grey[700],
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           '테스트 정보',
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.grey[700],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       '• 루틴: 푸쉬업, 스쿼트, 데드리프트\n'
//                       '• 개별: 푸쉬업, 스쿼트, 플랭크\n'
//                       '• 기본: 푸쉬업, 스쿼트, 데드리프트',
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: Colors.grey[600],
//                         height: 1.5,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }