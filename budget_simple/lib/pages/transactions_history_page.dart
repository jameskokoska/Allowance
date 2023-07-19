import 'package:budget_simple/database/tables.dart';
import 'package:budget_simple/pages/home_page.dart';
import 'package:budget_simple/struct/database_global.dart';
import 'package:budget_simple/struct/translations.dart';
import 'package:budget_simple/widgets/text_font.dart';
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
        title: const TextFont(text: "Transactions"),
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
  String? searchTerm;
  FocusNode focusNodeTextInput = FocusNode();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    focusNodeTextInput.addListener(() {
      if (focusNodeTextInput.hasFocus) {
        enableKeyboardListen = false;
      } else {
        enableKeyboardListen = true;
      }
    });
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          maxLength: 40,
          focusNode: focusNodeTextInput,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            hintText: translateText('Search Transaction Names'),
            counterText: "",
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
            ),
          ),
          onChanged: (value) {
            setState(() {
              searchTerm = value == "" ? null : value;
            });
          },
        ),
        Expanded(
          child: StreamBuilder<List<Transaction>>(
            stream: database.watchAllTransactions(
                limit: amountLoaded, searchTerm: searchTerm),
            builder: (context, snapshot) {
              if (snapshot.data != null && snapshot.data!.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                  child: TextFont(
                    text: "No transactions found",
                    fontSize: 16,
                  ),
                );
              } else if (snapshot.data != null) {
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
          ),
        ),
      ],
    );
  }
}
