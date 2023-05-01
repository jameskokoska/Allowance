import 'package:budget_simple/main.dart';
import 'package:budget_simple/struct/database-global.dart';
import 'package:budget_simple/widgets/text_font.dart';
import 'package:flutter/material.dart';

class ChangeCurrencyIcon extends StatelessWidget {
  const ChangeCurrencyIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      const Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 5),
        child: TextFont(
          text: "Change Currency Icon",
          fontSize: 30,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
        ),
      ),
      IntrinsicWidth(
        child: TextFormField(
          maxLength: 5,
          decoration: InputDecoration(
            hintText: currencyIcon,
            counterText: "",
          ),
          autofocus: true,
          onFieldSubmitted: (value) {
            sharedPreferences.setString("currencyIcon", value);
            initializeAppStateKey.currentState?.refreshAppState();
            Navigator.pop(context);
          },
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20),
        ),
      ),
      const SizedBox(height: 35),
    ]);
  }
}
