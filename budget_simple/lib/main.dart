import 'package:budget_simple/pages/home_page.dart';
import 'package:budget_simple/struct/databaseGlobal.dart';
import 'package:budget_simple/widgets/increase_limit.dart';
import 'package:flutter/material.dart';
import 'package:system_theme/system_theme.dart';
import 'package:budget_simple/database/tables.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*

TODO: Translations
TODO: Onboarding - set up initial spending limit, currency icon

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
  setSettings();
  runApp(InitializeApp(key: initializeAppStateKey));
}

setSettings() {
  currencyIcon = sharedPreferences.getString("currencyIcon") ?? "\$";
}

GlobalKey<_InitializeAppState> initializeAppStateKey = GlobalKey();

class InitializeApp extends StatefulWidget {
  const InitializeApp({Key? key}) : super(key: key);

  @override
  State<InitializeApp> createState() => _InitializeAppState();
}

class _InitializeAppState extends State<InitializeApp> {
  void refreshAppState() {
    setSettings();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return const App();
  }
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeAnimationDuration: const Duration(milliseconds: 1000),
      title: 'Budget Simple',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: SystemTheme.accentColor.accent,
          brightness: Brightness.light,
          background: Colors.white,
        ),
        snackBarTheme: const SnackBarThemeData(
          actionTextColor: Color(0xFF81A2D4),
        ),
        useMaterial3: true,
        applyElevationOverlayColor: false,
        canvasColor: Colors.white,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: SystemTheme.accentColor.accent,
          brightness: Brightness.dark,
          background: Colors.black,
        ),
        snackBarTheme: const SnackBarThemeData(),
        useMaterial3: true,
        canvasColor: Colors.black,
      ),
      themeMode: ThemeMode.system,
      home: const SafeArea(
        top: false,
        child: HomePage(),
      ),
    );
  }
}
