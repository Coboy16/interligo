// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AccountsTableTable extends AccountsTable
    with TableInfo<$AccountsTableTable, AccountsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _aliasMeta = const VerificationMeta('alias');
  @override
  late final GeneratedColumn<String> alias = GeneratedColumn<String>(
    'alias',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _availableBalanceMeta = const VerificationMeta(
    'availableBalance',
  );
  @override
  late final GeneratedColumn<double> availableBalance = GeneratedColumn<double>(
    'available_balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ledgerBalanceMeta = const VerificationMeta(
    'ledgerBalance',
  );
  @override
  late final GeneratedColumn<double> ledgerBalance = GeneratedColumn<double>(
    'ledger_balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    alias,
    currency,
    availableBalance,
    ledgerBalance,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccountsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('alias')) {
      context.handle(
        _aliasMeta,
        alias.isAcceptableOrUnknown(data['alias']!, _aliasMeta),
      );
    } else if (isInserting) {
      context.missing(_aliasMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('available_balance')) {
      context.handle(
        _availableBalanceMeta,
        availableBalance.isAcceptableOrUnknown(
          data['available_balance']!,
          _availableBalanceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_availableBalanceMeta);
    }
    if (data.containsKey('ledger_balance')) {
      context.handle(
        _ledgerBalanceMeta,
        ledgerBalance.isAcceptableOrUnknown(
          data['ledger_balance']!,
          _ledgerBalanceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ledgerBalanceMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      alias: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alias'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      availableBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}available_balance'],
      )!,
      ledgerBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ledger_balance'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $AccountsTableTable createAlias(String alias) {
    return $AccountsTableTable(attachedDatabase, alias);
  }
}

class AccountsTableData extends DataClass
    implements Insertable<AccountsTableData> {
  final int id;
  final String accountId;
  final String alias;
  final String currency;
  final double availableBalance;
  final double ledgerBalance;
  final DateTime cachedAt;
  const AccountsTableData({
    required this.id,
    required this.accountId,
    required this.alias,
    required this.currency,
    required this.availableBalance,
    required this.ledgerBalance,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<String>(accountId);
    map['alias'] = Variable<String>(alias);
    map['currency'] = Variable<String>(currency);
    map['available_balance'] = Variable<double>(availableBalance);
    map['ledger_balance'] = Variable<double>(ledgerBalance);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  AccountsTableCompanion toCompanion(bool nullToAbsent) {
    return AccountsTableCompanion(
      id: Value(id),
      accountId: Value(accountId),
      alias: Value(alias),
      currency: Value(currency),
      availableBalance: Value(availableBalance),
      ledgerBalance: Value(ledgerBalance),
      cachedAt: Value(cachedAt),
    );
  }

  factory AccountsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountsTableData(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      alias: serializer.fromJson<String>(json['alias']),
      currency: serializer.fromJson<String>(json['currency']),
      availableBalance: serializer.fromJson<double>(json['availableBalance']),
      ledgerBalance: serializer.fromJson<double>(json['ledgerBalance']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountId': serializer.toJson<String>(accountId),
      'alias': serializer.toJson<String>(alias),
      'currency': serializer.toJson<String>(currency),
      'availableBalance': serializer.toJson<double>(availableBalance),
      'ledgerBalance': serializer.toJson<double>(ledgerBalance),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  AccountsTableData copyWith({
    int? id,
    String? accountId,
    String? alias,
    String? currency,
    double? availableBalance,
    double? ledgerBalance,
    DateTime? cachedAt,
  }) => AccountsTableData(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    alias: alias ?? this.alias,
    currency: currency ?? this.currency,
    availableBalance: availableBalance ?? this.availableBalance,
    ledgerBalance: ledgerBalance ?? this.ledgerBalance,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  AccountsTableData copyWithCompanion(AccountsTableCompanion data) {
    return AccountsTableData(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      alias: data.alias.present ? data.alias.value : this.alias,
      currency: data.currency.present ? data.currency.value : this.currency,
      availableBalance: data.availableBalance.present
          ? data.availableBalance.value
          : this.availableBalance,
      ledgerBalance: data.ledgerBalance.present
          ? data.ledgerBalance.value
          : this.ledgerBalance,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountsTableData(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('alias: $alias, ')
          ..write('currency: $currency, ')
          ..write('availableBalance: $availableBalance, ')
          ..write('ledgerBalance: $ledgerBalance, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    alias,
    currency,
    availableBalance,
    ledgerBalance,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountsTableData &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.alias == this.alias &&
          other.currency == this.currency &&
          other.availableBalance == this.availableBalance &&
          other.ledgerBalance == this.ledgerBalance &&
          other.cachedAt == this.cachedAt);
}

class AccountsTableCompanion extends UpdateCompanion<AccountsTableData> {
  final Value<int> id;
  final Value<String> accountId;
  final Value<String> alias;
  final Value<String> currency;
  final Value<double> availableBalance;
  final Value<double> ledgerBalance;
  final Value<DateTime> cachedAt;
  const AccountsTableCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.alias = const Value.absent(),
    this.currency = const Value.absent(),
    this.availableBalance = const Value.absent(),
    this.ledgerBalance = const Value.absent(),
    this.cachedAt = const Value.absent(),
  });
  AccountsTableCompanion.insert({
    this.id = const Value.absent(),
    required String accountId,
    required String alias,
    required String currency,
    required double availableBalance,
    required double ledgerBalance,
    this.cachedAt = const Value.absent(),
  }) : accountId = Value(accountId),
       alias = Value(alias),
       currency = Value(currency),
       availableBalance = Value(availableBalance),
       ledgerBalance = Value(ledgerBalance);
  static Insertable<AccountsTableData> custom({
    Expression<int>? id,
    Expression<String>? accountId,
    Expression<String>? alias,
    Expression<String>? currency,
    Expression<double>? availableBalance,
    Expression<double>? ledgerBalance,
    Expression<DateTime>? cachedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (alias != null) 'alias': alias,
      if (currency != null) 'currency': currency,
      if (availableBalance != null) 'available_balance': availableBalance,
      if (ledgerBalance != null) 'ledger_balance': ledgerBalance,
      if (cachedAt != null) 'cached_at': cachedAt,
    });
  }

  AccountsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? accountId,
    Value<String>? alias,
    Value<String>? currency,
    Value<double>? availableBalance,
    Value<double>? ledgerBalance,
    Value<DateTime>? cachedAt,
  }) {
    return AccountsTableCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      alias: alias ?? this.alias,
      currency: currency ?? this.currency,
      availableBalance: availableBalance ?? this.availableBalance,
      ledgerBalance: ledgerBalance ?? this.ledgerBalance,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (alias.present) {
      map['alias'] = Variable<String>(alias.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (availableBalance.present) {
      map['available_balance'] = Variable<double>(availableBalance.value);
    }
    if (ledgerBalance.present) {
      map['ledger_balance'] = Variable<double>(ledgerBalance.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsTableCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('alias: $alias, ')
          ..write('currency: $currency, ')
          ..write('availableBalance: $availableBalance, ')
          ..write('ledgerBalance: $ledgerBalance, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTableTable extends TransactionsTable
    with TableInfo<$TransactionsTableTable, TransactionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
    'transaction_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    transactionId,
    accountId,
    date,
    amount,
    description,
    type,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $TransactionsTableTable createAlias(String alias) {
    return $TransactionsTableTable(attachedDatabase, alias);
  }
}

class TransactionsTableData extends DataClass
    implements Insertable<TransactionsTableData> {
  final int id;
  final String transactionId;
  final String accountId;
  final DateTime date;
  final double amount;
  final String description;
  final String type;
  final DateTime cachedAt;
  const TransactionsTableData({
    required this.id,
    required this.transactionId,
    required this.accountId,
    required this.date,
    required this.amount,
    required this.description,
    required this.type,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['transaction_id'] = Variable<String>(transactionId);
    map['account_id'] = Variable<String>(accountId);
    map['date'] = Variable<DateTime>(date);
    map['amount'] = Variable<double>(amount);
    map['description'] = Variable<String>(description);
    map['type'] = Variable<String>(type);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  TransactionsTableCompanion toCompanion(bool nullToAbsent) {
    return TransactionsTableCompanion(
      id: Value(id),
      transactionId: Value(transactionId),
      accountId: Value(accountId),
      date: Value(date),
      amount: Value(amount),
      description: Value(description),
      type: Value(type),
      cachedAt: Value(cachedAt),
    );
  }

  factory TransactionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionsTableData(
      id: serializer.fromJson<int>(json['id']),
      transactionId: serializer.fromJson<String>(json['transactionId']),
      accountId: serializer.fromJson<String>(json['accountId']),
      date: serializer.fromJson<DateTime>(json['date']),
      amount: serializer.fromJson<double>(json['amount']),
      description: serializer.fromJson<String>(json['description']),
      type: serializer.fromJson<String>(json['type']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'transactionId': serializer.toJson<String>(transactionId),
      'accountId': serializer.toJson<String>(accountId),
      'date': serializer.toJson<DateTime>(date),
      'amount': serializer.toJson<double>(amount),
      'description': serializer.toJson<String>(description),
      'type': serializer.toJson<String>(type),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  TransactionsTableData copyWith({
    int? id,
    String? transactionId,
    String? accountId,
    DateTime? date,
    double? amount,
    String? description,
    String? type,
    DateTime? cachedAt,
  }) => TransactionsTableData(
    id: id ?? this.id,
    transactionId: transactionId ?? this.transactionId,
    accountId: accountId ?? this.accountId,
    date: date ?? this.date,
    amount: amount ?? this.amount,
    description: description ?? this.description,
    type: type ?? this.type,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  TransactionsTableData copyWithCompanion(TransactionsTableCompanion data) {
    return TransactionsTableData(
      id: data.id.present ? data.id.value : this.id,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      date: data.date.present ? data.date.value : this.date,
      amount: data.amount.present ? data.amount.value : this.amount,
      description: data.description.present
          ? data.description.value
          : this.description,
      type: data.type.present ? data.type.value : this.type,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsTableData(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('accountId: $accountId, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    transactionId,
    accountId,
    date,
    amount,
    description,
    type,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionsTableData &&
          other.id == this.id &&
          other.transactionId == this.transactionId &&
          other.accountId == this.accountId &&
          other.date == this.date &&
          other.amount == this.amount &&
          other.description == this.description &&
          other.type == this.type &&
          other.cachedAt == this.cachedAt);
}

class TransactionsTableCompanion
    extends UpdateCompanion<TransactionsTableData> {
  final Value<int> id;
  final Value<String> transactionId;
  final Value<String> accountId;
  final Value<DateTime> date;
  final Value<double> amount;
  final Value<String> description;
  final Value<String> type;
  final Value<DateTime> cachedAt;
  const TransactionsTableCompanion({
    this.id = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.date = const Value.absent(),
    this.amount = const Value.absent(),
    this.description = const Value.absent(),
    this.type = const Value.absent(),
    this.cachedAt = const Value.absent(),
  });
  TransactionsTableCompanion.insert({
    this.id = const Value.absent(),
    required String transactionId,
    required String accountId,
    required DateTime date,
    required double amount,
    required String description,
    required String type,
    this.cachedAt = const Value.absent(),
  }) : transactionId = Value(transactionId),
       accountId = Value(accountId),
       date = Value(date),
       amount = Value(amount),
       description = Value(description),
       type = Value(type);
  static Insertable<TransactionsTableData> custom({
    Expression<int>? id,
    Expression<String>? transactionId,
    Expression<String>? accountId,
    Expression<DateTime>? date,
    Expression<double>? amount,
    Expression<String>? description,
    Expression<String>? type,
    Expression<DateTime>? cachedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionId != null) 'transaction_id': transactionId,
      if (accountId != null) 'account_id': accountId,
      if (date != null) 'date': date,
      if (amount != null) 'amount': amount,
      if (description != null) 'description': description,
      if (type != null) 'type': type,
      if (cachedAt != null) 'cached_at': cachedAt,
    });
  }

  TransactionsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? transactionId,
    Value<String>? accountId,
    Value<DateTime>? date,
    Value<double>? amount,
    Value<String>? description,
    Value<String>? type,
    Value<DateTime>? cachedAt,
  }) {
    return TransactionsTableCompanion(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      accountId: accountId ?? this.accountId,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      type: type ?? this.type,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsTableCompanion(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('accountId: $accountId, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }
}

class $CardsTableTable extends CardsTable
    with TableInfo<$CardsTableTable, CardsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _lastFourMeta = const VerificationMeta(
    'lastFour',
  );
  @override
  late final GeneratedColumn<String> lastFour = GeneratedColumn<String>(
    'last_four',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _holderNameMeta = const VerificationMeta(
    'holderName',
  );
  @override
  late final GeneratedColumn<String> holderName = GeneratedColumn<String>(
    'holder_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cardId,
    lastFour,
    type,
    status,
    holderName,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cards_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('last_four')) {
      context.handle(
        _lastFourMeta,
        lastFour.isAcceptableOrUnknown(data['last_four']!, _lastFourMeta),
      );
    } else if (isInserting) {
      context.missing(_lastFourMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('holder_name')) {
      context.handle(
        _holderNameMeta,
        holderName.isAcceptableOrUnknown(data['holder_name']!, _holderNameMeta),
      );
    } else if (isInserting) {
      context.missing(_holderNameMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_id'],
      )!,
      lastFour: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_four'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      holderName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}holder_name'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $CardsTableTable createAlias(String alias) {
    return $CardsTableTable(attachedDatabase, alias);
  }
}

class CardsTableData extends DataClass implements Insertable<CardsTableData> {
  final int id;
  final String cardId;
  final String lastFour;
  final String type;
  final String status;
  final String holderName;
  final DateTime cachedAt;
  const CardsTableData({
    required this.id,
    required this.cardId,
    required this.lastFour,
    required this.type,
    required this.status,
    required this.holderName,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['card_id'] = Variable<String>(cardId);
    map['last_four'] = Variable<String>(lastFour);
    map['type'] = Variable<String>(type);
    map['status'] = Variable<String>(status);
    map['holder_name'] = Variable<String>(holderName);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  CardsTableCompanion toCompanion(bool nullToAbsent) {
    return CardsTableCompanion(
      id: Value(id),
      cardId: Value(cardId),
      lastFour: Value(lastFour),
      type: Value(type),
      status: Value(status),
      holderName: Value(holderName),
      cachedAt: Value(cachedAt),
    );
  }

  factory CardsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardsTableData(
      id: serializer.fromJson<int>(json['id']),
      cardId: serializer.fromJson<String>(json['cardId']),
      lastFour: serializer.fromJson<String>(json['lastFour']),
      type: serializer.fromJson<String>(json['type']),
      status: serializer.fromJson<String>(json['status']),
      holderName: serializer.fromJson<String>(json['holderName']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cardId': serializer.toJson<String>(cardId),
      'lastFour': serializer.toJson<String>(lastFour),
      'type': serializer.toJson<String>(type),
      'status': serializer.toJson<String>(status),
      'holderName': serializer.toJson<String>(holderName),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  CardsTableData copyWith({
    int? id,
    String? cardId,
    String? lastFour,
    String? type,
    String? status,
    String? holderName,
    DateTime? cachedAt,
  }) => CardsTableData(
    id: id ?? this.id,
    cardId: cardId ?? this.cardId,
    lastFour: lastFour ?? this.lastFour,
    type: type ?? this.type,
    status: status ?? this.status,
    holderName: holderName ?? this.holderName,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  CardsTableData copyWithCompanion(CardsTableCompanion data) {
    return CardsTableData(
      id: data.id.present ? data.id.value : this.id,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      lastFour: data.lastFour.present ? data.lastFour.value : this.lastFour,
      type: data.type.present ? data.type.value : this.type,
      status: data.status.present ? data.status.value : this.status,
      holderName: data.holderName.present
          ? data.holderName.value
          : this.holderName,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardsTableData(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('lastFour: $lastFour, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('holderName: $holderName, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, cardId, lastFour, type, status, holderName, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardsTableData &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.lastFour == this.lastFour &&
          other.type == this.type &&
          other.status == this.status &&
          other.holderName == this.holderName &&
          other.cachedAt == this.cachedAt);
}

class CardsTableCompanion extends UpdateCompanion<CardsTableData> {
  final Value<int> id;
  final Value<String> cardId;
  final Value<String> lastFour;
  final Value<String> type;
  final Value<String> status;
  final Value<String> holderName;
  final Value<DateTime> cachedAt;
  const CardsTableCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.lastFour = const Value.absent(),
    this.type = const Value.absent(),
    this.status = const Value.absent(),
    this.holderName = const Value.absent(),
    this.cachedAt = const Value.absent(),
  });
  CardsTableCompanion.insert({
    this.id = const Value.absent(),
    required String cardId,
    required String lastFour,
    required String type,
    required String status,
    required String holderName,
    this.cachedAt = const Value.absent(),
  }) : cardId = Value(cardId),
       lastFour = Value(lastFour),
       type = Value(type),
       status = Value(status),
       holderName = Value(holderName);
  static Insertable<CardsTableData> custom({
    Expression<int>? id,
    Expression<String>? cardId,
    Expression<String>? lastFour,
    Expression<String>? type,
    Expression<String>? status,
    Expression<String>? holderName,
    Expression<DateTime>? cachedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (lastFour != null) 'last_four': lastFour,
      if (type != null) 'type': type,
      if (status != null) 'status': status,
      if (holderName != null) 'holder_name': holderName,
      if (cachedAt != null) 'cached_at': cachedAt,
    });
  }

  CardsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? cardId,
    Value<String>? lastFour,
    Value<String>? type,
    Value<String>? status,
    Value<String>? holderName,
    Value<DateTime>? cachedAt,
  }) {
    return CardsTableCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      lastFour: lastFour ?? this.lastFour,
      type: type ?? this.type,
      status: status ?? this.status,
      holderName: holderName ?? this.holderName,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (lastFour.present) {
      map['last_four'] = Variable<String>(lastFour.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (holderName.present) {
      map['holder_name'] = Variable<String>(holderName.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardsTableCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('lastFour: $lastFour, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('holderName: $holderName, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AccountsTableTable accountsTable = $AccountsTableTable(this);
  late final $TransactionsTableTable transactionsTable =
      $TransactionsTableTable(this);
  late final $CardsTableTable cardsTable = $CardsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    accountsTable,
    transactionsTable,
    cardsTable,
  ];
}

typedef $$AccountsTableTableCreateCompanionBuilder =
    AccountsTableCompanion Function({
      Value<int> id,
      required String accountId,
      required String alias,
      required String currency,
      required double availableBalance,
      required double ledgerBalance,
      Value<DateTime> cachedAt,
    });
typedef $$AccountsTableTableUpdateCompanionBuilder =
    AccountsTableCompanion Function({
      Value<int> id,
      Value<String> accountId,
      Value<String> alias,
      Value<String> currency,
      Value<double> availableBalance,
      Value<double> ledgerBalance,
      Value<DateTime> cachedAt,
    });

class $$AccountsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTableTable> {
  $$AccountsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alias => $composableBuilder(
    column: $table.alias,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get availableBalance => $composableBuilder(
    column: $table.availableBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ledgerBalance => $composableBuilder(
    column: $table.ledgerBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AccountsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTableTable> {
  $$AccountsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alias => $composableBuilder(
    column: $table.alias,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get availableBalance => $composableBuilder(
    column: $table.availableBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ledgerBalance => $composableBuilder(
    column: $table.ledgerBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTableTable> {
  $$AccountsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get alias =>
      $composableBuilder(column: $table.alias, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<double> get availableBalance => $composableBuilder(
    column: $table.availableBalance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get ledgerBalance => $composableBuilder(
    column: $table.ledgerBalance,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$AccountsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountsTableTable,
          AccountsTableData,
          $$AccountsTableTableFilterComposer,
          $$AccountsTableTableOrderingComposer,
          $$AccountsTableTableAnnotationComposer,
          $$AccountsTableTableCreateCompanionBuilder,
          $$AccountsTableTableUpdateCompanionBuilder,
          (
            AccountsTableData,
            BaseReferences<
              _$AppDatabase,
              $AccountsTableTable,
              AccountsTableData
            >,
          ),
          AccountsTableData,
          PrefetchHooks Function()
        > {
  $$AccountsTableTableTableManager(_$AppDatabase db, $AccountsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> alias = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<double> availableBalance = const Value.absent(),
                Value<double> ledgerBalance = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
              }) => AccountsTableCompanion(
                id: id,
                accountId: accountId,
                alias: alias,
                currency: currency,
                availableBalance: availableBalance,
                ledgerBalance: ledgerBalance,
                cachedAt: cachedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String accountId,
                required String alias,
                required String currency,
                required double availableBalance,
                required double ledgerBalance,
                Value<DateTime> cachedAt = const Value.absent(),
              }) => AccountsTableCompanion.insert(
                id: id,
                accountId: accountId,
                alias: alias,
                currency: currency,
                availableBalance: availableBalance,
                ledgerBalance: ledgerBalance,
                cachedAt: cachedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AccountsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountsTableTable,
      AccountsTableData,
      $$AccountsTableTableFilterComposer,
      $$AccountsTableTableOrderingComposer,
      $$AccountsTableTableAnnotationComposer,
      $$AccountsTableTableCreateCompanionBuilder,
      $$AccountsTableTableUpdateCompanionBuilder,
      (
        AccountsTableData,
        BaseReferences<_$AppDatabase, $AccountsTableTable, AccountsTableData>,
      ),
      AccountsTableData,
      PrefetchHooks Function()
    >;
typedef $$TransactionsTableTableCreateCompanionBuilder =
    TransactionsTableCompanion Function({
      Value<int> id,
      required String transactionId,
      required String accountId,
      required DateTime date,
      required double amount,
      required String description,
      required String type,
      Value<DateTime> cachedAt,
    });
typedef $$TransactionsTableTableUpdateCompanionBuilder =
    TransactionsTableCompanion Function({
      Value<int> id,
      Value<String> transactionId,
      Value<String> accountId,
      Value<DateTime> date,
      Value<double> amount,
      Value<String> description,
      Value<String> type,
      Value<DateTime> cachedAt,
    });

class $$TransactionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTableTable> {
  $$TransactionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTableTable> {
  $$TransactionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTableTable> {
  $$TransactionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$TransactionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTableTable,
          TransactionsTableData,
          $$TransactionsTableTableFilterComposer,
          $$TransactionsTableTableOrderingComposer,
          $$TransactionsTableTableAnnotationComposer,
          $$TransactionsTableTableCreateCompanionBuilder,
          $$TransactionsTableTableUpdateCompanionBuilder,
          (
            TransactionsTableData,
            BaseReferences<
              _$AppDatabase,
              $TransactionsTableTable,
              TransactionsTableData
            >,
          ),
          TransactionsTableData,
          PrefetchHooks Function()
        > {
  $$TransactionsTableTableTableManager(
    _$AppDatabase db,
    $TransactionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> transactionId = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
              }) => TransactionsTableCompanion(
                id: id,
                transactionId: transactionId,
                accountId: accountId,
                date: date,
                amount: amount,
                description: description,
                type: type,
                cachedAt: cachedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String transactionId,
                required String accountId,
                required DateTime date,
                required double amount,
                required String description,
                required String type,
                Value<DateTime> cachedAt = const Value.absent(),
              }) => TransactionsTableCompanion.insert(
                id: id,
                transactionId: transactionId,
                accountId: accountId,
                date: date,
                amount: amount,
                description: description,
                type: type,
                cachedAt: cachedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTableTable,
      TransactionsTableData,
      $$TransactionsTableTableFilterComposer,
      $$TransactionsTableTableOrderingComposer,
      $$TransactionsTableTableAnnotationComposer,
      $$TransactionsTableTableCreateCompanionBuilder,
      $$TransactionsTableTableUpdateCompanionBuilder,
      (
        TransactionsTableData,
        BaseReferences<
          _$AppDatabase,
          $TransactionsTableTable,
          TransactionsTableData
        >,
      ),
      TransactionsTableData,
      PrefetchHooks Function()
    >;
typedef $$CardsTableTableCreateCompanionBuilder =
    CardsTableCompanion Function({
      Value<int> id,
      required String cardId,
      required String lastFour,
      required String type,
      required String status,
      required String holderName,
      Value<DateTime> cachedAt,
    });
typedef $$CardsTableTableUpdateCompanionBuilder =
    CardsTableCompanion Function({
      Value<int> id,
      Value<String> cardId,
      Value<String> lastFour,
      Value<String> type,
      Value<String> status,
      Value<String> holderName,
      Value<DateTime> cachedAt,
    });

class $$CardsTableTableFilterComposer
    extends Composer<_$AppDatabase, $CardsTableTable> {
  $$CardsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardId => $composableBuilder(
    column: $table.cardId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastFour => $composableBuilder(
    column: $table.lastFour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get holderName => $composableBuilder(
    column: $table.holderName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CardsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CardsTableTable> {
  $$CardsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardId => $composableBuilder(
    column: $table.cardId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastFour => $composableBuilder(
    column: $table.lastFour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get holderName => $composableBuilder(
    column: $table.holderName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CardsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardsTableTable> {
  $$CardsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get cardId =>
      $composableBuilder(column: $table.cardId, builder: (column) => column);

  GeneratedColumn<String> get lastFour =>
      $composableBuilder(column: $table.lastFour, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get holderName => $composableBuilder(
    column: $table.holderName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$CardsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardsTableTable,
          CardsTableData,
          $$CardsTableTableFilterComposer,
          $$CardsTableTableOrderingComposer,
          $$CardsTableTableAnnotationComposer,
          $$CardsTableTableCreateCompanionBuilder,
          $$CardsTableTableUpdateCompanionBuilder,
          (
            CardsTableData,
            BaseReferences<_$AppDatabase, $CardsTableTable, CardsTableData>,
          ),
          CardsTableData,
          PrefetchHooks Function()
        > {
  $$CardsTableTableTableManager(_$AppDatabase db, $CardsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> cardId = const Value.absent(),
                Value<String> lastFour = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> holderName = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
              }) => CardsTableCompanion(
                id: id,
                cardId: cardId,
                lastFour: lastFour,
                type: type,
                status: status,
                holderName: holderName,
                cachedAt: cachedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String cardId,
                required String lastFour,
                required String type,
                required String status,
                required String holderName,
                Value<DateTime> cachedAt = const Value.absent(),
              }) => CardsTableCompanion.insert(
                id: id,
                cardId: cardId,
                lastFour: lastFour,
                type: type,
                status: status,
                holderName: holderName,
                cachedAt: cachedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CardsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardsTableTable,
      CardsTableData,
      $$CardsTableTableFilterComposer,
      $$CardsTableTableOrderingComposer,
      $$CardsTableTableAnnotationComposer,
      $$CardsTableTableCreateCompanionBuilder,
      $$CardsTableTableUpdateCompanionBuilder,
      (
        CardsTableData,
        BaseReferences<_$AppDatabase, $CardsTableTable, CardsTableData>,
      ),
      CardsTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AccountsTableTableTableManager get accountsTable =>
      $$AccountsTableTableTableManager(_db, _db.accountsTable);
  $$TransactionsTableTableTableManager get transactionsTable =>
      $$TransactionsTableTableTableManager(_db, _db.transactionsTable);
  $$CardsTableTableTableManager get cardsTable =>
      $$CardsTableTableTableManager(_db, _db.cardsTable);
}
