import 'package:flutter/material.dart';
import 'my_page_screen.dart';  // ← 반드시 추가!!

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Icon(Icons.settings_outlined, color: Colors.black),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/pro.png', width: 40, height: 40),
            SizedBox(width: 8),
            Text(
              "프로해빗",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                // 👉 MyPageScreen 으로 이동하는 부분
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MyPageScreen()),
                );
              },
              child: Icon(Icons.notifications_none, color: Colors.black),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: 300,
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.redAccent),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.trending_up, color: Colors.redAccent),
                    SizedBox(width: 8),
                    Text(
                      "추적 운동",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 7),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Colors.redAccent,
                      size: (20),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "마지막 등 운동 후 5일 경과!",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/dead.jpg',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      "데드리프트",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
