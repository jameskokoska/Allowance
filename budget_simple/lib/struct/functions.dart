import 'package:budget_simple/struct/database-global.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/number_symbols_data.dart' show numberFormatSymbols;
import 'package:universal_io/io.dart';
import 'package:url_launcher/url_launcher.dart';

pushRoute(BuildContext context, Widget page, {Offset? customOffset}) {
  Navigator.push(
    context,
    PageRouteBuilder(
      opaque: false,
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        Offset begin = customOffset ?? const Offset(0.0, 1.0);
        Offset end = Offset.zero;
        Curve curve = Curves.ease;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return page;
      },
    ),
  );
}

String getDecimalSeparator() {
  return numberFormatSymbols[Platform.localeName.split("-")[0]]?.DECIMAL_SEP ??
      ".";
}

NumberFormat getNumberFormat({int? decimals}) {
  return NumberFormat.currency(
    decimalDigits: decimals ?? 2,
    locale: Platform.localeName,
    symbol: currencyIcon,
  );
}

void openUrl(String link) async {
  if (await canLaunchUrl(Uri.parse(link))) {
    await launchUrl(
      Uri.parse(link),
      mode: LaunchMode.externalApplication,
    );
  }
}
