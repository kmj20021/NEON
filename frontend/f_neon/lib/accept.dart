import 'package:flutter/material.dart';

class AcceptPage extends StatelessWidget {
  const AcceptPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack (
        children: [
          Align(
            alignment: Alignment.topLeft,
            child:
            Padding(padding: EdgeInsets.all(16),child: Icon(Icons.arrow_back_ios, color: Colors.grey),
                ),
          ),

          Align(
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/pro.png', width: 50, height: 50),
                SizedBox(width: 10,),
                Text('프로해빗',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
              ],

            )
            ,
          ),
          SizedBox(height: 100,),
          Align(
            alignment: Alignment(0,-0.75),
            child: Text('약관 동의',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
          ),
          Align(
            alignment: Alignment(0,-0.62),
            child: Text('서비스 이용을 위해 약관에 동의해주세요',style: TextStyle(fontSize: 15,color: Colors.grey, fontWeight: FontWeight.bold),),
          ),
          Align(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                
              ],
            ),
          )
        ],
      ),
    );
  }
}
