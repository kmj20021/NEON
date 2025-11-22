import 'package:flutter/material.dart';
import 'dart:async';

// 운동 데이터 모델
class WorkoutData {
  final int id;
  final String name;
  final String description;
  final String bodyPart;
  final String intensity;
  final String image;
  final String youtubeUrl;
  final String detailDescription;

  WorkoutData({
    required this.id,
    required this.name,
    required this.description,
    required this.bodyPart,
    required this.intensity,
    required this.image,
    required this.youtubeUrl,
    required this.detailDescription,
  });
}

// 운동 세트 모델
class WorkoutSet {
  double weight;
  int reps;
  bool completed;

  WorkoutSet({
    this.weight = 0,
    this.reps = 0,
    this.completed = false,
  });

  WorkoutSet copyWith({double? weight, int? reps, bool? completed}) {
    return WorkoutSet(
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      completed: completed ?? this.completed,
    );
  }
}

// 운동 세션 모델
class WorkoutSession {
  final int workoutId;
  List<WorkoutSet> sets;

  WorkoutSession({
    required this.workoutId,
    required this.sets,
  });
}

// 선택된 루틴 모델
class SelectedRoutine {
  final String id;
  final String name;
  final List<int> workouts;

  SelectedRoutine({
    required this.id,
    required this.name,
    required this.workouts,
  });
}

class ActiveWorkoutScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final Function(String)? navigateToPage;
  final SelectedRoutine? selectedRoutine;
  final List<int>? selectedWorkouts;

  const ActiveWorkoutScreen({
    Key? key,
    this.onBack,
    this.navigateToPage,
    this.selectedRoutine,
    this.selectedWorkouts,
  }) : super(key: key);

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen> {
  String activeTab = '운동';
  int workoutTime = 0;
  bool isTimerActive = true;
  List<WorkoutSession> workoutSessions = [];
  bool isAddWorkoutDialogOpen = false;
  List<int> currentWorkoutIds = [];
  Timer? _timer;

  // 운동 데이터 (실제로는 서버나 로컬 DB에서 가져와야 함)
  final List<WorkoutData> workoutData = [
    WorkoutData(
      id: 1,
      name: '푸쉬업',
      description: '가슴, 어깨, 삼두근을 강화하는 기본 운동',
      bodyPart: '가슴',
      intensity: '중',
      image: 'https://images.unsplash.com/photo-1623804454517-3a08bedac511?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwdXNoJTIwdXAlMjBleGVyY2lzZSUyMGZpdG5lc3N8ZW58MXx8fHwxNzU5OTAzMjc2fDA&ixlib=rb-4.1.0&q=80&w=1080',
      youtubeUrl: 'https://www.youtube.com/watch?v=IODxDxX7oi4',
      detailDescription: '바닥에 엎드려서 손을 어깨너비로 벌리고 몸을 일직선으로 유지하며 팔을 굽혔다 펴는 운동입니다.',
    ),
    WorkoutData(
      id: 2,
      name: '스쿼트',
      description: '하체 근력 강화의 기본이 되는 운동',
      bodyPart: '하체',
      intensity: '중',
      image: 'https://images.unsplash.com/photo-1701826478825-8d975e7883f4?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxzcXVhdCUyMGV4ZXJjaXNlJTIwd29ya291dHxlbnwxfHx8fDE3NTk5MDMyNzl8MA&ixlib=rb-4.1.0&q=80&w=1080',
      youtubeUrl: 'https://www.youtube.com/watch?v=aclHkVaku9U',
      detailDescription: '발을 어깨너비로 벌리고 서서 의자에 앉듯이 엉덩이를 뒤로 빼며 무릎을 굽히는 운동입니다.',
    ),
    WorkoutData(
      id: 3,
      name: '데드리프트',
      description: '전신 근력 발달에 효과적인 복합 운동',
      bodyPart: '등',
      intensity: '고',
      image: 'https://images.unsplash.com/photo-1674927156017-e7c4b6b50dfb?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxkZWFkbGlmdCUyMGV4ZXJjaXNlJTIwZml0bmVzc3xlbnwxfHx8fDE3NTk5MDMyODN8MA&ixlib=rb-4.1.0&q=80&w=1080',
      youtubeUrl: 'https://www.youtube.com/watch?v=op9kVnSso6Q',
      detailDescription: '바벨을 바닥에서 들어 올리는 운동으로, 등, 엉덩이, 허벅지 뒷면을 강화합니다.',
    ),
    WorkoutData(
      id: 4,
      name: '플랭크',
      description: '코어 근육 강화 및 전신 안정성 향상',
      bodyPart: '코어',
      intensity: '중',
      image: 'https://images.unsplash.com/photo-1758599878868-52cced2f8154?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwbGFuayUyMGNvcmUlMjBleGVyY2lzZXxlbnwxfHx8fDE3NTk5MDMyODh8MA&ixlib=rb-4.1.0&q=80&w=1080',
      youtubeUrl: 'https://www.youtube.com/watch?v=ASdvN_XEl_c',
      detailDescription: '팔꿈치와 발끝으로 몸을 지탱하며 일직선을 유지하는 운동입니다. 코어 근육을 강화합니다.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeWorkouts();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // 초기 운동 목록 설정
  void _initializeWorkouts() {
    final workoutIds = widget.selectedRoutine?.workouts ?? 
                       widget.selectedWorkouts ?? 
                       [1, 2, 3];
    setState(() {
      currentWorkoutIds = workoutIds;
      _initializeWorkoutSessions();
    });
  }

  // 운동 세션 초기화
  void _initializeWorkoutSessions() {
    workoutSessions = currentWorkouts.map((workout) {
      return WorkoutSession(
        workoutId: workout.id,
        sets: [
          WorkoutSet(),
          WorkoutSet(),
          WorkoutSet(),
        ],
      );
    }).toList();
  }

  // 타이머 시작
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isTimerActive) {
        setState(() {
          workoutTime++;
        });
      }
    });
  }

  // 현재 운동 목록 가져오기
  List<WorkoutData> get currentWorkouts {
    return workoutData.where((workout) => 
      currentWorkoutIds.contains(workout.id)
    ).toList();
  }

  // 추가 가능한 운동 목록
  List<WorkoutData> get availableWorkouts {
    return workoutData.where((workout) => 
      !currentWorkoutIds.contains(workout.id)
    ).toList();
  }

  // 시간 포맷팅
  String formatTime(int seconds) {
    final hrs = seconds ~/ 3600;
    final mins = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    return '${hrs.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  // 세트 값 업데이트
  void updateSetValue(int workoutId, int setIndex, String field, double value) {
    setState(() {
      final sessionIndex = workoutSessions.indexWhere(
        (session) => session.workoutId == workoutId
      );
      if (sessionIndex != -1) {
        final session = workoutSessions[sessionIndex];
        if (setIndex < session.sets.length) {
          if (field == 'weight') {
            session.sets[setIndex].weight = value.clamp(0, double.infinity);
          } else if (field == 'reps') {
            session.sets[setIndex].reps = value.toInt().clamp(0, 9999);
          }
        }
      }
    });
  }

  // 세트 완료 토글
  void toggleSetCompletion(int workoutId, int setIndex) {
    setState(() {
      final sessionIndex = workoutSessions.indexWhere(
        (session) => session.workoutId == workoutId
      );
      if (sessionIndex != -1) {
        final session = workoutSessions[sessionIndex];
        if (setIndex < session.sets.length) {
          session.sets[setIndex].completed = !session.sets[setIndex].completed;
        }
      }
    });
  }

  // 세트 추가
  void addSet(int workoutId) {
    setState(() {
      final sessionIndex = workoutSessions.indexWhere(
        (session) => session.workoutId == workoutId
      );
      if (sessionIndex != -1) {
        workoutSessions[sessionIndex].sets.add(WorkoutSet());
      }
    });
  }

  // 마지막 세트 제거
  void removeLastSet(int workoutId) {
    setState(() {
      final sessionIndex = workoutSessions.indexWhere(
        (session) => session.workoutId == workoutId
      );
      if (sessionIndex != -1) {
        final session = workoutSessions[sessionIndex];
        if (session.sets.length > 1) {
          session.sets.removeLast();
        }
      }
    });
  }

  // 운동 세션 가져오기
  WorkoutSession? getWorkoutSession(int workoutId) {
    try {
      return workoutSessions.firstWhere(
        (session) => session.workoutId == workoutId
      );
    } catch (e) {
      return null;
    }
  }

  // 완료된 총 세트 수
  int getTotalCompletedSets() {
    return workoutSessions.fold(0, (total, session) {
      return total + session.sets.where((set) => set.completed).length;
    });
  }

  // 총 세트 수
  int getTotalSets() {
    return workoutSessions.fold(0, (total, session) {
      return total + session.sets.length;
    });
  }

  // 세션에 운동 추가
  void addWorkoutToSession(int workoutId) {
    setState(() {
      workoutSessions.add(WorkoutSession(
        workoutId: workoutId,
        sets: [
          WorkoutSet(),
          WorkoutSet(),
          WorkoutSet(),
        ],
      ));
      currentWorkoutIds.add(workoutId);
      isAddWorkoutDialogOpen = false;
    });
    Navigator.of(context).pop();
  }

  // 운동 추가 다이얼로그
  void _showAddWorkoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 600),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '운동 추가',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '세션에 추가할 운동을 선택하세요.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Flexible(
                  child: availableWorkouts.isEmpty
                      ? _buildEmptyWorkoutList()
                      : _buildAvailableWorkoutsList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 빈 운동 목록 위젯
  Widget _buildEmptyWorkoutList() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fitness_center,
            size: 48,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 12),
          Text(
            '추가할 수 있는 운동이 없습니다.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '모든 운동이 이미 세션에 추가되었습니다.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  // 추가 가능한 운동 목록 위젯
  Widget _buildAvailableWorkoutsList() {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      itemCount: availableWorkouts.length,
      itemBuilder: (context, index) {
        final workout = availableWorkouts[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => addWorkoutToSession(workout.id),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // 운동 이미지
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      workout.image,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 64,
                          height: 64,
                          color: Colors.grey[300],
                          child: const Icon(Icons.fitness_center),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 운동 정보
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          workout.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          workout.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                workout.bodyPart,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '강도: ${workout.intensity}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // 추가 버튼
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF5757),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            // 헤더
            _buildHeader(),
            // 운동 시간 카운터
            _buildWorkoutTimer(),
            // 메인 콘텐츠
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // 운동 추가 버튼
                    _buildAddWorkoutButton(),
                    const SizedBox(height: 16),
                    // 운동 목록
                    ..._buildWorkoutList(),
                    const SizedBox(height: 16),
                    // 운동 완료 버튼
                    _buildCompleteButton(),
                  ],
                ),
              ),
            ),
            // 네비게이션 바
            _buildNavigationBar(),
          ],
        ),
      ),
    );
  }

  // 헤더 위젯
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 뒤로가기 버튼
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: widget.onBack,
            color: Colors.grey[600],
          ),
          // 로고
          Row(
            children: [
              // appIcon 대신 placeholder 아이콘 사용
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5757),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.fitness_center,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '프로해빗',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          // 마이페이지 버튼
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // widget.navigateToPage?.call('마이 페이지');
              // 화면 이동 기능 - 실제 구현 시 Navigator.push 또는 라우팅 로직 추가
            },
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  // 운동 시간 카운터 위젯
  Widget _buildWorkoutTimer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.selectedRoutine?.name ?? '운동 세션',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF5757),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          formatTime(workoutTime),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF5757),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${getTotalCompletedSets()}/${getTotalSets()} 세트 완료',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: () {
              setState(() {
                isTimerActive = !isTimerActive;
              });
            },
            icon: const Icon(Icons.play_arrow, size: 16),
            label: Text(isTimerActive ? '일시정지' : '시작'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  // 운동 추가 버튼 위젯
  Widget _buildAddWorkoutButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: _showAddWorkoutDialog,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add, size: 16),
              const SizedBox(width: 4),
              const Text(
                '운동 추가',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.fitness_center,
                  size: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 운동 목록 위젯
  List<Widget> _buildWorkoutList() {
    return currentWorkouts.map((workout) {
      final session = getWorkoutSession(workout.id);
      if (session == null) return const SizedBox.shrink();

      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // 운동 헤더
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      workout.image,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 48,
                          height: 48,
                          color: Colors.grey[300],
                          child: const Icon(Icons.fitness_center),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          workout.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          workout.bodyPart,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (session.sets.length > 1)
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      color: Colors.red,
                      onPressed: () => removeLastSet(workout.id),
                      tooltip: '마지막 세트 삭제',
                    ),
                  IconButton(
                    icon: const Icon(Icons.open_in_new),
                    color: Colors.grey[600],
                    onPressed: () {
                      // url_launcher 패키지를 사용하여 YouTube URL 열기
                      // import 'package:url_launcher/url_launcher.dart';
                      // launchUrl(Uri.parse(workout.youtubeUrl));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // 세트 목록
              ...List.generate(session.sets.length, (setIndex) {
                final set = session.sets[setIndex];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        // 세트 번호
                        SizedBox(
                          width: 50,
                          child: Text(
                            '${setIndex + 1}세트',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        // 무게 입력
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '무게(kg)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildIncrementButton(
                                    Icons.remove,
                                    () => updateSetValue(
                                      workout.id,
                                      setIndex,
                                      'weight',
                                      set.weight - 0.5,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  SizedBox(
                                    width: 60,
                                    child: TextField(
                                      textAlign: TextAlign.center,
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        border: OutlineInputBorder(),
                                        isDense: true,
                                      ),
                                      controller: TextEditingController(
                                        text: set.weight.toString(),
                                      ),
                                      onChanged: (value) {
                                        final newValue = double.tryParse(value) ?? 0;
                                        updateSetValue(
                                          workout.id,
                                          setIndex,
                                          'weight',
                                          newValue,
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  _buildIncrementButton(
                                    Icons.add,
                                    () => updateSetValue(
                                      workout.id,
                                      setIndex,
                                      'weight',
                                      set.weight + 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // 횟수 입력
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '횟수',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildIncrementButton(
                                    Icons.remove,
                                    () => updateSetValue(
                                      workout.id,
                                      setIndex,
                                      'reps',
                                      (set.reps - 1).toDouble(),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  SizedBox(
                                    width: 60,
                                    child: TextField(
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        border: OutlineInputBorder(),
                                        isDense: true,
                                      ),
                                      controller: TextEditingController(
                                        text: set.reps.toString(),
                                      ),
                                      onChanged: (value) {
                                        final newValue = int.tryParse(value) ?? 0;
                                        updateSetValue(
                                          workout.id,
                                          setIndex,
                                          'reps',
                                          newValue.toDouble(),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  _buildIncrementButton(
                                    Icons.add,
                                    () => updateSetValue(
                                      workout.id,
                                      setIndex,
                                      'reps',
                                      (set.reps + 1).toDouble(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // 완료 체크박스
                        Column(
                          children: [
                            Text(
                              '완료',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            InkWell(
                              onTap: () => toggleSetCompletion(workout.id, setIndex),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: set.completed
                                      ? const Color(0xFFFF5757)
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: set.completed
                                        ? const Color(0xFFFF5757)
                                        : Colors.grey[300]!,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: set.completed
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 20,
                                      )
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
              // 세트 추가 버튼
              InkWell(
                onTap: () => addSet(workout.id),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[300]!,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '세트 추가',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  // 증감 버튼 위젯
  Widget _buildIncrementButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 14),
      ),
    );
  }

  // 운동 완료 버튼 위젯
  Widget _buildCompleteButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            isTimerActive = false;
          });
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('운동 완료'),
              content: const Text('운동이 완료되었습니다!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.onBack?.call();
                  },
                  child: const Text('확인'),
                ),
              ],
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF5757),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          '운동 완료',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // 네비게이션 바 위젯
  Widget _buildNavigationBar() {
    final navItems = [
      {'id': '운동', 'icon': Icons.play_arrow, 'label': '운동'},
      {'id': '상태확인', 'icon': Icons.favorite, 'label': '상태확인'},
      {'id': '성과확인', 'icon': Icons.bar_chart, 'label': '성과확인'},
      {'id': '식단', 'icon': Icons.restaurant, 'label': '식단'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: navItems.map((item) {
          final isActive = activeTab == item['id'];
          return InkWell(
            onTap: () {
              setState(() {
                activeTab = item['id'] as String;
              });
              if (item['id'] != '운동') {
                // widget.navigateToPage?.call(item['label'] as String);
                // 화면 이동 기능 - 실제 구현 시:
                // 1. Navigator.pushNamed(context, '/route_name')
                // 2. 또는 상태관리 라이브러리(Provider, Riverpod, Bloc 등)를 통한 화면 전환
                // 3. 또는 PageView/TabView 컨트롤러를 통한 페이지 변경
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFFFF5757) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item['icon'] as IconData,
                    color: isActive ? Colors.white : Colors.grey[600],
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['label'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: isActive ? Colors.white : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}