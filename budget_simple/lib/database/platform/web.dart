// web.dart
import 'package:drift/web.dart';
import 'package:budget_simple/database/tables.dart';

TransactionsDatabase constructDb(String dbName) {
  return TransactionsDatabase(WebDatabase(dbName, logStatements: false));
}
