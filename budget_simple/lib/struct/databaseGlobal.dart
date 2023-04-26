import 'package:budget_simple/database/tables.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

late TransactionsDatabase database;

double MAX_AMOUNT = 999999;

late SharedPreferences sharedPreferences;
late String currencyIcon;
late bool notifications;
late TimeOfDay notificationsTime;
