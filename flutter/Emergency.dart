import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key, required this.title});

  final String title;

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  late Contact selectedContact;

  List<Contact> contacts = [];

  _launchPhone() async {
    if (selectedContact != null) {
      final phoneNumber = selectedContact.phones?.first.value;
      if (phoneNumber != null) {
        try {
          await FlutterPhoneDirectCaller.callNumber(phoneNumber);
        } catch (e) {
          throw '전화 걸기에 실패했습니다: $phoneNumber';
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text("비상 연락처"),
        actions: [
          IconButton(
            onPressed: () {
              getPermission();
            },
            icon: const Icon(Icons.contacts),
          )
        ],
      ),
      body: ListView(
        children: contacts.take(5).map((contact) {
          return ListTile(
            title: Text(contact.displayName ?? ''),
            onTap: () {
              setState(() {
                selectedContact = contact;
              });

              showToast("선택된 연락처: ${contact.displayName}");
            },
          );
        }).toList(),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              addContact();
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 10), // 간격 추가
          FloatingActionButton(
            onPressed: _launchPhone,
            child: const Icon(Icons.phone),
          ),
        ],
      ),
    );
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
  // 주소록 사용권한 요청 함수
  void getPermission() async {
    var status = await Permission.contacts.status;

    if (status.isGranted) {
      // 연락처 권한이 허용된 경우
      print('허락됨');
      List<Contact> contactList = (await ContactsService.getContacts(
        withThumbnails: false,
      )).toList();

      setState(() {
        contacts = contactList;
      });

      // 첫 번째 연락처를 선택하거나 원하는 방식으로 선택
      if (contacts.isNotEmpty) {
        setState(() {
          selectedContact = contacts[0];
        });
      } else {
        // 연락처가 없는 경우에 대한 처리
      }
    } else if (status.isDenied) {
      print('거절됨');
      Permission.contacts.request(); // 허락 요청
    }
    if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  void addContact() async {
    var status = await Permission.contacts.status;

    if (status.isGranted) {
      // 연락처 권한이 허용된 경우
      ContactsService.openContactForm();
    } else if (status.isDenied) {
      // 권한이 거부된 경우, 권한 요청
      Permission.contacts.request();
    } else if (status.isPermanentlyDenied) {
      // 영구적으로 거부된 경우, 앱 설정 열기
      openAppSettings();
    }
  }
}