import 'package:budget_simple/database/tables.dart';
import 'package:budget_simple/struct/database-global.dart';
import 'package:budget_simple/struct/functions.dart';
import 'package:intl/intl.dart';

import 'package:budget_simple/widgets/tappable.dart';
import 'package:budget_simple/widgets/text_font.dart';
import 'package:flutter/material.dart';

class TransactionEntry extends StatelessWidget {
  const TransactionEntry({super.key, required this.transaction});
  final Transaction transaction;
  @override
  Widget build(BuildContext context) {
    const double maxWidth = 450;
    NumberFormat currency = getNumberFormat();
    return Tappable(
      onTap: () async {
        String? result = await showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const TextFont(
              text: 'Delete Transaction?',
              fontSize: 23,
              maxLines: 3,
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFont(
                    maxLines: 2,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    text: currency.format(transaction.amount),
                  ),
                  TextFont(
                    maxLines: 2,
                    fontSize: 18,
                    text: DateFormat('MMM d, yyyy')
                        .format(transaction.dateCreated),
                  ),
                  transaction.name != ""
                      ? TextFont(
                          text: transaction.name,
                          fontSize: 17,
                          maxLines: 2,
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
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
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFont(
                          text: DateFormat('MMM d, yyyy')
                              .format(transaction.dateCreated),
                          fontSize: 23,
                          maxLines: 5,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 1),
                        TextFont(
                          text: DateFormat('h:mma')
                              .format(transaction.dateCreated),
                          fontSize: 17,
                          maxLines: 5,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextFont(
                          text: currency.format(transaction.amount),
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.right,
                          maxLines: 5,
                        ),
                        transaction.name != ""
                            ? TextFont(
                                text: transaction.name,
                                fontSize: 17,
                                maxLines: 5,
                                textAlign: TextAlign.right,
                                textColor:
                                    Theme.of(context).colorScheme.tertiary,
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ],
              ),
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
