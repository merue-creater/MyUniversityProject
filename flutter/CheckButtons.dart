import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'device_screen.dart';
import 'dart:math';

List<String> checkList = [];
List<int> sendList = [];
var weight;
var height;
var bmi;
var sendOn;
var age;
var maxBpm;
var normalBpm;
var workBpm;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Check Box",
      debugShowCheckedModeBanner: false,
      home: CheckBoxs(),
    );
  }
}

class CheckBoxs extends StatefulWidget {
  const CheckBoxs({Key? key}) : super(key: key);

  @override
  _CheckBoxsState createState() => _CheckBoxsState();
}

class _CheckBoxsState extends State<CheckBoxs> {
  bool _isCheckA_1 = false;
  bool _isCheckA_2 = false;
  bool _isCheckB_1 = false;
  bool _isCheckB_2 = false;
  bool _isCheckC_1 = false;
  bool _isCheckC_2 = false;
  bool _isCheckD_1 = false;
  bool _isCheckD_2 = false;

  double weight = 0.0;
  double height = 0.0;


  @override
  void initState() {
    super.initState();
    loadCheckboxState('isCheckedA1');
    loadCheckboxState('isCheckedA2');
    loadCheckboxState('isCheckedB1');
    loadCheckboxState('isCheckedB2');
    loadCheckboxState('isCheckedC1');
    loadCheckboxState('isCheckedC2');
    loadCheckboxState('isCheckedD1');
    loadCheckboxState('isCheckedD2');
  }

