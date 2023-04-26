// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tables.dart';

// ignore_for_file: type=lint
class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _dateCreatedMeta =
      const VerificationMeta('dateCreated');
  @override
  late final GeneratedColumn<DateTime> dateCreated = GeneratedColumn<DateTime>(
      'date_created', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns => [id, name, amount, dateCreated];
  @override
  String get aliasedName => _alias ?? 'transactions';
  @override
  String get actualTableName => 'transactions';
  @override
  VerificationContext validateIntegrity(Insertable<Transaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date_created')) {
      context.handle(
          _dateCreatedMeta,
          dateCreated.isAcceptableOrUnknown(
              data['date_created']!, _dateCreatedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      dateCreated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_created'])!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final int id;
  final String name;
  final double amount;
  final DateTime dateCreated;
  const Transaction(
      {required this.id,
      required this.name,
      required this.amount,
      required this.dateCreated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['amount'] = Variable<double>(amount);
    map['date_created'] = Variable<DateTime>(dateCreated);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      name: Value(name),
      amount: Value(amount),
      dateCreated: Value(dateCreated),
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      amount: serializer.fromJson<double>(json['amount']),
      dateCreated: serializer.fromJson<DateTime>(json['dateCreated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'amount': serializer.toJson<double>(amount),
      'dateCreated': serializer.toJson<DateTime>(dateCreated),
    };
  }

  Transaction copyWith(
          {int? id, String? name, double? amount, DateTime? dateCreated}) =>
      Transaction(
        id: id ?? this.id,
        name: name ?? this.name,
        amount: amount ?? this.amount,
        dateCreated: dateCreated ?? this.dateCreated,
      );
  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('dateCreated: $dateCreated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, amount, dateCreated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.name == this.name &&
          other.amount == this.amount &&
          other.dateCreated == this.dateCreated);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> amount;
  final Value<DateTime> dateCreated;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
    this.dateCreated = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double amount,
    this.dateCreated = const Value.absent(),
  })  : name = Value(name),
        amount = Value(amount);
  static Insertable<Transaction> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? amount,
    Expression<DateTime>? dateCreated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
      if (dateCreated != null) 'date_created': dateCreated,
    });
  }

  TransactionsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<double>? amount,
      Value<DateTime>? dateCreated}) {
    return TransactionsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (dateCreated.present) {
      map['date_created'] = Variable<DateTime>(dateCreated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('dateCreated: $dateCreated')
          ..write(')'))
        .toString();
  }
}

