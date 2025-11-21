// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:url_launcher/url_launcher.dart';

// // 저장된 루틴 모델
// class SavedRoutine {
//   final String id;
//   final String name;
//   final List<int> workouts;
//   final DateTime createdAt;

//   SavedRoutine({
//     required this.id,
//     required this.name,
//     required this.workouts,
//     required this.createdAt,
//   });
// }

// // 운동 데이터 모델
// class WorkoutData {
//   final int id;
//   final String name;
//   final String description;
//   final String bodyPart;
//   final String intensity;
//   final String image;
//   final String youtubeUrl;
//   final String detailDescription;

//   WorkoutData({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.bodyPart,
//     required this.intensity,
//     required this.image,
//     required this.youtubeUrl,
//     required this.detailDescription,
//   });
// }

// class WorkoutScreen extends StatefulWidget {
//   // 페이지 이동 및 액션 콜백 함수들
//   // final VoidCallback onBack;
//   // final Function(String) navigateToPage;
//   // final Function(SavedRoutine) onSaveRoutine;
//   // final Function(List<int>) onStartWorkout;

//   const WorkoutScreen({
//     Key? key,
//     // required this.onBack,
//     // required this.navigateToPage,
//     // required this.onSaveRoutine,
//     // required this.onStartWorkout,
//   }) : super(key: key);

//   @override
//   State<WorkoutScreen> createState() => _WorkoutScreenState();
// }

// class _WorkoutScreenState extends State<WorkoutScreen> {
//   String selectedCategory = '전체';
//   String searchQuery = '';
//   List<int> selectedWorkouts = [];
//   bool showDetailModal = false;
//   WorkoutData? selectedWorkout;
//   String activeTab = '운동';
//   bool showSaveRoutineModal = false;
//   String routineName = '';

