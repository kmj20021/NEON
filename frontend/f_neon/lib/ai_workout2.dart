import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  String selectedCategory = '전체';
  String searchQuery = '';
  List<int> selectedWorkouts = [];
  bool showDetailModal = false;
  WorkoutData? selectedWorkout;
  String activeTab = '운동';
  bool showSaveRoutineModal = false;
  String routineName = '';
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _routineNameController = TextEditingController();

  final List<String> categories = ['전체', '가슴', '등', '어깨', '하체', '코어'];

  final List<WorkoutData> workoutData = [
    WorkoutData(
      id: 1,
      name: '푸쉬업',
      description: '가슴, 어깨, 삼두근을 강화하는 기본 운동',
      bodyPart: '가슴',
      intensity: '중',
      image: 'https://images.unsplash.com/photo-1623804454517-3a08bedac511?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwdXNoJTIwdXAlMjBleGVyY2lzZSUyMGZpdG5lc3N8ZW58MXx8fHwxNzU5OTAzMjc2fDA&ixlib=rb-4.1.0&q=80&w=1080',
      youtubeUrl: 'https://www.youtube.com/watch?v=IODxDxX7oi4',
      detailDescription: '바닥에 엎드려서 손을 어깨너비로 벌리고 몸을 일직선으로 유지하며 팔을 굽혔다 펴는 운동입니다. 가슴과 어깨, 삼두근을 효과적으로 단련할 수 있습니다.',
    ),
    WorkoutData(
      id: 2,
      name: '스쿼트',
      description: '하체 근력 강화의 기본이 되는 운동',
      bodyPart: '하체',
      intensity: '중',
      image: 'https://images.unsplash.com/photo-1701826478825-8d975e7883f4?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxzcXVhdCUyMGV4ZXJjaXNlJTIwd29ya291dHxlbnwxfHx8fDE3NTk5MDMyNzl8MA&ixlib=rb-4.1.0&q=80&w=1080',
      youtubeUrl: 'https://www.youtube.com/watch?v=aclHkVaku9U',
      detailDescription: '발을 어깨너비로 벌리고 서서 의자에 앉듯이 엉덩이를 뒤로 빼며 무릎을 굽히는 운동입니다. 허벅지와 엉덩이 근육을 강화합니다.',
    ),
    WorkoutData(
      id: 3,
      name: '데드리프트',
      description: '전신 근력 발달에 효과적인 복합 운동',
      bodyPart: '등',
      intensity: '고',
      image: 'https://images.unsplash.com/photo-1545612036-2872840642dc?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxkZWFkbGlmdCUyMGJhcmJlbGwlMjBleGVyY2lzZXxlbnwxfHx8fDE3NTk5MDMyODF8MA&ixlib=rb-4.1.0&q=80&w=1080',
      youtubeUrl: 'https://www.youtube.com/watch?v=1ZXobu7JvvE',
      detailDescription: '바벨을 잡고 허리를 곧게 펴며 일어서는 운동입니다. 등, 허벅지, 엉덩이, 코어 근육을 동시에 강화하는 최고의 복합 운동 중 하나입니다.',
    ),
    WorkoutData(
      id: 4,
      name: '풀업',
      description: '상체 당기는 근력을 기르는 운동',
      bodyPart: '등',
      intensity: '고',
      image: 'https://images.unsplash.com/photo-1616803928273-39775ac000ca?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwdWxsJTIwdXAlMjBleGVyY2lzZSUyMGZpdG5lc3N8ZW58MXx8fHwxNzU5OTAzMjg0fDA&ixlib=rb-4.1.0&q=80&w=1080',
      youtubeUrl: 'https://www.youtube.com/watch?v=eGo4IYlbE5g',
      detailDescription: '철봉에 매달려서 몸을 위로 당겨 올리는 운동입니다. 광배근, 이두근, 어깨 후면을 강화하며 상체 근력 발달에 매우 효과적입니다.',
    ),
    WorkoutData(
      id: 5,
      name: '벤치프레스',
      description: '가슴 근육 발달의 대표적인 운동',
      bodyPart: '가슴',
      intensity: '고',
      image: 'https://images.unsplash.com/photo-1651346847980-ab1c883e8cc8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxiZW5jaCUyMHByZXNzJTIwZXhlcmNpc2V8ZW58MXx8fHwxNzU5OTAzMjg2fDA&ixlib=rb-4.1.0&q=80&w=1080',
      youtubeUrl: 'https://www.youtube.com/watch?v=rT7DgCr-3pg',
      detailDescription: '벤치에 누워서 바벨을 가슴 위에서 위아래로 움직이는 운동입니다. 가슴 근육 발달에 가장 효과적인 운동 중 하나입니다.',
    ),
    WorkoutData(
      id: 6,
      name: '플랭크',
      description: '코어 근력과 안정성을 기르는 운동',
      bodyPart: '코어',
      intensity: '중',
      image: 'https://images.unsplash.com/photo-1758599878868-52cced2f8154?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwbGFuayUyMGNvcmUlMjBleGVyY2lzZXxlbnwxfHx8fDE3NTk5MDMyODh8MA&ixlib=rb-4.1.0&q=80&w=1080',
      youtubeUrl: 'https://www.youtube.com/watch?v=ASdvN_XEl_c',
      detailDescription: '팔꿈치와 발끝으로 몸을 지탱하며 일직선을 유지하는 운동입니다. 코어 근육을 강화하고 전신의 안정성을 높입니다.',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _routineNameController.dispose();
    super.dispose();
  }

  List<WorkoutData> get filteredWorkouts {
    return workoutData.where((workout) {
      final matchesCategory = selectedCategory == '전체' || workout.bodyPart == selectedCategory;
      final matchesSearch = workout.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          workout.description.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void handleWorkoutSelect(int workoutId) {
    setState(() {
      if (selectedWorkouts.contains(workoutId)) {
        selectedWorkouts.remove(workoutId);
      } else {
        selectedWorkouts.add(workoutId);
      }
    });
  }

  void handleShowDetail(WorkoutData workout) {
    setState(() {
      selectedWorkout = workout;
      showDetailModal = true;
    });
  }

  void handleSaveRoutine() {
    if (selectedWorkouts.isEmpty) {
      _showSnackBar('운동을 선택해주세요.');
      return;
    }
    setState(() {
      showSaveRoutineModal = true;
    });
  }

  void handleConfirmSaveRoutine() {
    if (routineName.trim().isEmpty) {
      _showSnackBar('루틴 이름을 입력해주세요.');
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
      _routineNameController.clear();
      selectedWorkouts.clear();
    });
    _showSnackBar('루틴이 저장되었습니다!');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Color getIntensityBackgroundColor(String intensity) {
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

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      _showSnackBar('URL을 열 수 없습니다');
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFFF5757);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Stack(
        children: [
          // 메인 콘텐츠
          CustomScrollView(
            slivers: [
              // 헤더
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
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade200,
                      ),
                      child: const Icon(Icons.fitness_center, size: 20),
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
                actions: [
                  IconButton(
                    icon: const Icon(Icons.person_outline, color: Colors.black87),
                    onPressed: () => widget.navigateToPage('마이 페이지'),
                  ),
                ],
              ),

              // 카테고리 필터
              SliverPersistentHeader(
                pinned: true,
                delegate: _CategoryHeaderDelegate(
                  categories: categories,
                  selectedCategory: selectedCategory,
                  onCategorySelected: (category) {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  searchController: _searchController,
                  onSearchChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
              ),

              // 운동 목록
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 180),
                sliver: filteredWorkouts.isNotEmpty
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final workout = filteredWorkouts[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _WorkoutCard(
                                workout: workout,
                                isSelected: selectedWorkouts.contains(workout.id),
                                onSelect: () => handleWorkoutSelect(workout.id),
                                onShowDetail: () => handleShowDetail(workout),
                                getIntensityBackgroundColor: getIntensityBackgroundColor,
                                getIntensityTextColor: getIntensityTextColor,
                              ),
                            );
                          },
                          childCount: filteredWorkouts.length,
                        ),
                      )
                    : SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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
              ),
            ],
          ),

          // 하단 액션 버튼
          Positioned(
            left: 0,
            right: 0,
            bottom: 80,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // 운동 시작하기 버튼
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ElevatedButton.icon(
                        onPressed: selectedWorkouts.isEmpty
                            ? null
                            : () => widget.onStartWorkout(selectedWorkouts),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          disabledBackgroundColor: Colors.grey.shade300,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.fitness_center, size: 20),
                        label: const Text('운동 시작하기'),
                      ),
                      if (selectedWorkouts.isNotEmpty)
                        Positioned(
                          top: -8,
                          right: -8,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${selectedWorkouts.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),

                  // 루틴 저장하기 버튼
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: selectedWorkouts.isEmpty ? null : handleSaveRoutine,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        side: BorderSide(color: Colors.grey.shade300),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.save_outlined, size: 20),
                      label: const Text('루틴 저장하기'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 플로팅 프로틴 구매 버튼
          Positioned(
            right: 16,
            bottom: 96,
            child: FloatingActionButton(
              onPressed: () => widget.navigateToPage('프로틴 구매'),
              backgroundColor: primaryColor,
              child: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
            ),
          ),

          // 하단 네비게이션 바
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _BottomNavigationBar(
              activeTab: activeTab,
              onTabSelected: (tab) {
                setState(() {
                  activeTab = tab;
                });
                if (tab != '운동') {
                  widget.navigateToPage(tab);
                } else {
                  widget.onBack();
                }
              },
            ),
          ),

          // 상세 모달 (중복된 Scaffold.body를 제거하고 메인 Stack으로 통합)
          if (showDetailModal && selectedWorkout != null)
            ...[
              GestureDetector(
                onTap: () {
                  setState(() {
                    showDetailModal = false;
                  });
                },
                child: Container(
                  color: Colors.black54,
                ),
              ),
              Center(
                child: _WorkoutDetailModal(
                  workout: selectedWorkout!,
                  onClose: () {
                    setState(() {
                      showDetailModal = false;
                    });
                  },
                  onOpenYoutube: () => _launchUrl(selectedWorkout!.youtubeUrl),
                  getIntensityBackgroundColor: getIntensityBackgroundColor,
                  getIntensityTextColor: getIntensityTextColor,
                ),
              ),
            ],
        ],
      ),

      // 루틴 저장 모달을 Overlay로 표시하기 위해 별도 처리
      floatingActionButton: showSaveRoutineModal
          ? GestureDetector(
              onTap: () {
                setState(() {
                  showSaveRoutineModal = false;
                });
              },
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: _SaveRoutineModal(
                    selectedWorkouts: selectedWorkouts,
                    workoutData: workoutData,
                    routineNameController: _routineNameController,
                    onCancel: () {
                      setState(() {
                        showSaveRoutineModal = false;
                      });
                    },
                    onConfirm: handleConfirmSaveRoutine,
                  ),
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

// 카테고리 헤더 Delegate
class _CategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;
  final TextEditingController searchController;
  final Function(String) onSearchChanged;

  _CategoryHeaderDelegate({
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.searchController,
    required this.onSearchChanged,
  });

  @override
  double get minExtent => 160;

  @override
  double get maxExtent => 160;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '운동 부위',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) => onCategorySelected(category),
                    backgroundColor: Colors.white,
                    selectedColor: const Color(0xFFFF5757),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    side: BorderSide(
                      color: isSelected ? const Color(0xFFFF5757) : Colors.grey.shade300,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: '운동 검색하기',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}

