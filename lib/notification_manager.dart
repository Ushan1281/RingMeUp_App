import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
        notificationResponse ) async{},
        onDidReceiveBackgroundNotificationResponse: (NotificationResponse
        notificationResponse) async{}
    );
  }

  void makeCall(String phoneNumber) async {
    final url = 'tel:9510372889';
    if (await canLaunchUrl(url as Uri)) {
      await launchUrl(url as Uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  final AndroidNotificationAction actionForCall = AndroidNotificationAction(
    'CaLL', 'CALL',
    cancelNotification: false,
      contextual: true,
      inputs: const <AndroidNotificationActionInput>[

      ],
  );
  notificationDetails(){
    return NotificationDetails(
      android: AndroidNotificationDetails('channelId','ChannelName',
        channelShowBadge: true,
        importance: Importance.max,playSound: true,priority: Priority.high,
        actions: [
          actionForCall,
          AndroidNotificationAction(
            'CANCEL',
            'CANCEL',
            cancelNotification: true,
          )
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