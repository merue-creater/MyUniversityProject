import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '심장 선택',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WorkPage2(),
    );
  }
}

class WorkPage2 extends StatelessWidget {
  final List<String> diseases = [
    '심근경색증',
    '협심증',
    '동맥경화',
    '심장 판막증',
    '심부전',
    '심장비대증',
    '부정맥',
    // 여기에 필요한 다른 심장병 추가 가능
  ];

  final List<String> text = [
    '가슴에 압박, 쥐어짜는 듯한 통증이 오거나, 갑자기 가슴 중앙부로부터 어깨, 목, 팔 등에서 통증을 느낀다. 식은 땀이 나며 숨쉬기가 힘들면서 불쾌감을 느끼기도 하고 오목 가슴이 아프고 토할 수도 있다.',
    '안정 시에는 통증이 없다가 심장 근육에 많은 산소가 필요한 상황, 즉 운동을 하거나 무거운 물건을 드는 경우, 차가운 날씨에 노출되는 경우, 흥분한 경우에 통증이 발생합니다. 지속 시간은 심근경색증과 달리 대개 5~10분 미만이며, 안정을 취하면 없어집니다. 그러나 병이 심해지면 안정 시에도 통증이 발생하고, 통증의 지속 시간도 길어질 수 있습니다. 이는 심근경색증으로 진행될 확률이 높은 매우 위급한 상황이다.',
    '동맥경화가 상당히 진행되어 있더라도 증상이 나타나지 않는 것이 보통입니다. 동맥 내부공간의 70% 이상이 막히면 말초부위의 혈류가 감소하여 비로소 증상을 느끼게 됩니다. 즉, 환자가 아무 불편을 느끼지 않아도 동맥경화가 상당히 진행되어 있는 경우가 많습니다. 동맥경화로 인해 혈액순환이 저하되어 나타나는 초기 증상으로는 손발이 차고 저리며, 뒷목 당김, 어깨 결림, 기억력 감퇴, 현기증, 만성 피로, 발의 냉감, 통증으로 인한 보행장애, 근육통 등이 있습니다.',
    '공통적인 증상은 호흡곤란, 전신 부종, 피로감 등이 있습니다.  증상의 심하기와 판막 이상의 정도가 반드시 일치하는 것은 아니나, 보통 판막 질환이 진행함에 따라 악화되는 양상을 보입니다. ',
    '다리 및 발목의 부종, 호흡곤란, 피곤과 정신쇠약, 수분 축적으로 인한 체중의 증가 등이다. 심부전은 보통 수개월 또는 수년에 걸쳐 진행되나 어떤 환자에서는 급격히 발생되기도 한다.',
    '호흡곤란, 가슴 통증, 운동 시 호흡곤란, 다리 부종, 전신 부종, 누웠을 때의 호흡곤란 등이 동반하게 된다.',
    '가슴 두근거림(심계항진) 입니다. 두근거림에는 가슴이 방망이질하듯 계속적으로 빠르게 뛰는 경우와 간헐적으로 심장 박동이 하나씩 건너뛰거나 강하게 느껴지는 경우가 있습니다. 또 다른 증상으로는 호흡곤란, 흉통, 현기증, 실신, 돌연사 등이 있습니다.',
    // 여기에 심장병 설명
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('심장병 정보'),
      ),
      body: ListView.builder(
        itemCount: diseases.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.heart_broken), // 예시 아이콘
            title: Text(diseases[index]),
            onTap: () {
              _showAlertDialog(context, diseases[index], text[index]);
            },
          );
        },
      ),
    );
  }

  void _showAlertDialog(BuildContext context, String disease, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$disease'),
          content: Text('$text'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}
