import 'package:budget_simple/database/tables.dart';
import 'package:budget_simple/struct/databaseGlobal.dart';
import 'package:budget_simple/widgets/transaction_entry.dart';
import 'package:flutter/material.dart';
import 'package:implicitly_animated_list/implicitly_animated_list.dart';

class TransactionsHistoryPage extends StatelessWidget {
  const TransactionsHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Transactions"),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.pop(context);
      //   },
      //   child: const Icon(Icons.add_rounded),
      // ),
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
            itemBuilder: (_, transaction) => Center(
              child: TransactionEntry(
                transaction: transaction,
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
