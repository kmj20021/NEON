import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(height: 100),
          buildBody(),
          SizedBox(height: 10),
          id(),
          SizedBox(height: 10),
          pw(),
          SizedBox(height: 50),
          login(),
          SizedBox(height: 70),
          find(),
          SizedBox(height: 70),
          logo(),
        ],
      ),
    );
  }

  Widget buildBody() {
    return Align(
      alignment: const Alignment(0.0, -0.6),
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/pro.png', width: 100, height: 100),
            const SizedBox(width: 4),
            const Text(
              '프로해빗',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget id(){
    return Align(
      child: Column(
        children: [
          Container(
            width: 500,
            height: 50,
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)
                  ),
                  labelText: "아이디"
              ),
            ),
          )
        ],
      ),
    );
  }


  Widget pw(){
    return Align(
      child: Column(
        children: [
          Container(
            width: 500,
            height: 50,
            child:
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)
                  ),
                  labelText: '비밀번호'
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget login(){
    return   Align(
      child: Column(
        children: [
          InkWell(
            onTap: (){
              print('로그인2');
            },
            child: Container(
              width: 500,
              height: 50,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 87, 87),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child:
              Text('로그인',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),),

            ),
          ),

        ],
      ),
    );

  }

  Widget find(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('회원가입',style: TextStyle(color: Colors.grey),),
          SizedBox(width: 16,),
          Text('아이디/비밀번호 찾기',style: TextStyle(color: Colors.grey),)
        ],
      ),
    );
  }

  Widget logo(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/google.png',width: 40,height: 40,),
          SizedBox(width: 20,),
          Image.asset('assets/ka1.png', width: 40, height: 40,)
        ],
      ),
    );
  }


}
