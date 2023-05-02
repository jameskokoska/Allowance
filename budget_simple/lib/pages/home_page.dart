import 'package:budget_simple/main.dart';
import 'package:budget_simple/pages/about_page.dart';
import 'package:budget_simple/pages/transactions_history_page.dart';
import 'package:budget_simple/struct/database_global.dart';
import 'package:budget_simple/struct/functions.dart';
import 'package:budget_simple/struct/notifications.dart';
import 'package:budget_simple/widgets/amount_button.dart';
import 'package:budget_simple/widgets/change_currency_icon.dart';
import 'package:budget_simple/widgets/home_message.dart';
import 'package:budget_simple/widgets/increase_limit.dart';
import 'package:budget_simple/widgets/support_developer.dart';
import 'package:budget_simple/widgets/tappable.dart';
import 'package:budget_simple/widgets/text_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:budget_simple/database/tables.dart';

initializeAppWithUI(BuildContext context) async {
  await setDailyNotificationOnLaunch(context);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String amountCalculated = "";
  String formattedOutput = "";
  bool showedWarningSnackbar = false;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: "");
    Future.delayed(
      const Duration(milliseconds: 0),
      () {
        initializeAppWithUI(context);
      },
    );
  }

  removeAllAmount() {
    amountCalculated = "";
    formattedOutput = "";
    _textController.value = const TextEditingValue(
      text: "",
    );
    setState(() {});
  }

  addToAmount(String action) async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if (action == "<") {
      if (amountCalculated.isNotEmpty) {
        amountCalculated =
            amountCalculated.substring(0, amountCalculated.length - 1);
      }
    } else if (action == ">") {
      if (amountCalculated != "") {
        if ((double.tryParse(amountCalculated) ?? 0) > MAX_AMOUNT) {
          amountCalculated = MAX_AMOUNT.toString();
        }
        int transactionAdded = await database.createTransaction(
          TransactionsCompanion.insert(
            amount: double.tryParse(amountCalculated) ?? 0,
            name: _textController.text,
          ),
        );
        HapticFeedback.heavyImpact();
        SnackBar snackBar = SnackBar(
          content: Text('Added $formattedOutput transaction'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              database.deleteTransaction(transactionAdded, context: context);
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        removeAllAmount();
      } else {
        if (showedWarningSnackbar == false) {
          const snackBar = SnackBar(
            content: Text('Enter an amount'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          showedWarningSnackbar = true;
        }
      }
    } else if (action == ".") {
      if (amountCalculated == "") {
        amountCalculated += "0.";
      } else if (!amountCalculated.contains(".")) {
        amountCalculated += action;
      }
    } else {
      if (amountCalculated.split('.').length > 1 &&
          amountCalculated.toString().split('.')[1].length >= 2) {
        return;
      }
      if ((double.tryParse(amountCalculated) ?? 0) < MAX_AMOUNT) {
        showedWarningSnackbar = false;
        amountCalculated += action;
      }
    }

    if (amountCalculated == "") {
      formattedOutput = "";
      setState(() {});
      return;
    }

    NumberFormat currency =
        getNumberFormat(decimals: amountCalculated.contains(".") ? 2 : 0);
    formattedOutput = currency.format(double.tryParse(amountCalculated));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = 400;
    BoxConstraints constraints = BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width > maxWidth
            ? maxWidth
            : MediaQuery.of(context).size.width);

    Widget amountRemainingWidget = Tappable(
      color: Colors.transparent,
      onTap: () {
        addAmountBottomSheet(context);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: StreamBuilder<SpendingLimitData>(
              stream: database.watchSpendingLimit(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return const SizedBox();
                }
                return StreamBuilder<double?>(
                  stream:
                      database.totalSpendAfterDay(snapshot.data!.dateCreated),
                  builder: (context, snapshotTotalSpent) {
                    NumberFormat currency = getNumberFormat();
                    double amount =
                        snapshot.data!.amount - (snapshotTotalSpent.data ?? 0);
                    int moreDays = (snapshot.data!.dateCreatedUntil
                                .difference(DateTime.now())
                                .inHours /
                            24)
                        .ceil();
                    if (moreDays < 0) moreDays = 0;
                    moreDays = moreDays.abs();
                    return Column(
                      children: [
                        HomeMessage(
                            onClose: () {
                              dismissedPopupOver = true;
                              sharedPreferences.setBool(
                                  "dismissedPopupOver", true);
                              initializeAppStateKey.currentState
                                  ?.refreshAppState();
                            },
                            show: amount < 0 && dismissedPopupOver == false,
                            title: "Over budget!",
                            message:
                                "You overspent on your allowance. It is recommended to reset your allowance when your term ends to track how much you overspent."),
                        HomeMessage(
                            onClose: () {
                              dismissedPopupAchieved = true;
                              sharedPreferences.setBool(
                                  "dismissedPopupAchieved", true);
                              initializeAppStateKey.currentState
                                  ?.refreshAppState();
                            },
                            show: dismissedPopupAchieved == false &&
                                amount >= 0 &&
                                moreDays <= 0,
                            title: "Budget Achieved!",
                            message:
                                "Congratulations on finishing your allowance with money to spare! Reset your allowance by tapping the amount below."),
                        HomeMessage(
                            onClose: () {
                              dismissedPopupDoneOver = true;
                              dismissedPopupAchieved = true;
                              sharedPreferences.setBool(
                                  "dismissedPopupDoneOver", true);
                              initializeAppStateKey.currentState
                                  ?.refreshAppState();
                            },
                            show: dismissedPopupDoneOver == false &&
                                amount < 0 &&
                                moreDays <= 0,
                            title: "Term Completed Over Budget",
                            message:
                                "Your budget term has ended but overspent. Adjust your spending habits or budget goals for the next cycle. Reset your allowance by tapping the amount below."),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          child: Column(
                            children: [
                              AnimatedSize(
                                duration: const Duration(milliseconds: 700),
                                clipBehavior: Clip.none,
                                curve: Curves.elasticOut,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 900),
                                  switchInCurve: const ElasticOutCurve(0.6),
                                  switchOutCurve: const ElasticInCurve(0.6),
                                  transitionBuilder: (Widget child,
                                      Animation<double> animation) {
                                    final inAnimation = Tween<Offset>(
                                            begin: const Offset(0.0, 1),
                                            end: const Offset(0.0, 0.0))
                                        .animate(animation);
                                    return ClipRect(
                                      clipper: BottomClipper(),
                                      child: SlideTransition(
                                        position: inAnimation,
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                    key: ValueKey(snapshotTotalSpent.data),
                                    height: 67,
                                    child: TextFont(
                                      text: currency
                                          .format(amount < 0 ? 0 : amount),
                                      fontSize: 55,
                                      fontWeight: FontWeight.bold,
                                      autoSizeText: true,
                                      minFontSize: 15,
                                      maxFontSize: 55,
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                              ),
                              TextFont(
                                text:
                                    "${currency.format(amount.abs() / moreDays)}/day for $moreDays more ${moreDays == 1 ? "day" : "days"}",
                                fontSize: 17,
                                maxLines: 3,
                                textAlign: TextAlign.center,
                                textColor:
                                    Theme.of(context).colorScheme.tertiary,
                              ),
                              amount < 0
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        child: TextFont(
                                          key: ValueKey(amount),
                                          text:
                                              "${currency.format(amount.abs())} overspent",
                                          textColor: Theme.of(context)
                                              .colorScheme
                                              .error,
                                          fontSize: 15,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink()
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );

    Widget topHeaderWidget = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () {
            pushRoute(context, const TransactionsHistoryPage());
          },
          icon: const Icon(Icons.receipt),
          padding: EdgeInsets.zero,
        ),
        IconButton(
          onPressed: () {
            pushRoute(context, const AboutPage());
          },
          icon: const Icon(Icons.settings),
          padding: EdgeInsets.zero,
        ),
        const SizedBox(width: 5),
      ],
    );

    Widget amountEnteredWidget = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.bottomRight,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              switchInCurve: Curves.elasticOut,
              switchOutCurve: Curves.easeInOutCubicEmphasized,
              transitionBuilder: (Widget child, Animation<double> animation) {
                final inAnimation = Tween<Offset>(
                        begin: const Offset(0.0, 1.0),
                        end: const Offset(0.0, 0.0))
                    .animate(animation);
                return ClipRect(
                  clipper: BottomClipper(),
                  child: SlideTransition(
                    position: inAnimation,
                    child: child,
                  ),
                );
              },
              child: AnimatedSize(
                key: ValueKey(formattedOutput == ""),
                duration: const Duration(milliseconds: 700),
                clipBehavior: Clip.none,
                curve: Curves.elasticOut,
                child: SizedBox(
                  height: 55,
                  child: TextFont(
                    text: formattedOutput,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    maxLines: 1,
                    autoSizeText: true,
                    minFontSize: 15,
                    maxFontSize: 55,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
      ],
    );

    Widget transactionNameFieldWidget = TextField(
      controller: _textController,
      textAlign: TextAlign.right,
      maxLength: 40,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        hintText: 'Transaction Name',
        counterText: "",
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
        ),
      ),
    );

    Widget amountButtonsTopWidget = SizedBox(
      width: constraints.maxWidth,
      child: Row(
        children: <Widget>[
          AmountButton(
            constraints: constraints,
            text: "7",
            addToAmount: addToAmount,
          ),
          AmountButton(
            constraints: constraints,
            text: "8",
            addToAmount: addToAmount,
          ),
          AmountButton(
            constraints: constraints,
            text: "9",
            addToAmount: addToAmount,
          ),
          AmountButton(
            constraints: constraints,
            text: "<",
            addToAmount: addToAmount,
            onLongPress: removeAllAmount,
            child: const Icon(Icons.backspace_outlined),
          ),
        ],
      ),
    );

    Widget amountButtonsBottomWidget = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            SizedBox(
              width: constraints.maxWidth * 0.75,
              child: Row(
                children: <Widget>[
                  AmountButton(
                    constraints: constraints,
                    text: "4",
                    addToAmount: addToAmount,
                  ),
                  AmountButton(
                    constraints: constraints,
                    text: "5",
                    addToAmount: addToAmount,
                  ),
                  AmountButton(
                    constraints: constraints,
                    text: "6",
                    addToAmount: addToAmount,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: constraints.maxWidth * 0.75,
              child: Row(
                children: <Widget>[
                  AmountButton(
                    constraints: constraints,
                    text: "1",
                    addToAmount: addToAmount,
                  ),
                  AmountButton(
                    constraints: constraints,
                    text: "2",
                    addToAmount: addToAmount,
                  ),
                  AmountButton(
                    constraints: constraints,
                    text: "3",
                    addToAmount: addToAmount,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: constraints.maxWidth * 0.75,
              child: Row(
                children: <Widget>[
                  AmountButton(
                    constraints: constraints,
                    text: "0",
                    widthRatio: 0.5,
                    addToAmount: addToAmount,
                    animationScale: 0.93,
                  ),
                  AmountButton(
                    constraints: constraints,
                    text: getDecimalSeparator(),
                    addToAmount: addToAmount,
                  ),
                ],
              ),
            ),
          ],
        ),
        AmountButton(
          animationScale: 0.94,
          constraints: constraints,
          text: ">",
          addToAmount: addToAmount,
          heightRatio: 0.75,
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [Icon(Icons.check), SizedBox(height: 30)],
          ),
        ),
      ],
    );

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          //Minimize keyboard when tap non interactive widget
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: SafeArea(
                bottom: false,
                left: false,
                right: false,
                top: true,
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    topHeaderWidget,
                    numberLogins == 6
                        ? const SupportDeveloper(
                            showCloseButton: true,
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(height: 5),
                    const Spacer(),
                    amountRemainingWidget,
                    const Spacer(),
                    const SizedBox(height: 5),
                    amountEnteredWidget,
                    transactionNameFieldWidget,
                    const SizedBox(height: 10),
                    amountButtonsTopWidget,
                    amountButtonsBottomWidget,
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

addAmountBottomSheet(context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    constraints: const BoxConstraints(maxWidth: 350),
    builder: (BuildContext context) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: const IncreaseLimit(),
      );
    },
  );
}

changeCurrencyIconBottomSheet(context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    constraints: const BoxConstraints(maxWidth: 350),
    builder: (BuildContext context) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: const ChangeCurrencyIcon(),
      );
    },
  );
}

class BottomClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(
      0.0,
      size.height,
      size.width,
      -250,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}
