import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(EmergencyContactApp());
}

class EmergencyContactApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emergency Contact Alert',
      debugShowCheckedModeBanner: false,
      home: EmergencyContact(),
    );
  }
}

class EmergencyContact extends StatelessWidget {
  const EmergencyContact({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            FlutterPhoneDirectCaller.callNumber('+82 1096127210');
            launchUrl('tel:+82 1096127210' as Uri); // launch 대신 launchUrl 사용
          },
          child: const Text('긴급전화'),
        ),
      ),
    );
  }
}
