import 'package:flutter/material.dart';

class AcceptPage extends StatefulWidget {
  const AcceptPage({super.key});
  @override
  State<AcceptPage> createState() => AcceptPagestate();
}

class AcceptPagestate extends State<AcceptPage> {
  bool _isChecked = false;
  bool _isChecked2 = false;
  bool _isChecked3 = false;
  bool _isChecked4 = false;
  bool _isChecked5 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),

          Align(
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/pro.png', width: 50, height: 50),
                SizedBox(width: 10),
                Text(
                  '프로해빗',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: 100),
          Align(
            alignment: Alignment(0, -0.75),
            child: Text(
              '약관 동의',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Align(
            alignment: Alignment(0, -0.62),
            child: Text(
              '서비스 이용을 위해 약관에 동의해주세요',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, -0.4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: _isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked = value!;
                      _isChecked2 = value;
                      _isChecked3 = value;
                      _isChecked4 = value;
                      _isChecked5 = value;
                    });
                  },
                ),
                Text(
                  '약관 전체를 동의하기 (선택 동의 포함)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            child: Align(
              alignment: Alignment(0, -0.15),
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Checkbox(
                    value: _isChecked2,
                    onChanged: (bool? value) {
                      setState(() {
                        _isChecked2 = value!;
                      });
                    },
                  ),
                  Text(
                    ' 만 14세 이상입니다.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Container(
                    height: 30,
                    width: 35,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text('필수', style: TextStyle(color: Colors.white)),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "자세히",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: Align(
              alignment: Alignment(0, 0.04),
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Checkbox(
                    value: _isChecked3,
                    onChanged: (bool? value) {
                      setState(() {
                        _isChecked3 = value!;
                      });
                    },
                  ),
                  Text(
                    ' 서비스 이용 약관 동의',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Container(
                    height: 30,
                    width: 35,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text('필수', style: TextStyle(color: Colors.white)),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "자세히",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: Align(
              alignment: Alignment(0, 0.26),
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Checkbox(
                    value: _isChecked4,
                    onChanged: (bool? value) {
                      setState(() {
                        _isChecked4 = value!;
                      });
                    },
                  ),
                  Text(
                    ' 마케팅 목적의 개인정보 \n 수집 이용 동의',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Container(
                    height: 30,
                    width: 35,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text('선택', style: TextStyle(color: Colors.white)),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "자세히",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: Align(
              alignment: Alignment(0, 0.5),
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Checkbox(
                    value: _isChecked5,
                    onChanged: (bool? value) {
                      setState(() {
                        _isChecked5 = value!;
                      });
                    },
                  ),
                  Text(
                    ' 광고성 정보 수신 동의',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Container(
                    height: 30,
                    width: 35,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text('선택', style: TextStyle(color: Colors.white)),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "자세히",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 0.8),
            child: InkWell(
              onTap: (_isChecked2 && _isChecked3 && _isChecked4 && _isChecked5)
                  ? () {
                      print("회원가입버튼클릭");
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Container(
                              width: 400,
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment(0, -0.75),
                                    child: Text(
                                      '만 14세 이상 이용 안내',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(0, -0.65),
                                    child: Text(
                                      '약관의 전체 내용을 확인하실 수 있습니다.',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(0, -0.5),
                                    child: Text(
                                      '프로해빗은 만 14이상의 사용자에게 서비스를 제공합니다.',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(-1, 0),
                                    child: Text(
                                      '만14세 미만인 경우:\n\n -법정 대리인 동의가 필요합니다.\n\n -개인정보 수집 및 이용에 대한 별도 동의가 필요합니다. \n\n -일부 서비스 제한이 이용될 수 있습니다',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(0, 0.5),
                                    child: Text(
                                      '만 14이상임을 확인하시면 프로해빗에 모든 서비스를 이용 하실 수 있습니다.',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(1, 0.8),
                                    child: Material(
                                      child: InkWell(
                                        onTap: () {
                                          print("확인");
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 55,
                                          height: 35,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                            color: Colors.redAccent,
                                          ),
                                          child: Text(
                                            '확인',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  : null,
              child: Container(
                width: double.infinity,
                height: 40,
                margin: EdgeInsets.symmetric(horizontal: 50),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(5),
                ),
                alignment: Alignment.center,
                child: Text(
                  "동의하고 회원가입",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
