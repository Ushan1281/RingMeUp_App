import 'package:flutter/material.dart';
import 'package:overlay_dialog/overlay_dialog.dart';
import 'package:ringmeup/main_screens/reminders.dart';
import 'package:telephony/telephony.dart';
import 'package:phone_state/phone_state.dart';
import 'notification_manager.dart';


// NotificationServices notification=NotificationServices();
void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  // await BackgroundFetch.configure(
  // BackgroundFetchConfig(
  // minimumFetchInterval: 15,
  // stopOnTerminate: false,
  // enableHeadless: true,
  // requiresBatteryNotLow: false,
  // requiresCharging: false,
  // requiresStorageNotLow: false,
  // requiresDeviceIdle: false,
  // startOnBoot: true,
  // ),
  // (String taskId) async {
  //   PhoneState.phoneStateStream.listen((event) {
  //     if (event == PhoneStateStatus.CALL_ENDED) {
  //       NotificationServices().showNotification(
  //         title: 'Set Call Back Reminder',
  //         body: 'You Have one Incoming Call',
  //       );
  //     }else if(event == PhoneStateStatus.CALL_INCOMING){
  //       NotificationServices().showNotification(
  //         title: 'Set Call Back Reminder',
  //         body: 'You Have one Incoming Call',
  //       );
  //     }
  //   });
  // print('Background task started: $taskId');
  // BackgroundFetch.finish(taskId);
  // },
  // );
   PhoneState.phoneStateStream;
   PhoneState.phoneStateStream.listen((event) {
     if (event == PhoneStateStatus.CALL_ENDED) {
       Widget _buildOverlay() {
         return Positioned.fill(
           child: Container(
             color: Colors.black.withOpacity(0.5),
             child: Center(
               child: Text(
                 'Incoming call...',
                 style: TextStyle(fontSize: 24, color: Colors.white),
               ),
             ),
           ),
         );
       }
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
    PhoneState.phoneStateStream;
    PhoneState.phoneStateStream.listen((event) {
      if (event == PhoneStateStatus.CALL_INCOMING) {
        NotificationServices().showNotification(
          title: 'Set Call Back Reminder',
          body: 'You Have one Incoming Call''\n''Want to add reminder',

        );
      }else if(event == PhoneStateStatus.CALL_ENDED){
        NotificationServices().showNotification(
          title: 'Set Call Back Reminder',
          body: 'You ended incoming call!!''\n''Want to add reminder',
        );
      }
      else{
        print("Error");
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      routes: {
        "/":(context) => reminders(),
      },
    );
  }
}


