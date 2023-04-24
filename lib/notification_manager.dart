import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
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
        onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse ) async{});
  }
  notificationDetails(){
    return NotificationDetails(
      android: AndroidNotificationDetails('channelId','ChannelName',
        importance: Importance.max,playSound: true,priority: Priority.high,
          progress: 0),


    );
  }

  Button(){
    return NotificationActionButton(
      key: "open",
      label: "Open File",
    );
  }
  Future showNotification(
  {int id =0, String? title, String? body,String?  payload }
  ) async{

    return notificationsPlugin.show(id, title, body, await
    notificationDetails());
  }

  Future setNotification(
      {int id =0, String? title, String? body,String? payload,var scheduleTime}
      ) async{
    return notificationsPlugin.schedule(
        id, title, body, scheduleTime,notificationDetails(),
         androidAllowWhileIdle: true
    );
  }
}