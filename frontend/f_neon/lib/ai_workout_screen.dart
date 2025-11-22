import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// 모델 클래스
class SavedRoutine {
  final String id;
  final String name;
  final List<int> workouts;
  final DateTime createdAt;

  SavedRoutine({
    required this.id,
    required this.name,
    required this.workouts,
    required this.createdAt,
  });
}

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

class WorkoutScreen extends StatefulWidget {
  // 페이지 이동 콜백 함수들
  final VoidCallback onBack;
  final Function(String) navigateToPage;
  final Function(SavedRoutine) onSaveRoutine;
  final Function(List<int>) onStartWorkout;

  const WorkoutScreen({
    Key? key,
    required this.onBack,
    required this.navigateToPage,
    required this.onSaveRoutine,
    required this.onStartWorkout,
  }) : super(key: key);

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  // 상태 변수들
  String selectedCategory = '전체';
  String searchQuery = '';
  List<int> selectedWorkouts = [];
  WorkoutData? selectedWorkout;
  bool showDetailModal = false;
  String activeTab = '운동';
  bool showSaveRoutineModal = false;
  String routineName = '';

  // 운동 데이터
  final List<WorkoutData> workoutData = [
    WorkoutData(
      id: 1,
      name: '푸쉬업',
      description: '가슴, 어깨, 삼두근을 강화하는 기본 운동',
      bodyPart: '가슴',
      intensity: '중',
      image: 'https://images.unsplash.com/photo-1623804454517-3a08bedac511',
      youtubeUrl: 'https://www.youtube.com/watch?v=IODxDxX7oi4',
      detailDescription: '바닥에 엎드려서 손을 어깨너비로 벌리고 몸을 일직선으로 유지하며 팔을 굽혔다 펴는 운동입니다.',
    ),
    WorkoutData(
      id: 2,
      name: '스쿼트',
      description: '하체 근력 강화의 기본이 되는 운동',
      bodyPart: '하체',
      intensity: '중',
      image: 'https://images.unsplash.com/photo-1701826478825-8d975e7883f4',
      youtubeUrl: 'https://www.youtube.com/watch?v=aclHkVaku9U',
      detailDescription: '발을 어깨너비로 벌리고 서서 의자에 앉듯이 엉덩이를 뒤로 빼며 무릎을 굽히는 운동입니다.',
    ),
    WorkoutData(
      id: 3,
      name: '데드리프트',
      description: '전신 근력 발달에 효과적인 복합 운동',
      bodyPart: '등',
      intensity: '고',
      image: 'https://images.unsplash.com/photo-1545612036-2872840642dc',
      youtubeUrl: 'https://www.youtube.com/watch?v=1ZXobu7JvvE',
      detailDescription: '바벨을 잡고 허리를 곧게 펴며 일어서는 운동입니다.',
    ),
    WorkoutData(
      id: 4,
      name: '풀업',
      description: '상체 당기는 근력을 기르는 운동',
      bodyPart: '등',
      intensity: '고',
      image: 'https://images.unsplash.com/photo-1616803928273-39775ac000ca',
      youtubeUrl: 'https://www.youtube.com/watch?v=eGo4IYlbE5g',
      detailDescription: '철봉에 매달려서 몸을 위로 당겨 올리는 운동입니다.',
    ),
    WorkoutData(
      id: 5,
      name: '벤치프레스',
      description: '가슴 근육 발달의 대표적인 운동',
      bodyPart: '가슴',
      intensity: '고',
      image: 'https://images.unsplash.com/photo-1651346847980-ab1c883e8cc8',
      youtubeUrl: 'https://www.youtube.com/watch?v=rT7DgCr-3pg',
      detailDescription: '벤치에 누워서 바벨을 가슴 위에서 위아래로 움직이는 운동입니다.',
    ),
    WorkoutData(
      id: 6,
      name: '플랭크',
      description: '코어 근력과 안정성을 기르는 운동',
      bodyPart: '코어',
      intensity: '중',
      image: 'https://images.unsplash.com/photo-1758599878868-52cced2f8154',
      youtubeUrl: 'https://www.youtube.com/watch?v=ASdvN_XEl_c',
      detailDescription: '팔꿈치와 발끝으로 몸을 지탱하며 일직선을 유지하는 운동입니다.',
    ),
  ];

  final List<String> categories = ['전체', '가슴', '등', '어깨', '하체', '코어'];

