import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: AppSettingsPage(),
    );
  }
}

class AppSettingsPage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AppSettingsPage> {
  late TextEditingController _usernameController;
  late TextEditingController _emergencyContactController;
  late TextEditingController _allergiesController;
  late TextEditingController _medicalConditionsController;
  late TextEditingController _medicationsController;
  late TextEditingController _bloodTypeController;
  late TextEditingController _medicalHistoryController;
  late TextEditingController _insuranceInfoController;
  late TextEditingController _locationInfoController;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _usernameController = TextEditingController(text: prefs.getString('username') ?? '');
      _emergencyContactController = TextEditingController(text: prefs.getString('emergencyContact') ?? '');
      _allergiesController = TextEditingController(text: prefs.getString('allergies') ?? '');
      _medicalConditionsController = TextEditingController(text: prefs.getString('medicalConditions') ?? '');
      _medicationsController = TextEditingController(text: prefs.getString('medications') ?? '');
      _bloodTypeController = TextEditingController(text: prefs.getString('bloodType') ?? '');
      _medicalHistoryController = TextEditingController(text: prefs.getString('medicalHistory') ?? '');
      _insuranceInfoController = TextEditingController(text: prefs.getString('insuranceInfo') ?? '');
      _locationInfoController = TextEditingController(text: prefs.getString('locationInfo') ?? '');
    });
  }

  _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', _usernameController.text);
    prefs.setString('emergencyContact', _emergencyContactController.text);
    prefs.setString('allergies', _allergiesController.text);
    prefs.setString('medicalConditions', _medicalConditionsController.text);
    prefs.setString('medications', _medicationsController.text);
    prefs.setString('bloodType', _bloodTypeController.text);
    prefs.setString('medicalHistory', _medicalHistoryController.text);
    prefs.setString('insuranceInfo', _insuranceInfoController.text);
    prefs.setString('locationInfo', _locationInfoController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('사용자 의료 정보'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: '사용자 이름, 나이'),
              ),
              TextField(
                controller: _emergencyContactController,
                decoration: InputDecoration(labelText: '긴급 연락처'),
              ),
              TextField(
                controller: _allergiesController,
                decoration: InputDecoration(labelText: '의학적 알레르기'),
              ),
              TextField(
                controller: _medicalConditionsController,
                decoration: InputDecoration(labelText: '의학적 건강 상태'),
              ),
              TextField(
                controller: _medicationsController,
                decoration: InputDecoration(labelText: '현재 복용 중인 약물'),
              ),
              TextField(
                controller: _bloodTypeController,
                decoration: InputDecoration(labelText: '혈액형'),
              ),
              TextField(
                controller: _medicalHistoryController,
                decoration: InputDecoration(labelText: '의료 기록'),
              ),
              TextField(
                controller: _insuranceInfoController,
                decoration: InputDecoration(labelText: '보험 정보'),
              ),
              TextField(
                controller: _locationInfoController,
                decoration: InputDecoration(labelText: '사용자 주소 정보'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _saveSettings();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('설정이 저장되었습니다.')),
                  );
                },
                child: Text('저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
