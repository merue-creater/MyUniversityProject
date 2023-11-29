import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '운동 선택',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: workPage(),
    );
  }
}

class workPage extends StatelessWidget {
  final List<String> exercises = [
    '런닝',
    '요가',
    '골프',
    '수영',
    '사이클링',
    '계단 오르기',
    '자유 운동',
    // 여기에 필요한 다른 운동 추가 가능
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('운동 선택'),
      ),
      body: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.directions_run), // 예시 아이콘
            title: Text(exercises[index]),
            onTap: () {
              _showToast(context, exercises[index]);
            },
          );
        },
      ),
    );
  }

  void _showToast(BuildContext context, String exercise) {
    Fluttertoast.showToast(
      msg: '선택한 운동: $exercise',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }
}