//   // 운동 데이터
//   final List<WorkoutData> workoutData = [
//     WorkoutData(
//       id: 1,
//       name: '푸쉬업',
//       description: '가슴, 어깨, 삼두근을 강화하는 기본 운동',
//       bodyPart: '가슴',
//       intensity: '중',
//       image: 'https://images.unsplash.com/photo-1623804454517-3a08bedac511?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwdXNoJTIwdXAlMjBleGVyY2lzZSUyMGZpdG5lc3N8ZW58MXx8fHwxNzU5OTAzMjc2fDA&ixlib=rb-4.1.0&q=80&w=1080',
//       youtubeUrl: 'https://www.youtube.com/watch?v=IODxDxX7oi4',
//       detailDescription: '바닥에 엎드려서 손을 어깨너비로 벌리고 몸을 일직선으로 유지하며 팔을 굽혔다 펴는 운동입니다. 가슴과 어깨, 삼두근을 효과적으로 단련할 수 있습니다.',
//     ),
//     WorkoutData(
//       id: 2,
//       name: '스쿼트',
//       description: '하체 근력 강화의 기본이 되는 운동',
//       bodyPart: '하체',
//       intensity: '중',
//       image: 'https://images.unsplash.com/photo-1701826478825-8d975e7883f4?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxzcXVhdCUyMGV4ZXJjaXNlJTIwd29ya291dHxlbnwxfHx8fDE3NTk5MDMyNzl8MA&ixlib=rb-4.1.0&q=80&w=1080',
//       youtubeUrl: 'https://www.youtube.com/watch?v=aclHkVaku9U',
//       detailDescription: '발을 어깨너비로 벌리고 서서 의자에 앉듯이 엉덩이를 뒤로 빼며 무릎을 굽히는 운동입니다. 허벅지와 엉덩이 근육을 강화합니다.',
//     ),
//     WorkoutData(
//       id: 3,
//       name: '데드리프트',
//       description: '전신 근력 발달에 효과적인 복합 운동',
//       bodyPart: '등',
//       intensity: '고',
//       image: 'https://images.unsplash.com/photo-1545612036-2872840642dc?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxkZWFkbGlmdCUyMGJhcmJlbGwlMjBleGVyY2lzZXxlbnwxfHx8fDE3NTk5MDMyODF8MA&ixlib=rb-4.1.0&q=80&w=1080',
//       youtubeUrl: 'https://www.youtube.com/watch?v=1ZXobu7JvvE',
//       detailDescription: '바벨을 잡고 허리를 곧게 펴며 일어서는 운동입니다. 등, 허벅지, 엉덩이, 코어 근육을 동시에 강화하는 최고의 복합 운동 중 하나입니다.',
//     ),
//     WorkoutData(
//       id: 4,
//       name: '풀업',
//       description: '상체 당기는 근력을 기르는 운동',
//       bodyPart: '등',
//       intensity: '고',
//       image: 'https://images.unsplash.com/photo-1616803928273-39775ac000ca?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwdWxsJTIwdXAlMjBleGVyY2lzZSUyMGZpdG5lc3N8ZW58MXx8fHwxNzU5OTAzMjg0fDA&ixlib=rb-4.1.0&q=80&w=1080',
//       youtubeUrl: 'https://www.youtube.com/watch?v=eGo4IYlbE5g',
//       detailDescription: '철봉에 매달려서 몸을 위로 당겨 올리는 운동입니다. 광배근, 이두근, 어깨 후면을 강화하며 상체 근력 발달에 매우 효과적입니다.',
//     ),
//     WorkoutData(
//       id: 5,
//       name: '벤치프레스',
//       description: '가슴 근육 발달의 대표적인 운동',
//       bodyPart: '가슴',
//       intensity: '고',
//       image: 'https://images.unsplash.com/photo-1651346847980-ab1c883e8cc8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxiZW5jaCUyMHByZXNzJTIwZXhlcmNpc2V8ZW58MXx8fHwxNzU5OTAzMjg2fDA&ixlib=rb-4.1.0&q=80&w=1080',
//       youtubeUrl: 'https://www.youtube.com/watch?v=rT7DgCr-3pg',
//       detailDescription: '벤치에 누워서 바벨을 가슴 위에서 위아래로 움직이는 운동입니다. 가슴 근육 발달에 가장 효과적인 운동 중 하나입니다.',
//     ),
//     WorkoutData(
//       id: 6,
//       name: '플랭크',
//       description: '코어 근력과 안정성을 기르는 운동',
//       bodyPart: '코어',
//       intensity: '중',
//       image: 'https://images.unsplash.com/photo-1758599878868-52cced2f8154?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwbGFuayUyMGNvcmUlMjBleGVyY2lzZXxlbnwxfHx8fDE3NTk5MDMyODh8MA&ixlib=rb-4.1.0&q=80&w=1080',
//       youtubeUrl: 'https://www.youtube.com/watch?v=ASdvN_XEl_c',
//       detailDescription: '팔꿈치와 발끝으로 몸을 지탱하며 일직선을 유지하는 운동입니다. 코어 근육을 강화하고 전신의 안정성을 높입니다.',
//     ),
//   ];

//   final List<String> categories = ['전체', '가슴', '등', '어깨', '하체', '코어'];

//   // 필터링된 운동 목록
//   List<WorkoutData> get filteredWorkouts {
//     return workoutData.where((workout) {
//       final matchesCategory = selectedCategory == '전체' || workout.bodyPart == selectedCategory;
//       final matchesSearch = workout.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
//           workout.description.toLowerCase().contains(searchQuery.toLowerCase());
//       return matchesCategory && matchesSearch;
//     }).toList();
//   }

//   // 운동 선택/해제
//   void handleWorkoutSelect(int workoutId) {
//     setState(() {
//       if (selectedWorkouts.contains(workoutId)) {
//         selectedWorkouts.remove(workoutId);
//       } else {
//         selectedWorkouts.add(workoutId);
//       }
//     });
//   }

//   // 운동 상세보기 - 수정된 버전
//   void handleShowDetail(WorkoutData workout) {
//     setState(() {
//       selectedWorkout = workout;
//     });
//     // 직접 다이얼로그 호출
//     _showDetailDialog();
//   }

//   // 루틴 저장 - 수정된 버전
//   void handleSaveRoutine() {
//     if (selectedWorkouts.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('운동을 선택해주세요.')),
//       );
//       return;
//     }

//     // 직접 다이얼로그 호출
//     _showSaveRoutineDialog();
//   }

//   // 루틴 저장 확인
//   void handleConfirmSaveRoutine() {
//     if (routineName.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('루틴 이름을 입력해주세요.')),
//       );
//       return;
//     }

