import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:ringmeup/calllog.dart';
import 'package:ringmeup/main_screens/reminders.dart';
import 'package:telephony/telephony.dart';
import 'package:phone_state/phone_state.dart';
import 'notification_manager.dart';

// NotificationServices notification=NotificationServices();
void main() async{
   WidgetsFlutterBinding.ensureInitialized();
   PhoneState.phoneStateStream;
   PhoneState.phoneStateStream.listen((event) {
     if (event == PhoneStateStatus.CALL_ENDED) {
       NotificationServices().showNotification(
         title: 'Set Call Back Reminder',
         body: 'You Ended Incoming Call',
       );
     }
     else if(event == PhoneStateStatus.CALL_INCOMING){
       NotificationServices().showNotification(
         title: 'Set Call Back Reminder',
         body: 'You Have one Incoming Call',
       );
     }
   });

   runApp(MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  Telephony telephony = Telephony.instance;
  @override
  void initState() {
    super.initState();
    CallLogs().getCallLogs();
    PhoneState.phoneStateStream;
    PhoneState.phoneStateStream.listen((event) {
      if (event == PhoneStateStatus.CALL_INCOMING) {
        // showOverlay((context, progress) => AlertDialog(
        //   content: Container(
        //     decoration: BoxDecoration(
        //       color: Colors.cyan
        //     ),
        //     child: Column(
        //       children: [
        //         Text('data')
        //       ],
        //     ),
        //   ),
        // ));
        NotificationServices().showNotification(
          title: 'Set Call Back Reminder',
          body: 'You Have one Incoming Call''\n''Want to add reminder',
        );
      }else if(event == PhoneStateStatus.CALL_ENDED){
        // showOverlay((context, progress) => AlertDialog(
        //   content: Container(
        //     child: Text('dddddd'),
        //   )
        // ));
        NotificationServices().showNotification(
          title: 'Set Call Back Reminder',
          body: 'You Ended Incoming Call',
        );
      }
      else{
        print("Error");
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        routes: {
          "/":(context) => reminders(),
        },
      ),
    );
  }
}