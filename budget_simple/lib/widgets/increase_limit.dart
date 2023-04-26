import 'package:budget_simple/database/tables.dart';
import 'package:budget_simple/struct/databaseGlobal.dart';
import 'package:budget_simple/widgets/tappable.dart';
import 'package:budget_simple/widgets/text_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class IncreaseLimit extends StatefulWidget {
  const IncreaseLimit({super.key});

  @override
  State<IncreaseLimit> createState() => _IncreaseLimitState();
}

DateTime dayInAMonth() {
  return DateTime(
      DateTime.now().year, DateTime.now().month + 1, DateTime.now().day);
}

class _IncreaseLimitState extends State<IncreaseLimit> {
  double selectedAmount = 0;
  DateTime selectedDate = dayInAMonth();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now().add(const Duration(days: 1)),
        lastDate: DateTime.now().add(const Duration(days: 500)));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 5),
          child: TextFont(
            text: "Refill Balance",
            fontSize: 30,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: TextFont(
            text:
                "You should refill your balance when the term ends to stay on top of your spending habits.",
            fontSize: 15,
            maxLines: 4,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextFont(text: "\$"),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 100),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: IntrinsicWidth(
                  child: TextFormField(
                    autofocus: true,
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
                      hintText: "0",
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            const TextFont(text: "until"),
            const SizedBox(width: 5),
            Tappable(
              borderRadius: 15,
              color: Colors.transparent,
              onTap: () {
                _selectDate(context);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 14),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1,
                    ),
                  ),
                ),
                child: TextFont(
                  text: DateFormat('MMM d, yyyy').format(selectedDate),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.close,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 400),
              opacity: selectedAmount <= 0 ? 0.3 : 1,
              child: OutlinedButton(
                  onPressed: () async {
                    if (selectedAmount <= 0) {
                    } else {
                      await database.createOrUpdateSpendingLimit(
                        SpendingLimitData(
                          id: 1,
                          amount: selectedAmount,
                          dateCreated: DateTime.now(),
                          dateCreatedUntil: selectedDate,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Icon(Icons.check)),
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
