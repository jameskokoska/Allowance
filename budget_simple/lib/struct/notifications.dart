import 'dart:io';

import 'package:budget_simple/struct/database_global.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<String?> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('notification_icon_android2');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    // onDidReceiveBackgroundNotificationResponse: onSelectNotification,
    // onDidReceiveNotificationResponse: onSelectNotification,
  );
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  NotificationResponse? payload =
      notificationAppLaunchDetails?.notificationResponse;
  String? response = payload?.payload;
  return response;
}

Future<bool> initializeNotificationsPlatform() async {
  if (kIsWeb || Platform.isLinux) {
    return false;
  }
  try {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
    tz.initializeTimeZones();
    final String locationName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(locationName ?? "America/New_York"));
  } catch (e) {
    print("Error setting up notifications: $e");
    return false;
  }
  print("Notifications initialized");
  return true;
}

Future<void> setDailyNotificationOnLaunch(context) async {
  if (kIsWeb) return;
  if (notifications) {
    await initializeNotificationsPlatform();
    await scheduleDailyNotification(context, notificationsTime);
  }
}

Future<bool> cancelDailyNotification() async {
  for (int i = 1; i <= 14; i++) {
    await flutterLocalNotificationsPlugin.cancel(i);
  }
  print("Cancelled notifications for daily reminder");
  return true;
}

tz.TZDateTime _nextInstanceOfSetTime(TimeOfDay timeOfDay, {int dayOffset = 0}) {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  // add one to current day (if app wasn't opened, it will notify)
  tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
      now.day + dayOffset, timeOfDay.hour, timeOfDay.minute);

  return scheduledDate;
}

Future<bool> scheduleDailyNotification(context, TimeOfDay timeOfDay) async {
  // If the app was opened on the day the notification was scheduled it will be
  // cancelled and set to the next day because of _nextInstanceOfSetTime
  await cancelDailyNotification();

  AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'transactionReminders',
    'Transaction Reminders',
    importance: Importance.max,
    priority: Priority.high,
    color: Theme.of(context).colorScheme.primary,
  );

  // schedule a week worth of notifications
  for (int i = 1; i <= 14; i++) {
    tz.TZDateTime dateTime = _nextInstanceOfSetTime(timeOfDay, dayOffset: i);
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      i,
      'Add Transactions',
      'Don\'t forget to add transactions to Allowance',
      dateTime,
      notificationDetails,
      androidAllowWhileIdle: true,
      payload: 'addTransaction',
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
    print("Notification scheduled for $dateTime with id $i");
  }
  // print(await flutterLocalNotificationsPlugin.getActiveNotifications());

  final List<PendingNotificationRequest> pendingNotificationRequests =
      await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  print(pendingNotificationRequests.first.body);

  return true;
}
