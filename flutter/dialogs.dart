import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'workpage.dart';

/// Flutter code sample for [AlertDialog].

class CallWorkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: workPage(),
    );
  }
}


class EmergnecyDialog extends StatelessWidget {
  const EmergnecyDialog({super.key});

  Future<void> _makeEmergencyCall() async {
    FlutterPhoneDirectCaller.callNumber('+82 1096127210');
    launchUrl('tel:+82 1096127210' as Uri); // launch 대신 launchUrl 사용
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('응급상황 판단 팝업창 테스트'),
            content: const Text('현재 응급상황이 아니면 확인 버튼을 눌러주세요.'),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  // 응급 상황 버튼을 눌렀을 때 전화를 걸도록 수정
                  await _makeEmergencyCall();
                  Navigator.pop(context, '확인');
                },
                child: const Text('응급 상황'),
              ),

              TextButton(
                onPressed: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('운동중?'),
                      content: const Text('운동중이신가요?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // 내부 다이얼로그 닫기
                            Future.delayed(Duration.zero, () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return workPage();
                                  }
                              ));
                            });
                          },
                          child: const Text('확인'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('확인'),
              ),
            ],
          ),
        );
      },
      child: const Text('응급상황 판단 팝업창 테스트'),
    );
  }
}