  Future<void> saveCheckboxState(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  Future<void> loadCheckboxState(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      switch (key) {
        case 'isCheckedA1':
          _isCheckA_1 = prefs.getBool(key) ?? false;
          break;
        case 'isCheckedA2':
          _isCheckA_2 = prefs.getBool(key) ?? false;
          break;
        case 'isCheckedB1':
          _isCheckB_1 = prefs.getBool(key) ?? false;
          break;
        case 'isCheckedB2':
          _isCheckB_2 = prefs.getBool(key) ?? false;
          break;
        case 'isCheckedC1':
          _isCheckC_1 = prefs.getBool(key) ?? false;
          break;
        case 'isCheckedC2':
          _isCheckC_2 = prefs.getBool(key) ?? false;
          break;
        case 'isCheckedD1':
          _isCheckD_1 = prefs.getBool(key) ?? false;
          break;
        case 'isCheckedD2':
          _isCheckD_2 = prefs.getBool(key) ?? false;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("건강 상태 체크"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Checkbox(
                      value: _isCheckA_1,
                      onChanged: (value) {
                        setState(() {
                          _isCheckA_1 = value!;
                          saveCheckboxState('isCheckedA1', _isCheckA_1);
                          checkedList(_isCheckA_1, "남자", 'isCheckedA1'); // 여기서 checkedList 호출
                        });
                      },
                    ),
                    const Text("남자"),
                    Checkbox(
                      value: _isCheckA_2,
                      onChanged: (value) {
                        setState(() {
                          _isCheckA_2 = value!;
                          saveCheckboxState('isCheckedA2', _isCheckA_2);
                          checkedList(_isCheckA_2, "여자", 'isCheckedA2'); // 여기서 checkedList 호출

                        });
                      },
                    ),
                    const Text("여자")
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Checkbox(
                      value: _isCheckB_1,
                      onChanged: (value) {
                        setState(() {
                          _isCheckB_1 = value!;
                          saveCheckboxState('isCheckedB1', _isCheckB_1);
                          checkedList(_isCheckB_1, "흡연", 'isCheckedB1'); // 여기서 checkedList 호출

                        });
                      },
                    ),
                    const Text("흡연"),
                    Checkbox(
                      value: _isCheckB_2,
                      onChanged: (value) {
                        setState(() {
                          _isCheckB_2 = value!;
                          saveCheckboxState('isCheckedB2', _isCheckB_2);
                          checkedList(_isCheckB_2, "비흡연", 'isCheckedB2'); // 여기서 checkedList 호출

                        });
                      },
                    ),
                    const Text("비흡연")
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Checkbox(
                      value: _isCheckC_1,
                      onChanged: (value) {
                        setState(() {
                          _isCheckC_1 = value!;
                          saveCheckboxState('isCheckedC1', _isCheckC_1);
                          checkedList(_isCheckC_1, "고혈압", 'isCheckedC1'); // 여기서 checkedList 호출

                        });
                      },
                    ),
                    const Text("고혈압"),
                    Checkbox(
                      value: _isCheckC_2,
                      onChanged: (value) {
                        setState(() {
                          _isCheckC_2 = value!;
                          saveCheckboxState('isCheckedC2', _isCheckC_2);
                          checkedList(_isCheckC_2, "해당 없음", 'isCheckedC2'); // 여기서 checkedList 호출

                        });
                      },
                    ),
                    const Text("해당 없음")
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Checkbox(
                      value: _isCheckD_1,
                      onChanged: (value) {
                        setState(() {
                          _isCheckD_1 = value!;
                          saveCheckboxState('isCheckedD1', _isCheckD_1);
                          checkedList(_isCheckD_1, "당뇨", 'isCheckedD1'); // 여기서 checkedList 호출

                        });
                      },
                    ),
                    const Text("당뇨"),
                    Checkbox(
                      value: _isCheckD_2,
                      onChanged: (value) {
                        setState(() {
                          _isCheckD_2 = value!;
                          saveCheckboxState('isCheckedD2', _isCheckD_2);
                          checkedList(_isCheckD_2, "해당 없음", 'isCheckedD2'); // 여기서 checkedList 호출

                        });
                      },
                    ),
                    const Text("해당 없음")
                  ],
                ),
              ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: '나이를 입력 해주세요.',
            ),
            onChanged: (text) {
              try {
                setState(() {
                  age = int.parse(text);
                });
              } catch (e) {
                print('나이 입력이 올바르지 않아요');
              }
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: '키를 입력 해주세요.',
            ),
            onChanged: (text) {
              try {
                setState(() {
                  height = double.parse(text); // double로 변경
                });
              } catch (e) {
                print('키 입력이 올바르지 않아요');
              }
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: '몸무게를 입력 해주세요.',
            ),
            onChanged: (text) {
              try {
                setState(() {
                  weight = double.parse(text); // double로 변경
                });
              } catch (e) {
                print('몸무게 입력이 올바르지 않아요');
              }
            },
          ),
        ),

              Text(
                bmi == null ? 'BMI: N/A' : 'BMI: $bmi',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),


              const SizedBox(
                height: 200,
              )
            ],
          ),
        ),
      ),

      //우측 하단의 버튼을 누르면 저장돼 있는 키와 몸무게로 bmi를 만들어sendlist에 저장
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            double calculatedBmi = weight / pow(height / 100, 2);
            bmi = double.parse(calculatedBmi.toStringAsFixed(2));
            sendList.add((bmi * 100).toInt());

            // BMI와 함께 토스트 메시지 표시
            Fluttertoast.showToast(
              msg: 'BMI: $bmi',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.black,
              textColor: Colors.white,
            );
            print(bmi);
          });
        },
        child: Text('저장'),
      ),





    );
  }


  void calculateBPM(){
    maxBpm = 220 - age;
    normalBpm = maxBpm - int.parse(bpm1);
    //workBpm = normalBpm *운동강도 + int.parse(bpm1); //운동강도는 운동하는거 물어보기
  }

  void checkedList(bool isCheck, String name, String key) {

    if (isCheck) {
      checkList.add(name);
      saveCheckboxState(key, isCheck); // 체크 상태를 저장
      print(checkList);
      print(sendList);

      switch(name){
        case "남자":
          sendList.add(1);
          print("남자");
          break;
        case "여자":
          sendList.add(2);
          print("여자");
          break;
        case "흡연":
          sendList.add(3);
          print("흡연");
          break;
        case "비흡연":
          sendList.add(4);
          print("비흡연");
          break;
        case "당뇨":
          sendList.add(5);
          print("당뇨");
          break;
        case "고혈압":
          sendList.add(6);
          print("고혈압");
          break;
        case "해당 없음":
          sendList.add(0);
          print("해당없음");
          break;
      }

      Fluttertoast.showToast(
        msg: "$checkList 선택",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black, // 배경색상 변경
        textColor: Colors.white, // 텍스트 색상 변경
      );
    } else {
      saveCheckboxState(key, isCheck); // 체크 해제 상태를 저장

      switch(name){
        case "남자":
          sendList.remove(1);
          print("남자");
          break;
        case "여자":
          sendList.remove(2);
          print("여자");
          break;
        case "흡연":
          sendList.remove(3);
          print("흡연");
          break;
        case "비흡연":
          sendList.remove(4);
          print("비흡연");
          break;
        case "당뇨":
          sendList.remove(5);
          print("당뇨");
          break;
        case "고혈압":
          sendList.remove(6);
          print("고혈압");
          break;
        case "해당 없음":
          sendList.remove(0);
          print("해당없음");
          break;
      }

      Fluttertoast.showToast(
        msg: "$name 선택 해제",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
      checkList.remove(name);
      saveCheckboxState(key, isCheck); // 체크 해제 상태를 저장
      print(checkList);
      print(sendList);
    }
  }
}