// 운동 카드 위젯
class _WorkoutCard extends StatelessWidget {
  final WorkoutData workout;
  final bool isSelected;
  final VoidCallback onSelect;
  final VoidCallback onShowDetail;
  final Color Function(String) getIntensityBackgroundColor;
  final Color Function(String) getIntensityTextColor;

  const _WorkoutCard({
    Key? key,
    required this.workout,
    required this.isSelected,
    required this.onSelect,
    required this.onShowDetail,
    required this.getIntensityBackgroundColor,
    required this.getIntensityTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // 운동 이미지
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: workout.image,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey.shade200,
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade200,
                child: const Icon(Icons.fitness_center, color: Colors.grey),
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
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  workout.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _Badge(
                      text: workout.bodyPart,
                      backgroundColor: Colors.grey.shade200,
                      textColor: Colors.grey.shade800,
                    ),
                    const SizedBox(width: 8),
                    _Badge(
                      text: '강도: ${workout.intensity}',
                      backgroundColor: getIntensityBackgroundColor(workout.intensity),
                      textColor: getIntensityTextColor(workout.intensity),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 액션 버튼
          Column(
            children: [
              // 체크박스
              GestureDetector(
                onTap: onSelect,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFFF5757) : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? const Color(0xFFFF5757) : Colors.grey.shade300,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(height: 8),
              // 자세히보기 버튼
              IconButton(
                onPressed: onShowDetail,
                icon: Icon(Icons.info_outline, color: Colors.grey.shade400),
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 배지 위젯
class _Badge extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const _Badge({
    Key? key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// 하단 네비게이션 바
class _BottomNavigationBar extends StatelessWidget {
  final String activeTab;
  final Function(String) onTabSelected;

  const _BottomNavigationBar({
    Key? key,
    required this.activeTab,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFFF5757);

    final items = [
      {'id': '운동', 'icon': Icons.play_arrow, 'label': '운동'},
      {'id': '상태확인', 'icon': Icons.monitor_heart_outlined, 'label': '상태확인'},
      {'id': '성과확인', 'icon': Icons.bar_chart, 'label': '성과확인'},
      {'id': '식단', 'icon': Icons.restaurant, 'label': '식단'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.map((item) {
          final isActive = activeTab == item['id'];
          return InkWell(
            onTap: () => onTabSelected(item['id'] as String),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item['icon'] as IconData,
                    size: 20,
                    color: isActive ? Colors.white : Colors.grey.shade600,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['label'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: isActive ? Colors.white : Colors.grey.shade600,
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

// 운동 상세 모달
class _WorkoutDetailModal extends StatelessWidget {
  final WorkoutData workout;
  final VoidCallback onClose;
  final VoidCallback onOpenYoutube;
  final Color Function(String) getIntensityBackgroundColor;
  final Color Function(String) getIntensityTextColor;

  const _WorkoutDetailModal({
    Key? key,
    required this.workout,
    required this.onClose,
    required this.onOpenYoutube,
    required this.getIntensityBackgroundColor,
    required this.getIntensityTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        workout.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: onClose,
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  workout.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          // 운동 이미지
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: CachedNetworkImage(
              imageUrl: workout.image,
              width: double.infinity,
              height: 192,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey.shade200,
                height: 192,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade200,
                height: 192,
                child: const Icon(Icons.fitness_center, color: Colors.grey, size: 48),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 배지
                Row(
                  children: [
                    _Badge(
                      text: workout.bodyPart,
                      backgroundColor: Colors.grey.shade200,
                      textColor: Colors.grey.shade800,
                    ),
                    const SizedBox(width: 8),
                    _Badge(
                      text: '강도: ${workout.intensity}',
                      backgroundColor: getIntensityBackgroundColor(workout.intensity),
                      textColor: getIntensityTextColor(workout.intensity),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 상세 설명
                Text(
                  workout.detailDescription,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),

                // YouTube 버튼
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onOpenYoutube,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5757),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('YouTube에서 보기'),
                        SizedBox(width: 8),
                        Icon(Icons.chevron_right, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 루틴 저장 모달
class _SaveRoutineModal extends StatelessWidget {
  final List<int> selectedWorkouts;
  final List<WorkoutData> workoutData;
  final TextEditingController routineNameController;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const _SaveRoutineModal({
    Key? key,
    required this.selectedWorkouts,
    required this.workoutData,
    required this.routineNameController,
    required this.onCancel,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '루틴 저장하기',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '선택한 운동들을 루틴으로 저장합니다. 루틴 이름을 입력해주세요.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 선택된 운동 목록
                Text(
                  '선택된 운동 (${selectedWorkouts.length}개)',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
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
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    workout.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.black87,
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

                // 루틴 이름 입력
                const Text(
                  '루틴 이름',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: routineNameController,
                  maxLength: 20,
                  decoration: InputDecoration(
                    hintText: '예: 상체 운동 루틴',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 버튼
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onCancel,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('취소'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onConfirm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF5757),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('저장하기'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}