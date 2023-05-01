import 'dart:convert';

import 'package:budget_simple/struct/database-global.dart';
import 'package:budget_simple/struct/functions.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart' hide Table;
import 'package:intl/intl.dart';

export 'platform/shared.dart';
part 'tables.g.dart';

// Generate database code
// flutter packages pub run build_runner build --delete-conflicting-outputs

int schemaVersionGlobal = 1;

class MapInColumnConverter extends TypeConverter<Map<String, String>, String> {
  const MapInColumnConverter();
  @override
  Map<String, String> fromSql(String fromDb) {
    return Map<String, String>.from(json.decode(fromDb));
  }

  @override
  String toSql(Map<String, String> value) {
    return json.encode(value);
  }
}

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get amount => real()();
  DateTimeColumn get dateCreated =>
      dateTime().clientDefault(() => DateTime.now())();
}

class SpendingLimit extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  DateTimeColumn get dateCreated =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get dateCreatedUntil =>
      dateTime().clientDefault(() => DateTime.now())();
}

@DriftDatabase(tables: [Transactions, SpendingLimit])
class TransactionsDatabase extends _$TransactionsDatabase {
  TransactionsDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => schemaVersionGlobal;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {},
      );

  Future<int> createTransaction(TransactionsCompanion transaction) {
    return into(transactions).insert(transaction);
  }

  Future<Transaction> getTransaction(int id) {
    return (select(transactions)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }

  Stream<List<Transaction>> watchAllTransactions(
      {int? limit, String? searchTerm}) {
    return (select(transactions)
          ..where((tbl) => searchTerm == null
              ? const Constant(true)
              : tbl.name.lower().like("%${searchTerm.toLowerCase()}%"))
          ..orderBy([(t) => OrderingTerm.desc(t.dateCreated)])
          ..limit(limit ?? DEFAULT_LIMIT))
        .watch();
  }

  Stream<SpendingLimitData> watchSpendingLimit() {
    return (select(spendingLimit)..where((tbl) => tbl.id.equals(1)))
        .watchSingle();
  }

  Future<SpendingLimitData> getSpendingLimit() {
    return (select(spendingLimit)..where((tbl) => tbl.id.equals(1)))
        .getSingle();
  }

  Future<int> createOrUpdateSpendingLimit(SpendingLimitData spendingLimit) {
    if (spendingLimit.amount > MAX_AMOUNT) {
      spendingLimit = spendingLimit.copyWith(amount: 999999);
    }
    return into($SpendingLimitTable(attachedDatabase))
        .insertOnConflictUpdate(spendingLimit);
  }

  Stream<double?> totalSpendAfterDay(DateTime day) {
    final totalAmt = transactions.amount.sum();
    final JoinedSelectStatement<$TransactionsTable, Transaction> query;
    query = selectOnly(transactions)
      ..addColumns([totalAmt])
      ..where(transactions.dateCreated.isBiggerThanValue(day));

    return query.map((row) => row.read(totalAmt)).watchSingleOrNull();
  }

  Future<int> deleteTransaction(id, {BuildContext? context}) async {
    NumberFormat currency = getNumberFormat();
    if (context != null) {
      Transaction transaction = await getTransaction(id);
      SnackBar snackBar = SnackBar(
        content:
            Text('Deleted ${currency.format(transaction.amount)} transaction'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return (delete(transactions)
          ..where((transaction) => transaction.id.equals(id)))
        .go();
  }
}
