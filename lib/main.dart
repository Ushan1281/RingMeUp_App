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
       String incomingNumber= event?.index as String;
       NotificationServices().showNotification(
         title: 'Set Call Back Reminder',
         body: 'You Ended Incoming Call'+incomingNumber,
       );
     }
     else if(event == PhoneStateStatus.CALL_INCOMING){
       String incomingNumber= event?.index as String;
       NotificationServices().showNotification(
         title: 'Set Call Back Reminder',
         body: 'You Ended Incoming Call'+incomingNumber,
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
  CallLogs cl = new CallLogs();
  Telephony telephony = Telephony.instance;
  @override
  void initState() {
    super.initState();
    CallLogs().getCallLogs();
    PhoneState.phoneStateStream;
    PhoneState.phoneStateStream.listen((event) {
      if (event == PhoneStateStatus.CALL_INCOMING) {
        /* This is a notification is used to show that in coming is there.
        After clicking this notification (User can redirect to the RingMeUp
        App to set reminder).*/
        NotificationServices().showNotification(
          title: 'Set Call Back Reminder',
          body: 'You Have one Incoming Call''\n''Want to add reminder',
        );
      }else if(event == PhoneStateStatus.CALL_ENDED){
        /* This is a notification is used to show that the app user ended
           incoming-call / call. After clicking this notification (User can
           redirect to the RingMeUp App to set reminder).*/
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