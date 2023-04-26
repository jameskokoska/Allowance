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

class TransactionsList extends StatefulWidget {
  const TransactionsList({super.key});

  @override
  State<TransactionsList> createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  late ScrollController _scrollController;
  int amountLoaded = DEFAULT_LIMIT;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  _scrollListener() {
    if (_scrollController.offset >
        _scrollController.position.maxScrollExtent - 100) {
      _loadMore(50);
    }
  }

  _loadMore(int amount) {
    setState(() {
      amountLoaded += amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Transaction>>(
      stream: database.watchAllTransactions(limit: amountLoaded),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return ImplicitlyAnimatedList(
            controller: _scrollController,
            itemData: snapshot.data!,
            itemBuilder: (_, transaction) => Center(
              child: TransactionEntry(
                key: ValueKey(transaction.id),
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