//     final newRoutine = SavedRoutine(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       name: routineName.trim(),
//       workouts: List.from(selectedWorkouts),
//       createdAt: DateTime.now(),
//     );

//     // 루틴 저장 콜백 호출
//     // widget.onSaveRoutine(newRoutine);

//     setState(() {
//       showSaveRoutineModal = false;
//       routineName = '';
//       selectedWorkouts.clear();
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('루틴이 저장되었습니다!')),
//     );
//   }

//   // 강도별 색상
//   Color getIntensityBackgroundColor(String intensity) {
//     switch (intensity) {
//       case '저':
//         return const Color(0xFFDCFCE7);
//       case '중':
//         return const Color(0xFFFEF3C7);
//       case '고':
//         return const Color(0xFFFEE2E2);
//       default:
//         return const Color(0xFFF3F4F6);
//     }
//   }

//   Color getIntensityTextColor(String intensity) {
//     switch (intensity) {
//       case '저':
//         return const Color(0xFF166534);
//       case '중':
//         return const Color(0xFF854D0E);
//       case '고':
//         return const Color(0xFF991B1B);
//       default:
//         return const Color(0xFF1F2937);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFAFAFA),
//       body: Stack(
//         children: [
//           // 메인 콘텐츠
//           SafeArea(
//             child: Column(
//               children: [
//                 // 고정 헤더
//                 _buildHeader(),

//                 // 고정 카테고리와 검색창
//                 _buildFilterSection(),

//                 // 스크롤 가능한 운동 목록
//                 Expanded(
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.only(
//                       left: 16,
//                       right: 16,
//                       top: 16,
//                       bottom: 160,
//                     ),
//                     child: _buildWorkoutList(),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // 플로팅 프로틴 구매 버튼
//           Positioned(
//             bottom: 90,
//             right: 16,
//             child: FloatingActionButton(
//               onPressed: () {
//                 // 페이지 이동: 프로틴 구매 페이지로 이동
//                 // widget.navigateToPage('프로틴 구매');
//                 // Navigator.pushNamed(context, '/protein-shop');
//               },
//               backgroundColor: const Color(0xFFFF5757),
//               child: const Icon(Icons.shopping_bag, color: Colors.white),
//             ),
//           ),

//           // 고정 하단 액션 버튼
//           Positioned(
//             bottom: 70,
//             left: 0,
//             right: 0,
//             child: _buildBottomActionButtons(),
//           ),

//           // 고정 네비게이션 바
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: _buildBottomNavigation(),
//           ),
//         ],
//       ),
//     );
//   }

//   // 헤더 위젯
//   Widget _buildHeader() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border(
//           bottom: BorderSide(color: Colors.grey.shade200),
//         ),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           // 뒤로가기 버튼
//           IconButton(
//             icon: const Icon(Icons.arrow_back, size: 24),
//             color: Colors.grey.shade600,
//             onPressed: () {
//               // 페이지 이동: 이전 페이지로 돌아가기
//               // widget.onBack();
//               // Navigator.pop(context);
//             },
//           ),

//           // 로고
//           Row(
//             children: [
//               Container(
//                 width: 32,
//                 height: 32,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.grey.shade300,
//                 ),
//                 // 실제 앱 아이콘 이미지를 사용하려면:
//                 // child: Image.asset('assets/app_icon.png'),
//               ),
//               const SizedBox(width: 8),
//               const Text(
//                 '프로해빗',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w500,
//                   color: Color(0xFF111827),
//                 ),
//               ),
//             ],
//           ),

//           // 마이페이지 버튼
//           IconButton(
//             icon: const Icon(Icons.person_outline, size: 24),
//             color: Colors.grey.shade600,
//             onPressed: () {
//               // 페이지 이동: 마이페이지로 이동
//               // widget.navigateToPage('마이 페이지');
//               // Navigator.pushNamed(context, '/mypage');
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   // 필터 섹션 (카테고리 + 검색)
//   Widget _buildFilterSection() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border(
//           bottom: BorderSide(color: Colors.grey.shade200),
//         ),
//       ),
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // 운동 부위 카테고리
//           const Text(
//             '운동 부위',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//               color: Color(0xFF111827),
//             ),
//           ),
//           const SizedBox(height: 12),
//           SizedBox(
//             height: 40,
//             child: ListView.separated(
//               scrollDirection: Axis.horizontal,
//               itemCount: categories.length,
//               separatorBuilder: (_, __) => const SizedBox(width: 8),
//               itemBuilder: (context, index) {
//                 final category = categories[index];
//                 final isSelected = selectedCategory == category;

//                 return FilterChip(
//                   label: Text(category),
//                   selected: isSelected,
//                   onSelected: (selected) {
//                     setState(() {
//                       selectedCategory = category;
//                     });
//                   },
//                   backgroundColor: Colors.white,
//                   selectedColor: const Color(0xFFFF5757),
//                   labelStyle: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                     color: isSelected ? Colors.white : const Color(0xFF374151),
//                   ),
//                   side: BorderSide(
//                     color: isSelected ? const Color(0xFFFF5757) : Colors.grey.shade300,
//                   ),
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 );
//               },
//             ),
//           ),
//           const SizedBox(height: 16),

