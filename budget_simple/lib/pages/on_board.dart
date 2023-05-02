import 'package:budget_simple/database/tables.dart';
import 'package:budget_simple/main.dart';
import 'package:budget_simple/struct/database_global.dart';
import 'package:budget_simple/widgets/floating.dart';
import 'package:budget_simple/widgets/increase_limit.dart';
import 'package:budget_simple/widgets/tappable.dart';
import 'package:budget_simple/widgets/text_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    Key? key,
    this.popNavigationWhenDone = false,
  }) : super(key: key);

  final bool popNavigationWhenDone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: OnBoardingPageBody(
      popNavigationWhenDone: popNavigationWhenDone,
    ));
  }
}

class OnBoardingPageBody extends StatefulWidget {
  const OnBoardingPageBody({Key? key, this.popNavigationWhenDone = false})
      : super(key: key);
  final bool popNavigationWhenDone;

  @override
  State<OnBoardingPageBody> createState() => OnBoardingPageBodyState();
}

class OnBoardingPageBodyState extends State<OnBoardingPageBody> {
  double selectedAmount = 500;
  DateTime selectedUntilDate = dayInAMonth();
  Future<void> _selectUntilDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedUntilDate,
        firstDate: DateTime.now().add(const Duration(days: 0)),
        lastDate: DateTime.now().add(const Duration(days: 500)));
    if (picked != null && picked != selectedUntilDate) {
      setState(() {
        selectedUntilDate = picked;
      });
    }
  }

  int currentIndex = 0;

  nextNavigation() async {
    if (widget.popNavigationWhenDone) {
      Navigator.pop(context);
    } else {
      await database.createOrUpdateSpendingLimit(
        SpendingLimitData(
          id: 1,
          amount: selectedAmount,
          dateCreated: DateTime.now(),
          dateCreatedUntil: selectedUntilDate,
        ),
      );
      hasOnboarded = true;
      sharedPreferences.setBool("hasOnboarded", true);
      initializeAppStateKey.currentState?.refreshAppState();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();

    final List<Widget> children = [
      OnBoardPage(
        widgets: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const TextFont(
                text: "Welcome to",
                fontSize: 20,
                textAlign: TextAlign.center,
                maxLines: 5,
              ),
              const TextFont(
                text: "Allowance",
                fontWeight: FontWeight.bold,
                fontSize: 35,
                textAlign: TextAlign.center,
                maxLines: 5,
              ),
              const SizedBox(height: 50),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: TextFont(
                  text: "Set up an allowance to stay on top of your spending!",
                  fontSize: 17,
                  textAlign: TextAlign.center,
                  maxLines: 100,
                ),
              ),
              const SizedBox(height: 70),
              Stack(
                children: [
                  FloatingWidget(
                    duration: const Duration(milliseconds: 1650),
                    child: Transform.translate(
                      offset: const Offset(-5, 50),
                      child: Transform.rotate(
                        angle: 0.2,
                        child: const SizedBox(
                          width: 100,
                          height: 100,
                          child: Image(
                            image: AssetImage('assets/onboard/coins.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  FloatingWidget(
                    duration: const Duration(milliseconds: 2000),
                    child: Transform.translate(
                      offset: const Offset(80, 0),
                      child: Transform.rotate(
                        angle: 0.2,
                        child: const SizedBox(
                          width: 320,
                          height: 250,
                          child: Image(
                            image: AssetImage('assets/onboard/piggy-bank.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      OnBoardPage(
        widgets: [
          const TextFont(
            text: "Allowance Reset Date",
            fontWeight: FontWeight.bold,
            fontSize: 30,
            textAlign: TextAlign.center,
            maxLines: 5,
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: TextFont(
              text: "Select the date you want your budget to reset",
              maxLines: 100,
              fontSize: 18,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          Tappable(
            borderRadius: 15,
            color: Colors.transparent,
            onTap: () {
              _selectUntilDate(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 14),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1,
                  ),
                ),
              ),
              child: TextFont(
                text: DateFormat('MMM d, yyyy').format(selectedUntilDate),
              ),
            ),
          ),
          const SizedBox(height: 40),
          FloatingWidget(
            duration: const Duration(milliseconds: 1900),
            child: Transform.translate(
              offset: const Offset(80, 0),
              child: Transform.rotate(
                angle: 0.1,
                child: const SizedBox(
                  width: 250,
                  height: 220,
                  child: Image(
                    image: AssetImage('assets/onboard/hourglass.png'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      OnBoardPage(
        widgets: [
          const TextFont(
            text: "Allowance Amount",
            fontWeight: FontWeight.bold,
            fontSize: 30,
            textAlign: TextAlign.center,
            maxLines: 5,
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: TextFont(
              text: "Enter the amount of money you want to spend in the term",
              maxLines: 100,
              fontSize: 18,
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IntrinsicWidth(
                child: TextFormField(
                  initialValue: currencyIcon,
                  maxLength: 5,
                  decoration: const InputDecoration(
                    hintText: "\$",
                    counterText: "",
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 14,
                    ),
                  ),
                  onChanged: (value) {
                    currencyIcon = value;
                    if (value.trim() == "") {
                      currencyIcon = "\$";
                    }
                    sharedPreferences.setString("currencyIcon", value);
                  },
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(width: 5),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 100),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: IntrinsicWidth(
                    child: TextFormField(
                      initialValue: selectedAmount.toInt().toString(),
                      onChanged: (value) {
                        setState(() {
                          selectedAmount = double.tryParse(value) ?? 0;
                        });
                      },
                      textAlign: TextAlign.center,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 15,
                        ),
                        hintText: "0",
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          FloatingWidget(
            duration: const Duration(milliseconds: 2100),
            child: Transform.translate(
              offset: const Offset(0, 0),
              child: Transform.rotate(
                angle: 0.1,
                child: const SizedBox(
                  width: 280,
                  height: 280,
                  child: Image(
                    image: AssetImage('assets/onboard/money.png'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      OnBoardPage(
        widgets: [
          const TextFont(
            text: "You're all set!",
            fontWeight: FontWeight.bold,
            fontSize: 30,
            textAlign: TextAlign.center,
            maxLines: 5,
          ),
          const SizedBox(height: 50),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: TextFont(
              text:
                  "Every time you make a transaction, simply enter the amount and Allowance will deduct it from your budget",
              maxLines: 100,
              fontSize: 18,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),
          FloatingWidget(
            duration: const Duration(milliseconds: 2100),
            child: Transform.translate(
              offset: const Offset(0, 0),
              child: Transform.rotate(
                angle: 0.1,
                child: const SizedBox(
                  width: 230,
                  height: 230,
                  child: Image(
                    image: AssetImage('assets/onboard/floating-piggy.png'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ];

    return Stack(
      children: [
        PageView(
          onPageChanged: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          controller: controller,
          children: children,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 15,
              ),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedOpacity(
                      opacity: currentIndex <= 0 ? 0 : 1,
                      duration: const Duration(milliseconds: 200),
                      child: IconButton(
                        onPressed: () {
                          controller.previousPage(
                            duration: const Duration(milliseconds: 1100),
                            curve: const ElasticOutCurve(1.3),
                          );
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                        },
                        icon: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.arrow_back_rounded,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        ...List<int>.generate(children.length, (i) => i + 1)
                            .map(
                              (
                                index,
                              ) =>
                                  Builder(
                                builder: (BuildContext context) =>
                                    AnimatedScale(
                                  duration: const Duration(milliseconds: 900),
                                  scale: index - 1 == currentIndex ? 1.3 : 1,
                                  curve: const ElasticOutCurve(0.2),
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 400),
                                    child: Container(
                                      key: ValueKey(index - 1 == currentIndex),
                                      width: 6,
                                      height: 6,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 3),
                                      decoration: BoxDecoration(
                                        color: index - 1 == currentIndex
                                            ? Theme.of(context)
                                                .colorScheme
                                                .secondary
                                                .withOpacity(0.7)
                                            : Theme.of(context)
                                                .colorScheme
                                                .secondary
                                                .withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        controller.nextPage(
                          duration: const Duration(milliseconds: 1100),
                          curve: const ElasticOutCurve(1.3),
                        );
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        if (currentIndex + 1 == children.length) {
                          nextNavigation();
                        }
                      },
                      icon: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class OnBoardPage extends StatelessWidget {
  const OnBoardPage({Key? key, required this.widgets}) : super(key: key);
  final List<Widget> widgets;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.25),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: widgets,
            ),
          )
        ],
      ),
    );
  }
}
