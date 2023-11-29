import 'dart:math';
import 'dart:async';
import 'workpage.dart';
import 'Emergency119.dart';
import 'package:flutter/material.dart';
import 'notification.dart';
import 'dart:isolate';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

String bpm = '89';
String y_val = '';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key, required this.title});
  final String title;

  @override
  _SecondPageState createState() => _SecondPageState();
}

void backgroundTask(SendPort sendPort) async {
  Timer.periodic(const Duration(seconds: 1), (timer) { // 1초마다 새로운 BPM 값을 생성
    int newBpm = Random().nextInt(30) - 10 + 80; // 70 ~ 100
    sendPort.send(newBpm);
  });
}

class _SecondPageState extends State<SecondPage> {
  int new_bpm = int.parse(bpm);
  final Stream<int> stream =
  Stream.periodic(const Duration(seconds: 1), (int new_bpm) => new_bpm); // 1초에 한번씩 업데이트
  late SharedPreferences prefs;
  late Isolate _isolate;
  late ReceivePort _receivePort;
  bool isEmergency = false;
  bool isExercise = false;

  @override
  void initState() {
    super.initState();
    initIsolate();
    initSharedPreferences();
    FlutterLocalNotification.init();
    Future.delayed(const Duration(seconds: 1), () => FlutterLocalNotification.requestNotificationPermission());
  }

  void initIsolate() async {
    _receivePort = ReceivePort();

    _isolate = await Isolate.spawn(
      backgroundTask,
      _receivePort.sendPort,
    );

    _receivePort.listen((dynamic data) {
      // Isolate에서 받은 데이터로 UI 업데이트
      setState(() {
        new_bpm = data;
        // 푸시 알림 추가
        analyzeHeartRate(new_bpm);
      });
    });
  }

  void initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      new_bpm = prefs.getInt('bpm') ?? 80;
    });
  }


  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('심박수 분석'),
      ),
      body: StreamBuilder<String>(
        stream: streamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == 'HELLO') {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (new_bpm <= 40 && (lastNotificationTime == null || DateTime.now().difference(lastNotificationTime!).inSeconds >= 7)) {
                  lastNotificationTime = DateTime.now();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return EmergencyContact();
                    }),
                  );
                }
              });
            } else if (snapshot.data == 'WORLD') {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (new_bpm >= 100 && (lastNotificationTime == null || DateTime.now().difference(lastNotificationTime!).inSeconds >= 7)) {
                  lastNotificationTime = DateTime.now();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return workPage();
                    }),
                  );
                }
              });
            }
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder<int>(
                  stream: stream,
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    int addValue = Random().nextInt(20)-10;
                    new_bpm = new_bpm + addValue;

                    prefs.setInt('bpm', new_bpm);
                    //test
                    if (new_bpm < 30 || new_bpm > 230) {
                      new_bpm = 80;
                    }

                    if (new_bpm <= 40 && isEmergency) {
                      Future.delayed(const Duration(seconds: 10), () {
                        if (isEmergency) {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return EmergencyContact();
                            }),
                          );
                        }
                      });
                    }else if(new_bpm >=220 && isEmergency){
                      Future.delayed(const Duration(seconds: 10), () {
                        if (isEmergency) {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return EmergencyContact();
                            }),
                          );
                        }
                      });
                    }

                    analyzeHeartRate(new_bpm);

                    return Text('$new_bpm BPM');
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    streamController.close();
    if (_isolate != null) {
      _isolate.kill();
    }
    super.dispose();
  }

  void analyzeHeartRate(int new_bpm) {
    if (new_bpm <= 40) {
      isEmergency = true;
      FlutterLocalNotification.showNotification(message: '현재 심박수: $new_bpm bpm');
    }
    else if (new_bpm >= 100) {
      isExercise = true;
      FlutterLocalNotification.showNotification2(message: '현재 심박수: $new_bpm bpm');
      if (isExercise == true && (new_bpm <= 40 || new_bpm >= 220)) {
        isEmergency = true;
        FlutterLocalNotification.showNotification(message: '현재 심박수: $new_bpm bpm');
        // 운동 상태에서 정상 범위로 돌아왔을 경우 운동 상태 종료
        if (isExercise = true && new_bpm >= 40 && new_bpm <= 100) {
          isExercise = false;
          isEmergency = false;
        }
      }
    }
  }
}