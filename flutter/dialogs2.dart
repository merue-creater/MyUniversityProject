import 'package:flutter/material.dart';
import 'workpage.dart';
import 'workpage2.dart';


class CallWorkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: workPage(),
    );
  }
}

class Demo extends StatelessWidget {
  const Demo({Key? key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('경고'),
            content: const Text('심장병 보유 가능성이 높음으로 판단됩니다.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                  Future.delayed(Duration.zero, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return WorkPage2();
                        },
                      ),
                    );
                  });
                },
                child: const Text('확인'),
              ),
            ],
          ),
        );
      },
      child: const Text('심장병 판단 팝업창 테스트'),
    );
  }
}
