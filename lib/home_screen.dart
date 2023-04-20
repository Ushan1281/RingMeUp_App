import 'package:flutter/material.dart';
import 'package:ringmeup/main_screens/chat.dart';
import 'package:ringmeup/main_screens/email.dart';
import 'package:ringmeup/main_screens/sms.dart';
import 'package:ringmeup/phonelog.dart';

import 'main_screens/reminders.dart';

class home_screen extends StatefulWidget {
  const home_screen({Key? key, }) : super(key: key);

  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {

  int currentIndex = 0;
  final screens = [
    reminders(),
    phonelog(),
    email(),
    chat(),
    sms(),
    
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: Container(
        height: 70,
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index)=> setState(() =>currentIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.green,
          unselectedItemColor: const Color.fromRGBO(156, 156, 156, 1),
          selectedIconTheme:   IconThemeData (
            color: Colors.green,
            size: 35,
          ),
          items: const [
            BottomNavigationBarItem(
              icon:Icon(Icons.notifications_active_outlined,),
              label:"Reminder",
            ),
            BottomNavigationBarItem(
              icon:Icon(Icons.call_outlined,),
              label: "Call",
            ),
            BottomNavigationBarItem(
              icon:Icon(Icons.email_outlined,),
              label: "Email ",
            ),
            BottomNavigationBarItem(
              icon:Icon(Icons.chat,),
              label: "Chat",
            ),
            BottomNavigationBarItem(
              icon:Icon(Icons.sms_outlined,),
              label: "SMS",
            ),
          ],
        ),
      ),
    );
  }
}