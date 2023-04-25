// web.dart
import 'package:drift/web.dart';
import 'package:budget_simple/database/tables.dart';

TransactionsDatabase constructDb() {
  return TransactionsDatabase(WebDatabase('db', logStatements: false));
}
