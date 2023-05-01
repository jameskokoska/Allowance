import 'dart:ui';

import 'package:budget_simple/pages/home_page.dart';
import 'package:budget_simple/struct/colors.dart';
import 'package:budget_simple/struct/database-global.dart';
import 'package:budget_simple/struct/languages-dict.dart';
import 'package:budget_simple/widgets/increase_limit.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:system_theme/system_theme.dart';
import 'package:budget_simple/database/tables.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
TODO: Translations
TODO: Onboarding - set up initial spending limit, currency icon
TODO: Notifications
TODO: ratings, IAP
TODO: host on firebase

adb tcpip 5555
adb connect 192.168.0.22

flutter channel master
flutter upgrade

flutter build appbundle --release

*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  database = constructDb('db');
  await SystemTheme.accentColor.load();
  // Set up the initial spending goal
  try {
    await database.getSpendingLimit();
  } catch (e) {
    await database.createOrUpdateSpendingLimit(
      SpendingLimitData(
        id: 1,
        amount: 500,
        dateCreated: DateTime.now(),
        dateCreatedUntil: dayInAMonth(),
      ),
    );
  }
  sharedPreferences = await SharedPreferences.getInstance();
  packageInfoGlobal = await PackageInfo.fromPlatform();
  setSettings();
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => InitializeApp(key: initializeAppStateKey),
    ),
  );
}

setSettings() {
  currencyIcon = sharedPreferences.getString("currencyIcon") ?? "\$";
  notifications = sharedPreferences.getBool("notifications") ?? true;
  String notificationsTimeStr =
      sharedPreferences.getString("notificationsTime") ?? "16:00";
  notificationsTime = TimeOfDay(
      hour: int.parse(notificationsTimeStr.split(":")[0]),
      minute: int.parse(notificationsTimeStr.split(":")[1]));
  language =
      sharedPreferences.getString("language") ?? (getDeviceLanguage() ?? "en");
  themeColor = stringToColor(sharedPreferences.getString("themeColor"));
  themeMode = sharedPreferences.getString("themeMode") ?? "System";
  dismissedPopupOver = sharedPreferences.getBool("dismissedPopupOver") ?? false;
  dismissedPopupAchieved =
      sharedPreferences.getBool("dismissedPopupAchieved") ?? false;
  dismissedPopupDoneOver =
      sharedPreferences.getBool("dismissedPopupDoneOver") ?? false;
  numberLogins = sharedPreferences.getInt("numberLogins") ?? 0;
  sharedPreferences.setInt("numberLogins", numberLogins + 1);
  print(numberLogins);
}

GlobalKey<_InitializeAppState> initializeAppStateKey = GlobalKey();

class InitializeApp extends StatefulWidget {
  const InitializeApp({Key? key}) : super(key: key);

  @override
  State<InitializeApp> createState() => _InitializeAppState();
}

class _InitializeAppState extends State<InitializeApp> {
  void refreshAppState() {
    setState(() {});
    print("Rebuilt");
    rebuildAllChildren(context);
  }

  @override
  Widget build(BuildContext context) {
    return const App();
  }
}

void rebuildAllChildren(BuildContext context) {
  void rebuild(Element el) {
    el.markNeedsBuild();
    el.visitChildren(rebuild);
  }

  (context as Element).visitChildren(rebuild);
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      themeAnimationDuration: const Duration(milliseconds: 1000),
      title: 'Allowance',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: themeColor ?? SystemTheme.accentColor.accent,
          brightness: Brightness.light,
        ),
        snackBarTheme: const SnackBarThemeData(
          actionTextColor: Color(0xFF81A2D4),
        ),
        useMaterial3: true,
        applyElevationOverlayColor: false,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: themeColor ?? SystemTheme.accentColor.accent,
          brightness: Brightness.dark,
        ),
        snackBarTheme: const SnackBarThemeData(),
        useMaterial3: true,
      ),
      themeMode: themeMode == "Light"
          ? ThemeMode.light
          : themeMode == "Dark"
              ? ThemeMode.dark
              : ThemeMode.system,
      home: const SafeArea(
        top: false,
        child: HomePage(),
      ),
      scrollBehavior: ScrollBehavior(),
    );
  }
}

class ScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
