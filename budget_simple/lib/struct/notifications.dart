import 'dart:io';

import 'package:budget_simple/struct/database_global.dart';
import 'package:budget_simple/struct/translations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<String?> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('notification_icon_android2');
  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
          onDidReceiveLocalNotification: (_, __, ___, ____) {});

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
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
  bool result = await checkNotificationsPermissionAll();
  if (result) {
    print("Notifications initialized");
    return true;
  } else {
    return false;
  }
}

Future<bool> checkNotificationsPermissionIOS() async {
  bool? result = await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
  if (result != true) return false;
  return true;
}

Future<bool> checkNotificationsPermissionAndroid() async {
  bool? result = await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestPermission();
  if (result != true) return false;
  return true;
}

Future<bool> checkNotificationsPermissionAll() async {
  try {
    if (Platform.isAndroid) return await checkNotificationsPermissionAndroid();
    if (Platform.isIOS) return await checkNotificationsPermissionIOS();
  } catch (e) {
    print("Error setting up notifications: $e");
    return false;
  }
  return false;
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
    // For testing notifications:
    // dateTime = tz.TZDateTime.now(tz.local).add(Duration(seconds: i * 5));
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      i,
      translateText("Add Transactions"),
      translateText("Don't forget to add transactions to Allowance"),
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
