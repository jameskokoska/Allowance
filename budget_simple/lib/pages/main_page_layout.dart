import 'package:budget_simple/pages/home_page.dart';
import 'package:budget_simple/pages/transactions_history_page.dart';
import 'package:budget_simple/widgets/top_header_buttons.dart';
import 'package:flutter/material.dart';

bool getIsFullScreen(context) {
  double maxWidth = 800;
  return MediaQuery.of(context).size.width > maxWidth;
}

double getHalfWidth(context) {
  double maxWidth = 1500;
  if (MediaQuery.of(context).size.width > maxWidth) return maxWidth / 2;
  return MediaQuery.of(context).size.width / 2;
}

getSpaceBetween(context) {
  double maxSpaceBetween = 100;
  double calculatedSpace =
      MediaQuery.of(context).size.width - getHalfWidth(context) * 2;
  if (calculatedSpace > maxSpaceBetween) return maxSpaceBetween;
  return calculatedSpace;
}

class MainPageLayout extends StatefulWidget {
  const MainPageLayout({super.key});

  @override
  State<MainPageLayout> createState() => _MainPageLayoutState();
}

class _MainPageLayoutState extends State<MainPageLayout> {
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        loaded = true;
      });
    });
  }

  Widget getChild() {
    return getIsFullScreen(context)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: getHalfWidth(context),
                child: const TransactionsHistoryPage(),
              ),
              SizedBox(width: getSpaceBetween(context)),
              SizedBox(
                width: getHalfWidth(context),
                child: const HomePage(),
              ),
            ],
          )
        : const HomePage();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeInOutCubic,
      switchOutCurve: Curves.easeInOutCubic,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 1.1, end: 1.0).animate(animation),
            child: Scaffold(
              body: Stack(children: [
                child,
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: getIsFullScreen(context)
                      ? const TopHeaderButtons(large: true)
                      : const SizedBox.shrink(),
                ),
              ]),
            ),
          ),
        );
      },
      child: loaded ? getChild() : const SizedBox.shrink(),
    );
  }
}
