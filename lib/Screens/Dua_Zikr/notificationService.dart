import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  NotificationService() {
    _initializeNotifications();
  }

  void _initializeNotifications() {
    AwesomeNotifications().initialize(
      null, // Default icon
      [
        NotificationChannel(
          channelKey: 'dua_zikr_channel',
          channelName: 'Dua Zikr Reminders',
          channelDescription: 'Reminds for selected Dua and Zikr',
          importance: NotificationImportance.Max,
          defaultColor: const Color(0xFF9D50DD),
          ledColor: const Color(0xFFFFFFFF),
          channelShowBadge: true,
        ),
      ],
    );
  }

  Future<void> scheduleCustomNotification(
      String title, String body, Duration interval) async {
    final scheduleTime = DateTime.now().add(interval);

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 0, // Notification ID
        channelKey: 'dua_zikr_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        year: scheduleTime.year,
        month: scheduleTime.month,
        day: scheduleTime.day,
        hour: scheduleTime.hour,
        minute: scheduleTime.minute,
        second: 0,
        preciseAlarm: true, // Ensures accurate timing
      ),
    );
  }
}





// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
//
// class NotificationService {
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   NotificationService() {
//     _initializeNotifications();
//   }
//
//   void _initializeNotifications() {
//     const android = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const iOS = DarwinInitializationSettings();
//     const settings = InitializationSettings(android: android, iOS: iOS);
//     _flutterLocalNotificationsPlugin.initialize(settings);
//   }
//
//   Future<void> scheduleCustomNotification(
//       String title, String body, Duration interval) async {
//     const androidDetails = AndroidNotificationDetails(
//       'dua_zikr_channel',
//       'Dua Zikr Reminders',
//       channelDescription: 'Reminds for selected Dua and Zikr',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//
//     const iOSDetails = DarwinNotificationDetails();
//     const details = NotificationDetails(android: androidDetails, iOS: iOSDetails);
//
//     final scheduledTime = tz.TZDateTime.now(tz.local).add(interval);
//
//     await _flutterLocalNotificationsPlugin.zonedSchedule(
//       0, // Notification ID
//       title,
//       body,
//       scheduledTime, // Schedule with TZDateTime
//       details,
//       uiLocalNotificationDateInterpretation:
//       UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//   }
// }



// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
//
// class NotificationService {
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   NotificationService() {
//     _initializeNotifications();
//   }
//
//   void _initializeNotifications() {
//     const android = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const iOS = DarwinInitializationSettings();
//     const settings = InitializationSettings(android: android, iOS: iOS);
//     _flutterLocalNotificationsPlugin.initialize(settings);
//   }
//
//   Future<void> scheduleCustomNotification(
//       String title, String body, Duration interval) async {
//     const androidDetails = AndroidNotificationDetails(
//       'dua_zikr_channel',
//       'Dua Zikr Reminders',
//       channelDescription: 'Reminds for selected Dua and Zikr',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//
//     const iOSDetails = DarwinNotificationDetails();
//     const details = NotificationDetails(android: androidDetails, iOS: iOSDetails);
//
//     final scheduledTime = tz.TZDateTime.now(tz.local).add(interval);
//
//     await _flutterLocalNotificationsPlugin.zonedSchedule(
//       0, // Notification ID
//       title,
//       body,
//       scheduledTime, // Schedule with TZDateTime
//       details,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//       UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//   }
// }
