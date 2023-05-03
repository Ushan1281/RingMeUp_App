import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices{
  final FlutterLocalNotificationsPlugin
  notificationsPlugin=FlutterLocalNotificationsPlugin();
  Future<void> initNotification() async{
    AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings("ic_launcher");
    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (int id, String? title, String? body,String? payload) async{});
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse
        notificationResponse ) async{});
  }

  /* Show Notification....*/
  /*
  This is a Notification Detail function which show how its look like when
  the user set the notification.
  */
  notificationDetails(){
    return NotificationDetails(
      android: AndroidNotificationDetails('channelId','ChannelName',
        channelShowBadge: true,
        importance: Importance.max,playSound: true,priority: Priority.high,
        actions: [
          AndroidNotificationAction(
            'Call','CALL', cancelNotification: false,inputs: const
          <AndroidNotificationActionInput>[

          ],
          ),
          AndroidNotificationAction(
              'CANCEL','CANCEL',cancelNotification: true

          ),
        ],
      )
    );
  }

  Future showNotification(
  {int id =0, String? title, String? body,String?payload,var button }
  ) async{
    return notificationsPlugin.show(id, title, body,await
    notificationDetails());
  }
  Future setNotification(
      {int id =0, String? title, String? body,String? payload,var scheduleTime}
      ) async{
    return notificationsPlugin.schedule(
        id, title,  body, scheduleTime,notificationDetails(),
         androidAllowWhileIdle: true
    );
  }

}