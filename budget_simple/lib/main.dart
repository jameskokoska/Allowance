import 'dart:ui';

import 'package:budget_simple/pages/main_page_layout.dart';
import 'package:budget_simple/pages/on_board.dart';
import 'package:budget_simple/struct/colors.dart';
import 'package:budget_simple/struct/database_global.dart';
import 'package:budget_simple/struct/languages_dict.dart';
import 'package:budget_simple/struct/notifications.dart';
import 'package:budget_simple/struct/translations.dart';
import 'package:budget_simple/widgets/increase_limit.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:system_theme/system_theme.dart';
import 'package:budget_simple/database/tables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

/*
flutter build appbundle --release

firebase deploy
*/

Color systemTheme = Colors.blue;
final InAppReview inAppReview = InAppReview.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  database = constructDb('db');
  if (kIsWeb == false) {
    await SystemTheme.accentColor.load();
    systemTheme = SystemTheme.accentColor.accent;
  }
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
  tz.initializeTimeZones();
  final String locationName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(locationName ?? "America/New_York"));
  sharedPreferences = await SharedPreferences.getInstance();
  packageInfoGlobal = await PackageInfo.fromPlatform();
  String? notificationPayload = await initializeNotifications();
  setSettings();
  dataSetTranslationsApp = await openAppTranslations();
  runApp(
    DevicePreview(
      enabled: kDebugMode,
      builder: (context) => InitializeApp(key: initializeAppStateKey),
    ),
  );
}

setSettings() async {
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
  hasOnboarded = sharedPreferences.getBool("hasOnboarded") ?? false;
  // print(numberLogins);
  if (!kIsWeb) {
    if (numberLogins == 6 || numberLogins == 15) {
      if (await inAppReview.isAvailable()) {
        inAppReview.requestReview();
      }
    }
  }
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
    // print("Rebuilt");
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
      // useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      themeAnimationDuration: const Duration(milliseconds: 1000),
      title: 'Allowance',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: themeColor ?? systemTheme,
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
          seedColor: themeColor ?? systemTheme,
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
      home: SafeArea(
        top: false,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 1200),
          switchInCurve: Curves.easeInOutCubic,
          switchOutCurve: Curves.easeInOutCubic,
          transitionBuilder: (Widget child, Animation<double> animation) {
            final inAnimation = Tween<Offset>(
                    begin: const Offset(-1.0, 0.0), end: const Offset(0.0, 0.0))
                .animate(animation);
            final outAnimation = Tween<Offset>(
                    begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0))
                .animate(animation);

            if (child.key == const ValueKey("Onboarding")) {
              return ClipRect(
                child: SlideTransition(
                  position: inAnimation,
                  child: child,
                ),
              );
            } else {
              return ClipRect(
                child: SlideTransition(position: outAnimation, child: child),
              );
            }
          },
          child: hasOnboarded == false
              ? const OnBoardingPage(
                  key: ValueKey("Onboarding"),
                )
              : const MainPageLayout(),
        ),
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
