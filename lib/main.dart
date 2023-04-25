import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:ringmeup/main_screens/reminders.dart';
import 'package:telephony/telephony.dart';
import 'package:phone_state/phone_state.dart';
import 'notification_manager.dart';

void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    // This task has exceeded its allowed running-time.
    // You must stop what you're doing and immediately .finish(taskId)
    print("[BackgroundFetch] Headless task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }
  print('[BackgroundFetch] Headless event received.');
  // Do your work here...
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
  BackgroundFetch.finish(taskId);
}
// NotificationServices notification=NotificationServices();
void main() async{
   WidgetsFlutterBinding.ensureInitialized();
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
       showOverlay((context, progress) => Container(
         height: 200,
         width: 200,
         decoration: BoxDecoration(
         color: Colors.white
         ),
         child: Text("hiiii"),
       ));
     }
   });
   runApp(MyApp());
   BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);

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
        showOverlay((context, progress) => Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
              color: Colors.white
          ),
          child: Text("hiiii"),
        ));
        NotificationServices().showNotification(
          title: 'Set Call Back Reminder',
          body: 'You Have one Incoming Call''\n''Want to add reminder',

        );
      }else if(event == PhoneStateStatus.CALL_ENDED){
        showOverlay((context, progress) => Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
              color: Colors.white
          ),
          child: Text("hiiii"),
        ));
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


