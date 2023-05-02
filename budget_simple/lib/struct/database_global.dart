import 'package:budget_simple/database/tables.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

late TransactionsDatabase database;

double MAX_AMOUNT = 999999;
int DEFAULT_LIMIT = 100;

late SharedPreferences sharedPreferences;
late String currencyIcon;
late bool notifications;
late TimeOfDay notificationsTime;
late String language;
late String themeMode;
late Color? themeColor;
late PackageInfo packageInfoGlobal;
late bool dismissedPopupOver;
late bool dismissedPopupAchieved;
late bool dismissedPopupDoneOver;
late int numberLogins;
late bool hasOnboarded;