  // 필터링된 운동 목록
  List<WorkoutData> get filteredWorkouts {
    return workoutData.where((workout) {
      final matchesCategory =
          selectedCategory == '전체' || workout.bodyPart == selectedCategory;
      final matchesSearch = workout.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          workout.description.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  // 운동 선택/해제
  void handleWorkoutSelect(int workoutId) {
    setState(() {
      if (selectedWorkouts.contains(workoutId)) {
        selectedWorkouts.remove(workoutId);
      } else {
        selectedWorkouts.add(workoutId);
      }
    });
  }

  // 운동 상세보기
  void handleShowDetail(WorkoutData workout) {
    setState(() {
      selectedWorkout = workout;
      showDetailModal = true;
    });
  }

  // 루틴 저장
  void handleSaveRoutine() {
    if (selectedWorkouts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('운동을 선택해주세요.')),
      );
      return;
    }
    setState(() {
      showSaveRoutineModal = true;
    });
  }

  // 루틴 저장 확인
  void handleConfirmSaveRoutine() {
    if (routineName.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('루틴 이름을 입력해주세요.')),
      );
      return;
    }

    final newRoutine = SavedRoutine(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: routineName.trim(),
      workouts: List.from(selectedWorkouts),
      createdAt: DateTime.now(),
    );

    widget.onSaveRoutine(newRoutine);
    
