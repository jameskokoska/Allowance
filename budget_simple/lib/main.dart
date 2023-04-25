import 'dart:io';

import 'package:budget_simple/struct/databaseGlobal.dart';
import 'package:budget_simple/widgets/animated_scale_bounce.dart';
import 'package:budget_simple/widgets/tappable.dart';
import 'package:budget_simple/widgets/text_font.dart';
import 'package:flutter/material.dart';
import 'package:implicitly_animated_list/implicitly_animated_list.dart';
import 'package:intl/intl.dart';
import 'package:system_theme/system_theme.dart';
import 'package:budget_simple/database/tables.dart';

void main() async {
  database = constructDb('db');
  await SystemTheme.accentColor.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
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
      scrollBehavior: const ScrollBehavior(),
      themeMode: ThemeMode.system,
      home: const SafeArea(
        top: false,
        child: MyHomePage(
          title: "",
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String amountCalculated = "";
  String formattedOutput = "";
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: "");
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
        int transactionAdded = await database.createTransaction(
          TransactionsCompanion.insert(
            amount: double.tryParse(amountCalculated) ?? 0,
            name: _textController.text,
          ),
        );
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

        _textController.value = const TextEditingValue(
          text: "",
        );
        amountCalculated = "";
      } else {
        const snackBar = SnackBar(
          content: Text('Enter an amount'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
      amountCalculated += action;
    }

    if (amountCalculated == "") {
      formattedOutput = "";
      setState(() {});
      return;
    }

    NumberFormat currency = NumberFormat.currency(
      decimalDigits: amountCalculated.contains(".") ? 2 : 0,
      locale: Platform.localeName,
      symbol: ('\$'),
    );
    formattedOutput = currency.format(double.tryParse(amountCalculated));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = 400;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          //Minimize keyboard when tap non interactive widget
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth:
                        (MediaQuery.of(context).size.height - 100) > maxWidth
                            ? maxWidth
                            : MediaQuery.of(context).size.height - 100),
                child: LayoutBuilder(
                    builder: (context, BoxConstraints constraints) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                          onPressed: () {
                            pushRoute(context, const TransactionsHistoryPage());
                          },
                          icon: const Icon(Icons.receipt)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          TextFont(
                            text: "\$300",
                            fontSize: 55,
                            fontWeight: FontWeight.bold,
                          ),
                          TextFont(
                            text: " left for this month",
                            fontSize: 19,
                          ),
                        ],
                      ),
                      const SizedBox(height: 250),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                switchInCurve: Curves.elasticOut,
                                switchOutCurve: Curves.easeInOutCubicEmphasized,
                                transitionBuilder: (Widget child,
                                    Animation<double> animation) {
                                  final inAnimation = Tween<Offset>(
                                          begin: const Offset(0.0, 1.0),
                                          end: const Offset(0.0, 0.0))
                                      .animate(animation);
                                  return ClipRect(
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
                                  child: TextFont(
                                    text: formattedOutput,
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                      TextField(
                        controller: _textController,
                        textAlign: TextAlign.right,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          hintText: 'Transaction Name',
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
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
                              child: const Icon(Icons.backspace_outlined),
                            ),
                          ],
                        ),
                      ),
                      Row(
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
                                    ),
                                    AmountButton(
                                      constraints: constraints,
                                      text: ".",
                                      addToAmount: addToAmount,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          AmountButton(
                            constraints: constraints,
                            text: ">",
                            addToAmount: addToAmount,
                            heightRatio: 0.75,
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                Icon(Icons.check),
                                SizedBox(height: 30)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

pushRoute(BuildContext context, Widget page) {
  Navigator.push(
    context,
    PageRouteBuilder(
      opaque: false,
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

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

class TransactionsHistoryPage extends StatelessWidget {
  const TransactionsHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Transactions"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.add_rounded),
      ),
      body: const TransactionsList(),
    );
  }
}

class TransactionsList extends StatelessWidget {
  const TransactionsList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Transaction>>(
      stream: database.watchAllTransactions(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return ImplicitlyAnimatedList(
            itemData: snapshot.data!,
            itemBuilder: (_, transaction) => TransactionEntry(
              transaction: transaction,
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class TransactionEntry extends StatelessWidget {
  const TransactionEntry({super.key, required this.transaction});
  final Transaction transaction;
  @override
  Widget build(BuildContext context) {
    NumberFormat currency = NumberFormat.currency(
      decimalDigits: 2,
      locale: Platform.localeName,
      symbol: ('\$'),
    );
    return Tappable(
      onTap: () async {
        String? result = await showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Delete Transaction?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: TextFont(
                  text: 'Cancel',
                  textColor: Theme.of(context).colorScheme.primary,
                  fontSize: 15,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'Delete'),
                child: TextFont(
                  text: 'Delete',
                  textColor: Theme.of(context).colorScheme.error,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        );
        if (result == "Delete") {
          await database.deleteTransaction(
            transaction.id,
            context: context,
          );
        }
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFont(
                      text: DateFormat('h:mma').format(transaction.dateCreated),
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    TextFont(
                      text: DateFormat('MMM d, yyyy')
                          .format(transaction.dateCreated),
                      fontSize: 17,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextFont(
                      text: currency.format(transaction.amount),
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    transaction.name != ""
                        ? TextFont(
                            text: transaction.name,
                            fontSize: 17,
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 2,
            color: Theme.of(context)
                .colorScheme
                .onTertiaryContainer
                .withOpacity(0.1),
          )
        ],
      ),
    );
  }
}

class AmountButton extends StatelessWidget {
  const AmountButton({
    super.key,
    required this.constraints,
    required this.text,
    required this.addToAmount,
    this.heightRatio = 0.25,
    this.widthRatio = 0.25,
    this.color,
    this.child,
  });
  final BoxConstraints constraints;
  final String text;
  final Function(String) addToAmount;
  final double heightRatio;
  final double widthRatio;
  final Color? color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return AnimatedScaleBounce(
      child: SizedBox(
        width: constraints.maxWidth * widthRatio,
        height: constraints.maxWidth * heightRatio,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Tappable(
            onTap: () {
              addToAmount(text);
            },
            borderRadius: 1000,
            color: color ?? Theme.of(context).colorScheme.secondaryContainer,
            child: child ??
                Center(
                  child: TextFont(
                    fontSize: 28,
                    text: text,
                    textColor:
                        Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
