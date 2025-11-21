import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

// 저장된 루틴 모델
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

// 캘린더 날짜 모델
class CalendarDay {
  final DateTime date;
  final int day;
  final bool isCurrentMonth;
  final bool isToday;
  final bool hasWorkout;

  CalendarDay({
    required this.date,
    required this.day,
    required this.isCurrentMonth,
    required this.isToday,
    required this.hasWorkout,
  });
}

// 운동 데이터 모델
class WorkoutData {
  final String day;
  final double minutes;

  WorkoutData({required this.day, required this.minutes});
}

class MainScreen extends StatefulWidget {
  // 페이지 이동 및 액션 콜백 함수들
  // final VoidCallback onLogout;
  // final VoidCallback onNavigateToWorkout;
  // final VoidCallback onNavigateToQuickStart;
  // final Function(String) navigateToPage;
  // final VoidCallback onNavigateToMyPage;
  // final VoidCallback? onNavigateToNotifications;
  // final Function(SavedRoutine) onStartWorkoutWithRoutine;
  final List<SavedRoutine> savedRoutines;

  const MainScreen({
    Key? key,
    // required this.onLogout,
    // required this.onNavigateToWorkout,
    // required this.onNavigateToQuickStart,
    // required this.navigateToPage,
    // required this.onNavigateToMyPage,
    // this.onNavigateToNotifications,
    // required this.onStartWorkoutWithRoutine,
    this.savedRoutines = const [],
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentWeek = 0;
  String activeTab = '운동';
  bool showCalendarModal = false;
  bool showRoutinesModal = false;
  late List<CalendarDay> calendarDays;
  final int consecutiveDays = 3;

  // 운동 데이터
  final List<WorkoutData> workoutData = [
    WorkoutData(day: '월', minutes: 45),
    WorkoutData(day: '화', minutes: 60),
    WorkoutData(day: '수', minutes: 90),
    WorkoutData(day: '목', minutes: 30),
    WorkoutData(day: '금', minutes: 120),
    WorkoutData(day: '토', minutes: 0),
    WorkoutData(day: '일', minutes: 75),
  ];

  @override
  void initState() {
    super.initState();
    calendarDays = _generateCalendarDays();
  }

  // 캘린더 날짜 생성
  List<CalendarDay> _generateCalendarDays() {
    final today = DateTime.now();
    final currentMonth = today.month;
    final currentYear = today.year;

    final firstDay = DateTime(currentYear, currentMonth, 1);
    final lastDay = DateTime(currentYear, currentMonth + 1, 0);

    final startDate = firstDay.subtract(Duration(days: firstDay.weekday % 7));

    final days = <CalendarDay>[];
    var currentDate = startDate;

    // 3주간 표시 (21일)
    for (int i = 0; i < 21; i++) {
      final isCurrentMonth = currentDate.month == currentMonth;
      final isToday = currentDate.year == today.year &&
          currentDate.month == today.month &&
          currentDate.day == today.day;
      final hasWorkout = DateTime.now().millisecond % 2 == 0; // 임의의 운동 기록

      days.add(CalendarDay(
        date: currentDate,
        day: currentDate.day,
        isCurrentMonth: isCurrentMonth,
        isToday: isToday,
        hasWorkout: isCurrentMonth && hasWorkout,
      ));

      currentDate = currentDate.add(const Duration(days: 1));
    }

    return days;
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final monthNames = [
      '1월', '2월', '3월', '4월', '5월', '6월',
      '7월', '8월', '9월', '10월', '11월', '12월'
    ];
    final currentMonthYear = '${today.year} ${monthNames[today.month - 1]}';

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Stack(
        children: [
          // 메인 콘텐츠
          SafeArea(
            child: Column(
              children: [
                // 고정 헤더
                _buildHeader(),
                
                // 스크롤 가능한 콘텐츠
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 24,
                      bottom: 100,
                    ),
                    child: Column(
                      children: [
                        // 운동 캘린더 위젯
                        _buildCalendarWidget(currentMonthYear),
                        const SizedBox(height: 24),
                        
                        // 주간 운동 그래프
                        _buildWorkoutGraph(),
                        const SizedBox(height: 24),
                        
                        // 하단 액션 버튼들
                        _buildActionButtons(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 플로팅 프로틴 구매 버튼
          Positioned(
            bottom: 90,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                // 페이지 이동: 프로틴 구매 페이지로 이동
                // navigateToPage('프로틴 구매');
                // Navigator.pushNamed(context, '/protein-shop');
              },
              backgroundColor: const Color(0xFFFF5757),
              child: const Icon(Icons.shopping_bag, color: Colors.white),
            ),
          ),

          // 고정 네비게이션 바
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomNavigation(),
          ),

          // 개발자 도구 (로그아웃 버튼)
          Positioned(
            top: 60,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                // 로그아웃 처리
                // onLogout();
                // Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1F2937),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                minimumSize: Size.zero,
              ),
              child: const Text(
                '로그아웃',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 헤더 위젯
  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 알림 버튼
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, size: 24),
                color: Colors.grey.shade600,
                onPressed: () {
                  // 페이지 이동: 알림 페이지로 이동
                  // onNavigateToNotifications?.call();
                  // Navigator.pushNamed(context, '/notifications');
                },
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF5757),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          
          // 로고
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade300,
                ),
                // 실제 앱 아이콘 이미지를 사용하려면:
                // child: Image.asset('assets/app_icon.png'),
              ),
              const SizedBox(width: 8),
              const Text(
                '프로해빗',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          
          // 마이페이지 버튼
          IconButton(
            icon: const Icon(Icons.person_outline, size: 24),
            color: Colors.grey.shade600,
            onPressed: () {
              // 페이지 이동: 마이페이지로 이동
              // onNavigateToMyPage();
              // Navigator.pushNamed(context, '/mypage');
            },
          ),
        ],
      ),
    );
  }

  // 캘린더 위젯
  Widget _buildCalendarWidget(String currentMonthYear) {
    final weekDays = ['일', '월', '화', '수', '목', '금', '토'];
    final displayDays = calendarDays
        .skip(currentWeek * 7)
        .take(7)
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '운동 캘린더',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF111827),
                    ),
                  ),
                  Text(
                    currentMonthYear,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 16),
                    onPressed: currentWeek == 0
                        ? null
                        : () => setState(() => currentWeek--),
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, size: 16),
                    onPressed: currentWeek == 2
                        ? null
                        : () => setState(() => currentWeek++),
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => setState(() => showCalendarModal = true),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      '전체보기',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // 캘린더 그리드
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: 14, // 7 (요일) + 7 (날짜)
            itemBuilder: (context, index) {
              if (index < 7) {
                // 요일 표시
                return Center(
                  child: Text(
                    weekDays[index],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                );
              } else {
                // 날짜 표시
                final dayIndex = index - 7;
                final day = displayDays[dayIndex];
                
                return Container(
                  decoration: BoxDecoration(
                    color: day.hasWorkout
                        ? const Color(0xFFFF5757)
                        : day.isToday
                            ? const Color(0xFFDCEBFE)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        fontSize: 14,
                        color: day.isToday
                            ? const Color(0xFF2563EB)
                            : day.hasWorkout
                                ? Colors.white
                                : day.isCurrentMonth
                                    ? const Color(0xFF111827)
                                    : Colors.grey.shade400,
                        fontWeight: day.isToday || day.hasWorkout
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 16),
          
          // 연속 출석 메시지
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              border: Border.all(color: const Color(0xFFFED7AA)),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Text(
                  '🔥 $consecutiveDays일 연속 출석!',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFFF5757),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '꾸준한 운동으로 목표를 달성해보세요',
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
  }

  // 운동 그래프 위젯
  Widget _buildWorkoutGraph() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '한 주간 운동시간',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF111827),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 2,
                    color: const Color(0xFFFF5757),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '운동시간',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // 그래프
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 30,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade100,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      interval: 30,
                      getTitlesWidget: (value, meta) {
                        String label = '';
                        if (value == 0) label = '0분';
                        else if (value == 30) label = '30분';
                        else if (value == 60) label = '1시간';
                        else if (value == 90) label = '1.5시간';
                        else if (value == 120) label = '2시간';
                        else if (value >= 150) label = '3시간+';
                        
                        return Text(
                          label,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < workoutData.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              workoutData[value.toInt()].day,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    left: BorderSide(color: Colors.grey.shade300),
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 150,
                lineBarsData: [
                  LineChartBarData(
                    spots: workoutData.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value.minutes);
                    }).toList(),
                    isCurved: true,
                    color: const Color(0xFFFF5757),
                    barWidth: 2,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: const Color(0xFFFF5757),
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // 자세히보기 버튼
          TextButton(
            onPressed: () {
              // 페이지 이동: 성과 확인 페이지로 이동
              // navigateToPage('성과 확인');
              // Navigator.pushNamed(context, '/performance');
            },
            child: Text(
              '자세히보기',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 액션 버튼들
  Widget _buildActionButtons() {
    return Column(
      children: [
        // 운동 시작하기 버튼
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              // 페이지 이동: 빠른 시작 페이지로 이동
              // onNavigateToQuickStart();
              // Navigator.pushNamed(context, '/quick-start');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5757),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.fitness_center, size: 20, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  '운동 시작하기',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        
        // 루틴 불러오기 버튼
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: () => setState(() => showRoutinesModal = true),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.upload_outlined, size: 20, color: Colors.grey.shade700),
                const SizedBox(width: 8),
                Text(
                  '루틴 불러오기',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 하단 네비게이션 바
  Widget _buildBottomNavigation() {
    final navItems = [
      {'id': '운동', 'icon': Icons.play_arrow, 'label': '운동'},
      {'id': '상태확인', 'icon': Icons.show_chart, 'label': '상태확인'},
      {'id': '성과확인', 'icon': Icons.bar_chart, 'label': '성과확인'},
      {'id': '공동구매', 'icon': Icons.shopping_bag_outlined, 'label': '공동구매'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: navItems.map((item) {
          final isActive = activeTab == item['id'];
          
          return InkWell(
            onTap: () {
              setState(() => activeTab = item['id'] as String);
              
              if (item['id'] != '운동') {
                // 페이지 이동: 각 탭에 해당하는 페이지로 이동
                // navigateToPage(item['label'] as String);
                // 예시:
                // if (item['id'] == '상태확인') Navigator.pushNamed(context, '/status');
                // else if (item['id'] == '성과확인') Navigator.pushNamed(context, '/performance');
                // else if (item['id'] == '공동구매') Navigator.pushNamed(context, '/group-buy');
              }
            },
            borderRadius: BorderRadius.circular(8),
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