    setState(() {
      showSaveRoutineModal = false;
      routineName = '';
      selectedWorkouts = [];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('루틴이 저장되었습니다!')),
    );
  }

  // 강도 색상
  Color getIntensityColor(String intensity) {
    switch (intensity) {
      case '저':
        return Colors.green.shade100;
      case '중':
        return Colors.yellow.shade100;
      case '고':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  Color getIntensityTextColor(String intensity) {
    switch (intensity) {
      case '저':
        return Colors.green.shade800;
      case '중':
        return Colors.yellow.shade800;
      case '고':
        return Colors.red.shade800;
      default:
        return Colors.grey.shade800;
    }
  }

  // YouTube URL 열기
  Future<void> openYouTube(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Stack(
        children: [
          // 메인 콘텐츠
          CustomScrollView(
            slivers: [
              // 고정 헤더
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: widget.onBack,
                ),
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 앱 아이콘 (실제 이미지로 교체 필요)
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '프로해빗',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.person_outline, color: Colors.black87),
                    onPressed: () {
                      // 페이지 이동: 마이 페이지로 이동
                      // widget.navigateToPage('마이 페이지');
                    },
                  ),
                ],
              ),

              // 카테고리와 검색창
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 운동 부위 카테고리
                      const Text(
                        '운동 부위',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 40,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            final isSelected = selectedCategory == category;
                            return ChoiceChip(
                              label: Text(category),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  selectedCategory = category;
                                });
                              },
                              backgroundColor: Colors.white,
                              selectedColor: const Color(0xFFFF5757),
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                              side: BorderSide(
                                color: isSelected
                                    ? const Color(0xFFFF5757)
                                    : Colors.grey.shade300,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 검색창
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: '운동 검색하기',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 운동 목록
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: filteredWorkouts.isEmpty
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(48),
                            child: Column(
                              children: [
                                Text(
                                  '검색 결과가 없습니다',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '다른 검색어나 카테고리를 시도해보세요',
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final workout = filteredWorkouts[index];
                            final isSelected = selectedWorkouts.contains(workout.id);

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  // 운동 이미지
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      width: 64,
                                      height: 64,
                                      color: Colors.grey.shade100,
                                      child: Image.network(
                                        workout.image,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.grey.shade200,
                                            child: const Icon(Icons.fitness_center),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),

                                  // 운동 정보
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          workout.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          workout.description,
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 14,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
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
                                                color: Colors.grey.shade200,
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
                                                color: getIntensityColor(workout.intensity),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                '강도: ${workout.intensity}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: getIntensityTextColor(
                                                      workout.intensity),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // 체크박스와 상세보기 버튼
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () => handleWorkoutSelect(workout.id),
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? const Color(0xFFFF5757)
                                                : Colors.transparent,
                                            border: Border.all(
                                              color: isSelected
                                                  ? const Color(0xFFFF5757)
                                                  : Colors.grey.shade300,
                                              width: 2,
                                            ),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: isSelected
                                              ? const Icon(
                                                  Icons.check,
                                                  size: 16,
                                                  color: Colors.white,
                                                )
                                              : null,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      IconButton(
                                        icon: Icon(
                                          Icons.info_outline,
                                          color: Colors.grey.shade400,
                                        ),
                                        onPressed: () => handleShowDetail(workout),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          childCount: filteredWorkouts.length,
                        ),
                      ),
              ),

              // 하단 여백 (네비게이션 바 공간)
              const SliverToBoxAdapter(
                child: SizedBox(height: 160),
              ),
            ],
          ),

          // 고정 하단 액션 버튼
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // 운동 시작하기 버튼
                  Expanded(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ElevatedButton.icon(
                          onPressed: selectedWorkouts.isEmpty
                              ? null
                              : () {
                                  // 운동 시작 기능 실행
                                  widget.onStartWorkout(selectedWorkouts);
                                },
                          icon: const Icon(Icons.fitness_center),
                          label: const Text('운동 시작하기'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF5757),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        if (selectedWorkouts.isNotEmpty)
                          Positioned(
                            top: -8,
                            right: -8,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF5757),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${selectedWorkouts.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  // 루틴 저장하기 버튼
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: selectedWorkouts.isEmpty ? null : handleSaveRoutine,
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('루틴 저장'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 플로팅 프로틴 구매 버튼
          Positioned(
            bottom: 90,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                // 페이지 이동: 프로틴 구매 페이지로 이동
                // widget.navigateToPage('프로틴 구매');
              },
              backgroundColor: const Color(0xFFFF5757),
              child: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
            ),
          ),

          // 고정 네비게이션 바
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: Icons.play_arrow,
                    label: '운동',
                    isActive: activeTab == '운동',
                    onTap: () {
                      setState(() => activeTab = '운동');
                      // 페이지 이동: 메인 페이지로 이동
                      // widget.onBack();
                    },
                  ),
                  _buildNavItem(
                    icon: Icons.favorite_outline,
                    label: '상태확인',
                    isActive: activeTab == '상태확인',
                    onTap: () {
                      setState(() => activeTab = '상태확인');
                      // 페이지 이동: 상태확인 페이지로 이동
                      // widget.navigateToPage('상태확인');
                    },
                  ),
                  _buildNavItem(
                    icon: Icons.bar_chart,
                    label: '성과확인',
                    isActive: activeTab == '성과확인',
                    onTap: () {
                      setState(() => activeTab = '성과확인');
                      // 페이지 이동: 성과확인 페이지로 이동
                      // widget.navigateToPage('성과확인');
                    },
                  ),
                  _buildNavItem(
                    icon: Icons.restaurant_menu,
                    label: '식단',
                    isActive: activeTab == '식단',
                    onTap: () {
                      setState(() => activeTab = '식단');
                      // 페이지 이동: 식단 페이지로 이동
                      // widget.navigateToPage('식단');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // 모달들은 별도로 표시
      // showDetailModal과 showSaveRoutineModal은 아래에서 처리
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFF5757) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? Colors.white : Colors.grey.shade600,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive ? Colors.white : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 운동 상세보기 모달 표시
  void showDetailDialog() {
    if (selectedWorkout == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(selectedWorkout!.name),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selectedWorkout!.description,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  selectedWorkout!.image,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.fitness_center, size: 48),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(selectedWorkout!.bodyPart),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: getIntensityColor(selectedWorkout!.intensity),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '강도: ${selectedWorkout!.intensity}',
                      style: TextStyle(
                        color: getIntensityTextColor(selectedWorkout!.intensity),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(selectedWorkout!.detailDescription),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => openYouTube(selectedWorkout!.youtubeUrl),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('YouTube에서 보기'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5757),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }

  // 루틴 저장 모달 표시
  void showSaveRoutineDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('루틴 저장하기'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('선택한 운동들을 루틴으로 저장합니다. 루틴 이름을 입력해주세요.'),
              const SizedBox(height: 16),
              Text(
                '선택된 운동 (${selectedWorkouts.length}개)',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                constraints: const BoxConstraints(maxHeight: 160),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: selectedWorkouts.length,
                  itemBuilder: (context, index) {
                    final workout = workoutData.firstWhere(
                      (w) => w.id == selectedWorkouts[index],
                    );
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check, color: Colors.green, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  workout.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  workout.bodyPart,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '루틴 이름',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                maxLength: 20,
                onChanged: (value) {
                  routineName = value;
                },
                decoration: const InputDecoration(
                  hintText: '예: 상체 운동 루틴',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                showSaveRoutineModal = false;
              });
            },
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              handleConfirmSaveRoutine();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5757),
              foregroundColor: Colors.white,
            ),
            child: const Text('저장하기'),
          ),
        ],
      ),
    );
  }
}