class $SpendingLimitTable extends SpendingLimit
    with TableInfo<$SpendingLimitTable, SpendingLimitData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpendingLimitTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _dateCreatedMeta =
      const VerificationMeta('dateCreated');
  @override
  late final GeneratedColumn<DateTime> dateCreated = GeneratedColumn<DateTime>(
      'date_created', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _dateCreatedUntilMeta =
      const VerificationMeta('dateCreatedUntil');
  @override
  late final GeneratedColumn<DateTime> dateCreatedUntil =
      GeneratedColumn<DateTime>('date_created_until', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns =>
      [id, amount, dateCreated, dateCreatedUntil];
  @override
  String get aliasedName => _alias ?? 'spending_limit';
  @override
  String get actualTableName => 'spending_limit';
  @override
  VerificationContext validateIntegrity(Insertable<SpendingLimitData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date_created')) {
      context.handle(
          _dateCreatedMeta,
          dateCreated.isAcceptableOrUnknown(
              data['date_created']!, _dateCreatedMeta));
    }
    if (data.containsKey('date_created_until')) {
      context.handle(
          _dateCreatedUntilMeta,
          dateCreatedUntil.isAcceptableOrUnknown(
              data['date_created_until']!, _dateCreatedUntilMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SpendingLimitData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SpendingLimitData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      dateCreated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_created'])!,
      dateCreatedUntil: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_created_until'])!,
    );
  }

  @override
  $SpendingLimitTable createAlias(String alias) {
    return $SpendingLimitTable(attachedDatabase, alias);
  }
}

class SpendingLimitData extends DataClass
    implements Insertable<SpendingLimitData> {
  final int id;
  final double amount;
  final DateTime dateCreated;
  final DateTime dateCreatedUntil;
  const SpendingLimitData(
      {required this.id,
      required this.amount,
      required this.dateCreated,
      required this.dateCreatedUntil});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount'] = Variable<double>(amount);
    map['date_created'] = Variable<DateTime>(dateCreated);
    map['date_created_until'] = Variable<DateTime>(dateCreatedUntil);
    return map;
  }

  SpendingLimitCompanion toCompanion(bool nullToAbsent) {
    return SpendingLimitCompanion(
      id: Value(id),
      amount: Value(amount),
      dateCreated: Value(dateCreated),
      dateCreatedUntil: Value(dateCreatedUntil),
    );
  }

  factory SpendingLimitData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SpendingLimitData(
      id: serializer.fromJson<int>(json['id']),
      amount: serializer.fromJson<double>(json['amount']),
      dateCreated: serializer.fromJson<DateTime>(json['dateCreated']),
      dateCreatedUntil: serializer.fromJson<DateTime>(json['dateCreatedUntil']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amount': serializer.toJson<double>(amount),
      'dateCreated': serializer.toJson<DateTime>(dateCreated),
      'dateCreatedUntil': serializer.toJson<DateTime>(dateCreatedUntil),
    };
  }

  SpendingLimitData copyWith(
          {int? id,
          double? amount,
          DateTime? dateCreated,
          DateTime? dateCreatedUntil}) =>
      SpendingLimitData(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        dateCreated: dateCreated ?? this.dateCreated,
        dateCreatedUntil: dateCreatedUntil ?? this.dateCreatedUntil,
      );
  @override
  String toString() {
    return (StringBuffer('SpendingLimitData(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('dateCreated: $dateCreated, ')
          ..write('dateCreatedUntil: $dateCreatedUntil')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, amount, dateCreated, dateCreatedUntil);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpendingLimitData &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.dateCreated == this.dateCreated &&
          other.dateCreatedUntil == this.dateCreatedUntil);
}

class SpendingLimitCompanion extends UpdateCompanion<SpendingLimitData> {
  final Value<int> id;
  final Value<double> amount;
  final Value<DateTime> dateCreated;
  final Value<DateTime> dateCreatedUntil;
  const SpendingLimitCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.dateCreated = const Value.absent(),
    this.dateCreatedUntil = const Value.absent(),
  });
  SpendingLimitCompanion.insert({
    this.id = const Value.absent(),
    required double amount,
    this.dateCreated = const Value.absent(),
    this.dateCreatedUntil = const Value.absent(),
  }) : amount = Value(amount);
  static Insertable<SpendingLimitData> custom({
    Expression<int>? id,
    Expression<double>? amount,
    Expression<DateTime>? dateCreated,
    Expression<DateTime>? dateCreatedUntil,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (dateCreated != null) 'date_created': dateCreated,
      if (dateCreatedUntil != null) 'date_created_until': dateCreatedUntil,
    });
  }

  SpendingLimitCompanion copyWith(
      {Value<int>? id,
      Value<double>? amount,
      Value<DateTime>? dateCreated,
      Value<DateTime>? dateCreatedUntil}) {
    return SpendingLimitCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      dateCreated: dateCreated ?? this.dateCreated,
      dateCreatedUntil: dateCreatedUntil ?? this.dateCreatedUntil,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (dateCreated.present) {
      map['date_created'] = Variable<DateTime>(dateCreated.value);
    }
    if (dateCreatedUntil.present) {
      map['date_created_until'] = Variable<DateTime>(dateCreatedUntil.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpendingLimitCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('dateCreated: $dateCreated, ')
          ..write('dateCreatedUntil: $dateCreatedUntil')
          ..write(')'))
        .toString();
  }
}

abstract class _$TransactionsDatabase extends GeneratedDatabase {
  _$TransactionsDatabase(QueryExecutor e) : super(e);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $SpendingLimitTable spendingLimit = $SpendingLimitTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [transactions, spendingLimit];
}
