import 'dart:math';
import 'package:flutter/material.dart';
import 'CheckButtons.dart';
import 'Emergency.dart';
import 'Monitor.dart';
import 'bluetooth.dart';
import 'device_screen.dart';
import 'dialogs.dart';
import 'dart:async';
import 'Emergency119.dart';
import 'dialogs2.dart';
import 'notification.dart';
import 'menu.dart';

StreamController<String> streamController = StreamController.broadcast();
DateTime? lastNotificationTime;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterLocalNotification.onBackgroundNotificationResponse();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'US',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const MyHomePage( title: 'US'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
        appBar: AppBar(
          title: Text('메뉴'),
        ),
        body: Center(
          child: TextButton(
            child: Text('뒤로가기'),
            onPressed: () {
              Navigator.pop(ctx);
            },
          ),
        )
    );
  }

class CallNum1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FirstPage(title: '',
      ),
    );
  }
}

class SecondPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SecondPage(title: '',
      ),
    );
  }
}

class ThirdPage extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
        body: test(title: '',
          ),
        );
  }
}

class Setting extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
        appBar: AppBar(
          title: Text('설정'),
        ),
        body: Center(
          child: TextButton(
            child: Text('뒤로가기'),
            onPressed: () {
              Navigator.pop(ctx);
            },
          ),
        )
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int new_bpm = int.parse(bpm);
  final Stream<int> stream = Stream.periodic(Duration(seconds: 1), (int new_bpm) => new_bpm); // 1초에 한번씩 업데이트

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
              return MenuPage();
            }
            ));
          },
        ),
      ),

      body: Align(
        alignment: Alignment.center,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/heartbeat.png',  width: 300, height: 300),

                //받은bpm값 1초단위로 변경
                StreamBuilder<int> (
                  stream: stream,
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    int addValue = Random().nextInt(3);
                    new_bpm = new_bpm + addValue;
                    if(new_bpm > 78){
                      new_bpm = 72;
                    }
                    return Text('${new_bpm} beats per minute');
                  },
                ),

                TextButton.icon(
                  icon: Icon(Icons.check),
                  label: Text('Check'),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (BuildContext context) {
                              return CheckBoxs();
                            })
                    );
                  },
                ),
                //if(new_bpm > normal_bpm) <- 이거 수정해야함 noraml_bpm이란걸 만들어서 사용자의 평균 bpm을 만들어야함
                EmergnecyDialog(),
                Demo(),
              ],
            ),
          ),
        ),

      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              IconButton(
                icon: const Icon(Icons.contacts, color: Colors.orangeAccent,),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (BuildContext context) {
                            return CallNum1();
                          }
                      )
                  );
                },
              ),

              IconButton(
                icon: const Icon(Icons.monitor_heart_outlined, color: Colors.grey,),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (BuildContext context) {
                            return SecondPage1(); //secondPage1()
                      }
                      )
                  );
                },
              ),

              IconButton(
                icon: const Icon(Icons.bluetooth_outlined, color: Colors.black,),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(
                      builder: (BuildContext context) {
                    return ThirdPage();
                  })
                  );
                },
              ),

              IconButton(
                icon: const Icon(Icons.warning_amber_outlined, color: Colors.red,),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(
                      builder: (BuildContext context) {
                    return EmergencyContact(); //EmergencyContact
                  })
                  );
                },
              ),
            ],
          ),
        )
      ),
    );
  }
}