//           // 검색창
//           TextField(
//             onChanged: (value) => setState(() => searchQuery = value),
//             decoration: InputDecoration(
//               hintText: '운동 검색하기',
//               prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: BorderSide(color: Colors.grey.shade300),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: BorderSide(color: Colors.grey.shade300),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: const BorderSide(color: Color(0xFFFF5757)),
//               ),
//               filled: true,
//               fillColor: Colors.white,
//               contentPadding: const EdgeInsets.symmetric(vertical: 12),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // 운동 목록 위젯
//   Widget _buildWorkoutList() {
//     if (filteredWorkouts.isEmpty) {
//       return const Center(
//         child: Padding(
//           padding: EdgeInsets.all(48),
//           child: Column(
//             children: [
//               Text(
//                 '검색 결과가 없습니다',
//                 style: TextStyle(
//                   color: Color(0xFF6B7280),
//                   fontSize: 16,
//                 ),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 '다른 검색어나 카테고리를 시도해보세요',
//                 style: TextStyle(
//                   color: Color(0xFF9CA3AF),
//                   fontSize: 14,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return Column(
//       children: filteredWorkouts.map((workout) {
//         final isSelected = selectedWorkouts.contains(workout.id);

//         return Container(
//           margin: const EdgeInsets.only(bottom: 12),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: Colors.grey.shade200),
//           ),
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             children: [
//               // 운동 이미지
//               Container(
//                 width: 64,
//                 height: 64,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.grey.shade100,
//                 ),
//                 clipBehavior: Clip.antiAlias,
//                 child: CachedNetworkImage(
//                   imageUrl: workout.image,
//                   fit: BoxFit.cover,
//                   placeholder: (context, url) => const Center(
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       valueColor: AlwaysStoppedAnimation(Color(0xFFFF5757)),
//                     ),
//                   ),
//                   errorWidget: (context, url, error) => Icon(
//                     Icons.fitness_center,
//                     color: Colors.grey.shade400,
//                     size: 32,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),

//               // 운동 정보
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       workout.name,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                         color: Color(0xFF111827),
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       workout.description,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         _buildBadge(workout.bodyPart, Colors.grey.shade100, Colors.grey.shade700),
//                         const SizedBox(width: 8),
//                         _buildBadge(
//                           '강도: ${workout.intensity}',
//                           getIntensityBackgroundColor(workout.intensity),
//                           getIntensityTextColor(workout.intensity),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),

//               // 액션 버튼들
//               Row(
//                 children: [
//                   // 체크박스
//                   GestureDetector(
//                     onTap: () => handleWorkoutSelect(workout.id),
//                     child: Container(
//                       width: 24,
//                       height: 24,
//                       decoration: BoxDecoration(
//                         color: isSelected ? const Color(0xFFFF5757) : Colors.transparent,
//                         border: Border.all(
//                           color: isSelected ? const Color(0xFFFF5757) : Colors.grey.shade300,
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                       child: isSelected
//                           ? const Icon(Icons.check, size: 16, color: Colors.white)
//                           : null,
//                     ),
//                   ),
//                   const SizedBox(width: 12),

//                   // 자세히보기 버튼
//                   IconButton(
//                     icon: Icon(Icons.info_outline, color: Colors.grey.shade400),
//                     iconSize: 20,
//                     padding: EdgeInsets.zero,
//                     constraints: const BoxConstraints(),
//                     onPressed: () => handleShowDetail(workout),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       }).toList(),
//     );
//   }

//   // 배지 위젯
//   Widget _buildBadge(String label, Color backgroundColor, Color textColor) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: Text(
//         label,
//         style: TextStyle(
//           fontSize: 12,
//           color: textColor,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }

//   // 하단 액션 버튼
//   Widget _buildBottomActionButtons() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border(
//           top: BorderSide(color: Colors.grey.shade200),
//         ),
//       ),
//       padding: const EdgeInsets.all(16),
//       child: Row(
//         children: [
//           // 운동 시작하기 버튼
//           Expanded(
//             child: Stack(
//               clipBehavior: Clip.none,
//               children: [
//                 SizedBox(
//                   height: 48,
//                   child: ElevatedButton(
//                     onPressed: selectedWorkouts.isEmpty
//                         ? null
//                         : () {
//                             // 페이지 이동: 선택한 운동으로 운동 시작
//                             // widget.onStartWorkout(selectedWorkouts);
//                             // Navigator.pushNamed(context, '/workout-session', arguments: selectedWorkouts);
//                           },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFFF5757),
//                       disabledBackgroundColor: Colors.grey.shade300,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.fitness_center, size: 20, color: Colors.white),
//                         SizedBox(width: 8),
//                         Text(
//                           '운동 시작하기',
//                           style: TextStyle(color: Colors.white, fontSize: 16),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // 선택된 운동 개수 배지
//                 if (selectedWorkouts.isNotEmpty)
//                   Positioned(
//                     top: -8,
//                     right: -8,
//                     child: Container(
//                       width: 24,
//                       height: 24,
//                       decoration: const BoxDecoration(
//                         color: Color(0xFFFF5757),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Center(
//                         child: Text(
//                           '${selectedWorkouts.length}',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 12),

//           // 루틴 저장하기 버튼
//           Expanded(
//             child: SizedBox(
//               height: 48,
//               child: OutlinedButton(
//                 onPressed: selectedWorkouts.isEmpty ? null : handleSaveRoutine,
//                 style: OutlinedButton.styleFrom(
//                   side: BorderSide(color: Colors.grey.shade300),
//                   disabledForegroundColor: Colors.grey.shade400,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.save_outlined, size: 20, color: Colors.grey.shade700),
//                     const SizedBox(width: 8),
//                     Text(
//                       '루틴 저장하기',
//                       style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // 하단 네비게이션 바
//   Widget _buildBottomNavigation() {
//     final navItems = [
//       {'id': '운동', 'icon': Icons.play_arrow, 'label': '운동'},
//       {'id': '상태확인', 'icon': Icons.show_chart, 'label': '상태확인'},
//       {'id': '성과확인', 'icon': Icons.bar_chart, 'label': '성과확인'},
//       {'id': '식단', 'icon': Icons.restaurant_menu, 'label': '식단'},
//     ];

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border(
//           top: BorderSide(color: Colors.grey.shade200),
//         ),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: navItems.map((item) {
//           final isActive = activeTab == item['id'];

//           return InkWell(
//             onTap: () {
//               setState(() => activeTab = item['id'] as String);

//               if (item['id'] == '운동') {
//                 // 페이지 이동: 메인으로 돌아가기
//                 // widget.onBack();
//                 // Navigator.pop(context);
//               } else {
//                 // 페이지 이동: 각 탭에 해당하는 페이지로 이동
//                 // widget.navigateToPage(item['label'] as String);
//                 // 예시:
//                 // if (item['id'] == '상태확인') Navigator.pushNamed(context, '/status');
//                 // else if (item['id'] == '성과확인') Navigator.pushNamed(context, '/performance');
//                 // else if (item['id'] == '식단') Navigator.pushNamed(context, '/diet');
//               }
//             },
//             borderRadius: BorderRadius.circular(8),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               decoration: BoxDecoration(
//                 color: isActive ? const Color(0xFFFF5757) : Colors.transparent,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     item['icon'] as IconData,
//                     size: 20,
//                     color: isActive ? Colors.white : Colors.grey.shade600,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     item['label'] as String,
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: isActive ? Colors.white : Colors.grey.shade600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   // 자세히보기 모달은 별도 위젯으로 분리하는 것이 좋지만, 여기서는 showDialog로 구현
//   void _showDetailDialog() {
//     if (selectedWorkout == null) return;

//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 제목
//               Text(
//                 selectedWorkout!.name,
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF111827),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 selectedWorkout!.description,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey.shade600,
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // 운동 이미지
//               Container(
//                 width: double.infinity,
//                 height: 192,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.grey.shade100,
//                 ),
//                 clipBehavior: Clip.antiAlias,
//                 child: CachedNetworkImage(
//                   imageUrl: selectedWorkout!.image,
//                   fit: BoxFit.cover,
//                   placeholder: (context, url) => const Center(
//                     child: CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation(Color(0xFFFF5757)),
//                     ),
//                   ),
//                   errorWidget: (context, url, error) => Icon(
//                     Icons.fitness_center,
//                     color: Colors.grey.shade400,
//                     size: 48,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // 배지들
//               Row(
//                 children: [
//                   _buildBadge(selectedWorkout!.bodyPart, Colors.grey.shade100, Colors.grey.shade700),
//                   const SizedBox(width: 8),
//                   _buildBadge(
//                     '강도: ${selectedWorkout!.intensity}',
//                     getIntensityBackgroundColor(selectedWorkout!.intensity),
//                     getIntensityTextColor(selectedWorkout!.intensity),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),

//               // 상세 설명
//               Text(
//                 selectedWorkout!.detailDescription,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey.shade600,
//                   height: 1.5,
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // YouTube 링크 버튼
//               SizedBox(
//                 width: double.infinity,
//                 height: 48,
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     final url = Uri.parse(selectedWorkout!.youtubeUrl);
//                     if (await canLaunchUrl(url)) {
//                       await launchUrl(url, mode: LaunchMode.externalApplication);
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFFFF5757),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: const Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'YouTube에서 보기',
//                         style: TextStyle(color: Colors.white, fontSize: 16),
//                       ),
//                       SizedBox(width: 8),
//                       Icon(Icons.chevron_right, size: 20, color: Colors.white),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // 루틴 저장 모달
//   void _showSaveRoutineDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 제목
//               const Text(
//                 '루틴 저장하기',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF111827),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 '선택한 운동들을 루틴으로 저장합니다. 루틴 이름을 입력해주세요.',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey.shade600,
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // 선택된 운동 목록
//               Text(
//                 '선택된 운동 (${selectedWorkouts.length}개)',
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                   color: Color(0xFF111827),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Container(
//                 constraints: const BoxConstraints(maxHeight: 160),
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: selectedWorkouts.length,
//                   itemBuilder: (context, index) {
//                     final workout = workoutData.firstWhere(
//                       (w) => w.id == selectedWorkouts[index],
//                     );
//                     return Container(
//                       margin: const EdgeInsets.only(bottom: 8),
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade50,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.check, color: Color(0xFF10B981), size: 16),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   workout.name,
//                                   style: const TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w500,
//                                     color: Color(0xFF111827),
//                                   ),
//                                 ),
//                                 Text(
//                                   workout.bodyPart,
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.grey.shade600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // 루틴 이름 입력
//               const Text(
//                 '루틴 이름',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   color: Color(0xFF111827),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 maxLength: 20,
//                 decoration: InputDecoration(
//                   hintText: '예: 상체 운동 루틴',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide(color: Colors.grey.shade300),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide(color: Colors.grey.shade300),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: const BorderSide(color: Color(0xFFFF5757)),
//                   ),
//                   counterText: '',
//                 ),
//                 onChanged: (value) => setState(() => routineName = value),
//               ),
//               Text(
//                 '${routineName.length}/20',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey.shade500,
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // 버튼들
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () {
//                         setState(() {
//                           showSaveRoutineModal = false;
//                           routineName = '';
//                         });
//                         Navigator.pop(context);
//                       },
//                       style: OutlinedButton.styleFrom(
//                         side: BorderSide(color: Colors.grey.shade300),
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: const Text('취소'),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: routineName.trim().isEmpty
//                           ? null
//                           : () {
//                               handleConfirmSaveRoutine();
//                               Navigator.pop(context);
//                             },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFFFF5757),
//                         disabledBackgroundColor: Colors.grey.shade300,
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: const Text(
//                         '저장하기',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }