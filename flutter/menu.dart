import 'package:flutter/material.dart';
import 'AppSettingsPage.dart';
import 'CheckButtons.dart';
import 'Emergency.dart';
import 'Emergency119.dart';
import 'workpage.dart';
import 'main.dart';

void main() {
  runApp(MenuPage());
}

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메뉴'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.contacts),
            title: Text('연락처'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return FirstPage(title: '');
                },
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('심박수 분석'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return SecondPage1();
                },
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.bluetooth),
            title: Text('블루투스'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return ThirdPage();
                },
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text('긴급전화'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return EmergencyContact();
                },
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.healing),
            title: Text('건강 상태 체크'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return CheckBoxs();
                },
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.directions_run),
            title: Text('운동상태'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return workPage();
                },
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.local_hospital_outlined),
            title: Text('사용자 의료 정보'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return AppSettingsPage();
                },
              ));
            },
          ),
        ],
      ),
    );
  }
}
