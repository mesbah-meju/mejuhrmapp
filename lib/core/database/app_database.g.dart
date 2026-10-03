// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $OfflineOperationsTable extends OfflineOperations
    with TableInfo<$OfflineOperationsTable, OfflineOperation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OfflineOperationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<int> tenantId = GeneratedColumn<int>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _operationTypeMeta =
      const VerificationMeta('operationType');
  @override
  late final GeneratedColumn<String> operationType = GeneratedColumn<String>(
      'operation_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityLocalIdMeta =
      const VerificationMeta('entityLocalId');
  @override
  late final GeneratedColumn<String> entityLocalId = GeneratedColumn<String>(
      'entity_local_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _entityServerIdMeta =
      const VerificationMeta('entityServerId');
  @override
  late final GeneratedColumn<int> entityServerId = GeneratedColumn<int>(
      'entity_server_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _payloadMeta =
      const VerificationMeta('payload');
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
      'payload', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
      'priority', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _retryCountMeta =
      const VerificationMeta('retryCount');
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
      'retry_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _maxRetriesMeta =
      const VerificationMeta('maxRetries');
  @override
  late final GeneratedColumn<int> maxRetries = GeneratedColumn<int>(
      'max_retries', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(5));
  static const VerificationMeta _nextRetryAtMeta =
      const VerificationMeta('nextRetryAt');
  @override
  late final GeneratedColumn<DateTime> nextRetryAt = GeneratedColumn<DateTime>(
      'next_retry_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastAttemptAtMeta =
      const VerificationMeta('lastAttemptAt');
  @override
  late final GeneratedColumn<DateTime> lastAttemptAt =
      GeneratedColumn<DateTime>('last_attempt_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastErrorMeta =
      const VerificationMeta('lastError');
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
      'last_error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _errorCodeMeta =
      const VerificationMeta('errorCode');
  @override
  late final GeneratedColumn<String> errorCode = GeneratedColumn<String>(
      'error_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dependsOnOperationIdMeta =
      const VerificationMeta('dependsOnOperationId');
  @override
  late final GeneratedColumn<String> dependsOnOperationId =
      GeneratedColumn<String>('depends_on_operation_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _idempotencyKeyMeta =
      const VerificationMeta('idempotencyKey');
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
      'idempotency_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tenantId,
        userId,
        operationType,
        entityType,
        entityLocalId,
        entityServerId,
        payload,
        status,
        priority,
        retryCount,
        maxRetries,
        nextRetryAt,
        lastAttemptAt,
        lastError,
        errorCode,
        dependsOnOperationId,
        idempotencyKey,
        createdAt,
        updatedAt,
        syncedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'offline_operations';
  @override
  VerificationContext validateIntegrity(Insertable<OfflineOperation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('operation_type')) {
      context.handle(
          _operationTypeMeta,
          operationType.isAcceptableOrUnknown(
              data['operation_type']!, _operationTypeMeta));
    } else if (isInserting) {
      context.missing(_operationTypeMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_local_id')) {
      context.handle(
          _entityLocalIdMeta,
          entityLocalId.isAcceptableOrUnknown(
              data['entity_local_id']!, _entityLocalIdMeta));
    }
    if (data.containsKey('entity_server_id')) {
      context.handle(
          _entityServerIdMeta,
          entityServerId.isAcceptableOrUnknown(
              data['entity_server_id']!, _entityServerIdMeta));
    }
    if (data.containsKey('payload')) {
      context.handle(_payloadMeta,
          payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta));
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    }
    if (data.containsKey('retry_count')) {
      context.handle(
          _retryCountMeta,
          retryCount.isAcceptableOrUnknown(
              data['retry_count']!, _retryCountMeta));
    }
    if (data.containsKey('max_retries')) {
      context.handle(
          _maxRetriesMeta,
          maxRetries.isAcceptableOrUnknown(
              data['max_retries']!, _maxRetriesMeta));
    }
    if (data.containsKey('next_retry_at')) {
      context.handle(
          _nextRetryAtMeta,
          nextRetryAt.isAcceptableOrUnknown(
              data['next_retry_at']!, _nextRetryAtMeta));
    }
    if (data.containsKey('last_attempt_at')) {
      context.handle(
          _lastAttemptAtMeta,
          lastAttemptAt.isAcceptableOrUnknown(
              data['last_attempt_at']!, _lastAttemptAtMeta));
    }
    if (data.containsKey('last_error')) {
      context.handle(_lastErrorMeta,
          lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta));
    }
    if (data.containsKey('error_code')) {
      context.handle(_errorCodeMeta,
          errorCode.isAcceptableOrUnknown(data['error_code']!, _errorCodeMeta));
    }
    if (data.containsKey('depends_on_operation_id')) {
      context.handle(
          _dependsOnOperationIdMeta,
          dependsOnOperationId.isAcceptableOrUnknown(
              data['depends_on_operation_id']!, _dependsOnOperationIdMeta));
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
          _idempotencyKeyMeta,
          idempotencyKey.isAcceptableOrUnknown(
              data['idempotency_key']!, _idempotencyKeyMeta));
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OfflineOperation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OfflineOperation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tenant_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      operationType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operation_type'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityLocalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_local_id']),
      entityServerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}entity_server_id']),
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority'])!,
      retryCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retry_count'])!,
      maxRetries: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}max_retries'])!,
      nextRetryAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}next_retry_at']),
      lastAttemptAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_attempt_at']),
      lastError: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_error']),
      errorCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}error_code']),
      dependsOnOperationId: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}depends_on_operation_id']),
      idempotencyKey: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}idempotency_key'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
    );
  }

  @override
  $OfflineOperationsTable createAlias(String alias) {
    return $OfflineOperationsTable(attachedDatabase, alias);
  }
}

class OfflineOperation extends DataClass
    implements Insertable<OfflineOperation> {
  final String id;
  final int tenantId;
  final int userId;
  final String operationType;
  final String entityType;
  final String? entityLocalId;
  final int? entityServerId;
  final String payload;
  final String status;
  final int priority;
  final int retryCount;
  final int maxRetries;
  final DateTime? nextRetryAt;
  final DateTime? lastAttemptAt;
  final String? lastError;
  final String? errorCode;
  final String? dependsOnOperationId;
  final String idempotencyKey;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? syncedAt;
  const OfflineOperation(
      {required this.id,
      required this.tenantId,
      required this.userId,
      required this.operationType,
      required this.entityType,
      this.entityLocalId,
      this.entityServerId,
      required this.payload,
      required this.status,
      required this.priority,
      required this.retryCount,
      required this.maxRetries,
      this.nextRetryAt,
      this.lastAttemptAt,
      this.lastError,
      this.errorCode,
      this.dependsOnOperationId,
      required this.idempotencyKey,
      required this.createdAt,
      required this.updatedAt,
      this.syncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tenant_id'] = Variable<int>(tenantId);
    map['user_id'] = Variable<int>(userId);
    map['operation_type'] = Variable<String>(operationType);
    map['entity_type'] = Variable<String>(entityType);
    if (!nullToAbsent || entityLocalId != null) {
      map['entity_local_id'] = Variable<String>(entityLocalId);
    }
    if (!nullToAbsent || entityServerId != null) {
      map['entity_server_id'] = Variable<int>(entityServerId);
    }
    map['payload'] = Variable<String>(payload);
    map['status'] = Variable<String>(status);
    map['priority'] = Variable<int>(priority);
    map['retry_count'] = Variable<int>(retryCount);
    map['max_retries'] = Variable<int>(maxRetries);
    if (!nullToAbsent || nextRetryAt != null) {
      map['next_retry_at'] = Variable<DateTime>(nextRetryAt);
    }
    if (!nullToAbsent || lastAttemptAt != null) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt);
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    if (!nullToAbsent || errorCode != null) {
      map['error_code'] = Variable<String>(errorCode);
    }
    if (!nullToAbsent || dependsOnOperationId != null) {
      map['depends_on_operation_id'] = Variable<String>(dependsOnOperationId);
    }
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  OfflineOperationsCompanion toCompanion(bool nullToAbsent) {
    return OfflineOperationsCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      userId: Value(userId),
      operationType: Value(operationType),
      entityType: Value(entityType),
      entityLocalId: entityLocalId == null && nullToAbsent
          ? const Value.absent()
          : Value(entityLocalId),
      entityServerId: entityServerId == null && nullToAbsent
          ? const Value.absent()
          : Value(entityServerId),
      payload: Value(payload),
      status: Value(status),
      priority: Value(priority),
      retryCount: Value(retryCount),
      maxRetries: Value(maxRetries),
      nextRetryAt: nextRetryAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextRetryAt),
      lastAttemptAt: lastAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAttemptAt),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      errorCode: errorCode == null && nullToAbsent
          ? const Value.absent()
          : Value(errorCode),
      dependsOnOperationId: dependsOnOperationId == null && nullToAbsent
          ? const Value.absent()
          : Value(dependsOnOperationId),
      idempotencyKey: Value(idempotencyKey),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory OfflineOperation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OfflineOperation(
      id: serializer.fromJson<String>(json['id']),
      tenantId: serializer.fromJson<int>(json['tenantId']),
      userId: serializer.fromJson<int>(json['userId']),
      operationType: serializer.fromJson<String>(json['operationType']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityLocalId: serializer.fromJson<String?>(json['entityLocalId']),
      entityServerId: serializer.fromJson<int?>(json['entityServerId']),
      payload: serializer.fromJson<String>(json['payload']),
      status: serializer.fromJson<String>(json['status']),
      priority: serializer.fromJson<int>(json['priority']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      maxRetries: serializer.fromJson<int>(json['maxRetries']),
      nextRetryAt: serializer.fromJson<DateTime?>(json['nextRetryAt']),
      lastAttemptAt: serializer.fromJson<DateTime?>(json['lastAttemptAt']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      errorCode: serializer.fromJson<String?>(json['errorCode']),
      dependsOnOperationId:
          serializer.fromJson<String?>(json['dependsOnOperationId']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tenantId': serializer.toJson<int>(tenantId),
      'userId': serializer.toJson<int>(userId),
      'operationType': serializer.toJson<String>(operationType),
      'entityType': serializer.toJson<String>(entityType),
      'entityLocalId': serializer.toJson<String?>(entityLocalId),
      'entityServerId': serializer.toJson<int?>(entityServerId),
      'payload': serializer.toJson<String>(payload),
      'status': serializer.toJson<String>(status),
      'priority': serializer.toJson<int>(priority),
      'retryCount': serializer.toJson<int>(retryCount),
      'maxRetries': serializer.toJson<int>(maxRetries),
      'nextRetryAt': serializer.toJson<DateTime?>(nextRetryAt),
      'lastAttemptAt': serializer.toJson<DateTime?>(lastAttemptAt),
      'lastError': serializer.toJson<String?>(lastError),
      'errorCode': serializer.toJson<String?>(errorCode),
      'dependsOnOperationId': serializer.toJson<String?>(dependsOnOperationId),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  OfflineOperation copyWith(
          {String? id,
          int? tenantId,
          int? userId,
          String? operationType,
          String? entityType,
          Value<String?> entityLocalId = const Value.absent(),
          Value<int?> entityServerId = const Value.absent(),
          String? payload,
          String? status,
          int? priority,
          int? retryCount,
          int? maxRetries,
          Value<DateTime?> nextRetryAt = const Value.absent(),
          Value<DateTime?> lastAttemptAt = const Value.absent(),
          Value<String?> lastError = const Value.absent(),
          Value<String?> errorCode = const Value.absent(),
          Value<String?> dependsOnOperationId = const Value.absent(),
          String? idempotencyKey,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> syncedAt = const Value.absent()}) =>
      OfflineOperation(
        id: id ?? this.id,
        tenantId: tenantId ?? this.tenantId,
        userId: userId ?? this.userId,
        operationType: operationType ?? this.operationType,
        entityType: entityType ?? this.entityType,
        entityLocalId:
            entityLocalId.present ? entityLocalId.value : this.entityLocalId,
        entityServerId:
            entityServerId.present ? entityServerId.value : this.entityServerId,
        payload: payload ?? this.payload,
        status: status ?? this.status,
        priority: priority ?? this.priority,
        retryCount: retryCount ?? this.retryCount,
        maxRetries: maxRetries ?? this.maxRetries,
        nextRetryAt: nextRetryAt.present ? nextRetryAt.value : this.nextRetryAt,
        lastAttemptAt:
            lastAttemptAt.present ? lastAttemptAt.value : this.lastAttemptAt,
        lastError: lastError.present ? lastError.value : this.lastError,
        errorCode: errorCode.present ? errorCode.value : this.errorCode,
        dependsOnOperationId: dependsOnOperationId.present
            ? dependsOnOperationId.value
            : this.dependsOnOperationId,
        idempotencyKey: idempotencyKey ?? this.idempotencyKey,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
      );
  OfflineOperation copyWithCompanion(OfflineOperationsCompanion data) {
    return OfflineOperation(
      id: data.id.present ? data.id.value : this.id,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      userId: data.userId.present ? data.userId.value : this.userId,
      operationType: data.operationType.present
          ? data.operationType.value
          : this.operationType,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityLocalId: data.entityLocalId.present
          ? data.entityLocalId.value
          : this.entityLocalId,
      entityServerId: data.entityServerId.present
          ? data.entityServerId.value
          : this.entityServerId,
      payload: data.payload.present ? data.payload.value : this.payload,
      status: data.status.present ? data.status.value : this.status,
      priority: data.priority.present ? data.priority.value : this.priority,
      retryCount:
          data.retryCount.present ? data.retryCount.value : this.retryCount,
      maxRetries:
          data.maxRetries.present ? data.maxRetries.value : this.maxRetries,
      nextRetryAt:
          data.nextRetryAt.present ? data.nextRetryAt.value : this.nextRetryAt,
      lastAttemptAt: data.lastAttemptAt.present
          ? data.lastAttemptAt.value
          : this.lastAttemptAt,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      errorCode: data.errorCode.present ? data.errorCode.value : this.errorCode,
      dependsOnOperationId: data.dependsOnOperationId.present
          ? data.dependsOnOperationId.value
          : this.dependsOnOperationId,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OfflineOperation(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('userId: $userId, ')
          ..write('operationType: $operationType, ')
          ..write('entityType: $entityType, ')
          ..write('entityLocalId: $entityLocalId, ')
          ..write('entityServerId: $entityServerId, ')
          ..write('payload: $payload, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('retryCount: $retryCount, ')
          ..write('maxRetries: $maxRetries, ')
          ..write('nextRetryAt: $nextRetryAt, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('lastError: $lastError, ')
          ..write('errorCode: $errorCode, ')
          ..write('dependsOnOperationId: $dependsOnOperationId, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        tenantId,
        userId,
        operationType,
        entityType,
        entityLocalId,
        entityServerId,
        payload,
        status,
        priority,
        retryCount,
        maxRetries,
        nextRetryAt,
        lastAttemptAt,
        lastError,
        errorCode,
        dependsOnOperationId,
        idempotencyKey,
        createdAt,
        updatedAt,
        syncedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OfflineOperation &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.userId == this.userId &&
          other.operationType == this.operationType &&
          other.entityType == this.entityType &&
          other.entityLocalId == this.entityLocalId &&
          other.entityServerId == this.entityServerId &&
          other.payload == this.payload &&
          other.status == this.status &&
          other.priority == this.priority &&
          other.retryCount == this.retryCount &&
          other.maxRetries == this.maxRetries &&
          other.nextRetryAt == this.nextRetryAt &&
          other.lastAttemptAt == this.lastAttemptAt &&
          other.lastError == this.lastError &&
          other.errorCode == this.errorCode &&
          other.dependsOnOperationId == this.dependsOnOperationId &&
          other.idempotencyKey == this.idempotencyKey &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt);
}

class OfflineOperationsCompanion extends UpdateCompanion<OfflineOperation> {
  final Value<String> id;
  final Value<int> tenantId;
  final Value<int> userId;
  final Value<String> operationType;
  final Value<String> entityType;
  final Value<String?> entityLocalId;
  final Value<int?> entityServerId;
  final Value<String> payload;
  final Value<String> status;
  final Value<int> priority;
  final Value<int> retryCount;
  final Value<int> maxRetries;
  final Value<DateTime?> nextRetryAt;
  final Value<DateTime?> lastAttemptAt;
  final Value<String?> lastError;
  final Value<String?> errorCode;
  final Value<String?> dependsOnOperationId;
  final Value<String> idempotencyKey;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const OfflineOperationsCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.userId = const Value.absent(),
    this.operationType = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityLocalId = const Value.absent(),
    this.entityServerId = const Value.absent(),
    this.payload = const Value.absent(),
    this.status = const Value.absent(),
    this.priority = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.maxRetries = const Value.absent(),
    this.nextRetryAt = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.errorCode = const Value.absent(),
    this.dependsOnOperationId = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OfflineOperationsCompanion.insert({
    required String id,
    required int tenantId,
    required int userId,
    required String operationType,
    required String entityType,
    this.entityLocalId = const Value.absent(),
    this.entityServerId = const Value.absent(),
    required String payload,
    this.status = const Value.absent(),
    this.priority = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.maxRetries = const Value.absent(),
    this.nextRetryAt = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
    this.lastError = const Value.absent(),
    this.errorCode = const Value.absent(),
    this.dependsOnOperationId = const Value.absent(),
    required String idempotencyKey,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        tenantId = Value(tenantId),
        userId = Value(userId),
        operationType = Value(operationType),
        entityType = Value(entityType),
        payload = Value(payload),
        idempotencyKey = Value(idempotencyKey),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<OfflineOperation> custom({
    Expression<String>? id,
    Expression<int>? tenantId,
    Expression<int>? userId,
    Expression<String>? operationType,
    Expression<String>? entityType,
    Expression<String>? entityLocalId,
    Expression<int>? entityServerId,
    Expression<String>? payload,
    Expression<String>? status,
    Expression<int>? priority,
    Expression<int>? retryCount,
    Expression<int>? maxRetries,
    Expression<DateTime>? nextRetryAt,
    Expression<DateTime>? lastAttemptAt,
    Expression<String>? lastError,
    Expression<String>? errorCode,
    Expression<String>? dependsOnOperationId,
    Expression<String>? idempotencyKey,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (userId != null) 'user_id': userId,
      if (operationType != null) 'operation_type': operationType,
      if (entityType != null) 'entity_type': entityType,
      if (entityLocalId != null) 'entity_local_id': entityLocalId,
      if (entityServerId != null) 'entity_server_id': entityServerId,
      if (payload != null) 'payload': payload,
      if (status != null) 'status': status,
      if (priority != null) 'priority': priority,
      if (retryCount != null) 'retry_count': retryCount,
      if (maxRetries != null) 'max_retries': maxRetries,
      if (nextRetryAt != null) 'next_retry_at': nextRetryAt,
      if (lastAttemptAt != null) 'last_attempt_at': lastAttemptAt,
      if (lastError != null) 'last_error': lastError,
      if (errorCode != null) 'error_code': errorCode,
      if (dependsOnOperationId != null)
        'depends_on_operation_id': dependsOnOperationId,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OfflineOperationsCompanion copyWith(
      {Value<String>? id,
      Value<int>? tenantId,
      Value<int>? userId,
      Value<String>? operationType,
      Value<String>? entityType,
      Value<String?>? entityLocalId,
      Value<int?>? entityServerId,
      Value<String>? payload,
      Value<String>? status,
      Value<int>? priority,
      Value<int>? retryCount,
      Value<int>? maxRetries,
      Value<DateTime?>? nextRetryAt,
      Value<DateTime?>? lastAttemptAt,
      Value<String?>? lastError,
      Value<String?>? errorCode,
      Value<String?>? dependsOnOperationId,
      Value<String>? idempotencyKey,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? syncedAt,
      Value<int>? rowid}) {
    return OfflineOperationsCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      userId: userId ?? this.userId,
      operationType: operationType ?? this.operationType,
      entityType: entityType ?? this.entityType,
      entityLocalId: entityLocalId ?? this.entityLocalId,
      entityServerId: entityServerId ?? this.entityServerId,
      payload: payload ?? this.payload,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      retryCount: retryCount ?? this.retryCount,
      maxRetries: maxRetries ?? this.maxRetries,
      nextRetryAt: nextRetryAt ?? this.nextRetryAt,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      lastError: lastError ?? this.lastError,
      errorCode: errorCode ?? this.errorCode,
      dependsOnOperationId: dependsOnOperationId ?? this.dependsOnOperationId,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<int>(tenantId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (operationType.present) {
      map['operation_type'] = Variable<String>(operationType.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityLocalId.present) {
      map['entity_local_id'] = Variable<String>(entityLocalId.value);
    }
    if (entityServerId.present) {
      map['entity_server_id'] = Variable<int>(entityServerId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (maxRetries.present) {
      map['max_retries'] = Variable<int>(maxRetries.value);
    }
    if (nextRetryAt.present) {
      map['next_retry_at'] = Variable<DateTime>(nextRetryAt.value);
    }
    if (lastAttemptAt.present) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (errorCode.present) {
      map['error_code'] = Variable<String>(errorCode.value);
    }
    if (dependsOnOperationId.present) {
      map['depends_on_operation_id'] =
          Variable<String>(dependsOnOperationId.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OfflineOperationsCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('userId: $userId, ')
          ..write('operationType: $operationType, ')
          ..write('entityType: $entityType, ')
          ..write('entityLocalId: $entityLocalId, ')
          ..write('entityServerId: $entityServerId, ')
          ..write('payload: $payload, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('retryCount: $retryCount, ')
          ..write('maxRetries: $maxRetries, ')
          ..write('nextRetryAt: $nextRetryAt, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('lastError: $lastError, ')
          ..write('errorCode: $errorCode, ')
          ..write('dependsOnOperationId: $dependsOnOperationId, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTableTable extends TasksTable
    with TableInfo<$TasksTableTable, TasksTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta =
      const VerificationMeta('localId');
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
      'local_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
      'server_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<int> tenantId = GeneratedColumn<int>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _branchIdMeta =
      const VerificationMeta('branchId');
  @override
  late final GeneratedColumn<int> branchId = GeneratedColumn<int>(
      'branch_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _taskNameMeta =
      const VerificationMeta('taskName');
  @override
  late final GeneratedColumn<String> taskName = GeneratedColumn<String>(
      'task_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _completedByMeMeta =
      const VerificationMeta('completedByMe');
  @override
  late final GeneratedColumn<bool> completedByMe = GeneratedColumn<bool>(
      'completed_by_me', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("completed_by_me" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _completedByOtherMeta =
      const VerificationMeta('completedByOther');
  @override
  late final GeneratedColumn<bool> completedByOther = GeneratedColumn<bool>(
      'completed_by_other', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("completed_by_other" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _completedByMeta =
      const VerificationMeta('completedBy');
  @override
  late final GeneratedColumn<int> completedBy = GeneratedColumn<int>(
      'completed_by', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _completedByNameMeta =
      const VerificationMeta('completedByName');
  @override
  late final GeneratedColumn<String> completedByName = GeneratedColumn<String>(
      'completed_by_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<String> completedAt = GeneratedColumn<String>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _managerCommentMeta =
      const VerificationMeta('managerComment');
  @override
  late final GeneratedColumn<String> managerComment = GeneratedColumn<String>(
      'manager_comment', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _approvedByNameMeta =
      const VerificationMeta('approvedByName');
  @override
  late final GeneratedColumn<String> approvedByName = GeneratedColumn<String>(
      'approved_by_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _approvedAtMeta =
      const VerificationMeta('approvedAt');
  @override
  late final GeneratedColumn<String> approvedAt = GeneratedColumn<String>(
      'approved_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _canToggleMeta =
      const VerificationMeta('canToggle');
  @override
  late final GeneratedColumn<bool> canToggle = GeneratedColumn<bool>(
      'can_toggle', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("can_toggle" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _syncStateMeta =
      const VerificationMeta('syncState');
  @override
  late final GeneratedColumn<String> syncState = GeneratedColumn<String>(
      'sync_state', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('synced'));
  static const VerificationMeta _localUpdatedAtMeta =
      const VerificationMeta('localUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> localUpdatedAt =
      GeneratedColumn<DateTime>('local_updated_at', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _serverUpdatedAtMeta =
      const VerificationMeta('serverUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>('server_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        localId,
        serverId,
        tenantId,
        userId,
        branchId,
        taskName,
        description,
        isCompleted,
        status,
        completedByMe,
        completedByOther,
        completedBy,
        completedByName,
        completedAt,
        notes,
        managerComment,
        approvedByName,
        approvedAt,
        canToggle,
        syncState,
        localUpdatedAt,
        serverUpdatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks_table';
  @override
  VerificationContext validateIntegrity(Insertable<TasksTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(_localIdMeta,
          localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta));
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    }
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('branch_id')) {
      context.handle(_branchIdMeta,
          branchId.isAcceptableOrUnknown(data['branch_id']!, _branchIdMeta));
    }
    if (data.containsKey('task_name')) {
      context.handle(_taskNameMeta,
          taskName.isAcceptableOrUnknown(data['task_name']!, _taskNameMeta));
    } else if (isInserting) {
      context.missing(_taskNameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('completed_by_me')) {
      context.handle(
          _completedByMeMeta,
          completedByMe.isAcceptableOrUnknown(
              data['completed_by_me']!, _completedByMeMeta));
    }
    if (data.containsKey('completed_by_other')) {
      context.handle(
          _completedByOtherMeta,
          completedByOther.isAcceptableOrUnknown(
              data['completed_by_other']!, _completedByOtherMeta));
    }
    if (data.containsKey('completed_by')) {
      context.handle(
          _completedByMeta,
          completedBy.isAcceptableOrUnknown(
              data['completed_by']!, _completedByMeta));
    }
    if (data.containsKey('completed_by_name')) {
      context.handle(
          _completedByNameMeta,
          completedByName.isAcceptableOrUnknown(
              data['completed_by_name']!, _completedByNameMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('manager_comment')) {
      context.handle(
          _managerCommentMeta,
          managerComment.isAcceptableOrUnknown(
              data['manager_comment']!, _managerCommentMeta));
    }
    if (data.containsKey('approved_by_name')) {
      context.handle(
          _approvedByNameMeta,
          approvedByName.isAcceptableOrUnknown(
              data['approved_by_name']!, _approvedByNameMeta));
    }
    if (data.containsKey('approved_at')) {
      context.handle(
          _approvedAtMeta,
          approvedAt.isAcceptableOrUnknown(
              data['approved_at']!, _approvedAtMeta));
    }
    if (data.containsKey('can_toggle')) {
      context.handle(_canToggleMeta,
          canToggle.isAcceptableOrUnknown(data['can_toggle']!, _canToggleMeta));
    }
    if (data.containsKey('sync_state')) {
      context.handle(_syncStateMeta,
          syncState.isAcceptableOrUnknown(data['sync_state']!, _syncStateMeta));
    }
    if (data.containsKey('local_updated_at')) {
      context.handle(
          _localUpdatedAtMeta,
          localUpdatedAt.isAcceptableOrUnknown(
              data['local_updated_at']!, _localUpdatedAtMeta));
    } else if (isInserting) {
      context.missing(_localUpdatedAtMeta);
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
          _serverUpdatedAtMeta,
          serverUpdatedAt.isAcceptableOrUnknown(
              data['server_updated_at']!, _serverUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  TasksTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TasksTableData(
      localId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_id'])!,
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_id']),
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tenant_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      branchId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}branch_id']),
      taskName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}task_name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      completedByMe: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}completed_by_me'])!,
      completedByOther: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}completed_by_other'])!,
      completedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}completed_by']),
      completedByName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}completed_by_name']),
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}completed_at']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      managerComment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}manager_comment']),
      approvedByName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}approved_by_name']),
      approvedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}approved_at']),
      canToggle: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}can_toggle'])!,
      syncState: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_state'])!,
      localUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}local_updated_at'])!,
      serverUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}server_updated_at']),
    );
  }

  @override
  $TasksTableTable createAlias(String alias) {
    return $TasksTableTable(attachedDatabase, alias);
  }
}

class TasksTableData extends DataClass implements Insertable<TasksTableData> {
  final String localId;
  final int? serverId;
  final int tenantId;
  final int userId;
  final int? branchId;
  final String taskName;
  final String? description;
  final bool isCompleted;
  final String status;
  final bool completedByMe;
  final bool completedByOther;
  final int? completedBy;
  final String? completedByName;
  final String? completedAt;
  final String? notes;
  final String? managerComment;
  final String? approvedByName;
  final String? approvedAt;
  final bool canToggle;
  final String syncState;
  final DateTime localUpdatedAt;
  final DateTime? serverUpdatedAt;
  const TasksTableData(
      {required this.localId,
      this.serverId,
      required this.tenantId,
      required this.userId,
      this.branchId,
      required this.taskName,
      this.description,
      required this.isCompleted,
      required this.status,
      required this.completedByMe,
      required this.completedByOther,
      this.completedBy,
      this.completedByName,
      this.completedAt,
      this.notes,
      this.managerComment,
      this.approvedByName,
      this.approvedAt,
      required this.canToggle,
      required this.syncState,
      required this.localUpdatedAt,
      this.serverUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    map['tenant_id'] = Variable<int>(tenantId);
    map['user_id'] = Variable<int>(userId);
    if (!nullToAbsent || branchId != null) {
      map['branch_id'] = Variable<int>(branchId);
    }
    map['task_name'] = Variable<String>(taskName);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    map['status'] = Variable<String>(status);
    map['completed_by_me'] = Variable<bool>(completedByMe);
    map['completed_by_other'] = Variable<bool>(completedByOther);
    if (!nullToAbsent || completedBy != null) {
      map['completed_by'] = Variable<int>(completedBy);
    }
    if (!nullToAbsent || completedByName != null) {
      map['completed_by_name'] = Variable<String>(completedByName);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<String>(completedAt);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || managerComment != null) {
      map['manager_comment'] = Variable<String>(managerComment);
    }
    if (!nullToAbsent || approvedByName != null) {
      map['approved_by_name'] = Variable<String>(approvedByName);
    }
    if (!nullToAbsent || approvedAt != null) {
      map['approved_at'] = Variable<String>(approvedAt);
    }
    map['can_toggle'] = Variable<bool>(canToggle);
    map['sync_state'] = Variable<String>(syncState);
    map['local_updated_at'] = Variable<DateTime>(localUpdatedAt);
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    }
    return map;
  }

  TasksTableCompanion toCompanion(bool nullToAbsent) {
    return TasksTableCompanion(
      localId: Value(localId),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      tenantId: Value(tenantId),
      userId: Value(userId),
      branchId: branchId == null && nullToAbsent
          ? const Value.absent()
          : Value(branchId),
      taskName: Value(taskName),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isCompleted: Value(isCompleted),
      status: Value(status),
      completedByMe: Value(completedByMe),
      completedByOther: Value(completedByOther),
      completedBy: completedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(completedBy),
      completedByName: completedByName == null && nullToAbsent
          ? const Value.absent()
          : Value(completedByName),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      managerComment: managerComment == null && nullToAbsent
          ? const Value.absent()
          : Value(managerComment),
      approvedByName: approvedByName == null && nullToAbsent
          ? const Value.absent()
          : Value(approvedByName),
      approvedAt: approvedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(approvedAt),
      canToggle: Value(canToggle),
      syncState: Value(syncState),
      localUpdatedAt: Value(localUpdatedAt),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
    );
  }

  factory TasksTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TasksTableData(
      localId: serializer.fromJson<String>(json['localId']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      tenantId: serializer.fromJson<int>(json['tenantId']),
      userId: serializer.fromJson<int>(json['userId']),
      branchId: serializer.fromJson<int?>(json['branchId']),
      taskName: serializer.fromJson<String>(json['taskName']),
      description: serializer.fromJson<String?>(json['description']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      status: serializer.fromJson<String>(json['status']),
      completedByMe: serializer.fromJson<bool>(json['completedByMe']),
      completedByOther: serializer.fromJson<bool>(json['completedByOther']),
      completedBy: serializer.fromJson<int?>(json['completedBy']),
      completedByName: serializer.fromJson<String?>(json['completedByName']),
      completedAt: serializer.fromJson<String?>(json['completedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      managerComment: serializer.fromJson<String?>(json['managerComment']),
      approvedByName: serializer.fromJson<String?>(json['approvedByName']),
      approvedAt: serializer.fromJson<String?>(json['approvedAt']),
      canToggle: serializer.fromJson<bool>(json['canToggle']),
      syncState: serializer.fromJson<String>(json['syncState']),
      localUpdatedAt: serializer.fromJson<DateTime>(json['localUpdatedAt']),
      serverUpdatedAt: serializer.fromJson<DateTime?>(json['serverUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'serverId': serializer.toJson<int?>(serverId),
      'tenantId': serializer.toJson<int>(tenantId),
      'userId': serializer.toJson<int>(userId),
      'branchId': serializer.toJson<int?>(branchId),
      'taskName': serializer.toJson<String>(taskName),
      'description': serializer.toJson<String?>(description),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'status': serializer.toJson<String>(status),
      'completedByMe': serializer.toJson<bool>(completedByMe),
      'completedByOther': serializer.toJson<bool>(completedByOther),
      'completedBy': serializer.toJson<int?>(completedBy),
      'completedByName': serializer.toJson<String?>(completedByName),
      'completedAt': serializer.toJson<String?>(completedAt),
      'notes': serializer.toJson<String?>(notes),
      'managerComment': serializer.toJson<String?>(managerComment),
      'approvedByName': serializer.toJson<String?>(approvedByName),
      'approvedAt': serializer.toJson<String?>(approvedAt),
      'canToggle': serializer.toJson<bool>(canToggle),
      'syncState': serializer.toJson<String>(syncState),
      'localUpdatedAt': serializer.toJson<DateTime>(localUpdatedAt),
      'serverUpdatedAt': serializer.toJson<DateTime?>(serverUpdatedAt),
    };
  }

  TasksTableData copyWith(
          {String? localId,
          Value<int?> serverId = const Value.absent(),
          int? tenantId,
          int? userId,
          Value<int?> branchId = const Value.absent(),
          String? taskName,
          Value<String?> description = const Value.absent(),
          bool? isCompleted,
          String? status,
          bool? completedByMe,
          bool? completedByOther,
          Value<int?> completedBy = const Value.absent(),
          Value<String?> completedByName = const Value.absent(),
          Value<String?> completedAt = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          Value<String?> managerComment = const Value.absent(),
          Value<String?> approvedByName = const Value.absent(),
          Value<String?> approvedAt = const Value.absent(),
          bool? canToggle,
          String? syncState,
          DateTime? localUpdatedAt,
          Value<DateTime?> serverUpdatedAt = const Value.absent()}) =>
      TasksTableData(
        localId: localId ?? this.localId,
        serverId: serverId.present ? serverId.value : this.serverId,
        tenantId: tenantId ?? this.tenantId,
        userId: userId ?? this.userId,
        branchId: branchId.present ? branchId.value : this.branchId,
        taskName: taskName ?? this.taskName,
        description: description.present ? description.value : this.description,
        isCompleted: isCompleted ?? this.isCompleted,
        status: status ?? this.status,
        completedByMe: completedByMe ?? this.completedByMe,
        completedByOther: completedByOther ?? this.completedByOther,
        completedBy: completedBy.present ? completedBy.value : this.completedBy,
        completedByName: completedByName.present
            ? completedByName.value
            : this.completedByName,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        notes: notes.present ? notes.value : this.notes,
        managerComment:
            managerComment.present ? managerComment.value : this.managerComment,
        approvedByName:
            approvedByName.present ? approvedByName.value : this.approvedByName,
        approvedAt: approvedAt.present ? approvedAt.value : this.approvedAt,
        canToggle: canToggle ?? this.canToggle,
        syncState: syncState ?? this.syncState,
        localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
        serverUpdatedAt: serverUpdatedAt.present
            ? serverUpdatedAt.value
            : this.serverUpdatedAt,
      );
  TasksTableData copyWithCompanion(TasksTableCompanion data) {
    return TasksTableData(
      localId: data.localId.present ? data.localId.value : this.localId,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      userId: data.userId.present ? data.userId.value : this.userId,
      branchId: data.branchId.present ? data.branchId.value : this.branchId,
      taskName: data.taskName.present ? data.taskName.value : this.taskName,
      description:
          data.description.present ? data.description.value : this.description,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      status: data.status.present ? data.status.value : this.status,
      completedByMe: data.completedByMe.present
          ? data.completedByMe.value
          : this.completedByMe,
      completedByOther: data.completedByOther.present
          ? data.completedByOther.value
          : this.completedByOther,
      completedBy:
          data.completedBy.present ? data.completedBy.value : this.completedBy,
      completedByName: data.completedByName.present
          ? data.completedByName.value
          : this.completedByName,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      managerComment: data.managerComment.present
          ? data.managerComment.value
          : this.managerComment,
      approvedByName: data.approvedByName.present
          ? data.approvedByName.value
          : this.approvedByName,
      approvedAt:
          data.approvedAt.present ? data.approvedAt.value : this.approvedAt,
      canToggle: data.canToggle.present ? data.canToggle.value : this.canToggle,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      localUpdatedAt: data.localUpdatedAt.present
          ? data.localUpdatedAt.value
          : this.localUpdatedAt,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TasksTableData(')
          ..write('localId: $localId, ')
          ..write('serverId: $serverId, ')
          ..write('tenantId: $tenantId, ')
          ..write('userId: $userId, ')
          ..write('branchId: $branchId, ')
          ..write('taskName: $taskName, ')
          ..write('description: $description, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('status: $status, ')
          ..write('completedByMe: $completedByMe, ')
          ..write('completedByOther: $completedByOther, ')
          ..write('completedBy: $completedBy, ')
          ..write('completedByName: $completedByName, ')
          ..write('completedAt: $completedAt, ')
          ..write('notes: $notes, ')
          ..write('managerComment: $managerComment, ')
          ..write('approvedByName: $approvedByName, ')
          ..write('approvedAt: $approvedAt, ')
          ..write('canToggle: $canToggle, ')
          ..write('syncState: $syncState, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('serverUpdatedAt: $serverUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        localId,
        serverId,
        tenantId,
        userId,
        branchId,
        taskName,
        description,
        isCompleted,
        status,
        completedByMe,
        completedByOther,
        completedBy,
        completedByName,
        completedAt,
        notes,
        managerComment,
        approvedByName,
        approvedAt,
        canToggle,
        syncState,
        localUpdatedAt,
        serverUpdatedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TasksTableData &&
          other.localId == this.localId &&
          other.serverId == this.serverId &&
          other.tenantId == this.tenantId &&
          other.userId == this.userId &&
          other.branchId == this.branchId &&
          other.taskName == this.taskName &&
          other.description == this.description &&
          other.isCompleted == this.isCompleted &&
          other.status == this.status &&
          other.completedByMe == this.completedByMe &&
          other.completedByOther == this.completedByOther &&
          other.completedBy == this.completedBy &&
          other.completedByName == this.completedByName &&
          other.completedAt == this.completedAt &&
          other.notes == this.notes &&
          other.managerComment == this.managerComment &&
          other.approvedByName == this.approvedByName &&
          other.approvedAt == this.approvedAt &&
          other.canToggle == this.canToggle &&
          other.syncState == this.syncState &&
          other.localUpdatedAt == this.localUpdatedAt &&
          other.serverUpdatedAt == this.serverUpdatedAt);
}

class TasksTableCompanion extends UpdateCompanion<TasksTableData> {
  final Value<String> localId;
  final Value<int?> serverId;
  final Value<int> tenantId;
  final Value<int> userId;
  final Value<int?> branchId;
  final Value<String> taskName;
  final Value<String?> description;
  final Value<bool> isCompleted;
  final Value<String> status;
  final Value<bool> completedByMe;
  final Value<bool> completedByOther;
  final Value<int?> completedBy;
  final Value<String?> completedByName;
  final Value<String?> completedAt;
  final Value<String?> notes;
  final Value<String?> managerComment;
  final Value<String?> approvedByName;
  final Value<String?> approvedAt;
  final Value<bool> canToggle;
  final Value<String> syncState;
  final Value<DateTime> localUpdatedAt;
  final Value<DateTime?> serverUpdatedAt;
  final Value<int> rowid;
  const TasksTableCompanion({
    this.localId = const Value.absent(),
    this.serverId = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.userId = const Value.absent(),
    this.branchId = const Value.absent(),
    this.taskName = const Value.absent(),
    this.description = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.status = const Value.absent(),
    this.completedByMe = const Value.absent(),
    this.completedByOther = const Value.absent(),
    this.completedBy = const Value.absent(),
    this.completedByName = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.managerComment = const Value.absent(),
    this.approvedByName = const Value.absent(),
    this.approvedAt = const Value.absent(),
    this.canToggle = const Value.absent(),
    this.syncState = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksTableCompanion.insert({
    required String localId,
    this.serverId = const Value.absent(),
    required int tenantId,
    required int userId,
    this.branchId = const Value.absent(),
    required String taskName,
    this.description = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.status = const Value.absent(),
    this.completedByMe = const Value.absent(),
    this.completedByOther = const Value.absent(),
    this.completedBy = const Value.absent(),
    this.completedByName = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.managerComment = const Value.absent(),
    this.approvedByName = const Value.absent(),
    this.approvedAt = const Value.absent(),
    this.canToggle = const Value.absent(),
    this.syncState = const Value.absent(),
    required DateTime localUpdatedAt,
    this.serverUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : localId = Value(localId),
        tenantId = Value(tenantId),
        userId = Value(userId),
        taskName = Value(taskName),
        localUpdatedAt = Value(localUpdatedAt);
  static Insertable<TasksTableData> custom({
    Expression<String>? localId,
    Expression<int>? serverId,
    Expression<int>? tenantId,
    Expression<int>? userId,
    Expression<int>? branchId,
    Expression<String>? taskName,
    Expression<String>? description,
    Expression<bool>? isCompleted,
    Expression<String>? status,
    Expression<bool>? completedByMe,
    Expression<bool>? completedByOther,
    Expression<int>? completedBy,
    Expression<String>? completedByName,
    Expression<String>? completedAt,
    Expression<String>? notes,
    Expression<String>? managerComment,
    Expression<String>? approvedByName,
    Expression<String>? approvedAt,
    Expression<bool>? canToggle,
    Expression<String>? syncState,
    Expression<DateTime>? localUpdatedAt,
    Expression<DateTime>? serverUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (serverId != null) 'server_id': serverId,
      if (tenantId != null) 'tenant_id': tenantId,
      if (userId != null) 'user_id': userId,
      if (branchId != null) 'branch_id': branchId,
      if (taskName != null) 'task_name': taskName,
      if (description != null) 'description': description,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (status != null) 'status': status,
      if (completedByMe != null) 'completed_by_me': completedByMe,
      if (completedByOther != null) 'completed_by_other': completedByOther,
      if (completedBy != null) 'completed_by': completedBy,
      if (completedByName != null) 'completed_by_name': completedByName,
      if (completedAt != null) 'completed_at': completedAt,
      if (notes != null) 'notes': notes,
      if (managerComment != null) 'manager_comment': managerComment,
      if (approvedByName != null) 'approved_by_name': approvedByName,
      if (approvedAt != null) 'approved_at': approvedAt,
      if (canToggle != null) 'can_toggle': canToggle,
      if (syncState != null) 'sync_state': syncState,
      if (localUpdatedAt != null) 'local_updated_at': localUpdatedAt,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksTableCompanion copyWith(
      {Value<String>? localId,
      Value<int?>? serverId,
      Value<int>? tenantId,
      Value<int>? userId,
      Value<int?>? branchId,
      Value<String>? taskName,
      Value<String?>? description,
      Value<bool>? isCompleted,
      Value<String>? status,
      Value<bool>? completedByMe,
      Value<bool>? completedByOther,
      Value<int?>? completedBy,
      Value<String?>? completedByName,
      Value<String?>? completedAt,
      Value<String?>? notes,
      Value<String?>? managerComment,
      Value<String?>? approvedByName,
      Value<String?>? approvedAt,
      Value<bool>? canToggle,
      Value<String>? syncState,
      Value<DateTime>? localUpdatedAt,
      Value<DateTime?>? serverUpdatedAt,
      Value<int>? rowid}) {
    return TasksTableCompanion(
      localId: localId ?? this.localId,
      serverId: serverId ?? this.serverId,
      tenantId: tenantId ?? this.tenantId,
      userId: userId ?? this.userId,
      branchId: branchId ?? this.branchId,
      taskName: taskName ?? this.taskName,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      status: status ?? this.status,
      completedByMe: completedByMe ?? this.completedByMe,
      completedByOther: completedByOther ?? this.completedByOther,
      completedBy: completedBy ?? this.completedBy,
      completedByName: completedByName ?? this.completedByName,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
      managerComment: managerComment ?? this.managerComment,
      approvedByName: approvedByName ?? this.approvedByName,
      approvedAt: approvedAt ?? this.approvedAt,
      canToggle: canToggle ?? this.canToggle,
      syncState: syncState ?? this.syncState,
      localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<int>(tenantId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (branchId.present) {
      map['branch_id'] = Variable<int>(branchId.value);
    }
    if (taskName.present) {
      map['task_name'] = Variable<String>(taskName.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (completedByMe.present) {
      map['completed_by_me'] = Variable<bool>(completedByMe.value);
    }
    if (completedByOther.present) {
      map['completed_by_other'] = Variable<bool>(completedByOther.value);
    }
    if (completedBy.present) {
      map['completed_by'] = Variable<int>(completedBy.value);
    }
    if (completedByName.present) {
      map['completed_by_name'] = Variable<String>(completedByName.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<String>(completedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (managerComment.present) {
      map['manager_comment'] = Variable<String>(managerComment.value);
    }
    if (approvedByName.present) {
      map['approved_by_name'] = Variable<String>(approvedByName.value);
    }
    if (approvedAt.present) {
      map['approved_at'] = Variable<String>(approvedAt.value);
    }
    if (canToggle.present) {
      map['can_toggle'] = Variable<bool>(canToggle.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(syncState.value);
    }
    if (localUpdatedAt.present) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksTableCompanion(')
          ..write('localId: $localId, ')
          ..write('serverId: $serverId, ')
          ..write('tenantId: $tenantId, ')
          ..write('userId: $userId, ')
          ..write('branchId: $branchId, ')
          ..write('taskName: $taskName, ')
          ..write('description: $description, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('status: $status, ')
          ..write('completedByMe: $completedByMe, ')
          ..write('completedByOther: $completedByOther, ')
          ..write('completedBy: $completedBy, ')
          ..write('completedByName: $completedByName, ')
          ..write('completedAt: $completedAt, ')
          ..write('notes: $notes, ')
          ..write('managerComment: $managerComment, ')
          ..write('approvedByName: $approvedByName, ')
          ..write('approvedAt: $approvedAt, ')
          ..write('canToggle: $canToggle, ')
          ..write('syncState: $syncState, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AttendanceTableTable extends AttendanceTable
    with TableInfo<$AttendanceTableTable, AttendanceTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttendanceTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta =
      const VerificationMeta('localId');
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
      'local_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
      'server_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<int> tenantId = GeneratedColumn<int>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _clockInMeta =
      const VerificationMeta('clockIn');
  @override
  late final GeneratedColumn<String> clockIn = GeneratedColumn<String>(
      'clock_in', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _clockOutMeta =
      const VerificationMeta('clockOut');
  @override
  late final GeneratedColumn<String> clockOut = GeneratedColumn<String>(
      'clock_out', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('present'));
  static const VerificationMeta _calculatedStatusMeta =
      const VerificationMeta('calculatedStatus');
  @override
  late final GeneratedColumn<String> calculatedStatus = GeneratedColumn<String>(
      'calculated_status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isLateMeta = const VerificationMeta('isLate');
  @override
  late final GeneratedColumn<bool> isLate = GeneratedColumn<bool>(
      'is_late', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_late" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isEarlyMeta =
      const VerificationMeta('isEarly');
  @override
  late final GeneratedColumn<bool> isEarly = GeneratedColumn<bool>(
      'is_early', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_early" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _totalHoursMeta =
      const VerificationMeta('totalHours');
  @override
  late final GeneratedColumn<String> totalHours = GeneratedColumn<String>(
      'total_hours', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('0.00 hours'));
  static const VerificationMeta _totalHoursNumericMeta =
      const VerificationMeta('totalHoursNumeric');
  @override
  late final GeneratedColumn<double> totalHoursNumeric =
      GeneratedColumn<double>('total_hours_numeric', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0.0));
  static const VerificationMeta _breakHoursMeta =
      const VerificationMeta('breakHours');
  @override
  late final GeneratedColumn<String> breakHours = GeneratedColumn<String>(
      'break_hours', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _breakHoursNumericMeta =
      const VerificationMeta('breakHoursNumeric');
  @override
  late final GeneratedColumn<double> breakHoursNumeric =
      GeneratedColumn<double>('break_hours_numeric', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0.0));
  static const VerificationMeta _overtimeHoursMeta =
      const VerificationMeta('overtimeHours');
  @override
  late final GeneratedColumn<String> overtimeHours = GeneratedColumn<String>(
      'overtime_hours', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _overtimeHoursNumericMeta =
      const VerificationMeta('overtimeHoursNumeric');
  @override
  late final GeneratedColumn<double> overtimeHoursNumeric =
      GeneratedColumn<double>('overtime_hours_numeric', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0.0));
  static const VerificationMeta _overtimeAmountMeta =
      const VerificationMeta('overtimeAmount');
  @override
  late final GeneratedColumn<double> overtimeAmount = GeneratedColumn<double>(
      'overtime_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _checkInLocationJsonMeta =
      const VerificationMeta('checkInLocationJson');
  @override
  late final GeneratedColumn<String> checkInLocationJson =
      GeneratedColumn<String>('check_in_location_json', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _checkOutLocationJsonMeta =
      const VerificationMeta('checkOutLocationJson');
  @override
  late final GeneratedColumn<String> checkOutLocationJson =
      GeneratedColumn<String>('check_out_location_json', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _checkInBranchJsonMeta =
      const VerificationMeta('checkInBranchJson');
  @override
  late final GeneratedColumn<String> checkInBranchJson =
      GeneratedColumn<String>('check_in_branch_json', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _checkOutBranchJsonMeta =
      const VerificationMeta('checkOutBranchJson');
  @override
  late final GeneratedColumn<String> checkOutBranchJson =
      GeneratedColumn<String>('check_out_branch_json', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _shiftJsonMeta =
      const VerificationMeta('shiftJson');
  @override
  late final GeneratedColumn<String> shiftJson = GeneratedColumn<String>(
      'shift_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _accuracyMeta =
      const VerificationMeta('accuracy');
  @override
  late final GeneratedColumn<double> accuracy = GeneratedColumn<double>(
      'accuracy', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _syncStateMeta =
      const VerificationMeta('syncState');
  @override
  late final GeneratedColumn<String> syncState = GeneratedColumn<String>(
      'sync_state', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('synced'));
  static const VerificationMeta _localUpdatedAtMeta =
      const VerificationMeta('localUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> localUpdatedAt =
      GeneratedColumn<DateTime>('local_updated_at', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _serverUpdatedAtMeta =
      const VerificationMeta('serverUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> serverUpdatedAt =
      GeneratedColumn<DateTime>('server_updated_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        localId,
        serverId,
        tenantId,
        userId,
        date,
        clockIn,
        clockOut,
        status,
        calculatedStatus,
        isLate,
        isEarly,
        totalHours,
        totalHoursNumeric,
        breakHours,
        breakHoursNumeric,
        overtimeHours,
        overtimeHoursNumeric,
        overtimeAmount,
        notes,
        checkInLocationJson,
        checkOutLocationJson,
        checkInBranchJson,
        checkOutBranchJson,
        shiftJson,
        latitude,
        longitude,
        accuracy,
        syncState,
        localUpdatedAt,
        serverUpdatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attendance_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<AttendanceTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(_localIdMeta,
          localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta));
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    }
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('clock_in')) {
      context.handle(_clockInMeta,
          clockIn.isAcceptableOrUnknown(data['clock_in']!, _clockInMeta));
    }
    if (data.containsKey('clock_out')) {
      context.handle(_clockOutMeta,
          clockOut.isAcceptableOrUnknown(data['clock_out']!, _clockOutMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('calculated_status')) {
      context.handle(
          _calculatedStatusMeta,
          calculatedStatus.isAcceptableOrUnknown(
              data['calculated_status']!, _calculatedStatusMeta));
    }
    if (data.containsKey('is_late')) {
      context.handle(_isLateMeta,
          isLate.isAcceptableOrUnknown(data['is_late']!, _isLateMeta));
    }
    if (data.containsKey('is_early')) {
      context.handle(_isEarlyMeta,
          isEarly.isAcceptableOrUnknown(data['is_early']!, _isEarlyMeta));
    }
    if (data.containsKey('total_hours')) {
      context.handle(
          _totalHoursMeta,
          totalHours.isAcceptableOrUnknown(
              data['total_hours']!, _totalHoursMeta));
    }
    if (data.containsKey('total_hours_numeric')) {
      context.handle(
          _totalHoursNumericMeta,
          totalHoursNumeric.isAcceptableOrUnknown(
              data['total_hours_numeric']!, _totalHoursNumericMeta));
    }
    if (data.containsKey('break_hours')) {
      context.handle(
          _breakHoursMeta,
          breakHours.isAcceptableOrUnknown(
              data['break_hours']!, _breakHoursMeta));
    }
    if (data.containsKey('break_hours_numeric')) {
      context.handle(
          _breakHoursNumericMeta,
          breakHoursNumeric.isAcceptableOrUnknown(
              data['break_hours_numeric']!, _breakHoursNumericMeta));
    }
    if (data.containsKey('overtime_hours')) {
      context.handle(
          _overtimeHoursMeta,
          overtimeHours.isAcceptableOrUnknown(
              data['overtime_hours']!, _overtimeHoursMeta));
    }
    if (data.containsKey('overtime_hours_numeric')) {
      context.handle(
          _overtimeHoursNumericMeta,
          overtimeHoursNumeric.isAcceptableOrUnknown(
              data['overtime_hours_numeric']!, _overtimeHoursNumericMeta));
    }
    if (data.containsKey('overtime_amount')) {
      context.handle(
          _overtimeAmountMeta,
          overtimeAmount.isAcceptableOrUnknown(
              data['overtime_amount']!, _overtimeAmountMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('check_in_location_json')) {
      context.handle(
          _checkInLocationJsonMeta,
          checkInLocationJson.isAcceptableOrUnknown(
              data['check_in_location_json']!, _checkInLocationJsonMeta));
    }
    if (data.containsKey('check_out_location_json')) {
      context.handle(
          _checkOutLocationJsonMeta,
          checkOutLocationJson.isAcceptableOrUnknown(
              data['check_out_location_json']!, _checkOutLocationJsonMeta));
    }
    if (data.containsKey('check_in_branch_json')) {
      context.handle(
          _checkInBranchJsonMeta,
          checkInBranchJson.isAcceptableOrUnknown(
              data['check_in_branch_json']!, _checkInBranchJsonMeta));
    }
    if (data.containsKey('check_out_branch_json')) {
      context.handle(
          _checkOutBranchJsonMeta,
          checkOutBranchJson.isAcceptableOrUnknown(
              data['check_out_branch_json']!, _checkOutBranchJsonMeta));
    }
    if (data.containsKey('shift_json')) {
      context.handle(_shiftJsonMeta,
          shiftJson.isAcceptableOrUnknown(data['shift_json']!, _shiftJsonMeta));
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    }
    if (data.containsKey('accuracy')) {
      context.handle(_accuracyMeta,
          accuracy.isAcceptableOrUnknown(data['accuracy']!, _accuracyMeta));
    }
    if (data.containsKey('sync_state')) {
      context.handle(_syncStateMeta,
          syncState.isAcceptableOrUnknown(data['sync_state']!, _syncStateMeta));
    }
    if (data.containsKey('local_updated_at')) {
      context.handle(
          _localUpdatedAtMeta,
          localUpdatedAt.isAcceptableOrUnknown(
              data['local_updated_at']!, _localUpdatedAtMeta));
    } else if (isInserting) {
      context.missing(_localUpdatedAtMeta);
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
          _serverUpdatedAtMeta,
          serverUpdatedAt.isAcceptableOrUnknown(
              data['server_updated_at']!, _serverUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  AttendanceTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttendanceTableData(
      localId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_id'])!,
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_id']),
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tenant_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      clockIn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}clock_in']),
      clockOut: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}clock_out']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      calculatedStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}calculated_status']),
      isLate: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_late'])!,
      isEarly: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_early'])!,
      totalHours: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}total_hours'])!,
      totalHoursNumeric: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}total_hours_numeric'])!,
      breakHours: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}break_hours']),
      breakHoursNumeric: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}break_hours_numeric'])!,
      overtimeHours: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}overtime_hours']),
      overtimeHoursNumeric: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}overtime_hours_numeric'])!,
      overtimeAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}overtime_amount'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      checkInLocationJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}check_in_location_json']),
      checkOutLocationJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}check_out_location_json']),
      checkInBranchJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}check_in_branch_json']),
      checkOutBranchJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}check_out_branch_json']),
      shiftJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shift_json']),
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude']),
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude']),
      accuracy: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}accuracy']),
      syncState: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_state'])!,
      localUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}local_updated_at'])!,
      serverUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}server_updated_at']),
    );
  }

  @override
  $AttendanceTableTable createAlias(String alias) {
    return $AttendanceTableTable(attachedDatabase, alias);
  }
}

class AttendanceTableData extends DataClass
    implements Insertable<AttendanceTableData> {
  final String localId;
  final int? serverId;
  final int tenantId;
  final int userId;
  final String date;
  final String? clockIn;
  final String? clockOut;
  final String status;
  final String? calculatedStatus;
  final bool isLate;
  final bool isEarly;
  final String totalHours;
  final double totalHoursNumeric;
  final String? breakHours;
  final double breakHoursNumeric;
  final String? overtimeHours;
  final double overtimeHoursNumeric;
  final double overtimeAmount;
  final String? notes;
  final String? checkInLocationJson;
  final String? checkOutLocationJson;
  final String? checkInBranchJson;
  final String? checkOutBranchJson;
  final String? shiftJson;
  final double? latitude;
  final double? longitude;
  final double? accuracy;
  final String syncState;
  final DateTime localUpdatedAt;
  final DateTime? serverUpdatedAt;
  const AttendanceTableData(
      {required this.localId,
      this.serverId,
      required this.tenantId,
      required this.userId,
      required this.date,
      this.clockIn,
      this.clockOut,
      required this.status,
      this.calculatedStatus,
      required this.isLate,
      required this.isEarly,
      required this.totalHours,
      required this.totalHoursNumeric,
      this.breakHours,
      required this.breakHoursNumeric,
      this.overtimeHours,
      required this.overtimeHoursNumeric,
      required this.overtimeAmount,
      this.notes,
      this.checkInLocationJson,
      this.checkOutLocationJson,
      this.checkInBranchJson,
      this.checkOutBranchJson,
      this.shiftJson,
      this.latitude,
      this.longitude,
      this.accuracy,
      required this.syncState,
      required this.localUpdatedAt,
      this.serverUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    map['tenant_id'] = Variable<int>(tenantId);
    map['user_id'] = Variable<int>(userId);
    map['date'] = Variable<String>(date);
    if (!nullToAbsent || clockIn != null) {
      map['clock_in'] = Variable<String>(clockIn);
    }
    if (!nullToAbsent || clockOut != null) {
      map['clock_out'] = Variable<String>(clockOut);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || calculatedStatus != null) {
      map['calculated_status'] = Variable<String>(calculatedStatus);
    }
    map['is_late'] = Variable<bool>(isLate);
    map['is_early'] = Variable<bool>(isEarly);
    map['total_hours'] = Variable<String>(totalHours);
    map['total_hours_numeric'] = Variable<double>(totalHoursNumeric);
    if (!nullToAbsent || breakHours != null) {
      map['break_hours'] = Variable<String>(breakHours);
    }
    map['break_hours_numeric'] = Variable<double>(breakHoursNumeric);
    if (!nullToAbsent || overtimeHours != null) {
      map['overtime_hours'] = Variable<String>(overtimeHours);
    }
    map['overtime_hours_numeric'] = Variable<double>(overtimeHoursNumeric);
    map['overtime_amount'] = Variable<double>(overtimeAmount);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || checkInLocationJson != null) {
      map['check_in_location_json'] = Variable<String>(checkInLocationJson);
    }
    if (!nullToAbsent || checkOutLocationJson != null) {
      map['check_out_location_json'] = Variable<String>(checkOutLocationJson);
    }
    if (!nullToAbsent || checkInBranchJson != null) {
      map['check_in_branch_json'] = Variable<String>(checkInBranchJson);
    }
    if (!nullToAbsent || checkOutBranchJson != null) {
      map['check_out_branch_json'] = Variable<String>(checkOutBranchJson);
    }
    if (!nullToAbsent || shiftJson != null) {
      map['shift_json'] = Variable<String>(shiftJson);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || accuracy != null) {
      map['accuracy'] = Variable<double>(accuracy);
    }
    map['sync_state'] = Variable<String>(syncState);
    map['local_updated_at'] = Variable<DateTime>(localUpdatedAt);
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt);
    }
    return map;
  }

  AttendanceTableCompanion toCompanion(bool nullToAbsent) {
    return AttendanceTableCompanion(
      localId: Value(localId),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      tenantId: Value(tenantId),
      userId: Value(userId),
      date: Value(date),
      clockIn: clockIn == null && nullToAbsent
          ? const Value.absent()
          : Value(clockIn),
      clockOut: clockOut == null && nullToAbsent
          ? const Value.absent()
          : Value(clockOut),
      status: Value(status),
      calculatedStatus: calculatedStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(calculatedStatus),
      isLate: Value(isLate),
      isEarly: Value(isEarly),
      totalHours: Value(totalHours),
      totalHoursNumeric: Value(totalHoursNumeric),
      breakHours: breakHours == null && nullToAbsent
          ? const Value.absent()
          : Value(breakHours),
      breakHoursNumeric: Value(breakHoursNumeric),
      overtimeHours: overtimeHours == null && nullToAbsent
          ? const Value.absent()
          : Value(overtimeHours),
      overtimeHoursNumeric: Value(overtimeHoursNumeric),
      overtimeAmount: Value(overtimeAmount),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      checkInLocationJson: checkInLocationJson == null && nullToAbsent
          ? const Value.absent()
          : Value(checkInLocationJson),
      checkOutLocationJson: checkOutLocationJson == null && nullToAbsent
          ? const Value.absent()
          : Value(checkOutLocationJson),
      checkInBranchJson: checkInBranchJson == null && nullToAbsent
          ? const Value.absent()
          : Value(checkInBranchJson),
      checkOutBranchJson: checkOutBranchJson == null && nullToAbsent
          ? const Value.absent()
          : Value(checkOutBranchJson),
      shiftJson: shiftJson == null && nullToAbsent
          ? const Value.absent()
          : Value(shiftJson),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      accuracy: accuracy == null && nullToAbsent
          ? const Value.absent()
          : Value(accuracy),
      syncState: Value(syncState),
      localUpdatedAt: Value(localUpdatedAt),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
    );
  }

  factory AttendanceTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttendanceTableData(
      localId: serializer.fromJson<String>(json['localId']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      tenantId: serializer.fromJson<int>(json['tenantId']),
      userId: serializer.fromJson<int>(json['userId']),
      date: serializer.fromJson<String>(json['date']),
      clockIn: serializer.fromJson<String?>(json['clockIn']),
      clockOut: serializer.fromJson<String?>(json['clockOut']),
      status: serializer.fromJson<String>(json['status']),
      calculatedStatus: serializer.fromJson<String?>(json['calculatedStatus']),
      isLate: serializer.fromJson<bool>(json['isLate']),
      isEarly: serializer.fromJson<bool>(json['isEarly']),
      totalHours: serializer.fromJson<String>(json['totalHours']),
      totalHoursNumeric: serializer.fromJson<double>(json['totalHoursNumeric']),
      breakHours: serializer.fromJson<String?>(json['breakHours']),
      breakHoursNumeric: serializer.fromJson<double>(json['breakHoursNumeric']),
      overtimeHours: serializer.fromJson<String?>(json['overtimeHours']),
      overtimeHoursNumeric:
          serializer.fromJson<double>(json['overtimeHoursNumeric']),
      overtimeAmount: serializer.fromJson<double>(json['overtimeAmount']),
      notes: serializer.fromJson<String?>(json['notes']),
      checkInLocationJson:
          serializer.fromJson<String?>(json['checkInLocationJson']),
      checkOutLocationJson:
          serializer.fromJson<String?>(json['checkOutLocationJson']),
      checkInBranchJson:
          serializer.fromJson<String?>(json['checkInBranchJson']),
      checkOutBranchJson:
          serializer.fromJson<String?>(json['checkOutBranchJson']),
      shiftJson: serializer.fromJson<String?>(json['shiftJson']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      accuracy: serializer.fromJson<double?>(json['accuracy']),
      syncState: serializer.fromJson<String>(json['syncState']),
      localUpdatedAt: serializer.fromJson<DateTime>(json['localUpdatedAt']),
      serverUpdatedAt: serializer.fromJson<DateTime?>(json['serverUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'serverId': serializer.toJson<int?>(serverId),
      'tenantId': serializer.toJson<int>(tenantId),
      'userId': serializer.toJson<int>(userId),
      'date': serializer.toJson<String>(date),
      'clockIn': serializer.toJson<String?>(clockIn),
      'clockOut': serializer.toJson<String?>(clockOut),
      'status': serializer.toJson<String>(status),
      'calculatedStatus': serializer.toJson<String?>(calculatedStatus),
      'isLate': serializer.toJson<bool>(isLate),
      'isEarly': serializer.toJson<bool>(isEarly),
      'totalHours': serializer.toJson<String>(totalHours),
      'totalHoursNumeric': serializer.toJson<double>(totalHoursNumeric),
      'breakHours': serializer.toJson<String?>(breakHours),
      'breakHoursNumeric': serializer.toJson<double>(breakHoursNumeric),
      'overtimeHours': serializer.toJson<String?>(overtimeHours),
      'overtimeHoursNumeric': serializer.toJson<double>(overtimeHoursNumeric),
      'overtimeAmount': serializer.toJson<double>(overtimeAmount),
      'notes': serializer.toJson<String?>(notes),
      'checkInLocationJson': serializer.toJson<String?>(checkInLocationJson),
      'checkOutLocationJson': serializer.toJson<String?>(checkOutLocationJson),
      'checkInBranchJson': serializer.toJson<String?>(checkInBranchJson),
      'checkOutBranchJson': serializer.toJson<String?>(checkOutBranchJson),
      'shiftJson': serializer.toJson<String?>(shiftJson),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'accuracy': serializer.toJson<double?>(accuracy),
      'syncState': serializer.toJson<String>(syncState),
      'localUpdatedAt': serializer.toJson<DateTime>(localUpdatedAt),
      'serverUpdatedAt': serializer.toJson<DateTime?>(serverUpdatedAt),
    };
  }

  AttendanceTableData copyWith(
          {String? localId,
          Value<int?> serverId = const Value.absent(),
          int? tenantId,
          int? userId,
          String? date,
          Value<String?> clockIn = const Value.absent(),
          Value<String?> clockOut = const Value.absent(),
          String? status,
          Value<String?> calculatedStatus = const Value.absent(),
          bool? isLate,
          bool? isEarly,
          String? totalHours,
          double? totalHoursNumeric,
          Value<String?> breakHours = const Value.absent(),
          double? breakHoursNumeric,
          Value<String?> overtimeHours = const Value.absent(),
          double? overtimeHoursNumeric,
          double? overtimeAmount,
          Value<String?> notes = const Value.absent(),
          Value<String?> checkInLocationJson = const Value.absent(),
          Value<String?> checkOutLocationJson = const Value.absent(),
          Value<String?> checkInBranchJson = const Value.absent(),
          Value<String?> checkOutBranchJson = const Value.absent(),
          Value<String?> shiftJson = const Value.absent(),
          Value<double?> latitude = const Value.absent(),
          Value<double?> longitude = const Value.absent(),
          Value<double?> accuracy = const Value.absent(),
          String? syncState,
          DateTime? localUpdatedAt,
          Value<DateTime?> serverUpdatedAt = const Value.absent()}) =>
      AttendanceTableData(
        localId: localId ?? this.localId,
        serverId: serverId.present ? serverId.value : this.serverId,
        tenantId: tenantId ?? this.tenantId,
        userId: userId ?? this.userId,
        date: date ?? this.date,
        clockIn: clockIn.present ? clockIn.value : this.clockIn,
        clockOut: clockOut.present ? clockOut.value : this.clockOut,
        status: status ?? this.status,
        calculatedStatus: calculatedStatus.present
            ? calculatedStatus.value
            : this.calculatedStatus,
        isLate: isLate ?? this.isLate,
        isEarly: isEarly ?? this.isEarly,
        totalHours: totalHours ?? this.totalHours,
        totalHoursNumeric: totalHoursNumeric ?? this.totalHoursNumeric,
        breakHours: breakHours.present ? breakHours.value : this.breakHours,
        breakHoursNumeric: breakHoursNumeric ?? this.breakHoursNumeric,
        overtimeHours:
            overtimeHours.present ? overtimeHours.value : this.overtimeHours,
        overtimeHoursNumeric: overtimeHoursNumeric ?? this.overtimeHoursNumeric,
        overtimeAmount: overtimeAmount ?? this.overtimeAmount,
        notes: notes.present ? notes.value : this.notes,
        checkInLocationJson: checkInLocationJson.present
            ? checkInLocationJson.value
            : this.checkInLocationJson,
        checkOutLocationJson: checkOutLocationJson.present
            ? checkOutLocationJson.value
            : this.checkOutLocationJson,
        checkInBranchJson: checkInBranchJson.present
            ? checkInBranchJson.value
            : this.checkInBranchJson,
        checkOutBranchJson: checkOutBranchJson.present
            ? checkOutBranchJson.value
            : this.checkOutBranchJson,
        shiftJson: shiftJson.present ? shiftJson.value : this.shiftJson,
        latitude: latitude.present ? latitude.value : this.latitude,
        longitude: longitude.present ? longitude.value : this.longitude,
        accuracy: accuracy.present ? accuracy.value : this.accuracy,
        syncState: syncState ?? this.syncState,
        localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
        serverUpdatedAt: serverUpdatedAt.present
            ? serverUpdatedAt.value
            : this.serverUpdatedAt,
      );
  AttendanceTableData copyWithCompanion(AttendanceTableCompanion data) {
    return AttendanceTableData(
      localId: data.localId.present ? data.localId.value : this.localId,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      userId: data.userId.present ? data.userId.value : this.userId,
      date: data.date.present ? data.date.value : this.date,
      clockIn: data.clockIn.present ? data.clockIn.value : this.clockIn,
      clockOut: data.clockOut.present ? data.clockOut.value : this.clockOut,
      status: data.status.present ? data.status.value : this.status,
      calculatedStatus: data.calculatedStatus.present
          ? data.calculatedStatus.value
          : this.calculatedStatus,
      isLate: data.isLate.present ? data.isLate.value : this.isLate,
      isEarly: data.isEarly.present ? data.isEarly.value : this.isEarly,
      totalHours:
          data.totalHours.present ? data.totalHours.value : this.totalHours,
      totalHoursNumeric: data.totalHoursNumeric.present
          ? data.totalHoursNumeric.value
          : this.totalHoursNumeric,
      breakHours:
          data.breakHours.present ? data.breakHours.value : this.breakHours,
      breakHoursNumeric: data.breakHoursNumeric.present
          ? data.breakHoursNumeric.value
          : this.breakHoursNumeric,
      overtimeHours: data.overtimeHours.present
          ? data.overtimeHours.value
          : this.overtimeHours,
      overtimeHoursNumeric: data.overtimeHoursNumeric.present
          ? data.overtimeHoursNumeric.value
          : this.overtimeHoursNumeric,
      overtimeAmount: data.overtimeAmount.present
          ? data.overtimeAmount.value
          : this.overtimeAmount,
      notes: data.notes.present ? data.notes.value : this.notes,
      checkInLocationJson: data.checkInLocationJson.present
          ? data.checkInLocationJson.value
          : this.checkInLocationJson,
      checkOutLocationJson: data.checkOutLocationJson.present
          ? data.checkOutLocationJson.value
          : this.checkOutLocationJson,
      checkInBranchJson: data.checkInBranchJson.present
          ? data.checkInBranchJson.value
          : this.checkInBranchJson,
      checkOutBranchJson: data.checkOutBranchJson.present
          ? data.checkOutBranchJson.value
          : this.checkOutBranchJson,
      shiftJson: data.shiftJson.present ? data.shiftJson.value : this.shiftJson,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      accuracy: data.accuracy.present ? data.accuracy.value : this.accuracy,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      localUpdatedAt: data.localUpdatedAt.present
          ? data.localUpdatedAt.value
          : this.localUpdatedAt,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceTableData(')
          ..write('localId: $localId, ')
          ..write('serverId: $serverId, ')
          ..write('tenantId: $tenantId, ')
          ..write('userId: $userId, ')
          ..write('date: $date, ')
          ..write('clockIn: $clockIn, ')
          ..write('clockOut: $clockOut, ')
          ..write('status: $status, ')
          ..write('calculatedStatus: $calculatedStatus, ')
          ..write('isLate: $isLate, ')
          ..write('isEarly: $isEarly, ')
          ..write('totalHours: $totalHours, ')
          ..write('totalHoursNumeric: $totalHoursNumeric, ')
          ..write('breakHours: $breakHours, ')
          ..write('breakHoursNumeric: $breakHoursNumeric, ')
          ..write('overtimeHours: $overtimeHours, ')
          ..write('overtimeHoursNumeric: $overtimeHoursNumeric, ')
          ..write('overtimeAmount: $overtimeAmount, ')
          ..write('notes: $notes, ')
          ..write('checkInLocationJson: $checkInLocationJson, ')
          ..write('checkOutLocationJson: $checkOutLocationJson, ')
          ..write('checkInBranchJson: $checkInBranchJson, ')
          ..write('checkOutBranchJson: $checkOutBranchJson, ')
          ..write('shiftJson: $shiftJson, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('accuracy: $accuracy, ')
          ..write('syncState: $syncState, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('serverUpdatedAt: $serverUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        localId,
        serverId,
        tenantId,
        userId,
        date,
        clockIn,
        clockOut,
        status,
        calculatedStatus,
        isLate,
        isEarly,
        totalHours,
        totalHoursNumeric,
        breakHours,
        breakHoursNumeric,
        overtimeHours,
        overtimeHoursNumeric,
        overtimeAmount,
        notes,
        checkInLocationJson,
        checkOutLocationJson,
        checkInBranchJson,
        checkOutBranchJson,
        shiftJson,
        latitude,
        longitude,
        accuracy,
        syncState,
        localUpdatedAt,
        serverUpdatedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttendanceTableData &&
          other.localId == this.localId &&
          other.serverId == this.serverId &&
          other.tenantId == this.tenantId &&
          other.userId == this.userId &&
          other.date == this.date &&
          other.clockIn == this.clockIn &&
          other.clockOut == this.clockOut &&
          other.status == this.status &&
          other.calculatedStatus == this.calculatedStatus &&
          other.isLate == this.isLate &&
          other.isEarly == this.isEarly &&
          other.totalHours == this.totalHours &&
          other.totalHoursNumeric == this.totalHoursNumeric &&
          other.breakHours == this.breakHours &&
          other.breakHoursNumeric == this.breakHoursNumeric &&
          other.overtimeHours == this.overtimeHours &&
          other.overtimeHoursNumeric == this.overtimeHoursNumeric &&
          other.overtimeAmount == this.overtimeAmount &&
          other.notes == this.notes &&
          other.checkInLocationJson == this.checkInLocationJson &&
          other.checkOutLocationJson == this.checkOutLocationJson &&
          other.checkInBranchJson == this.checkInBranchJson &&
          other.checkOutBranchJson == this.checkOutBranchJson &&
          other.shiftJson == this.shiftJson &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.accuracy == this.accuracy &&
          other.syncState == this.syncState &&
          other.localUpdatedAt == this.localUpdatedAt &&
          other.serverUpdatedAt == this.serverUpdatedAt);
}

class AttendanceTableCompanion extends UpdateCompanion<AttendanceTableData> {
  final Value<String> localId;
  final Value<int?> serverId;
  final Value<int> tenantId;
  final Value<int> userId;
  final Value<String> date;
  final Value<String?> clockIn;
  final Value<String?> clockOut;
  final Value<String> status;
  final Value<String?> calculatedStatus;
  final Value<bool> isLate;
  final Value<bool> isEarly;
  final Value<String> totalHours;
  final Value<double> totalHoursNumeric;
  final Value<String?> breakHours;
  final Value<double> breakHoursNumeric;
  final Value<String?> overtimeHours;
  final Value<double> overtimeHoursNumeric;
  final Value<double> overtimeAmount;
  final Value<String?> notes;
  final Value<String?> checkInLocationJson;
  final Value<String?> checkOutLocationJson;
  final Value<String?> checkInBranchJson;
  final Value<String?> checkOutBranchJson;
  final Value<String?> shiftJson;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<double?> accuracy;
  final Value<String> syncState;
  final Value<DateTime> localUpdatedAt;
  final Value<DateTime?> serverUpdatedAt;
  final Value<int> rowid;
  const AttendanceTableCompanion({
    this.localId = const Value.absent(),
    this.serverId = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.userId = const Value.absent(),
    this.date = const Value.absent(),
    this.clockIn = const Value.absent(),
    this.clockOut = const Value.absent(),
    this.status = const Value.absent(),
    this.calculatedStatus = const Value.absent(),
    this.isLate = const Value.absent(),
    this.isEarly = const Value.absent(),
    this.totalHours = const Value.absent(),
    this.totalHoursNumeric = const Value.absent(),
    this.breakHours = const Value.absent(),
    this.breakHoursNumeric = const Value.absent(),
    this.overtimeHours = const Value.absent(),
    this.overtimeHoursNumeric = const Value.absent(),
    this.overtimeAmount = const Value.absent(),
    this.notes = const Value.absent(),
    this.checkInLocationJson = const Value.absent(),
    this.checkOutLocationJson = const Value.absent(),
    this.checkInBranchJson = const Value.absent(),
    this.checkOutBranchJson = const Value.absent(),
    this.shiftJson = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.accuracy = const Value.absent(),
    this.syncState = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttendanceTableCompanion.insert({
    required String localId,
    this.serverId = const Value.absent(),
    required int tenantId,
    required int userId,
    required String date,
    this.clockIn = const Value.absent(),
    this.clockOut = const Value.absent(),
    this.status = const Value.absent(),
    this.calculatedStatus = const Value.absent(),
    this.isLate = const Value.absent(),
    this.isEarly = const Value.absent(),
    this.totalHours = const Value.absent(),
    this.totalHoursNumeric = const Value.absent(),
    this.breakHours = const Value.absent(),
    this.breakHoursNumeric = const Value.absent(),
    this.overtimeHours = const Value.absent(),
    this.overtimeHoursNumeric = const Value.absent(),
    this.overtimeAmount = const Value.absent(),
    this.notes = const Value.absent(),
    this.checkInLocationJson = const Value.absent(),
    this.checkOutLocationJson = const Value.absent(),
    this.checkInBranchJson = const Value.absent(),
    this.checkOutBranchJson = const Value.absent(),
    this.shiftJson = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.accuracy = const Value.absent(),
    this.syncState = const Value.absent(),
    required DateTime localUpdatedAt,
    this.serverUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : localId = Value(localId),
        tenantId = Value(tenantId),
        userId = Value(userId),
        date = Value(date),
        localUpdatedAt = Value(localUpdatedAt);
  static Insertable<AttendanceTableData> custom({
    Expression<String>? localId,
    Expression<int>? serverId,
    Expression<int>? tenantId,
    Expression<int>? userId,
    Expression<String>? date,
    Expression<String>? clockIn,
    Expression<String>? clockOut,
    Expression<String>? status,
    Expression<String>? calculatedStatus,
    Expression<bool>? isLate,
    Expression<bool>? isEarly,
    Expression<String>? totalHours,
    Expression<double>? totalHoursNumeric,
    Expression<String>? breakHours,
    Expression<double>? breakHoursNumeric,
    Expression<String>? overtimeHours,
    Expression<double>? overtimeHoursNumeric,
    Expression<double>? overtimeAmount,
    Expression<String>? notes,
    Expression<String>? checkInLocationJson,
    Expression<String>? checkOutLocationJson,
    Expression<String>? checkInBranchJson,
    Expression<String>? checkOutBranchJson,
    Expression<String>? shiftJson,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? accuracy,
    Expression<String>? syncState,
    Expression<DateTime>? localUpdatedAt,
    Expression<DateTime>? serverUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (serverId != null) 'server_id': serverId,
      if (tenantId != null) 'tenant_id': tenantId,
      if (userId != null) 'user_id': userId,
      if (date != null) 'date': date,
      if (clockIn != null) 'clock_in': clockIn,
      if (clockOut != null) 'clock_out': clockOut,
      if (status != null) 'status': status,
      if (calculatedStatus != null) 'calculated_status': calculatedStatus,
      if (isLate != null) 'is_late': isLate,
      if (isEarly != null) 'is_early': isEarly,
      if (totalHours != null) 'total_hours': totalHours,
      if (totalHoursNumeric != null) 'total_hours_numeric': totalHoursNumeric,
      if (breakHours != null) 'break_hours': breakHours,
      if (breakHoursNumeric != null) 'break_hours_numeric': breakHoursNumeric,
      if (overtimeHours != null) 'overtime_hours': overtimeHours,
      if (overtimeHoursNumeric != null)
        'overtime_hours_numeric': overtimeHoursNumeric,
      if (overtimeAmount != null) 'overtime_amount': overtimeAmount,
      if (notes != null) 'notes': notes,
      if (checkInLocationJson != null)
        'check_in_location_json': checkInLocationJson,
      if (checkOutLocationJson != null)
        'check_out_location_json': checkOutLocationJson,
      if (checkInBranchJson != null) 'check_in_branch_json': checkInBranchJson,
      if (checkOutBranchJson != null)
        'check_out_branch_json': checkOutBranchJson,
      if (shiftJson != null) 'shift_json': shiftJson,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (accuracy != null) 'accuracy': accuracy,
      if (syncState != null) 'sync_state': syncState,
      if (localUpdatedAt != null) 'local_updated_at': localUpdatedAt,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttendanceTableCompanion copyWith(
      {Value<String>? localId,
      Value<int?>? serverId,
      Value<int>? tenantId,
      Value<int>? userId,
      Value<String>? date,
      Value<String?>? clockIn,
      Value<String?>? clockOut,
      Value<String>? status,
      Value<String?>? calculatedStatus,
      Value<bool>? isLate,
      Value<bool>? isEarly,
      Value<String>? totalHours,
      Value<double>? totalHoursNumeric,
      Value<String?>? breakHours,
      Value<double>? breakHoursNumeric,
      Value<String?>? overtimeHours,
      Value<double>? overtimeHoursNumeric,
      Value<double>? overtimeAmount,
      Value<String?>? notes,
      Value<String?>? checkInLocationJson,
      Value<String?>? checkOutLocationJson,
      Value<String?>? checkInBranchJson,
      Value<String?>? checkOutBranchJson,
      Value<String?>? shiftJson,
      Value<double?>? latitude,
      Value<double?>? longitude,
      Value<double?>? accuracy,
      Value<String>? syncState,
      Value<DateTime>? localUpdatedAt,
      Value<DateTime?>? serverUpdatedAt,
      Value<int>? rowid}) {
    return AttendanceTableCompanion(
      localId: localId ?? this.localId,
      serverId: serverId ?? this.serverId,
      tenantId: tenantId ?? this.tenantId,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      clockIn: clockIn ?? this.clockIn,
      clockOut: clockOut ?? this.clockOut,
      status: status ?? this.status,
      calculatedStatus: calculatedStatus ?? this.calculatedStatus,
      isLate: isLate ?? this.isLate,
      isEarly: isEarly ?? this.isEarly,
      totalHours: totalHours ?? this.totalHours,
      totalHoursNumeric: totalHoursNumeric ?? this.totalHoursNumeric,
      breakHours: breakHours ?? this.breakHours,
      breakHoursNumeric: breakHoursNumeric ?? this.breakHoursNumeric,
      overtimeHours: overtimeHours ?? this.overtimeHours,
      overtimeHoursNumeric: overtimeHoursNumeric ?? this.overtimeHoursNumeric,
      overtimeAmount: overtimeAmount ?? this.overtimeAmount,
      notes: notes ?? this.notes,
      checkInLocationJson: checkInLocationJson ?? this.checkInLocationJson,
      checkOutLocationJson: checkOutLocationJson ?? this.checkOutLocationJson,
      checkInBranchJson: checkInBranchJson ?? this.checkInBranchJson,
      checkOutBranchJson: checkOutBranchJson ?? this.checkOutBranchJson,
      shiftJson: shiftJson ?? this.shiftJson,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracy: accuracy ?? this.accuracy,
      syncState: syncState ?? this.syncState,
      localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<int>(tenantId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (clockIn.present) {
      map['clock_in'] = Variable<String>(clockIn.value);
    }
    if (clockOut.present) {
      map['clock_out'] = Variable<String>(clockOut.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (calculatedStatus.present) {
      map['calculated_status'] = Variable<String>(calculatedStatus.value);
    }
    if (isLate.present) {
      map['is_late'] = Variable<bool>(isLate.value);
    }
    if (isEarly.present) {
      map['is_early'] = Variable<bool>(isEarly.value);
    }
    if (totalHours.present) {
      map['total_hours'] = Variable<String>(totalHours.value);
    }
    if (totalHoursNumeric.present) {
      map['total_hours_numeric'] = Variable<double>(totalHoursNumeric.value);
    }
    if (breakHours.present) {
      map['break_hours'] = Variable<String>(breakHours.value);
    }
    if (breakHoursNumeric.present) {
      map['break_hours_numeric'] = Variable<double>(breakHoursNumeric.value);
    }
    if (overtimeHours.present) {
      map['overtime_hours'] = Variable<String>(overtimeHours.value);
    }
    if (overtimeHoursNumeric.present) {
      map['overtime_hours_numeric'] =
          Variable<double>(overtimeHoursNumeric.value);
    }
    if (overtimeAmount.present) {
      map['overtime_amount'] = Variable<double>(overtimeAmount.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (checkInLocationJson.present) {
      map['check_in_location_json'] =
          Variable<String>(checkInLocationJson.value);
    }
    if (checkOutLocationJson.present) {
      map['check_out_location_json'] =
          Variable<String>(checkOutLocationJson.value);
    }
    if (checkInBranchJson.present) {
      map['check_in_branch_json'] = Variable<String>(checkInBranchJson.value);
    }
    if (checkOutBranchJson.present) {
      map['check_out_branch_json'] = Variable<String>(checkOutBranchJson.value);
    }
    if (shiftJson.present) {
      map['shift_json'] = Variable<String>(shiftJson.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (accuracy.present) {
      map['accuracy'] = Variable<double>(accuracy.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(syncState.value);
    }
    if (localUpdatedAt.present) {
      map['local_updated_at'] = Variable<DateTime>(localUpdatedAt.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<DateTime>(serverUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceTableCompanion(')
          ..write('localId: $localId, ')
          ..write('serverId: $serverId, ')
          ..write('tenantId: $tenantId, ')
          ..write('userId: $userId, ')
          ..write('date: $date, ')
          ..write('clockIn: $clockIn, ')
          ..write('clockOut: $clockOut, ')
          ..write('status: $status, ')
          ..write('calculatedStatus: $calculatedStatus, ')
          ..write('isLate: $isLate, ')
          ..write('isEarly: $isEarly, ')
          ..write('totalHours: $totalHours, ')
          ..write('totalHoursNumeric: $totalHoursNumeric, ')
          ..write('breakHours: $breakHours, ')
          ..write('breakHoursNumeric: $breakHoursNumeric, ')
          ..write('overtimeHours: $overtimeHours, ')
          ..write('overtimeHoursNumeric: $overtimeHoursNumeric, ')
          ..write('overtimeAmount: $overtimeAmount, ')
          ..write('notes: $notes, ')
          ..write('checkInLocationJson: $checkInLocationJson, ')
          ..write('checkOutLocationJson: $checkOutLocationJson, ')
          ..write('checkInBranchJson: $checkInBranchJson, ')
          ..write('checkOutBranchJson: $checkOutBranchJson, ')
          ..write('shiftJson: $shiftJson, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('accuracy: $accuracy, ')
          ..write('syncState: $syncState, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TodayAttendanceTableTable extends TodayAttendanceTable
    with TableInfo<$TodayAttendanceTableTable, TodayAttendanceTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodayAttendanceTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<int> tenantId = GeneratedColumn<int>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isClockedInMeta =
      const VerificationMeta('isClockedIn');
  @override
  late final GeneratedColumn<bool> isClockedIn = GeneratedColumn<bool>(
      'is_clocked_in', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_clocked_in" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _canClockInMeta =
      const VerificationMeta('canClockIn');
  @override
  late final GeneratedColumn<bool> canClockIn = GeneratedColumn<bool>(
      'can_clock_in', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("can_clock_in" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _canClockOutMeta =
      const VerificationMeta('canClockOut');
  @override
  late final GeneratedColumn<bool> canClockOut = GeneratedColumn<bool>(
      'can_clock_out', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("can_clock_out" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _attendanceIdMeta =
      const VerificationMeta('attendanceId');
  @override
  late final GeneratedColumn<int> attendanceId = GeneratedColumn<int>(
      'attendance_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _clockInMeta =
      const VerificationMeta('clockIn');
  @override
  late final GeneratedColumn<String> clockIn = GeneratedColumn<String>(
      'clock_in', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _clockOutMeta =
      const VerificationMeta('clockOut');
  @override
  late final GeneratedColumn<String> clockOut = GeneratedColumn<String>(
      'clock_out', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _totalHoursMeta =
      const VerificationMeta('totalHours');
  @override
  late final GeneratedColumn<String> totalHours = GeneratedColumn<String>(
      'total_hours', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('0.00 hours'));
  static const VerificationMeta _totalHoursNumericMeta =
      const VerificationMeta('totalHoursNumeric');
  @override
  late final GeneratedColumn<double> totalHoursNumeric =
      GeneratedColumn<double>('total_hours_numeric', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0.0));
  static const VerificationMeta _breakHoursMeta =
      const VerificationMeta('breakHours');
  @override
  late final GeneratedColumn<String> breakHours = GeneratedColumn<String>(
      'break_hours', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _overtimeHoursMeta =
      const VerificationMeta('overtimeHours');
  @override
  late final GeneratedColumn<String> overtimeHours = GeneratedColumn<String>(
      'overtime_hours', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('present'));
  static const VerificationMeta _isWorkingDayMeta =
      const VerificationMeta('isWorkingDay');
  @override
  late final GeneratedColumn<bool> isWorkingDay = GeneratedColumn<bool>(
      'is_working_day', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_working_day" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isHolidayMeta =
      const VerificationMeta('isHoliday');
  @override
  late final GeneratedColumn<bool> isHoliday = GeneratedColumn<bool>(
      'is_holiday', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_holiday" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _holidayNameMeta =
      const VerificationMeta('holidayName');
  @override
  late final GeneratedColumn<String> holidayName = GeneratedColumn<String>(
      'holiday_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isOnLeaveMeta =
      const VerificationMeta('isOnLeave');
  @override
  late final GeneratedColumn<bool> isOnLeave = GeneratedColumn<bool>(
      'is_on_leave', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_on_leave" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isHalfDayLeaveMeta =
      const VerificationMeta('isHalfDayLeave');
  @override
  late final GeneratedColumn<bool> isHalfDayLeave = GeneratedColumn<bool>(
      'is_half_day_leave', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_half_day_leave" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _leaveTitleMeta =
      const VerificationMeta('leaveTitle');
  @override
  late final GeneratedColumn<String> leaveTitle = GeneratedColumn<String>(
      'leave_title', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _checkInLocationJsonMeta =
      const VerificationMeta('checkInLocationJson');
  @override
  late final GeneratedColumn<String> checkInLocationJson =
      GeneratedColumn<String>('check_in_location_json', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _checkInBranchJsonMeta =
      const VerificationMeta('checkInBranchJson');
  @override
  late final GeneratedColumn<String> checkInBranchJson =
      GeneratedColumn<String>('check_in_branch_json', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _shiftJsonMeta =
      const VerificationMeta('shiftJson');
  @override
  late final GeneratedColumn<String> shiftJson = GeneratedColumn<String>(
      'shift_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _workingDaysMapJsonMeta =
      const VerificationMeta('workingDaysMapJson');
  @override
  late final GeneratedColumn<String> workingDaysMapJson =
      GeneratedColumn<String>('working_days_map_json', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fetchedAtMeta =
      const VerificationMeta('fetchedAt');
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
      'fetched_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        tenantId,
        userId,
        date,
        isClockedIn,
        canClockIn,
        canClockOut,
        attendanceId,
        clockIn,
        clockOut,
        totalHours,
        totalHoursNumeric,
        breakHours,
        overtimeHours,
        status,
        isWorkingDay,
        isHoliday,
        holidayName,
        isOnLeave,
        isHalfDayLeave,
        leaveTitle,
        checkInLocationJson,
        checkInBranchJson,
        shiftJson,
        workingDaysMapJson,
        fetchedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'today_attendance_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<TodayAttendanceTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('is_clocked_in')) {
      context.handle(
          _isClockedInMeta,
          isClockedIn.isAcceptableOrUnknown(
              data['is_clocked_in']!, _isClockedInMeta));
    }
    if (data.containsKey('can_clock_in')) {
      context.handle(
          _canClockInMeta,
          canClockIn.isAcceptableOrUnknown(
              data['can_clock_in']!, _canClockInMeta));
    }
    if (data.containsKey('can_clock_out')) {
      context.handle(
          _canClockOutMeta,
          canClockOut.isAcceptableOrUnknown(
              data['can_clock_out']!, _canClockOutMeta));
    }
    if (data.containsKey('attendance_id')) {
      context.handle(
          _attendanceIdMeta,
          attendanceId.isAcceptableOrUnknown(
              data['attendance_id']!, _attendanceIdMeta));
    }
    if (data.containsKey('clock_in')) {
      context.handle(_clockInMeta,
          clockIn.isAcceptableOrUnknown(data['clock_in']!, _clockInMeta));
    }
    if (data.containsKey('clock_out')) {
      context.handle(_clockOutMeta,
          clockOut.isAcceptableOrUnknown(data['clock_out']!, _clockOutMeta));
    }
    if (data.containsKey('total_hours')) {
      context.handle(
          _totalHoursMeta,
          totalHours.isAcceptableOrUnknown(
              data['total_hours']!, _totalHoursMeta));
    }
    if (data.containsKey('total_hours_numeric')) {
      context.handle(
          _totalHoursNumericMeta,
          totalHoursNumeric.isAcceptableOrUnknown(
              data['total_hours_numeric']!, _totalHoursNumericMeta));
    }
    if (data.containsKey('break_hours')) {
      context.handle(
          _breakHoursMeta,
          breakHours.isAcceptableOrUnknown(
              data['break_hours']!, _breakHoursMeta));
    }
    if (data.containsKey('overtime_hours')) {
      context.handle(
          _overtimeHoursMeta,
          overtimeHours.isAcceptableOrUnknown(
              data['overtime_hours']!, _overtimeHoursMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('is_working_day')) {
      context.handle(
          _isWorkingDayMeta,
          isWorkingDay.isAcceptableOrUnknown(
              data['is_working_day']!, _isWorkingDayMeta));
    }
    if (data.containsKey('is_holiday')) {
      context.handle(_isHolidayMeta,
          isHoliday.isAcceptableOrUnknown(data['is_holiday']!, _isHolidayMeta));
    }
    if (data.containsKey('holiday_name')) {
      context.handle(
          _holidayNameMeta,
          holidayName.isAcceptableOrUnknown(
              data['holiday_name']!, _holidayNameMeta));
    }
    if (data.containsKey('is_on_leave')) {
      context.handle(
          _isOnLeaveMeta,
          isOnLeave.isAcceptableOrUnknown(
              data['is_on_leave']!, _isOnLeaveMeta));
    }
    if (data.containsKey('is_half_day_leave')) {
      context.handle(
          _isHalfDayLeaveMeta,
          isHalfDayLeave.isAcceptableOrUnknown(
              data['is_half_day_leave']!, _isHalfDayLeaveMeta));
    }
    if (data.containsKey('leave_title')) {
      context.handle(
          _leaveTitleMeta,
          leaveTitle.isAcceptableOrUnknown(
              data['leave_title']!, _leaveTitleMeta));
    }
    if (data.containsKey('check_in_location_json')) {
      context.handle(
          _checkInLocationJsonMeta,
          checkInLocationJson.isAcceptableOrUnknown(
              data['check_in_location_json']!, _checkInLocationJsonMeta));
    }
    if (data.containsKey('check_in_branch_json')) {
      context.handle(
          _checkInBranchJsonMeta,
          checkInBranchJson.isAcceptableOrUnknown(
              data['check_in_branch_json']!, _checkInBranchJsonMeta));
    }
    if (data.containsKey('shift_json')) {
      context.handle(_shiftJsonMeta,
          shiftJson.isAcceptableOrUnknown(data['shift_json']!, _shiftJsonMeta));
    }
    if (data.containsKey('working_days_map_json')) {
      context.handle(
          _workingDaysMapJsonMeta,
          workingDaysMapJson.isAcceptableOrUnknown(
              data['working_days_map_json']!, _workingDaysMapJsonMeta));
    }
    if (data.containsKey('fetched_at')) {
      context.handle(_fetchedAtMeta,
          fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta));
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tenantId, userId};
  @override
  TodayAttendanceTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TodayAttendanceTableData(
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tenant_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      isClockedIn: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_clocked_in'])!,
      canClockIn: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}can_clock_in'])!,
      canClockOut: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}can_clock_out'])!,
      attendanceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attendance_id']),
      clockIn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}clock_in']),
      clockOut: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}clock_out']),
      totalHours: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}total_hours'])!,
      totalHoursNumeric: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}total_hours_numeric'])!,
      breakHours: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}break_hours']),
      overtimeHours: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}overtime_hours']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      isWorkingDay: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_working_day'])!,
      isHoliday: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_holiday'])!,
      holidayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}holiday_name']),
      isOnLeave: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_on_leave'])!,
      isHalfDayLeave: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}is_half_day_leave'])!,
      leaveTitle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}leave_title']),
      checkInLocationJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}check_in_location_json']),
      checkInBranchJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}check_in_branch_json']),
      shiftJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shift_json']),
      workingDaysMapJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}working_days_map_json']),
      fetchedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fetched_at'])!,
    );
  }

  @override
  $TodayAttendanceTableTable createAlias(String alias) {
    return $TodayAttendanceTableTable(attachedDatabase, alias);
  }
}

class TodayAttendanceTableData extends DataClass
    implements Insertable<TodayAttendanceTableData> {
  final int tenantId;
  final int userId;
  final String date;
  final bool isClockedIn;
  final bool canClockIn;
  final bool canClockOut;
  final int? attendanceId;
  final String? clockIn;
  final String? clockOut;
  final String totalHours;
  final double totalHoursNumeric;
  final String? breakHours;
  final String? overtimeHours;
  final String status;
  final bool isWorkingDay;
  final bool isHoliday;
  final String? holidayName;
  final bool isOnLeave;
  final bool isHalfDayLeave;
  final String? leaveTitle;
  final String? checkInLocationJson;
  final String? checkInBranchJson;
  final String? shiftJson;
  final String? workingDaysMapJson;
  final DateTime fetchedAt;
  const TodayAttendanceTableData(
      {required this.tenantId,
      required this.userId,
      required this.date,
      required this.isClockedIn,
      required this.canClockIn,
      required this.canClockOut,
      this.attendanceId,
      this.clockIn,
      this.clockOut,
      required this.totalHours,
      required this.totalHoursNumeric,
      this.breakHours,
      this.overtimeHours,
      required this.status,
      required this.isWorkingDay,
      required this.isHoliday,
      this.holidayName,
      required this.isOnLeave,
      required this.isHalfDayLeave,
      this.leaveTitle,
      this.checkInLocationJson,
      this.checkInBranchJson,
      this.shiftJson,
      this.workingDaysMapJson,
      required this.fetchedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['tenant_id'] = Variable<int>(tenantId);
    map['user_id'] = Variable<int>(userId);
    map['date'] = Variable<String>(date);
    map['is_clocked_in'] = Variable<bool>(isClockedIn);
    map['can_clock_in'] = Variable<bool>(canClockIn);
    map['can_clock_out'] = Variable<bool>(canClockOut);
    if (!nullToAbsent || attendanceId != null) {
      map['attendance_id'] = Variable<int>(attendanceId);
    }
    if (!nullToAbsent || clockIn != null) {
      map['clock_in'] = Variable<String>(clockIn);
    }
    if (!nullToAbsent || clockOut != null) {
      map['clock_out'] = Variable<String>(clockOut);
    }
    map['total_hours'] = Variable<String>(totalHours);
    map['total_hours_numeric'] = Variable<double>(totalHoursNumeric);
    if (!nullToAbsent || breakHours != null) {
      map['break_hours'] = Variable<String>(breakHours);
    }
    if (!nullToAbsent || overtimeHours != null) {
      map['overtime_hours'] = Variable<String>(overtimeHours);
    }
    map['status'] = Variable<String>(status);
    map['is_working_day'] = Variable<bool>(isWorkingDay);
    map['is_holiday'] = Variable<bool>(isHoliday);
    if (!nullToAbsent || holidayName != null) {
      map['holiday_name'] = Variable<String>(holidayName);
    }
    map['is_on_leave'] = Variable<bool>(isOnLeave);
    map['is_half_day_leave'] = Variable<bool>(isHalfDayLeave);
    if (!nullToAbsent || leaveTitle != null) {
      map['leave_title'] = Variable<String>(leaveTitle);
    }
    if (!nullToAbsent || checkInLocationJson != null) {
      map['check_in_location_json'] = Variable<String>(checkInLocationJson);
    }
    if (!nullToAbsent || checkInBranchJson != null) {
      map['check_in_branch_json'] = Variable<String>(checkInBranchJson);
    }
    if (!nullToAbsent || shiftJson != null) {
      map['shift_json'] = Variable<String>(shiftJson);
    }
    if (!nullToAbsent || workingDaysMapJson != null) {
      map['working_days_map_json'] = Variable<String>(workingDaysMapJson);
    }
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  TodayAttendanceTableCompanion toCompanion(bool nullToAbsent) {
    return TodayAttendanceTableCompanion(
      tenantId: Value(tenantId),
      userId: Value(userId),
      date: Value(date),
      isClockedIn: Value(isClockedIn),
      canClockIn: Value(canClockIn),
      canClockOut: Value(canClockOut),
      attendanceId: attendanceId == null && nullToAbsent
          ? const Value.absent()
          : Value(attendanceId),
      clockIn: clockIn == null && nullToAbsent
          ? const Value.absent()
          : Value(clockIn),
      clockOut: clockOut == null && nullToAbsent
          ? const Value.absent()
          : Value(clockOut),
      totalHours: Value(totalHours),
      totalHoursNumeric: Value(totalHoursNumeric),
      breakHours: breakHours == null && nullToAbsent
          ? const Value.absent()
          : Value(breakHours),
      overtimeHours: overtimeHours == null && nullToAbsent
          ? const Value.absent()
          : Value(overtimeHours),
      status: Value(status),
      isWorkingDay: Value(isWorkingDay),
      isHoliday: Value(isHoliday),
      holidayName: holidayName == null && nullToAbsent
          ? const Value.absent()
          : Value(holidayName),
      isOnLeave: Value(isOnLeave),
      isHalfDayLeave: Value(isHalfDayLeave),
      leaveTitle: leaveTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(leaveTitle),
      checkInLocationJson: checkInLocationJson == null && nullToAbsent
          ? const Value.absent()
          : Value(checkInLocationJson),
      checkInBranchJson: checkInBranchJson == null && nullToAbsent
          ? const Value.absent()
          : Value(checkInBranchJson),
      shiftJson: shiftJson == null && nullToAbsent
          ? const Value.absent()
          : Value(shiftJson),
      workingDaysMapJson: workingDaysMapJson == null && nullToAbsent
          ? const Value.absent()
          : Value(workingDaysMapJson),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory TodayAttendanceTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TodayAttendanceTableData(
      tenantId: serializer.fromJson<int>(json['tenantId']),
      userId: serializer.fromJson<int>(json['userId']),
      date: serializer.fromJson<String>(json['date']),
      isClockedIn: serializer.fromJson<bool>(json['isClockedIn']),
      canClockIn: serializer.fromJson<bool>(json['canClockIn']),
      canClockOut: serializer.fromJson<bool>(json['canClockOut']),
      attendanceId: serializer.fromJson<int?>(json['attendanceId']),
      clockIn: serializer.fromJson<String?>(json['clockIn']),
      clockOut: serializer.fromJson<String?>(json['clockOut']),
      totalHours: serializer.fromJson<String>(json['totalHours']),
      totalHoursNumeric: serializer.fromJson<double>(json['totalHoursNumeric']),
      breakHours: serializer.fromJson<String?>(json['breakHours']),
      overtimeHours: serializer.fromJson<String?>(json['overtimeHours']),
      status: serializer.fromJson<String>(json['status']),
      isWorkingDay: serializer.fromJson<bool>(json['isWorkingDay']),
      isHoliday: serializer.fromJson<bool>(json['isHoliday']),
      holidayName: serializer.fromJson<String?>(json['holidayName']),
      isOnLeave: serializer.fromJson<bool>(json['isOnLeave']),
      isHalfDayLeave: serializer.fromJson<bool>(json['isHalfDayLeave']),
      leaveTitle: serializer.fromJson<String?>(json['leaveTitle']),
      checkInLocationJson:
          serializer.fromJson<String?>(json['checkInLocationJson']),
      checkInBranchJson:
          serializer.fromJson<String?>(json['checkInBranchJson']),
      shiftJson: serializer.fromJson<String?>(json['shiftJson']),
      workingDaysMapJson:
          serializer.fromJson<String?>(json['workingDaysMapJson']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tenantId': serializer.toJson<int>(tenantId),
      'userId': serializer.toJson<int>(userId),
      'date': serializer.toJson<String>(date),
      'isClockedIn': serializer.toJson<bool>(isClockedIn),
      'canClockIn': serializer.toJson<bool>(canClockIn),
      'canClockOut': serializer.toJson<bool>(canClockOut),
      'attendanceId': serializer.toJson<int?>(attendanceId),
      'clockIn': serializer.toJson<String?>(clockIn),
      'clockOut': serializer.toJson<String?>(clockOut),
      'totalHours': serializer.toJson<String>(totalHours),
      'totalHoursNumeric': serializer.toJson<double>(totalHoursNumeric),
      'breakHours': serializer.toJson<String?>(breakHours),
      'overtimeHours': serializer.toJson<String?>(overtimeHours),
      'status': serializer.toJson<String>(status),
      'isWorkingDay': serializer.toJson<bool>(isWorkingDay),
      'isHoliday': serializer.toJson<bool>(isHoliday),
      'holidayName': serializer.toJson<String?>(holidayName),
      'isOnLeave': serializer.toJson<bool>(isOnLeave),
      'isHalfDayLeave': serializer.toJson<bool>(isHalfDayLeave),
      'leaveTitle': serializer.toJson<String?>(leaveTitle),
      'checkInLocationJson': serializer.toJson<String?>(checkInLocationJson),
      'checkInBranchJson': serializer.toJson<String?>(checkInBranchJson),
      'shiftJson': serializer.toJson<String?>(shiftJson),
      'workingDaysMapJson': serializer.toJson<String?>(workingDaysMapJson),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  TodayAttendanceTableData copyWith(
          {int? tenantId,
          int? userId,
          String? date,
          bool? isClockedIn,
          bool? canClockIn,
          bool? canClockOut,
          Value<int?> attendanceId = const Value.absent(),
          Value<String?> clockIn = const Value.absent(),
          Value<String?> clockOut = const Value.absent(),
          String? totalHours,
          double? totalHoursNumeric,
          Value<String?> breakHours = const Value.absent(),
          Value<String?> overtimeHours = const Value.absent(),
          String? status,
          bool? isWorkingDay,
          bool? isHoliday,
          Value<String?> holidayName = const Value.absent(),
          bool? isOnLeave,
          bool? isHalfDayLeave,
          Value<String?> leaveTitle = const Value.absent(),
          Value<String?> checkInLocationJson = const Value.absent(),
          Value<String?> checkInBranchJson = const Value.absent(),
          Value<String?> shiftJson = const Value.absent(),
          Value<String?> workingDaysMapJson = const Value.absent(),
          DateTime? fetchedAt}) =>
      TodayAttendanceTableData(
        tenantId: tenantId ?? this.tenantId,
        userId: userId ?? this.userId,
        date: date ?? this.date,
        isClockedIn: isClockedIn ?? this.isClockedIn,
        canClockIn: canClockIn ?? this.canClockIn,
        canClockOut: canClockOut ?? this.canClockOut,
        attendanceId:
            attendanceId.present ? attendanceId.value : this.attendanceId,
        clockIn: clockIn.present ? clockIn.value : this.clockIn,
        clockOut: clockOut.present ? clockOut.value : this.clockOut,
        totalHours: totalHours ?? this.totalHours,
        totalHoursNumeric: totalHoursNumeric ?? this.totalHoursNumeric,
        breakHours: breakHours.present ? breakHours.value : this.breakHours,
        overtimeHours:
            overtimeHours.present ? overtimeHours.value : this.overtimeHours,
        status: status ?? this.status,
        isWorkingDay: isWorkingDay ?? this.isWorkingDay,
        isHoliday: isHoliday ?? this.isHoliday,
        holidayName: holidayName.present ? holidayName.value : this.holidayName,
        isOnLeave: isOnLeave ?? this.isOnLeave,
        isHalfDayLeave: isHalfDayLeave ?? this.isHalfDayLeave,
        leaveTitle: leaveTitle.present ? leaveTitle.value : this.leaveTitle,
        checkInLocationJson: checkInLocationJson.present
            ? checkInLocationJson.value
            : this.checkInLocationJson,
        checkInBranchJson: checkInBranchJson.present
            ? checkInBranchJson.value
            : this.checkInBranchJson,
        shiftJson: shiftJson.present ? shiftJson.value : this.shiftJson,
        workingDaysMapJson: workingDaysMapJson.present
            ? workingDaysMapJson.value
            : this.workingDaysMapJson,
        fetchedAt: fetchedAt ?? this.fetchedAt,
      );
  TodayAttendanceTableData copyWithCompanion(
      TodayAttendanceTableCompanion data) {
    return TodayAttendanceTableData(
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      userId: data.userId.present ? data.userId.value : this.userId,
      date: data.date.present ? data.date.value : this.date,
      isClockedIn:
          data.isClockedIn.present ? data.isClockedIn.value : this.isClockedIn,
      canClockIn:
          data.canClockIn.present ? data.canClockIn.value : this.canClockIn,
      canClockOut:
          data.canClockOut.present ? data.canClockOut.value : this.canClockOut,
      attendanceId: data.attendanceId.present
          ? data.attendanceId.value
          : this.attendanceId,
      clockIn: data.clockIn.present ? data.clockIn.value : this.clockIn,
      clockOut: data.clockOut.present ? data.clockOut.value : this.clockOut,
      totalHours:
          data.totalHours.present ? data.totalHours.value : this.totalHours,
      totalHoursNumeric: data.totalHoursNumeric.present
          ? data.totalHoursNumeric.value
          : this.totalHoursNumeric,
      breakHours:
          data.breakHours.present ? data.breakHours.value : this.breakHours,
      overtimeHours: data.overtimeHours.present
          ? data.overtimeHours.value
          : this.overtimeHours,
      status: data.status.present ? data.status.value : this.status,
      isWorkingDay: data.isWorkingDay.present
          ? data.isWorkingDay.value
          : this.isWorkingDay,
      isHoliday: data.isHoliday.present ? data.isHoliday.value : this.isHoliday,
      holidayName:
          data.holidayName.present ? data.holidayName.value : this.holidayName,
      isOnLeave: data.isOnLeave.present ? data.isOnLeave.value : this.isOnLeave,
      isHalfDayLeave: data.isHalfDayLeave.present
          ? data.isHalfDayLeave.value
          : this.isHalfDayLeave,
      leaveTitle:
          data.leaveTitle.present ? data.leaveTitle.value : this.leaveTitle,
      checkInLocationJson: data.checkInLocationJson.present
          ? data.checkInLocationJson.value
          : this.checkInLocationJson,
      checkInBranchJson: data.checkInBranchJson.present
          ? data.checkInBranchJson.value
          : this.checkInBranchJson,
      shiftJson: data.shiftJson.present ? data.shiftJson.value : this.shiftJson,
      workingDaysMapJson: data.workingDaysMapJson.present
          ? data.workingDaysMapJson.value
          : this.workingDaysMapJson,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TodayAttendanceTableData(')
          ..write('tenantId: $tenantId, ')
          ..write('userId: $userId, ')
          ..write('date: $date, ')
          ..write('isClockedIn: $isClockedIn, ')
          ..write('canClockIn: $canClockIn, ')
          ..write('canClockOut: $canClockOut, ')
          ..write('attendanceId: $attendanceId, ')
          ..write('clockIn: $clockIn, ')
          ..write('clockOut: $clockOut, ')
          ..write('totalHours: $totalHours, ')
          ..write('totalHoursNumeric: $totalHoursNumeric, ')
          ..write('breakHours: $breakHours, ')
          ..write('overtimeHours: $overtimeHours, ')
          ..write('status: $status, ')
          ..write('isWorkingDay: $isWorkingDay, ')
          ..write('isHoliday: $isHoliday, ')
          ..write('holidayName: $holidayName, ')
          ..write('isOnLeave: $isOnLeave, ')
          ..write('isHalfDayLeave: $isHalfDayLeave, ')
          ..write('leaveTitle: $leaveTitle, ')
          ..write('checkInLocationJson: $checkInLocationJson, ')
          ..write('checkInBranchJson: $checkInBranchJson, ')
          ..write('shiftJson: $shiftJson, ')
          ..write('workingDaysMapJson: $workingDaysMapJson, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        tenantId,
        userId,
        date,
        isClockedIn,
        canClockIn,
        canClockOut,
        attendanceId,
        clockIn,
        clockOut,
        totalHours,
        totalHoursNumeric,
        breakHours,
        overtimeHours,
        status,
        isWorkingDay,
        isHoliday,
        holidayName,
        isOnLeave,
        isHalfDayLeave,
        leaveTitle,
        checkInLocationJson,
        checkInBranchJson,
        shiftJson,
        workingDaysMapJson,
        fetchedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TodayAttendanceTableData &&
          other.tenantId == this.tenantId &&
          other.userId == this.userId &&
          other.date == this.date &&
          other.isClockedIn == this.isClockedIn &&
          other.canClockIn == this.canClockIn &&
          other.canClockOut == this.canClockOut &&
          other.attendanceId == this.attendanceId &&
          other.clockIn == this.clockIn &&
          other.clockOut == this.clockOut &&
          other.totalHours == this.totalHours &&
          other.totalHoursNumeric == this.totalHoursNumeric &&
          other.breakHours == this.breakHours &&
          other.overtimeHours == this.overtimeHours &&
          other.status == this.status &&
          other.isWorkingDay == this.isWorkingDay &&
          other.isHoliday == this.isHoliday &&
          other.holidayName == this.holidayName &&
          other.isOnLeave == this.isOnLeave &&
          other.isHalfDayLeave == this.isHalfDayLeave &&
          other.leaveTitle == this.leaveTitle &&
          other.checkInLocationJson == this.checkInLocationJson &&
          other.checkInBranchJson == this.checkInBranchJson &&
          other.shiftJson == this.shiftJson &&
          other.workingDaysMapJson == this.workingDaysMapJson &&
          other.fetchedAt == this.fetchedAt);
}

class TodayAttendanceTableCompanion
    extends UpdateCompanion<TodayAttendanceTableData> {
  final Value<int> tenantId;
  final Value<int> userId;
  final Value<String> date;
  final Value<bool> isClockedIn;
  final Value<bool> canClockIn;
  final Value<bool> canClockOut;
  final Value<int?> attendanceId;
  final Value<String?> clockIn;
  final Value<String?> clockOut;
  final Value<String> totalHours;
  final Value<double> totalHoursNumeric;
  final Value<String?> breakHours;
  final Value<String?> overtimeHours;
  final Value<String> status;
  final Value<bool> isWorkingDay;
  final Value<bool> isHoliday;
  final Value<String?> holidayName;
  final Value<bool> isOnLeave;
  final Value<bool> isHalfDayLeave;
  final Value<String?> leaveTitle;
  final Value<String?> checkInLocationJson;
  final Value<String?> checkInBranchJson;
  final Value<String?> shiftJson;
  final Value<String?> workingDaysMapJson;
  final Value<DateTime> fetchedAt;
  final Value<int> rowid;
  const TodayAttendanceTableCompanion({
    this.tenantId = const Value.absent(),
    this.userId = const Value.absent(),
    this.date = const Value.absent(),
    this.isClockedIn = const Value.absent(),
    this.canClockIn = const Value.absent(),
    this.canClockOut = const Value.absent(),
    this.attendanceId = const Value.absent(),
    this.clockIn = const Value.absent(),
    this.clockOut = const Value.absent(),
    this.totalHours = const Value.absent(),
    this.totalHoursNumeric = const Value.absent(),
    this.breakHours = const Value.absent(),
    this.overtimeHours = const Value.absent(),
    this.status = const Value.absent(),
    this.isWorkingDay = const Value.absent(),
    this.isHoliday = const Value.absent(),
    this.holidayName = const Value.absent(),
    this.isOnLeave = const Value.absent(),
    this.isHalfDayLeave = const Value.absent(),
    this.leaveTitle = const Value.absent(),
    this.checkInLocationJson = const Value.absent(),
    this.checkInBranchJson = const Value.absent(),
    this.shiftJson = const Value.absent(),
    this.workingDaysMapJson = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TodayAttendanceTableCompanion.insert({
    required int tenantId,
    required int userId,
    required String date,
    this.isClockedIn = const Value.absent(),
    this.canClockIn = const Value.absent(),
    this.canClockOut = const Value.absent(),
    this.attendanceId = const Value.absent(),
    this.clockIn = const Value.absent(),
    this.clockOut = const Value.absent(),
    this.totalHours = const Value.absent(),
    this.totalHoursNumeric = const Value.absent(),
    this.breakHours = const Value.absent(),
    this.overtimeHours = const Value.absent(),
    this.status = const Value.absent(),
    this.isWorkingDay = const Value.absent(),
    this.isHoliday = const Value.absent(),
    this.holidayName = const Value.absent(),
    this.isOnLeave = const Value.absent(),
    this.isHalfDayLeave = const Value.absent(),
    this.leaveTitle = const Value.absent(),
    this.checkInLocationJson = const Value.absent(),
    this.checkInBranchJson = const Value.absent(),
    this.shiftJson = const Value.absent(),
    this.workingDaysMapJson = const Value.absent(),
    required DateTime fetchedAt,
    this.rowid = const Value.absent(),
  })  : tenantId = Value(tenantId),
        userId = Value(userId),
        date = Value(date),
        fetchedAt = Value(fetchedAt);
  static Insertable<TodayAttendanceTableData> custom({
    Expression<int>? tenantId,
    Expression<int>? userId,
    Expression<String>? date,
    Expression<bool>? isClockedIn,
    Expression<bool>? canClockIn,
    Expression<bool>? canClockOut,
    Expression<int>? attendanceId,
    Expression<String>? clockIn,
    Expression<String>? clockOut,
    Expression<String>? totalHours,
    Expression<double>? totalHoursNumeric,
    Expression<String>? breakHours,
    Expression<String>? overtimeHours,
    Expression<String>? status,
    Expression<bool>? isWorkingDay,
    Expression<bool>? isHoliday,
    Expression<String>? holidayName,
    Expression<bool>? isOnLeave,
    Expression<bool>? isHalfDayLeave,
    Expression<String>? leaveTitle,
    Expression<String>? checkInLocationJson,
    Expression<String>? checkInBranchJson,
    Expression<String>? shiftJson,
    Expression<String>? workingDaysMapJson,
    Expression<DateTime>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tenantId != null) 'tenant_id': tenantId,
      if (userId != null) 'user_id': userId,
      if (date != null) 'date': date,
      if (isClockedIn != null) 'is_clocked_in': isClockedIn,
      if (canClockIn != null) 'can_clock_in': canClockIn,
      if (canClockOut != null) 'can_clock_out': canClockOut,
      if (attendanceId != null) 'attendance_id': attendanceId,
      if (clockIn != null) 'clock_in': clockIn,
      if (clockOut != null) 'clock_out': clockOut,
      if (totalHours != null) 'total_hours': totalHours,
      if (totalHoursNumeric != null) 'total_hours_numeric': totalHoursNumeric,
      if (breakHours != null) 'break_hours': breakHours,
      if (overtimeHours != null) 'overtime_hours': overtimeHours,
      if (status != null) 'status': status,
      if (isWorkingDay != null) 'is_working_day': isWorkingDay,
      if (isHoliday != null) 'is_holiday': isHoliday,
      if (holidayName != null) 'holiday_name': holidayName,
      if (isOnLeave != null) 'is_on_leave': isOnLeave,
      if (isHalfDayLeave != null) 'is_half_day_leave': isHalfDayLeave,
      if (leaveTitle != null) 'leave_title': leaveTitle,
      if (checkInLocationJson != null)
        'check_in_location_json': checkInLocationJson,
      if (checkInBranchJson != null) 'check_in_branch_json': checkInBranchJson,
      if (shiftJson != null) 'shift_json': shiftJson,
      if (workingDaysMapJson != null)
        'working_days_map_json': workingDaysMapJson,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TodayAttendanceTableCompanion copyWith(
      {Value<int>? tenantId,
      Value<int>? userId,
      Value<String>? date,
      Value<bool>? isClockedIn,
      Value<bool>? canClockIn,
      Value<bool>? canClockOut,
      Value<int?>? attendanceId,
      Value<String?>? clockIn,
      Value<String?>? clockOut,
      Value<String>? totalHours,
      Value<double>? totalHoursNumeric,
      Value<String?>? breakHours,
      Value<String?>? overtimeHours,
      Value<String>? status,
      Value<bool>? isWorkingDay,
      Value<bool>? isHoliday,
      Value<String?>? holidayName,
      Value<bool>? isOnLeave,
      Value<bool>? isHalfDayLeave,
      Value<String?>? leaveTitle,
      Value<String?>? checkInLocationJson,
      Value<String?>? checkInBranchJson,
      Value<String?>? shiftJson,
      Value<String?>? workingDaysMapJson,
      Value<DateTime>? fetchedAt,
      Value<int>? rowid}) {
    return TodayAttendanceTableCompanion(
      tenantId: tenantId ?? this.tenantId,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      isClockedIn: isClockedIn ?? this.isClockedIn,
      canClockIn: canClockIn ?? this.canClockIn,
      canClockOut: canClockOut ?? this.canClockOut,
      attendanceId: attendanceId ?? this.attendanceId,
      clockIn: clockIn ?? this.clockIn,
      clockOut: clockOut ?? this.clockOut,
      totalHours: totalHours ?? this.totalHours,
      totalHoursNumeric: totalHoursNumeric ?? this.totalHoursNumeric,
      breakHours: breakHours ?? this.breakHours,
      overtimeHours: overtimeHours ?? this.overtimeHours,
      status: status ?? this.status,
      isWorkingDay: isWorkingDay ?? this.isWorkingDay,
      isHoliday: isHoliday ?? this.isHoliday,
      holidayName: holidayName ?? this.holidayName,
      isOnLeave: isOnLeave ?? this.isOnLeave,
      isHalfDayLeave: isHalfDayLeave ?? this.isHalfDayLeave,
      leaveTitle: leaveTitle ?? this.leaveTitle,
      checkInLocationJson: checkInLocationJson ?? this.checkInLocationJson,
      checkInBranchJson: checkInBranchJson ?? this.checkInBranchJson,
      shiftJson: shiftJson ?? this.shiftJson,
      workingDaysMapJson: workingDaysMapJson ?? this.workingDaysMapJson,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tenantId.present) {
      map['tenant_id'] = Variable<int>(tenantId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (isClockedIn.present) {
      map['is_clocked_in'] = Variable<bool>(isClockedIn.value);
    }
    if (canClockIn.present) {
      map['can_clock_in'] = Variable<bool>(canClockIn.value);
    }
    if (canClockOut.present) {
      map['can_clock_out'] = Variable<bool>(canClockOut.value);
    }
    if (attendanceId.present) {
      map['attendance_id'] = Variable<int>(attendanceId.value);
    }
    if (clockIn.present) {
      map['clock_in'] = Variable<String>(clockIn.value);
    }
    if (clockOut.present) {
      map['clock_out'] = Variable<String>(clockOut.value);
    }
    if (totalHours.present) {
      map['total_hours'] = Variable<String>(totalHours.value);
    }
    if (totalHoursNumeric.present) {
      map['total_hours_numeric'] = Variable<double>(totalHoursNumeric.value);
    }
    if (breakHours.present) {
      map['break_hours'] = Variable<String>(breakHours.value);
    }
    if (overtimeHours.present) {
      map['overtime_hours'] = Variable<String>(overtimeHours.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isWorkingDay.present) {
      map['is_working_day'] = Variable<bool>(isWorkingDay.value);
    }
    if (isHoliday.present) {
      map['is_holiday'] = Variable<bool>(isHoliday.value);
    }
    if (holidayName.present) {
      map['holiday_name'] = Variable<String>(holidayName.value);
    }
    if (isOnLeave.present) {
      map['is_on_leave'] = Variable<bool>(isOnLeave.value);
    }
    if (isHalfDayLeave.present) {
      map['is_half_day_leave'] = Variable<bool>(isHalfDayLeave.value);
    }
    if (leaveTitle.present) {
      map['leave_title'] = Variable<String>(leaveTitle.value);
    }
    if (checkInLocationJson.present) {
      map['check_in_location_json'] =
          Variable<String>(checkInLocationJson.value);
    }
    if (checkInBranchJson.present) {
      map['check_in_branch_json'] = Variable<String>(checkInBranchJson.value);
    }
    if (shiftJson.present) {
      map['shift_json'] = Variable<String>(shiftJson.value);
    }
    if (workingDaysMapJson.present) {
      map['working_days_map_json'] = Variable<String>(workingDaysMapJson.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodayAttendanceTableCompanion(')
          ..write('tenantId: $tenantId, ')
          ..write('userId: $userId, ')
          ..write('date: $date, ')
          ..write('isClockedIn: $isClockedIn, ')
          ..write('canClockIn: $canClockIn, ')
          ..write('canClockOut: $canClockOut, ')
          ..write('attendanceId: $attendanceId, ')
          ..write('clockIn: $clockIn, ')
          ..write('clockOut: $clockOut, ')
          ..write('totalHours: $totalHours, ')
          ..write('totalHoursNumeric: $totalHoursNumeric, ')
          ..write('breakHours: $breakHours, ')
          ..write('overtimeHours: $overtimeHours, ')
          ..write('status: $status, ')
          ..write('isWorkingDay: $isWorkingDay, ')
          ..write('isHoliday: $isHoliday, ')
          ..write('holidayName: $holidayName, ')
          ..write('isOnLeave: $isOnLeave, ')
          ..write('isHalfDayLeave: $isHalfDayLeave, ')
          ..write('leaveTitle: $leaveTitle, ')
          ..write('checkInLocationJson: $checkInLocationJson, ')
          ..write('checkInBranchJson: $checkInBranchJson, ')
          ..write('shiftJson: $shiftJson, ')
          ..write('workingDaysMapJson: $workingDaysMapJson, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TargetsTableTable extends TargetsTable
    with TableInfo<$TargetsTableTable, TargetsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TargetsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta =
      const VerificationMeta('localId');
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
      'local_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
      'server_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<int> tenantId = GeneratedColumn<int>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetTypeMeta =
      const VerificationMeta('targetType');
  @override
  late final GeneratedColumn<String> targetType = GeneratedColumn<String>(
      'target_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetValueMeta =
      const VerificationMeta('targetValue');
  @override
  late final GeneratedColumn<double> targetValue = GeneratedColumn<double>(
      'target_value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _achievedValueMeta =
      const VerificationMeta('achievedValue');
  @override
  late final GeneratedColumn<double> achievedValue = GeneratedColumn<double>(
      'achieved_value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _progressMeta =
      const VerificationMeta('progress');
  @override
  late final GeneratedColumn<double> progress = GeneratedColumn<double>(
      'progress', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
      'start_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<String> endDate = GeneratedColumn<String>(
      'end_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncStateMeta =
      const VerificationMeta('syncState');
  @override
  late final GeneratedColumn<String> syncState = GeneratedColumn<String>(
      'sync_state', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('synced'));
  static const VerificationMeta _fetchedAtMeta =
      const VerificationMeta('fetchedAt');
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
      'fetched_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        localId,
        serverId,
        tenantId,
        userId,
        title,
        targetType,
        targetValue,
        achievedValue,
        progress,
        unit,
        startDate,
        endDate,
        status,
        notes,
        syncState,
        fetchedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'targets_table';
  @override
  VerificationContext validateIntegrity(Insertable<TargetsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(_localIdMeta,
          localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta));
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    }
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('target_type')) {
      context.handle(
          _targetTypeMeta,
          targetType.isAcceptableOrUnknown(
              data['target_type']!, _targetTypeMeta));
    } else if (isInserting) {
      context.missing(_targetTypeMeta);
    }
    if (data.containsKey('target_value')) {
      context.handle(
          _targetValueMeta,
          targetValue.isAcceptableOrUnknown(
              data['target_value']!, _targetValueMeta));
    } else if (isInserting) {
      context.missing(_targetValueMeta);
    }
    if (data.containsKey('achieved_value')) {
      context.handle(
          _achievedValueMeta,
          achievedValue.isAcceptableOrUnknown(
              data['achieved_value']!, _achievedValueMeta));
    } else if (isInserting) {
      context.missing(_achievedValueMeta);
    }
    if (data.containsKey('progress')) {
      context.handle(_progressMeta,
          progress.isAcceptableOrUnknown(data['progress']!, _progressMeta));
    } else if (isInserting) {
      context.missing(_progressMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('sync_state')) {
      context.handle(_syncStateMeta,
          syncState.isAcceptableOrUnknown(data['sync_state']!, _syncStateMeta));
    }
    if (data.containsKey('fetched_at')) {
      context.handle(_fetchedAtMeta,
          fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta));
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  TargetsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TargetsTableData(
      localId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_id'])!,
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_id']),
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tenant_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      targetType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_type'])!,
      targetValue: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}target_value'])!,
      achievedValue: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}achieved_value'])!,
      progress: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}progress'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit']),
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}start_date']),
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}end_date']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      syncState: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_state'])!,
      fetchedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fetched_at'])!,
    );
  }

  @override
  $TargetsTableTable createAlias(String alias) {
    return $TargetsTableTable(attachedDatabase, alias);
  }
}

class TargetsTableData extends DataClass
    implements Insertable<TargetsTableData> {
  final String localId;
  final int? serverId;
  final int tenantId;
  final int userId;
  final String title;
  final String targetType;
  final double targetValue;
  final double achievedValue;
  final double progress;
  final String? unit;
  final String? startDate;
  final String? endDate;
  final String status;
  final String? notes;
  final String syncState;
  final DateTime fetchedAt;
  const TargetsTableData(
      {required this.localId,
      this.serverId,
      required this.tenantId,
      required this.userId,
      required this.title,
      required this.targetType,
      required this.targetValue,
      required this.achievedValue,
      required this.progress,
      this.unit,
      this.startDate,
      this.endDate,
      required this.status,
      this.notes,
      required this.syncState,
      required this.fetchedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    map['tenant_id'] = Variable<int>(tenantId);
    map['user_id'] = Variable<int>(userId);
    map['title'] = Variable<String>(title);
    map['target_type'] = Variable<String>(targetType);
    map['target_value'] = Variable<double>(targetValue);
    map['achieved_value'] = Variable<double>(achievedValue);
    map['progress'] = Variable<double>(progress);
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<String>(startDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<String>(endDate);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['sync_state'] = Variable<String>(syncState);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  TargetsTableCompanion toCompanion(bool nullToAbsent) {
    return TargetsTableCompanion(
      localId: Value(localId),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      tenantId: Value(tenantId),
      userId: Value(userId),
      title: Value(title),
      targetType: Value(targetType),
      targetValue: Value(targetValue),
      achievedValue: Value(achievedValue),
      progress: Value(progress),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      status: Value(status),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      syncState: Value(syncState),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory TargetsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TargetsTableData(
      localId: serializer.fromJson<String>(json['localId']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      tenantId: serializer.fromJson<int>(json['tenantId']),
      userId: serializer.fromJson<int>(json['userId']),
      title: serializer.fromJson<String>(json['title']),
      targetType: serializer.fromJson<String>(json['targetType']),
      targetValue: serializer.fromJson<double>(json['targetValue']),
      achievedValue: serializer.fromJson<double>(json['achievedValue']),
      progress: serializer.fromJson<double>(json['progress']),
      unit: serializer.fromJson<String?>(json['unit']),
      startDate: serializer.fromJson<String?>(json['startDate']),
      endDate: serializer.fromJson<String?>(json['endDate']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      syncState: serializer.fromJson<String>(json['syncState']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'serverId': serializer.toJson<int?>(serverId),
      'tenantId': serializer.toJson<int>(tenantId),
      'userId': serializer.toJson<int>(userId),
      'title': serializer.toJson<String>(title),
      'targetType': serializer.toJson<String>(targetType),
      'targetValue': serializer.toJson<double>(targetValue),
      'achievedValue': serializer.toJson<double>(achievedValue),
      'progress': serializer.toJson<double>(progress),
      'unit': serializer.toJson<String?>(unit),
      'startDate': serializer.toJson<String?>(startDate),
      'endDate': serializer.toJson<String?>(endDate),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'syncState': serializer.toJson<String>(syncState),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  TargetsTableData copyWith(
          {String? localId,
          Value<int?> serverId = const Value.absent(),
          int? tenantId,
          int? userId,
          String? title,
          String? targetType,
          double? targetValue,
          double? achievedValue,
          double? progress,
          Value<String?> unit = const Value.absent(),
          Value<String?> startDate = const Value.absent(),
          Value<String?> endDate = const Value.absent(),
          String? status,
          Value<String?> notes = const Value.absent(),
          String? syncState,
          DateTime? fetchedAt}) =>
      TargetsTableData(
        localId: localId ?? this.localId,
        serverId: serverId.present ? serverId.value : this.serverId,
        tenantId: tenantId ?? this.tenantId,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        targetType: targetType ?? this.targetType,
        targetValue: targetValue ?? this.targetValue,
        achievedValue: achievedValue ?? this.achievedValue,
        progress: progress ?? this.progress,
        unit: unit.present ? unit.value : this.unit,
        startDate: startDate.present ? startDate.value : this.startDate,
        endDate: endDate.present ? endDate.value : this.endDate,
        status: status ?? this.status,
        notes: notes.present ? notes.value : this.notes,
        syncState: syncState ?? this.syncState,
        fetchedAt: fetchedAt ?? this.fetchedAt,
      );
  TargetsTableData copyWithCompanion(TargetsTableCompanion data) {
    return TargetsTableData(
      localId: data.localId.present ? data.localId.value : this.localId,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      userId: data.userId.present ? data.userId.value : this.userId,
      title: data.title.present ? data.title.value : this.title,
      targetType:
          data.targetType.present ? data.targetType.value : this.targetType,
      targetValue:
          data.targetValue.present ? data.targetValue.value : this.targetValue,
      achievedValue: data.achievedValue.present
          ? data.achievedValue.value
          : this.achievedValue,
      progress: data.progress.present ? data.progress.value : this.progress,
      unit: data.unit.present ? data.unit.value : this.unit,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TargetsTableData(')
          ..write('localId: $localId, ')
          ..write('serverId: $serverId, ')
          ..write('tenantId: $tenantId, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('targetType: $targetType, ')
          ..write('targetValue: $targetValue, ')
          ..write('achievedValue: $achievedValue, ')
          ..write('progress: $progress, ')
          ..write('unit: $unit, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('syncState: $syncState, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      localId,
      serverId,
      tenantId,
      userId,
      title,
      targetType,
      targetValue,
      achievedValue,
      progress,
      unit,
      startDate,
      endDate,
      status,
      notes,
      syncState,
      fetchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TargetsTableData &&
          other.localId == this.localId &&
          other.serverId == this.serverId &&
          other.tenantId == this.tenantId &&
          other.userId == this.userId &&
          other.title == this.title &&
          other.targetType == this.targetType &&
          other.targetValue == this.targetValue &&
          other.achievedValue == this.achievedValue &&
          other.progress == this.progress &&
          other.unit == this.unit &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.syncState == this.syncState &&
          other.fetchedAt == this.fetchedAt);
}

class TargetsTableCompanion extends UpdateCompanion<TargetsTableData> {
  final Value<String> localId;
  final Value<int?> serverId;
  final Value<int> tenantId;
  final Value<int> userId;
  final Value<String> title;
  final Value<String> targetType;
  final Value<double> targetValue;
  final Value<double> achievedValue;
  final Value<double> progress;
  final Value<String?> unit;
  final Value<String?> startDate;
  final Value<String?> endDate;
  final Value<String> status;
  final Value<String?> notes;
  final Value<String> syncState;
  final Value<DateTime> fetchedAt;
  final Value<int> rowid;
  const TargetsTableCompanion({
    this.localId = const Value.absent(),
    this.serverId = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.userId = const Value.absent(),
    this.title = const Value.absent(),
    this.targetType = const Value.absent(),
    this.targetValue = const Value.absent(),
    this.achievedValue = const Value.absent(),
    this.progress = const Value.absent(),
    this.unit = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.syncState = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TargetsTableCompanion.insert({
    required String localId,
    this.serverId = const Value.absent(),
    required int tenantId,
    required int userId,
    required String title,
    required String targetType,
    required double targetValue,
    required double achievedValue,
    required double progress,
    this.unit = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    required String status,
    this.notes = const Value.absent(),
    this.syncState = const Value.absent(),
    required DateTime fetchedAt,
    this.rowid = const Value.absent(),
  })  : localId = Value(localId),
        tenantId = Value(tenantId),
        userId = Value(userId),
        title = Value(title),
        targetType = Value(targetType),
        targetValue = Value(targetValue),
        achievedValue = Value(achievedValue),
        progress = Value(progress),
        status = Value(status),
        fetchedAt = Value(fetchedAt);
  static Insertable<TargetsTableData> custom({
    Expression<String>? localId,
    Expression<int>? serverId,
    Expression<int>? tenantId,
    Expression<int>? userId,
    Expression<String>? title,
    Expression<String>? targetType,
    Expression<double>? targetValue,
    Expression<double>? achievedValue,
    Expression<double>? progress,
    Expression<String>? unit,
    Expression<String>? startDate,
    Expression<String>? endDate,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<String>? syncState,
    Expression<DateTime>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (serverId != null) 'server_id': serverId,
      if (tenantId != null) 'tenant_id': tenantId,
      if (userId != null) 'user_id': userId,
      if (title != null) 'title': title,
      if (targetType != null) 'target_type': targetType,
      if (targetValue != null) 'target_value': targetValue,
      if (achievedValue != null) 'achieved_value': achievedValue,
      if (progress != null) 'progress': progress,
      if (unit != null) 'unit': unit,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (syncState != null) 'sync_state': syncState,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TargetsTableCompanion copyWith(
      {Value<String>? localId,
      Value<int?>? serverId,
      Value<int>? tenantId,
      Value<int>? userId,
      Value<String>? title,
      Value<String>? targetType,
      Value<double>? targetValue,
      Value<double>? achievedValue,
      Value<double>? progress,
      Value<String?>? unit,
      Value<String?>? startDate,
      Value<String?>? endDate,
      Value<String>? status,
      Value<String?>? notes,
      Value<String>? syncState,
      Value<DateTime>? fetchedAt,
      Value<int>? rowid}) {
    return TargetsTableCompanion(
      localId: localId ?? this.localId,
      serverId: serverId ?? this.serverId,
      tenantId: tenantId ?? this.tenantId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      targetType: targetType ?? this.targetType,
      targetValue: targetValue ?? this.targetValue,
      achievedValue: achievedValue ?? this.achievedValue,
      progress: progress ?? this.progress,
      unit: unit ?? this.unit,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      syncState: syncState ?? this.syncState,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<int>(tenantId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (targetType.present) {
      map['target_type'] = Variable<String>(targetType.value);
    }
    if (targetValue.present) {
      map['target_value'] = Variable<double>(targetValue.value);
    }
    if (achievedValue.present) {
      map['achieved_value'] = Variable<double>(achievedValue.value);
    }
    if (progress.present) {
      map['progress'] = Variable<double>(progress.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<String>(endDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(syncState.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TargetsTableCompanion(')
          ..write('localId: $localId, ')
          ..write('serverId: $serverId, ')
          ..write('tenantId: $tenantId, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('targetType: $targetType, ')
          ..write('targetValue: $targetValue, ')
          ..write('achievedValue: $achievedValue, ')
          ..write('progress: $progress, ')
          ..write('unit: $unit, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('syncState: $syncState, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TenantLocationsTableTable extends TenantLocationsTable
    with TableInfo<$TenantLocationsTableTable, TenantLocationsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TenantLocationsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<int> tenantId = GeneratedColumn<int>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _locationNameMeta =
      const VerificationMeta('locationName');
  @override
  late final GeneratedColumn<String> locationName = GeneratedColumn<String>(
      'location_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _radiusMetersMeta =
      const VerificationMeta('radiusMeters');
  @override
  late final GeneratedColumn<double> radiusMeters = GeneratedColumn<double>(
      'radius_meters', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _fetchedAtMeta =
      const VerificationMeta('fetchedAt');
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
      'fetched_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tenantId,
        locationName,
        address,
        latitude,
        longitude,
        radiusMeters,
        isActive,
        fetchedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tenant_locations_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<TenantLocationsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('location_name')) {
      context.handle(
          _locationNameMeta,
          locationName.isAcceptableOrUnknown(
              data['location_name']!, _locationNameMeta));
    } else if (isInserting) {
      context.missing(_locationNameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('radius_meters')) {
      context.handle(
          _radiusMetersMeta,
          radiusMeters.isAcceptableOrUnknown(
              data['radius_meters']!, _radiusMetersMeta));
    } else if (isInserting) {
      context.missing(_radiusMetersMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('fetched_at')) {
      context.handle(_fetchedAtMeta,
          fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta));
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, tenantId};
  @override
  TenantLocationsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TenantLocationsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tenant_id'])!,
      locationName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location_name'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude'])!,
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude'])!,
      radiusMeters: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}radius_meters'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      fetchedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fetched_at'])!,
    );
  }

  @override
  $TenantLocationsTableTable createAlias(String alias) {
    return $TenantLocationsTableTable(attachedDatabase, alias);
  }
}

class TenantLocationsTableData extends DataClass
    implements Insertable<TenantLocationsTableData> {
  final int id;
  final int tenantId;
  final String locationName;
  final String? address;
  final double latitude;
  final double longitude;
  final double radiusMeters;
  final bool isActive;
  final DateTime fetchedAt;
  const TenantLocationsTableData(
      {required this.id,
      required this.tenantId,
      required this.locationName,
      this.address,
      required this.latitude,
      required this.longitude,
      required this.radiusMeters,
      required this.isActive,
      required this.fetchedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tenant_id'] = Variable<int>(tenantId);
    map['location_name'] = Variable<String>(locationName);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['radius_meters'] = Variable<double>(radiusMeters);
    map['is_active'] = Variable<bool>(isActive);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  TenantLocationsTableCompanion toCompanion(bool nullToAbsent) {
    return TenantLocationsTableCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      locationName: Value(locationName),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      latitude: Value(latitude),
      longitude: Value(longitude),
      radiusMeters: Value(radiusMeters),
      isActive: Value(isActive),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory TenantLocationsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TenantLocationsTableData(
      id: serializer.fromJson<int>(json['id']),
      tenantId: serializer.fromJson<int>(json['tenantId']),
      locationName: serializer.fromJson<String>(json['locationName']),
      address: serializer.fromJson<String?>(json['address']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      radiusMeters: serializer.fromJson<double>(json['radiusMeters']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tenantId': serializer.toJson<int>(tenantId),
      'locationName': serializer.toJson<String>(locationName),
      'address': serializer.toJson<String?>(address),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'radiusMeters': serializer.toJson<double>(radiusMeters),
      'isActive': serializer.toJson<bool>(isActive),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  TenantLocationsTableData copyWith(
          {int? id,
          int? tenantId,
          String? locationName,
          Value<String?> address = const Value.absent(),
          double? latitude,
          double? longitude,
          double? radiusMeters,
          bool? isActive,
          DateTime? fetchedAt}) =>
      TenantLocationsTableData(
        id: id ?? this.id,
        tenantId: tenantId ?? this.tenantId,
        locationName: locationName ?? this.locationName,
        address: address.present ? address.value : this.address,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        radiusMeters: radiusMeters ?? this.radiusMeters,
        isActive: isActive ?? this.isActive,
        fetchedAt: fetchedAt ?? this.fetchedAt,
      );
  TenantLocationsTableData copyWithCompanion(
      TenantLocationsTableCompanion data) {
    return TenantLocationsTableData(
      id: data.id.present ? data.id.value : this.id,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      locationName: data.locationName.present
          ? data.locationName.value
          : this.locationName,
      address: data.address.present ? data.address.value : this.address,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      radiusMeters: data.radiusMeters.present
          ? data.radiusMeters.value
          : this.radiusMeters,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TenantLocationsTableData(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('locationName: $locationName, ')
          ..write('address: $address, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('radiusMeters: $radiusMeters, ')
          ..write('isActive: $isActive, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tenantId, locationName, address, latitude,
      longitude, radiusMeters, isActive, fetchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TenantLocationsTableData &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.locationName == this.locationName &&
          other.address == this.address &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.radiusMeters == this.radiusMeters &&
          other.isActive == this.isActive &&
          other.fetchedAt == this.fetchedAt);
}

class TenantLocationsTableCompanion
    extends UpdateCompanion<TenantLocationsTableData> {
  final Value<int> id;
  final Value<int> tenantId;
  final Value<String> locationName;
  final Value<String?> address;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<double> radiusMeters;
  final Value<bool> isActive;
  final Value<DateTime> fetchedAt;
  final Value<int> rowid;
  const TenantLocationsTableCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.locationName = const Value.absent(),
    this.address = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.radiusMeters = const Value.absent(),
    this.isActive = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TenantLocationsTableCompanion.insert({
    required int id,
    required int tenantId,
    required String locationName,
    this.address = const Value.absent(),
    required double latitude,
    required double longitude,
    required double radiusMeters,
    this.isActive = const Value.absent(),
    required DateTime fetchedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        tenantId = Value(tenantId),
        locationName = Value(locationName),
        latitude = Value(latitude),
        longitude = Value(longitude),
        radiusMeters = Value(radiusMeters),
        fetchedAt = Value(fetchedAt);
  static Insertable<TenantLocationsTableData> custom({
    Expression<int>? id,
    Expression<int>? tenantId,
    Expression<String>? locationName,
    Expression<String>? address,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? radiusMeters,
    Expression<bool>? isActive,
    Expression<DateTime>? fetchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (locationName != null) 'location_name': locationName,
      if (address != null) 'address': address,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (radiusMeters != null) 'radius_meters': radiusMeters,
      if (isActive != null) 'is_active': isActive,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TenantLocationsTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? tenantId,
      Value<String>? locationName,
      Value<String?>? address,
      Value<double>? latitude,
      Value<double>? longitude,
      Value<double>? radiusMeters,
      Value<bool>? isActive,
      Value<DateTime>? fetchedAt,
      Value<int>? rowid}) {
    return TenantLocationsTableCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      locationName: locationName ?? this.locationName,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radiusMeters: radiusMeters ?? this.radiusMeters,
      isActive: isActive ?? this.isActive,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<int>(tenantId.value);
    }
    if (locationName.present) {
      map['location_name'] = Variable<String>(locationName.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (radiusMeters.present) {
      map['radius_meters'] = Variable<double>(radiusMeters.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TenantLocationsTableCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('locationName: $locationName, ')
          ..write('address: $address, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('radiusMeters: $radiusMeters, ')
          ..write('isActive: $isActive, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PayrollRecordsTableTable extends PayrollRecordsTable
    with TableInfo<$PayrollRecordsTableTable, PayrollRecordsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PayrollRecordsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<int> tenantId = GeneratedColumn<int>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
      'month', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
      'year', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _netSalaryMeta =
      const VerificationMeta('netSalary');
  @override
  late final GeneratedColumn<double> netSalary = GeneratedColumn<double>(
      'net_salary', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _grossSalaryMeta =
      const VerificationMeta('grossSalary');
  @override
  late final GeneratedColumn<double> grossSalary = GeneratedColumn<double>(
      'gross_salary', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _deductionsMeta =
      const VerificationMeta('deductions');
  @override
  late final GeneratedColumn<double> deductions = GeneratedColumn<double>(
      'deductions', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _allowancesMeta =
      const VerificationMeta('allowances');
  @override
  late final GeneratedColumn<double> allowances = GeneratedColumn<double>(
      'allowances', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payslipUrlMeta =
      const VerificationMeta('payslipUrl');
  @override
  late final GeneratedColumn<String> payslipUrl = GeneratedColumn<String>(
      'payslip_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _detailsJsonMeta =
      const VerificationMeta('detailsJson');
  @override
  late final GeneratedColumn<String> detailsJson = GeneratedColumn<String>(
      'details_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fetchedAtMeta =
      const VerificationMeta('fetchedAt');
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
      'fetched_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _expiresAtMeta =
      const VerificationMeta('expiresAt');
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
      'expires_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        tenantId,
        userId,
        month,
        year,
        netSalary,
        grossSalary,
        deductions,
        allowances,
        status,
        payslipUrl,
        detailsJson,
        fetchedAt,
        expiresAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payroll_records_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<PayrollRecordsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
          _monthMeta, month.isAcceptableOrUnknown(data['month']!, _monthMeta));
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
          _yearMeta, year.isAcceptableOrUnknown(data['year']!, _yearMeta));
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('net_salary')) {
      context.handle(_netSalaryMeta,
          netSalary.isAcceptableOrUnknown(data['net_salary']!, _netSalaryMeta));
    } else if (isInserting) {
      context.missing(_netSalaryMeta);
    }
    if (data.containsKey('gross_salary')) {
      context.handle(
          _grossSalaryMeta,
          grossSalary.isAcceptableOrUnknown(
              data['gross_salary']!, _grossSalaryMeta));
    } else if (isInserting) {
      context.missing(_grossSalaryMeta);
    }
    if (data.containsKey('deductions')) {
      context.handle(
          _deductionsMeta,
          deductions.isAcceptableOrUnknown(
              data['deductions']!, _deductionsMeta));
    } else if (isInserting) {
      context.missing(_deductionsMeta);
    }
    if (data.containsKey('allowances')) {
      context.handle(
          _allowancesMeta,
          allowances.isAcceptableOrUnknown(
              data['allowances']!, _allowancesMeta));
    } else if (isInserting) {
      context.missing(_allowancesMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('payslip_url')) {
      context.handle(
          _payslipUrlMeta,
          payslipUrl.isAcceptableOrUnknown(
              data['payslip_url']!, _payslipUrlMeta));
    }
    if (data.containsKey('details_json')) {
      context.handle(
          _detailsJsonMeta,
          detailsJson.isAcceptableOrUnknown(
              data['details_json']!, _detailsJsonMeta));
    }
    if (data.containsKey('fetched_at')) {
      context.handle(_fetchedAtMeta,
          fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta));
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(_expiresAtMeta,
          expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, tenantId};
  @override
  PayrollRecordsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PayrollRecordsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tenant_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      month: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}month'])!,
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}year'])!,
      netSalary: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}net_salary'])!,
      grossSalary: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}gross_salary'])!,
      deductions: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}deductions'])!,
      allowances: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}allowances'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      payslipUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payslip_url']),
      detailsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}details_json']),
      fetchedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fetched_at'])!,
      expiresAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expires_at']),
    );
  }

  @override
  $PayrollRecordsTableTable createAlias(String alias) {
    return $PayrollRecordsTableTable(attachedDatabase, alias);
  }
}

class PayrollRecordsTableData extends DataClass
    implements Insertable<PayrollRecordsTableData> {
  final int id;
  final int tenantId;
  final int userId;
  final int month;
  final int year;
  final double netSalary;
  final double grossSalary;
  final double deductions;
  final double allowances;
  final String status;
  final String? payslipUrl;
  final String? detailsJson;
  final DateTime fetchedAt;
  final DateTime? expiresAt;
  const PayrollRecordsTableData(
      {required this.id,
      required this.tenantId,
      required this.userId,
      required this.month,
      required this.year,
      required this.netSalary,
      required this.grossSalary,
      required this.deductions,
      required this.allowances,
      required this.status,
      this.payslipUrl,
      this.detailsJson,
      required this.fetchedAt,
      this.expiresAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tenant_id'] = Variable<int>(tenantId);
    map['user_id'] = Variable<int>(userId);
    map['month'] = Variable<int>(month);
    map['year'] = Variable<int>(year);
    map['net_salary'] = Variable<double>(netSalary);
    map['gross_salary'] = Variable<double>(grossSalary);
    map['deductions'] = Variable<double>(deductions);
    map['allowances'] = Variable<double>(allowances);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || payslipUrl != null) {
      map['payslip_url'] = Variable<String>(payslipUrl);
    }
    if (!nullToAbsent || detailsJson != null) {
      map['details_json'] = Variable<String>(detailsJson);
    }
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    return map;
  }

  PayrollRecordsTableCompanion toCompanion(bool nullToAbsent) {
    return PayrollRecordsTableCompanion(
      id: Value(id),
      tenantId: Value(tenantId),
      userId: Value(userId),
      month: Value(month),
      year: Value(year),
      netSalary: Value(netSalary),
      grossSalary: Value(grossSalary),
      deductions: Value(deductions),
      allowances: Value(allowances),
      status: Value(status),
      payslipUrl: payslipUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(payslipUrl),
      detailsJson: detailsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(detailsJson),
      fetchedAt: Value(fetchedAt),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
    );
  }

  factory PayrollRecordsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PayrollRecordsTableData(
      id: serializer.fromJson<int>(json['id']),
      tenantId: serializer.fromJson<int>(json['tenantId']),
      userId: serializer.fromJson<int>(json['userId']),
      month: serializer.fromJson<int>(json['month']),
      year: serializer.fromJson<int>(json['year']),
      netSalary: serializer.fromJson<double>(json['netSalary']),
      grossSalary: serializer.fromJson<double>(json['grossSalary']),
      deductions: serializer.fromJson<double>(json['deductions']),
      allowances: serializer.fromJson<double>(json['allowances']),
      status: serializer.fromJson<String>(json['status']),
      payslipUrl: serializer.fromJson<String?>(json['payslipUrl']),
      detailsJson: serializer.fromJson<String?>(json['detailsJson']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tenantId': serializer.toJson<int>(tenantId),
      'userId': serializer.toJson<int>(userId),
      'month': serializer.toJson<int>(month),
      'year': serializer.toJson<int>(year),
      'netSalary': serializer.toJson<double>(netSalary),
      'grossSalary': serializer.toJson<double>(grossSalary),
      'deductions': serializer.toJson<double>(deductions),
      'allowances': serializer.toJson<double>(allowances),
      'status': serializer.toJson<String>(status),
      'payslipUrl': serializer.toJson<String?>(payslipUrl),
      'detailsJson': serializer.toJson<String?>(detailsJson),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
    };
  }

  PayrollRecordsTableData copyWith(
          {int? id,
          int? tenantId,
          int? userId,
          int? month,
          int? year,
          double? netSalary,
          double? grossSalary,
          double? deductions,
          double? allowances,
          String? status,
          Value<String?> payslipUrl = const Value.absent(),
          Value<String?> detailsJson = const Value.absent(),
          DateTime? fetchedAt,
          Value<DateTime?> expiresAt = const Value.absent()}) =>
      PayrollRecordsTableData(
        id: id ?? this.id,
        tenantId: tenantId ?? this.tenantId,
        userId: userId ?? this.userId,
        month: month ?? this.month,
        year: year ?? this.year,
        netSalary: netSalary ?? this.netSalary,
        grossSalary: grossSalary ?? this.grossSalary,
        deductions: deductions ?? this.deductions,
        allowances: allowances ?? this.allowances,
        status: status ?? this.status,
        payslipUrl: payslipUrl.present ? payslipUrl.value : this.payslipUrl,
        detailsJson: detailsJson.present ? detailsJson.value : this.detailsJson,
        fetchedAt: fetchedAt ?? this.fetchedAt,
        expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
      );
  PayrollRecordsTableData copyWithCompanion(PayrollRecordsTableCompanion data) {
    return PayrollRecordsTableData(
      id: data.id.present ? data.id.value : this.id,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      userId: data.userId.present ? data.userId.value : this.userId,
      month: data.month.present ? data.month.value : this.month,
      year: data.year.present ? data.year.value : this.year,
      netSalary: data.netSalary.present ? data.netSalary.value : this.netSalary,
      grossSalary:
          data.grossSalary.present ? data.grossSalary.value : this.grossSalary,
      deductions:
          data.deductions.present ? data.deductions.value : this.deductions,
      allowances:
          data.allowances.present ? data.allowances.value : this.allowances,
      status: data.status.present ? data.status.value : this.status,
      payslipUrl:
          data.payslipUrl.present ? data.payslipUrl.value : this.payslipUrl,
      detailsJson:
          data.detailsJson.present ? data.detailsJson.value : this.detailsJson,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PayrollRecordsTableData(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('userId: $userId, ')
          ..write('month: $month, ')
          ..write('year: $year, ')
          ..write('netSalary: $netSalary, ')
          ..write('grossSalary: $grossSalary, ')
          ..write('deductions: $deductions, ')
          ..write('allowances: $allowances, ')
          ..write('status: $status, ')
          ..write('payslipUrl: $payslipUrl, ')
          ..write('detailsJson: $detailsJson, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      tenantId,
      userId,
      month,
      year,
      netSalary,
      grossSalary,
      deductions,
      allowances,
      status,
      payslipUrl,
      detailsJson,
      fetchedAt,
      expiresAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PayrollRecordsTableData &&
          other.id == this.id &&
          other.tenantId == this.tenantId &&
          other.userId == this.userId &&
          other.month == this.month &&
          other.year == this.year &&
          other.netSalary == this.netSalary &&
          other.grossSalary == this.grossSalary &&
          other.deductions == this.deductions &&
          other.allowances == this.allowances &&
          other.status == this.status &&
          other.payslipUrl == this.payslipUrl &&
          other.detailsJson == this.detailsJson &&
          other.fetchedAt == this.fetchedAt &&
          other.expiresAt == this.expiresAt);
}

class PayrollRecordsTableCompanion
    extends UpdateCompanion<PayrollRecordsTableData> {
  final Value<int> id;
  final Value<int> tenantId;
  final Value<int> userId;
  final Value<int> month;
  final Value<int> year;
  final Value<double> netSalary;
  final Value<double> grossSalary;
  final Value<double> deductions;
  final Value<double> allowances;
  final Value<String> status;
  final Value<String?> payslipUrl;
  final Value<String?> detailsJson;
  final Value<DateTime> fetchedAt;
  final Value<DateTime?> expiresAt;
  final Value<int> rowid;
  const PayrollRecordsTableCompanion({
    this.id = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.userId = const Value.absent(),
    this.month = const Value.absent(),
    this.year = const Value.absent(),
    this.netSalary = const Value.absent(),
    this.grossSalary = const Value.absent(),
    this.deductions = const Value.absent(),
    this.allowances = const Value.absent(),
    this.status = const Value.absent(),
    this.payslipUrl = const Value.absent(),
    this.detailsJson = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PayrollRecordsTableCompanion.insert({
    required int id,
    required int tenantId,
    required int userId,
    required int month,
    required int year,
    required double netSalary,
    required double grossSalary,
    required double deductions,
    required double allowances,
    required String status,
    this.payslipUrl = const Value.absent(),
    this.detailsJson = const Value.absent(),
    required DateTime fetchedAt,
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        tenantId = Value(tenantId),
        userId = Value(userId),
        month = Value(month),
        year = Value(year),
        netSalary = Value(netSalary),
        grossSalary = Value(grossSalary),
        deductions = Value(deductions),
        allowances = Value(allowances),
        status = Value(status),
        fetchedAt = Value(fetchedAt);
  static Insertable<PayrollRecordsTableData> custom({
    Expression<int>? id,
    Expression<int>? tenantId,
    Expression<int>? userId,
    Expression<int>? month,
    Expression<int>? year,
    Expression<double>? netSalary,
    Expression<double>? grossSalary,
    Expression<double>? deductions,
    Expression<double>? allowances,
    Expression<String>? status,
    Expression<String>? payslipUrl,
    Expression<String>? detailsJson,
    Expression<DateTime>? fetchedAt,
    Expression<DateTime>? expiresAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tenantId != null) 'tenant_id': tenantId,
      if (userId != null) 'user_id': userId,
      if (month != null) 'month': month,
      if (year != null) 'year': year,
      if (netSalary != null) 'net_salary': netSalary,
      if (grossSalary != null) 'gross_salary': grossSalary,
      if (deductions != null) 'deductions': deductions,
      if (allowances != null) 'allowances': allowances,
      if (status != null) 'status': status,
      if (payslipUrl != null) 'payslip_url': payslipUrl,
      if (detailsJson != null) 'details_json': detailsJson,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PayrollRecordsTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? tenantId,
      Value<int>? userId,
      Value<int>? month,
      Value<int>? year,
      Value<double>? netSalary,
      Value<double>? grossSalary,
      Value<double>? deductions,
      Value<double>? allowances,
      Value<String>? status,
      Value<String?>? payslipUrl,
      Value<String?>? detailsJson,
      Value<DateTime>? fetchedAt,
      Value<DateTime?>? expiresAt,
      Value<int>? rowid}) {
    return PayrollRecordsTableCompanion(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      userId: userId ?? this.userId,
      month: month ?? this.month,
      year: year ?? this.year,
      netSalary: netSalary ?? this.netSalary,
      grossSalary: grossSalary ?? this.grossSalary,
      deductions: deductions ?? this.deductions,
      allowances: allowances ?? this.allowances,
      status: status ?? this.status,
      payslipUrl: payslipUrl ?? this.payslipUrl,
      detailsJson: detailsJson ?? this.detailsJson,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<int>(tenantId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (netSalary.present) {
      map['net_salary'] = Variable<double>(netSalary.value);
    }
    if (grossSalary.present) {
      map['gross_salary'] = Variable<double>(grossSalary.value);
    }
    if (deductions.present) {
      map['deductions'] = Variable<double>(deductions.value);
    }
    if (allowances.present) {
      map['allowances'] = Variable<double>(allowances.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (payslipUrl.present) {
      map['payslip_url'] = Variable<String>(payslipUrl.value);
    }
    if (detailsJson.present) {
      map['details_json'] = Variable<String>(detailsJson.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PayrollRecordsTableCompanion(')
          ..write('id: $id, ')
          ..write('tenantId: $tenantId, ')
          ..write('userId: $userId, ')
          ..write('month: $month, ')
          ..write('year: $year, ')
          ..write('netSalary: $netSalary, ')
          ..write('grossSalary: $grossSalary, ')
          ..write('deductions: $deductions, ')
          ..write('allowances: $allowances, ')
          ..write('status: $status, ')
          ..write('payslipUrl: $payslipUrl, ')
          ..write('detailsJson: $detailsJson, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DashboardSnapshotsTableTable extends DashboardSnapshotsTable
    with TableInfo<$DashboardSnapshotsTableTable, DashboardSnapshotsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DashboardSnapshotsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<int> tenantId = GeneratedColumn<int>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _snapshotTypeMeta =
      const VerificationMeta('snapshotType');
  @override
  late final GeneratedColumn<String> snapshotType = GeneratedColumn<String>(
      'snapshot_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dataJsonMeta =
      const VerificationMeta('dataJson');
  @override
  late final GeneratedColumn<String> dataJson = GeneratedColumn<String>(
      'data_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fetchedAtMeta =
      const VerificationMeta('fetchedAt');
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
      'fetched_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _expiresAtMeta =
      const VerificationMeta('expiresAt');
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
      'expires_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [tenantId, userId, snapshotType, dataJson, fetchedAt, expiresAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dashboard_snapshots_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<DashboardSnapshotsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('snapshot_type')) {
      context.handle(
          _snapshotTypeMeta,
          snapshotType.isAcceptableOrUnknown(
              data['snapshot_type']!, _snapshotTypeMeta));
    } else if (isInserting) {
      context.missing(_snapshotTypeMeta);
    }
    if (data.containsKey('data_json')) {
      context.handle(_dataJsonMeta,
          dataJson.isAcceptableOrUnknown(data['data_json']!, _dataJsonMeta));
    } else if (isInserting) {
      context.missing(_dataJsonMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(_fetchedAtMeta,
          fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta));
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(_expiresAtMeta,
          expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta));
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tenantId, userId, snapshotType};
  @override
  DashboardSnapshotsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DashboardSnapshotsTableData(
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tenant_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      snapshotType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}snapshot_type'])!,
      dataJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data_json'])!,
      fetchedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fetched_at'])!,
      expiresAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expires_at'])!,
    );
  }

  @override
  $DashboardSnapshotsTableTable createAlias(String alias) {
    return $DashboardSnapshotsTableTable(attachedDatabase, alias);
  }
}

class DashboardSnapshotsTableData extends DataClass
    implements Insertable<DashboardSnapshotsTableData> {
  final int tenantId;
  final int userId;
  final String snapshotType;
  final String dataJson;
  final DateTime fetchedAt;
  final DateTime expiresAt;
  const DashboardSnapshotsTableData(
      {required this.tenantId,
      required this.userId,
      required this.snapshotType,
      required this.dataJson,
      required this.fetchedAt,
      required this.expiresAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['tenant_id'] = Variable<int>(tenantId);
    map['user_id'] = Variable<int>(userId);
    map['snapshot_type'] = Variable<String>(snapshotType);
    map['data_json'] = Variable<String>(dataJson);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    map['expires_at'] = Variable<DateTime>(expiresAt);
    return map;
  }

  DashboardSnapshotsTableCompanion toCompanion(bool nullToAbsent) {
    return DashboardSnapshotsTableCompanion(
      tenantId: Value(tenantId),
      userId: Value(userId),
      snapshotType: Value(snapshotType),
      dataJson: Value(dataJson),
      fetchedAt: Value(fetchedAt),
      expiresAt: Value(expiresAt),
    );
  }

  factory DashboardSnapshotsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DashboardSnapshotsTableData(
      tenantId: serializer.fromJson<int>(json['tenantId']),
      userId: serializer.fromJson<int>(json['userId']),
      snapshotType: serializer.fromJson<String>(json['snapshotType']),
      dataJson: serializer.fromJson<String>(json['dataJson']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
      expiresAt: serializer.fromJson<DateTime>(json['expiresAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tenantId': serializer.toJson<int>(tenantId),
      'userId': serializer.toJson<int>(userId),
      'snapshotType': serializer.toJson<String>(snapshotType),
      'dataJson': serializer.toJson<String>(dataJson),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
      'expiresAt': serializer.toJson<DateTime>(expiresAt),
    };
  }

  DashboardSnapshotsTableData copyWith(
          {int? tenantId,
          int? userId,
          String? snapshotType,
          String? dataJson,
          DateTime? fetchedAt,
          DateTime? expiresAt}) =>
      DashboardSnapshotsTableData(
        tenantId: tenantId ?? this.tenantId,
        userId: userId ?? this.userId,
        snapshotType: snapshotType ?? this.snapshotType,
        dataJson: dataJson ?? this.dataJson,
        fetchedAt: fetchedAt ?? this.fetchedAt,
        expiresAt: expiresAt ?? this.expiresAt,
      );
  DashboardSnapshotsTableData copyWithCompanion(
      DashboardSnapshotsTableCompanion data) {
    return DashboardSnapshotsTableData(
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      userId: data.userId.present ? data.userId.value : this.userId,
      snapshotType: data.snapshotType.present
          ? data.snapshotType.value
          : this.snapshotType,
      dataJson: data.dataJson.present ? data.dataJson.value : this.dataJson,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DashboardSnapshotsTableData(')
          ..write('tenantId: $tenantId, ')
          ..write('userId: $userId, ')
          ..write('snapshotType: $snapshotType, ')
          ..write('dataJson: $dataJson, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      tenantId, userId, snapshotType, dataJson, fetchedAt, expiresAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DashboardSnapshotsTableData &&
          other.tenantId == this.tenantId &&
          other.userId == this.userId &&
          other.snapshotType == this.snapshotType &&
          other.dataJson == this.dataJson &&
          other.fetchedAt == this.fetchedAt &&
          other.expiresAt == this.expiresAt);
}

class DashboardSnapshotsTableCompanion
    extends UpdateCompanion<DashboardSnapshotsTableData> {
  final Value<int> tenantId;
  final Value<int> userId;
  final Value<String> snapshotType;
  final Value<String> dataJson;
  final Value<DateTime> fetchedAt;
  final Value<DateTime> expiresAt;
  final Value<int> rowid;
  const DashboardSnapshotsTableCompanion({
    this.tenantId = const Value.absent(),
    this.userId = const Value.absent(),
    this.snapshotType = const Value.absent(),
    this.dataJson = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DashboardSnapshotsTableCompanion.insert({
    required int tenantId,
    required int userId,
    required String snapshotType,
    required String dataJson,
    required DateTime fetchedAt,
    required DateTime expiresAt,
    this.rowid = const Value.absent(),
  })  : tenantId = Value(tenantId),
        userId = Value(userId),
        snapshotType = Value(snapshotType),
        dataJson = Value(dataJson),
        fetchedAt = Value(fetchedAt),
        expiresAt = Value(expiresAt);
  static Insertable<DashboardSnapshotsTableData> custom({
    Expression<int>? tenantId,
    Expression<int>? userId,
    Expression<String>? snapshotType,
    Expression<String>? dataJson,
    Expression<DateTime>? fetchedAt,
    Expression<DateTime>? expiresAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tenantId != null) 'tenant_id': tenantId,
      if (userId != null) 'user_id': userId,
      if (snapshotType != null) 'snapshot_type': snapshotType,
      if (dataJson != null) 'data_json': dataJson,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DashboardSnapshotsTableCompanion copyWith(
      {Value<int>? tenantId,
      Value<int>? userId,
      Value<String>? snapshotType,
      Value<String>? dataJson,
      Value<DateTime>? fetchedAt,
      Value<DateTime>? expiresAt,
      Value<int>? rowid}) {
    return DashboardSnapshotsTableCompanion(
      tenantId: tenantId ?? this.tenantId,
      userId: userId ?? this.userId,
      snapshotType: snapshotType ?? this.snapshotType,
      dataJson: dataJson ?? this.dataJson,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tenantId.present) {
      map['tenant_id'] = Variable<int>(tenantId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (snapshotType.present) {
      map['snapshot_type'] = Variable<String>(snapshotType.value);
    }
    if (dataJson.present) {
      map['data_json'] = Variable<String>(dataJson.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DashboardSnapshotsTableCompanion(')
          ..write('tenantId: $tenantId, ')
          ..write('userId: $userId, ')
          ..write('snapshotType: $snapshotType, ')
          ..write('dataJson: $dataJson, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserProfilesTableTable extends UserProfilesTable
    with TableInfo<$UserProfilesTableTable, UserProfilesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<int> tenantId = GeneratedColumn<int>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _employeeCodeMeta =
      const VerificationMeta('employeeCode');
  @override
  late final GeneratedColumn<String> employeeCode = GeneratedColumn<String>(
      'employee_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _departmentMeta =
      const VerificationMeta('department');
  @override
  late final GeneratedColumn<String> department = GeneratedColumn<String>(
      'department', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _designationMeta =
      const VerificationMeta('designation');
  @override
  late final GeneratedColumn<String> designation = GeneratedColumn<String>(
      'designation', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _branchNameMeta =
      const VerificationMeta('branchName');
  @override
  late final GeneratedColumn<String> branchName = GeneratedColumn<String>(
      'branch_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _avatarUrlMeta =
      const VerificationMeta('avatarUrl');
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
      'avatar_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _loginTypeMeta =
      const VerificationMeta('loginType');
  @override
  late final GeneratedColumn<String> loginType = GeneratedColumn<String>(
      'login_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rawUserJsonMeta =
      const VerificationMeta('rawUserJson');
  @override
  late final GeneratedColumn<String> rawUserJson = GeneratedColumn<String>(
      'raw_user_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _rawEmployeeJsonMeta =
      const VerificationMeta('rawEmployeeJson');
  @override
  late final GeneratedColumn<String> rawEmployeeJson = GeneratedColumn<String>(
      'raw_employee_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        userId,
        tenantId,
        name,
        email,
        employeeCode,
        role,
        department,
        designation,
        branchName,
        avatarUrl,
        loginType,
        rawUserJson,
        rawEmployeeJson,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<UserProfilesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('employee_code')) {
      context.handle(
          _employeeCodeMeta,
          employeeCode.isAcceptableOrUnknown(
              data['employee_code']!, _employeeCodeMeta));
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('department')) {
      context.handle(
          _departmentMeta,
          department.isAcceptableOrUnknown(
              data['department']!, _departmentMeta));
    }
    if (data.containsKey('designation')) {
      context.handle(
          _designationMeta,
          designation.isAcceptableOrUnknown(
              data['designation']!, _designationMeta));
    }
    if (data.containsKey('branch_name')) {
      context.handle(
          _branchNameMeta,
          branchName.isAcceptableOrUnknown(
              data['branch_name']!, _branchNameMeta));
    }
    if (data.containsKey('avatar_url')) {
      context.handle(_avatarUrlMeta,
          avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta));
    }
    if (data.containsKey('login_type')) {
      context.handle(_loginTypeMeta,
          loginType.isAcceptableOrUnknown(data['login_type']!, _loginTypeMeta));
    } else if (isInserting) {
      context.missing(_loginTypeMeta);
    }
    if (data.containsKey('raw_user_json')) {
      context.handle(
          _rawUserJsonMeta,
          rawUserJson.isAcceptableOrUnknown(
              data['raw_user_json']!, _rawUserJsonMeta));
    }
    if (data.containsKey('raw_employee_json')) {
      context.handle(
          _rawEmployeeJsonMeta,
          rawEmployeeJson.isAcceptableOrUnknown(
              data['raw_employee_json']!, _rawEmployeeJsonMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, tenantId};
  @override
  UserProfilesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfilesTableData(
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tenant_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      employeeCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}employee_code']),
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      department: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}department']),
      designation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}designation']),
      branchName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}branch_name']),
      avatarUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_url']),
      loginType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}login_type'])!,
      rawUserJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}raw_user_json']),
      rawEmployeeJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}raw_employee_json']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $UserProfilesTableTable createAlias(String alias) {
    return $UserProfilesTableTable(attachedDatabase, alias);
  }
}

class UserProfilesTableData extends DataClass
    implements Insertable<UserProfilesTableData> {
  final int userId;
  final int tenantId;
  final String name;
  final String email;
  final String? employeeCode;
  final String role;
  final String? department;
  final String? designation;
  final String? branchName;
  final String? avatarUrl;
  final String loginType;
  final String? rawUserJson;
  final String? rawEmployeeJson;
  final DateTime updatedAt;
  const UserProfilesTableData(
      {required this.userId,
      required this.tenantId,
      required this.name,
      required this.email,
      this.employeeCode,
      required this.role,
      this.department,
      this.designation,
      this.branchName,
      this.avatarUrl,
      required this.loginType,
      this.rawUserJson,
      this.rawEmployeeJson,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<int>(userId);
    map['tenant_id'] = Variable<int>(tenantId);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || employeeCode != null) {
      map['employee_code'] = Variable<String>(employeeCode);
    }
    map['role'] = Variable<String>(role);
    if (!nullToAbsent || department != null) {
      map['department'] = Variable<String>(department);
    }
    if (!nullToAbsent || designation != null) {
      map['designation'] = Variable<String>(designation);
    }
    if (!nullToAbsent || branchName != null) {
      map['branch_name'] = Variable<String>(branchName);
    }
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    map['login_type'] = Variable<String>(loginType);
    if (!nullToAbsent || rawUserJson != null) {
      map['raw_user_json'] = Variable<String>(rawUserJson);
    }
    if (!nullToAbsent || rawEmployeeJson != null) {
      map['raw_employee_json'] = Variable<String>(rawEmployeeJson);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserProfilesTableCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesTableCompanion(
      userId: Value(userId),
      tenantId: Value(tenantId),
      name: Value(name),
      email: Value(email),
      employeeCode: employeeCode == null && nullToAbsent
          ? const Value.absent()
          : Value(employeeCode),
      role: Value(role),
      department: department == null && nullToAbsent
          ? const Value.absent()
          : Value(department),
      designation: designation == null && nullToAbsent
          ? const Value.absent()
          : Value(designation),
      branchName: branchName == null && nullToAbsent
          ? const Value.absent()
          : Value(branchName),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      loginType: Value(loginType),
      rawUserJson: rawUserJson == null && nullToAbsent
          ? const Value.absent()
          : Value(rawUserJson),
      rawEmployeeJson: rawEmployeeJson == null && nullToAbsent
          ? const Value.absent()
          : Value(rawEmployeeJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserProfilesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfilesTableData(
      userId: serializer.fromJson<int>(json['userId']),
      tenantId: serializer.fromJson<int>(json['tenantId']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      employeeCode: serializer.fromJson<String?>(json['employeeCode']),
      role: serializer.fromJson<String>(json['role']),
      department: serializer.fromJson<String?>(json['department']),
      designation: serializer.fromJson<String?>(json['designation']),
      branchName: serializer.fromJson<String?>(json['branchName']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      loginType: serializer.fromJson<String>(json['loginType']),
      rawUserJson: serializer.fromJson<String?>(json['rawUserJson']),
      rawEmployeeJson: serializer.fromJson<String?>(json['rawEmployeeJson']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<int>(userId),
      'tenantId': serializer.toJson<int>(tenantId),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'employeeCode': serializer.toJson<String?>(employeeCode),
      'role': serializer.toJson<String>(role),
      'department': serializer.toJson<String?>(department),
      'designation': serializer.toJson<String?>(designation),
      'branchName': serializer.toJson<String?>(branchName),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'loginType': serializer.toJson<String>(loginType),
      'rawUserJson': serializer.toJson<String?>(rawUserJson),
      'rawEmployeeJson': serializer.toJson<String?>(rawEmployeeJson),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserProfilesTableData copyWith(
          {int? userId,
          int? tenantId,
          String? name,
          String? email,
          Value<String?> employeeCode = const Value.absent(),
          String? role,
          Value<String?> department = const Value.absent(),
          Value<String?> designation = const Value.absent(),
          Value<String?> branchName = const Value.absent(),
          Value<String?> avatarUrl = const Value.absent(),
          String? loginType,
          Value<String?> rawUserJson = const Value.absent(),
          Value<String?> rawEmployeeJson = const Value.absent(),
          DateTime? updatedAt}) =>
      UserProfilesTableData(
        userId: userId ?? this.userId,
        tenantId: tenantId ?? this.tenantId,
        name: name ?? this.name,
        email: email ?? this.email,
        employeeCode:
            employeeCode.present ? employeeCode.value : this.employeeCode,
        role: role ?? this.role,
        department: department.present ? department.value : this.department,
        designation: designation.present ? designation.value : this.designation,
        branchName: branchName.present ? branchName.value : this.branchName,
        avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
        loginType: loginType ?? this.loginType,
        rawUserJson: rawUserJson.present ? rawUserJson.value : this.rawUserJson,
        rawEmployeeJson: rawEmployeeJson.present
            ? rawEmployeeJson.value
            : this.rawEmployeeJson,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  UserProfilesTableData copyWithCompanion(UserProfilesTableCompanion data) {
    return UserProfilesTableData(
      userId: data.userId.present ? data.userId.value : this.userId,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      employeeCode: data.employeeCode.present
          ? data.employeeCode.value
          : this.employeeCode,
      role: data.role.present ? data.role.value : this.role,
      department:
          data.department.present ? data.department.value : this.department,
      designation:
          data.designation.present ? data.designation.value : this.designation,
      branchName:
          data.branchName.present ? data.branchName.value : this.branchName,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      loginType: data.loginType.present ? data.loginType.value : this.loginType,
      rawUserJson:
          data.rawUserJson.present ? data.rawUserJson.value : this.rawUserJson,
      rawEmployeeJson: data.rawEmployeeJson.present
          ? data.rawEmployeeJson.value
          : this.rawEmployeeJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesTableData(')
          ..write('userId: $userId, ')
          ..write('tenantId: $tenantId, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('employeeCode: $employeeCode, ')
          ..write('role: $role, ')
          ..write('department: $department, ')
          ..write('designation: $designation, ')
          ..write('branchName: $branchName, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('loginType: $loginType, ')
          ..write('rawUserJson: $rawUserJson, ')
          ..write('rawEmployeeJson: $rawEmployeeJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      userId,
      tenantId,
      name,
      email,
      employeeCode,
      role,
      department,
      designation,
      branchName,
      avatarUrl,
      loginType,
      rawUserJson,
      rawEmployeeJson,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfilesTableData &&
          other.userId == this.userId &&
          other.tenantId == this.tenantId &&
          other.name == this.name &&
          other.email == this.email &&
          other.employeeCode == this.employeeCode &&
          other.role == this.role &&
          other.department == this.department &&
          other.designation == this.designation &&
          other.branchName == this.branchName &&
          other.avatarUrl == this.avatarUrl &&
          other.loginType == this.loginType &&
          other.rawUserJson == this.rawUserJson &&
          other.rawEmployeeJson == this.rawEmployeeJson &&
          other.updatedAt == this.updatedAt);
}

class UserProfilesTableCompanion
    extends UpdateCompanion<UserProfilesTableData> {
  final Value<int> userId;
  final Value<int> tenantId;
  final Value<String> name;
  final Value<String> email;
  final Value<String?> employeeCode;
  final Value<String> role;
  final Value<String?> department;
  final Value<String?> designation;
  final Value<String?> branchName;
  final Value<String?> avatarUrl;
  final Value<String> loginType;
  final Value<String?> rawUserJson;
  final Value<String?> rawEmployeeJson;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UserProfilesTableCompanion({
    this.userId = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.employeeCode = const Value.absent(),
    this.role = const Value.absent(),
    this.department = const Value.absent(),
    this.designation = const Value.absent(),
    this.branchName = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.loginType = const Value.absent(),
    this.rawUserJson = const Value.absent(),
    this.rawEmployeeJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProfilesTableCompanion.insert({
    required int userId,
    required int tenantId,
    required String name,
    required String email,
    this.employeeCode = const Value.absent(),
    required String role,
    this.department = const Value.absent(),
    this.designation = const Value.absent(),
    this.branchName = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    required String loginType,
    this.rawUserJson = const Value.absent(),
    this.rawEmployeeJson = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : userId = Value(userId),
        tenantId = Value(tenantId),
        name = Value(name),
        email = Value(email),
        role = Value(role),
        loginType = Value(loginType),
        updatedAt = Value(updatedAt);
  static Insertable<UserProfilesTableData> custom({
    Expression<int>? userId,
    Expression<int>? tenantId,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? employeeCode,
    Expression<String>? role,
    Expression<String>? department,
    Expression<String>? designation,
    Expression<String>? branchName,
    Expression<String>? avatarUrl,
    Expression<String>? loginType,
    Expression<String>? rawUserJson,
    Expression<String>? rawEmployeeJson,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (tenantId != null) 'tenant_id': tenantId,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (employeeCode != null) 'employee_code': employeeCode,
      if (role != null) 'role': role,
      if (department != null) 'department': department,
      if (designation != null) 'designation': designation,
      if (branchName != null) 'branch_name': branchName,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (loginType != null) 'login_type': loginType,
      if (rawUserJson != null) 'raw_user_json': rawUserJson,
      if (rawEmployeeJson != null) 'raw_employee_json': rawEmployeeJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProfilesTableCompanion copyWith(
      {Value<int>? userId,
      Value<int>? tenantId,
      Value<String>? name,
      Value<String>? email,
      Value<String?>? employeeCode,
      Value<String>? role,
      Value<String?>? department,
      Value<String?>? designation,
      Value<String?>? branchName,
      Value<String?>? avatarUrl,
      Value<String>? loginType,
      Value<String?>? rawUserJson,
      Value<String?>? rawEmployeeJson,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return UserProfilesTableCompanion(
      userId: userId ?? this.userId,
      tenantId: tenantId ?? this.tenantId,
      name: name ?? this.name,
      email: email ?? this.email,
      employeeCode: employeeCode ?? this.employeeCode,
      role: role ?? this.role,
      department: department ?? this.department,
      designation: designation ?? this.designation,
      branchName: branchName ?? this.branchName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      loginType: loginType ?? this.loginType,
      rawUserJson: rawUserJson ?? this.rawUserJson,
      rawEmployeeJson: rawEmployeeJson ?? this.rawEmployeeJson,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<int>(tenantId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (employeeCode.present) {
      map['employee_code'] = Variable<String>(employeeCode.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (department.present) {
      map['department'] = Variable<String>(department.value);
    }
    if (designation.present) {
      map['designation'] = Variable<String>(designation.value);
    }
    if (branchName.present) {
      map['branch_name'] = Variable<String>(branchName.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (loginType.present) {
      map['login_type'] = Variable<String>(loginType.value);
    }
    if (rawUserJson.present) {
      map['raw_user_json'] = Variable<String>(rawUserJson.value);
    }
    if (rawEmployeeJson.present) {
      map['raw_employee_json'] = Variable<String>(rawEmployeeJson.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesTableCompanion(')
          ..write('userId: $userId, ')
          ..write('tenantId: $tenantId, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('employeeCode: $employeeCode, ')
          ..write('role: $role, ')
          ..write('department: $department, ')
          ..write('designation: $designation, ')
          ..write('branchName: $branchName, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('loginType: $loginType, ')
          ..write('rawUserJson: $rawUserJson, ')
          ..write('rawEmployeeJson: $rawEmployeeJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EntityMappingsTableTable extends EntityMappingsTable
    with TableInfo<$EntityMappingsTableTable, EntityMappingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntityMappingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta =
      const VerificationMeta('localId');
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
      'local_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
      'server_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tenantIdMeta =
      const VerificationMeta('tenantId');
  @override
  late final GeneratedColumn<int> tenantId = GeneratedColumn<int>(
      'tenant_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [localId, serverId, entityType, tenantId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entity_mappings_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<EntityMappingsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(_localIdMeta,
          localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta));
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('tenant_id')) {
      context.handle(_tenantIdMeta,
          tenantId.isAcceptableOrUnknown(data['tenant_id']!, _tenantIdMeta));
    } else if (isInserting) {
      context.missing(_tenantIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  EntityMappingsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntityMappingsTableData(
      localId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_id'])!,
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_id'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      tenantId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tenant_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $EntityMappingsTableTable createAlias(String alias) {
    return $EntityMappingsTableTable(attachedDatabase, alias);
  }
}

class EntityMappingsTableData extends DataClass
    implements Insertable<EntityMappingsTableData> {
  final String localId;
  final int serverId;
  final String entityType;
  final int tenantId;
  final DateTime createdAt;
  const EntityMappingsTableData(
      {required this.localId,
      required this.serverId,
      required this.entityType,
      required this.tenantId,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    map['server_id'] = Variable<int>(serverId);
    map['entity_type'] = Variable<String>(entityType);
    map['tenant_id'] = Variable<int>(tenantId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EntityMappingsTableCompanion toCompanion(bool nullToAbsent) {
    return EntityMappingsTableCompanion(
      localId: Value(localId),
      serverId: Value(serverId),
      entityType: Value(entityType),
      tenantId: Value(tenantId),
      createdAt: Value(createdAt),
    );
  }

  factory EntityMappingsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntityMappingsTableData(
      localId: serializer.fromJson<String>(json['localId']),
      serverId: serializer.fromJson<int>(json['serverId']),
      entityType: serializer.fromJson<String>(json['entityType']),
      tenantId: serializer.fromJson<int>(json['tenantId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'serverId': serializer.toJson<int>(serverId),
      'entityType': serializer.toJson<String>(entityType),
      'tenantId': serializer.toJson<int>(tenantId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  EntityMappingsTableData copyWith(
          {String? localId,
          int? serverId,
          String? entityType,
          int? tenantId,
          DateTime? createdAt}) =>
      EntityMappingsTableData(
        localId: localId ?? this.localId,
        serverId: serverId ?? this.serverId,
        entityType: entityType ?? this.entityType,
        tenantId: tenantId ?? this.tenantId,
        createdAt: createdAt ?? this.createdAt,
      );
  EntityMappingsTableData copyWithCompanion(EntityMappingsTableCompanion data) {
    return EntityMappingsTableData(
      localId: data.localId.present ? data.localId.value : this.localId,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      tenantId: data.tenantId.present ? data.tenantId.value : this.tenantId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntityMappingsTableData(')
          ..write('localId: $localId, ')
          ..write('serverId: $serverId, ')
          ..write('entityType: $entityType, ')
          ..write('tenantId: $tenantId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(localId, serverId, entityType, tenantId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntityMappingsTableData &&
          other.localId == this.localId &&
          other.serverId == this.serverId &&
          other.entityType == this.entityType &&
          other.tenantId == this.tenantId &&
          other.createdAt == this.createdAt);
}

class EntityMappingsTableCompanion
    extends UpdateCompanion<EntityMappingsTableData> {
  final Value<String> localId;
  final Value<int> serverId;
  final Value<String> entityType;
  final Value<int> tenantId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const EntityMappingsTableCompanion({
    this.localId = const Value.absent(),
    this.serverId = const Value.absent(),
    this.entityType = const Value.absent(),
    this.tenantId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EntityMappingsTableCompanion.insert({
    required String localId,
    required int serverId,
    required String entityType,
    required int tenantId,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : localId = Value(localId),
        serverId = Value(serverId),
        entityType = Value(entityType),
        tenantId = Value(tenantId),
        createdAt = Value(createdAt);
  static Insertable<EntityMappingsTableData> custom({
    Expression<String>? localId,
    Expression<int>? serverId,
    Expression<String>? entityType,
    Expression<int>? tenantId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (serverId != null) 'server_id': serverId,
      if (entityType != null) 'entity_type': entityType,
      if (tenantId != null) 'tenant_id': tenantId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EntityMappingsTableCompanion copyWith(
      {Value<String>? localId,
      Value<int>? serverId,
      Value<String>? entityType,
      Value<int>? tenantId,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return EntityMappingsTableCompanion(
      localId: localId ?? this.localId,
      serverId: serverId ?? this.serverId,
      entityType: entityType ?? this.entityType,
      tenantId: tenantId ?? this.tenantId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (tenantId.present) {
      map['tenant_id'] = Variable<int>(tenantId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntityMappingsTableCompanion(')
          ..write('localId: $localId, ')
          ..write('serverId: $serverId, ')
          ..write('entityType: $entityType, ')
          ..write('tenantId: $tenantId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $OfflineOperationsTable offlineOperations =
      $OfflineOperationsTable(this);
  late final $TasksTableTable tasksTable = $TasksTableTable(this);
  late final $AttendanceTableTable attendanceTable =
      $AttendanceTableTable(this);
  late final $TodayAttendanceTableTable todayAttendanceTable =
      $TodayAttendanceTableTable(this);
  late final $TargetsTableTable targetsTable = $TargetsTableTable(this);
  late final $TenantLocationsTableTable tenantLocationsTable =
      $TenantLocationsTableTable(this);
  late final $PayrollRecordsTableTable payrollRecordsTable =
      $PayrollRecordsTableTable(this);
  late final $DashboardSnapshotsTableTable dashboardSnapshotsTable =
      $DashboardSnapshotsTableTable(this);
  late final $UserProfilesTableTable userProfilesTable =
      $UserProfilesTableTable(this);
  late final $EntityMappingsTableTable entityMappingsTable =
      $EntityMappingsTableTable(this);
  late final Index idxOpsStatusTenant = Index('idx_ops_status_tenant',
      'CREATE INDEX idx_ops_status_tenant ON offline_operations (status, tenant_id)');
  late final Index idxOpsNextRetry = Index('idx_ops_next_retry',
      'CREATE INDEX idx_ops_next_retry ON offline_operations (next_retry_at)');
  late final Index idxOpsCreated = Index('idx_ops_created',
      'CREATE INDEX idx_ops_created ON offline_operations (created_at)');
  late final Index idxOpsEntityLocal = Index('idx_ops_entity_local',
      'CREATE INDEX idx_ops_entity_local ON offline_operations (entity_local_id)');
  late final Index idxOpsType = Index('idx_ops_type',
      'CREATE INDEX idx_ops_type ON offline_operations (operation_type)');
  late final Index idxTasksTenantUser = Index('idx_tasks_tenant_user',
      'CREATE INDEX idx_tasks_tenant_user ON tasks_table (tenant_id, user_id)');
  late final Index idxTasksStatus = Index('idx_tasks_status',
      'CREATE INDEX idx_tasks_status ON tasks_table (status)');
  late final Index idxTasksSyncState = Index('idx_tasks_sync_state',
      'CREATE INDEX idx_tasks_sync_state ON tasks_table (sync_state)');
  late final Index idxAttTenantUserDate = Index('idx_att_tenant_user_date',
      'CREATE INDEX idx_att_tenant_user_date ON attendance_table (tenant_id, user_id, date)');
  late final Index idxAttSyncState = Index('idx_att_sync_state',
      'CREATE INDEX idx_att_sync_state ON attendance_table (sync_state)');
  late final Index idxTargetsTenantUser = Index('idx_targets_tenant_user',
      'CREATE INDEX idx_targets_tenant_user ON targets_table (tenant_id, user_id)');
  late final Index idxLocationsTenant = Index('idx_locations_tenant',
      'CREATE INDEX idx_locations_tenant ON tenant_locations_table (tenant_id)');
  late final Index idxPayrollTenantUser = Index('idx_payroll_tenant_user',
      'CREATE INDEX idx_payroll_tenant_user ON payroll_records_table (tenant_id, user_id)');
  late final Index idxMappingsServer = Index('idx_mappings_server',
      'CREATE INDEX idx_mappings_server ON entity_mappings_table (server_id, entity_type, tenant_id)');
  late final OfflineOperationsDao offlineOperationsDao =
      OfflineOperationsDao(this as AppDatabase);
  late final TasksDao tasksDao = TasksDao(this as AppDatabase);
  late final AttendanceDao attendanceDao = AttendanceDao(this as AppDatabase);
  late final TargetsDao targetsDao = TargetsDao(this as AppDatabase);
  late final TenantLocationsDao tenantLocationsDao =
      TenantLocationsDao(this as AppDatabase);
  late final PayrollDao payrollDao = PayrollDao(this as AppDatabase);
  late final DashboardDao dashboardDao = DashboardDao(this as AppDatabase);
  late final UserProfilesDao userProfilesDao =
      UserProfilesDao(this as AppDatabase);
  late final EntityMappingsDao entityMappingsDao =
      EntityMappingsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        offlineOperations,
        tasksTable,
        attendanceTable,
        todayAttendanceTable,
        targetsTable,
        tenantLocationsTable,
        payrollRecordsTable,
        dashboardSnapshotsTable,
        userProfilesTable,
        entityMappingsTable,
        idxOpsStatusTenant,
        idxOpsNextRetry,
        idxOpsCreated,
        idxOpsEntityLocal,
        idxOpsType,
        idxTasksTenantUser,
        idxTasksStatus,
        idxTasksSyncState,
        idxAttTenantUserDate,
        idxAttSyncState,
        idxTargetsTenantUser,
        idxLocationsTenant,
        idxPayrollTenantUser,
        idxMappingsServer
      ];
}

typedef $$OfflineOperationsTableCreateCompanionBuilder
    = OfflineOperationsCompanion Function({
  required String id,
  required int tenantId,
  required int userId,
  required String operationType,
  required String entityType,
  Value<String?> entityLocalId,
  Value<int?> entityServerId,
  required String payload,
  Value<String> status,
  Value<int> priority,
  Value<int> retryCount,
  Value<int> maxRetries,
  Value<DateTime?> nextRetryAt,
  Value<DateTime?> lastAttemptAt,
  Value<String?> lastError,
  Value<String?> errorCode,
  Value<String?> dependsOnOperationId,
  required String idempotencyKey,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> syncedAt,
  Value<int> rowid,
});
typedef $$OfflineOperationsTableUpdateCompanionBuilder
    = OfflineOperationsCompanion Function({
  Value<String> id,
  Value<int> tenantId,
  Value<int> userId,
  Value<String> operationType,
  Value<String> entityType,
  Value<String?> entityLocalId,
  Value<int?> entityServerId,
  Value<String> payload,
  Value<String> status,
  Value<int> priority,
  Value<int> retryCount,
  Value<int> maxRetries,
  Value<DateTime?> nextRetryAt,
  Value<DateTime?> lastAttemptAt,
  Value<String?> lastError,
  Value<String?> errorCode,
  Value<String?> dependsOnOperationId,
  Value<String> idempotencyKey,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> syncedAt,
  Value<int> rowid,
});

class $$OfflineOperationsTableFilterComposer
    extends Composer<_$AppDatabase, $OfflineOperationsTable> {
  $$OfflineOperationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operationType => $composableBuilder(
      column: $table.operationType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityLocalId => $composableBuilder(
      column: $table.entityLocalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get entityServerId => $composableBuilder(
      column: $table.entityServerId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get maxRetries => $composableBuilder(
      column: $table.maxRetries, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextRetryAt => $composableBuilder(
      column: $table.nextRetryAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastAttemptAt => $composableBuilder(
      column: $table.lastAttemptAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get errorCode => $composableBuilder(
      column: $table.errorCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dependsOnOperationId => $composableBuilder(
      column: $table.dependsOnOperationId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));
}

class $$OfflineOperationsTableOrderingComposer
    extends Composer<_$AppDatabase, $OfflineOperationsTable> {
  $$OfflineOperationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operationType => $composableBuilder(
      column: $table.operationType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityLocalId => $composableBuilder(
      column: $table.entityLocalId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get entityServerId => $composableBuilder(
      column: $table.entityServerId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get maxRetries => $composableBuilder(
      column: $table.maxRetries, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextRetryAt => $composableBuilder(
      column: $table.nextRetryAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastAttemptAt => $composableBuilder(
      column: $table.lastAttemptAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get errorCode => $composableBuilder(
      column: $table.errorCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dependsOnOperationId => $composableBuilder(
      column: $table.dependsOnOperationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));
}

class $$OfflineOperationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OfflineOperationsTable> {
  $$OfflineOperationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get operationType => $composableBuilder(
      column: $table.operationType, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get entityLocalId => $composableBuilder(
      column: $table.entityLocalId, builder: (column) => column);

  GeneratedColumn<int> get entityServerId => $composableBuilder(
      column: $table.entityServerId, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => column);

  GeneratedColumn<int> get maxRetries => $composableBuilder(
      column: $table.maxRetries, builder: (column) => column);

  GeneratedColumn<DateTime> get nextRetryAt => $composableBuilder(
      column: $table.nextRetryAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastAttemptAt => $composableBuilder(
      column: $table.lastAttemptAt, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<String> get errorCode =>
      $composableBuilder(column: $table.errorCode, builder: (column) => column);

  GeneratedColumn<String> get dependsOnOperationId => $composableBuilder(
      column: $table.dependsOnOperationId, builder: (column) => column);

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
      column: $table.idempotencyKey, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$OfflineOperationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OfflineOperationsTable,
    OfflineOperation,
    $$OfflineOperationsTableFilterComposer,
    $$OfflineOperationsTableOrderingComposer,
    $$OfflineOperationsTableAnnotationComposer,
    $$OfflineOperationsTableCreateCompanionBuilder,
    $$OfflineOperationsTableUpdateCompanionBuilder,
    (
      OfflineOperation,
      BaseReferences<_$AppDatabase, $OfflineOperationsTable, OfflineOperation>
    ),
    OfflineOperation,
    PrefetchHooks Function()> {
  $$OfflineOperationsTableTableManager(
      _$AppDatabase db, $OfflineOperationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OfflineOperationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OfflineOperationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OfflineOperationsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> tenantId = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<String> operationType = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<String?> entityLocalId = const Value.absent(),
            Value<int?> entityServerId = const Value.absent(),
            Value<String> payload = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> priority = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<int> maxRetries = const Value.absent(),
            Value<DateTime?> nextRetryAt = const Value.absent(),
            Value<DateTime?> lastAttemptAt = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<String?> errorCode = const Value.absent(),
            Value<String?> dependsOnOperationId = const Value.absent(),
            Value<String> idempotencyKey = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OfflineOperationsCompanion(
            id: id,
            tenantId: tenantId,
            userId: userId,
            operationType: operationType,
            entityType: entityType,
            entityLocalId: entityLocalId,
            entityServerId: entityServerId,
            payload: payload,
            status: status,
            priority: priority,
            retryCount: retryCount,
            maxRetries: maxRetries,
            nextRetryAt: nextRetryAt,
            lastAttemptAt: lastAttemptAt,
            lastError: lastError,
            errorCode: errorCode,
            dependsOnOperationId: dependsOnOperationId,
            idempotencyKey: idempotencyKey,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required int tenantId,
            required int userId,
            required String operationType,
            required String entityType,
            Value<String?> entityLocalId = const Value.absent(),
            Value<int?> entityServerId = const Value.absent(),
            required String payload,
            Value<String> status = const Value.absent(),
            Value<int> priority = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<int> maxRetries = const Value.absent(),
            Value<DateTime?> nextRetryAt = const Value.absent(),
            Value<DateTime?> lastAttemptAt = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<String?> errorCode = const Value.absent(),
            Value<String?> dependsOnOperationId = const Value.absent(),
            required String idempotencyKey,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OfflineOperationsCompanion.insert(
            id: id,
            tenantId: tenantId,
            userId: userId,
            operationType: operationType,
            entityType: entityType,
            entityLocalId: entityLocalId,
            entityServerId: entityServerId,
            payload: payload,
            status: status,
            priority: priority,
            retryCount: retryCount,
            maxRetries: maxRetries,
            nextRetryAt: nextRetryAt,
            lastAttemptAt: lastAttemptAt,
            lastError: lastError,
            errorCode: errorCode,
            dependsOnOperationId: dependsOnOperationId,
            idempotencyKey: idempotencyKey,
            createdAt: createdAt,
            updatedAt: updatedAt,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$OfflineOperationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OfflineOperationsTable,
    OfflineOperation,
    $$OfflineOperationsTableFilterComposer,
    $$OfflineOperationsTableOrderingComposer,
    $$OfflineOperationsTableAnnotationComposer,
    $$OfflineOperationsTableCreateCompanionBuilder,
    $$OfflineOperationsTableUpdateCompanionBuilder,
    (
      OfflineOperation,
      BaseReferences<_$AppDatabase, $OfflineOperationsTable, OfflineOperation>
    ),
    OfflineOperation,
    PrefetchHooks Function()>;
typedef $$TasksTableTableCreateCompanionBuilder = TasksTableCompanion Function({
  required String localId,
  Value<int?> serverId,
  required int tenantId,
  required int userId,
  Value<int?> branchId,
  required String taskName,
  Value<String?> description,
  Value<bool> isCompleted,
  Value<String> status,
  Value<bool> completedByMe,
  Value<bool> completedByOther,
  Value<int?> completedBy,
  Value<String?> completedByName,
  Value<String?> completedAt,
  Value<String?> notes,
  Value<String?> managerComment,
  Value<String?> approvedByName,
  Value<String?> approvedAt,
  Value<bool> canToggle,
  Value<String> syncState,
  required DateTime localUpdatedAt,
  Value<DateTime?> serverUpdatedAt,
  Value<int> rowid,
});
typedef $$TasksTableTableUpdateCompanionBuilder = TasksTableCompanion Function({
  Value<String> localId,
  Value<int?> serverId,
  Value<int> tenantId,
  Value<int> userId,
  Value<int?> branchId,
  Value<String> taskName,
  Value<String?> description,
  Value<bool> isCompleted,
  Value<String> status,
  Value<bool> completedByMe,
  Value<bool> completedByOther,
  Value<int?> completedBy,
  Value<String?> completedByName,
  Value<String?> completedAt,
  Value<String?> notes,
  Value<String?> managerComment,
  Value<String?> approvedByName,
  Value<String?> approvedAt,
  Value<bool> canToggle,
  Value<String> syncState,
  Value<DateTime> localUpdatedAt,
  Value<DateTime?> serverUpdatedAt,
  Value<int> rowid,
});

class $$TasksTableTableFilterComposer
    extends Composer<_$AppDatabase, $TasksTableTable> {
  $$TasksTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localId => $composableBuilder(
      column: $table.localId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serverId => $composableBuilder(
      column: $table.serverId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get branchId => $composableBuilder(
      column: $table.branchId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get taskName => $composableBuilder(
      column: $table.taskName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get completedByMe => $composableBuilder(
      column: $table.completedByMe, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get completedByOther => $composableBuilder(
      column: $table.completedByOther,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get completedBy => $composableBuilder(
      column: $table.completedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get completedByName => $composableBuilder(
      column: $table.completedByName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get managerComment => $composableBuilder(
      column: $table.managerComment,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get approvedByName => $composableBuilder(
      column: $table.approvedByName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get approvedAt => $composableBuilder(
      column: $table.approvedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get canToggle => $composableBuilder(
      column: $table.canToggle, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncState => $composableBuilder(
      column: $table.syncState, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnFilters(column));
}

class $$TasksTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTableTable> {
  $$TasksTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localId => $composableBuilder(
      column: $table.localId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serverId => $composableBuilder(
      column: $table.serverId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get branchId => $composableBuilder(
      column: $table.branchId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get taskName => $composableBuilder(
      column: $table.taskName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get completedByMe => $composableBuilder(
      column: $table.completedByMe,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get completedByOther => $composableBuilder(
      column: $table.completedByOther,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get completedBy => $composableBuilder(
      column: $table.completedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get completedByName => $composableBuilder(
      column: $table.completedByName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get managerComment => $composableBuilder(
      column: $table.managerComment,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get approvedByName => $composableBuilder(
      column: $table.approvedByName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get approvedAt => $composableBuilder(
      column: $table.approvedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get canToggle => $composableBuilder(
      column: $table.canToggle, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncState => $composableBuilder(
      column: $table.syncState, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$TasksTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTableTable> {
  $$TasksTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<int> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get branchId =>
      $composableBuilder(column: $table.branchId, builder: (column) => column);

  GeneratedColumn<String> get taskName =>
      $composableBuilder(column: $table.taskName, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get completedByMe => $composableBuilder(
      column: $table.completedByMe, builder: (column) => column);

  GeneratedColumn<bool> get completedByOther => $composableBuilder(
      column: $table.completedByOther, builder: (column) => column);

  GeneratedColumn<int> get completedBy => $composableBuilder(
      column: $table.completedBy, builder: (column) => column);

  GeneratedColumn<String> get completedByName => $composableBuilder(
      column: $table.completedByName, builder: (column) => column);

  GeneratedColumn<String> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get managerComment => $composableBuilder(
      column: $table.managerComment, builder: (column) => column);

  GeneratedColumn<String> get approvedByName => $composableBuilder(
      column: $table.approvedByName, builder: (column) => column);

  GeneratedColumn<String> get approvedAt => $composableBuilder(
      column: $table.approvedAt, builder: (column) => column);

  GeneratedColumn<bool> get canToggle =>
      $composableBuilder(column: $table.canToggle, builder: (column) => column);

  GeneratedColumn<String> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt, builder: (column) => column);
}

class $$TasksTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TasksTableTable,
    TasksTableData,
    $$TasksTableTableFilterComposer,
    $$TasksTableTableOrderingComposer,
    $$TasksTableTableAnnotationComposer,
    $$TasksTableTableCreateCompanionBuilder,
    $$TasksTableTableUpdateCompanionBuilder,
    (
      TasksTableData,
      BaseReferences<_$AppDatabase, $TasksTableTable, TasksTableData>
    ),
    TasksTableData,
    PrefetchHooks Function()> {
  $$TasksTableTableTableManager(_$AppDatabase db, $TasksTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> localId = const Value.absent(),
            Value<int?> serverId = const Value.absent(),
            Value<int> tenantId = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<int?> branchId = const Value.absent(),
            Value<String> taskName = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<bool> completedByMe = const Value.absent(),
            Value<bool> completedByOther = const Value.absent(),
            Value<int?> completedBy = const Value.absent(),
            Value<String?> completedByName = const Value.absent(),
            Value<String?> completedAt = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> managerComment = const Value.absent(),
            Value<String?> approvedByName = const Value.absent(),
            Value<String?> approvedAt = const Value.absent(),
            Value<bool> canToggle = const Value.absent(),
            Value<String> syncState = const Value.absent(),
            Value<DateTime> localUpdatedAt = const Value.absent(),
            Value<DateTime?> serverUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TasksTableCompanion(
            localId: localId,
            serverId: serverId,
            tenantId: tenantId,
            userId: userId,
            branchId: branchId,
            taskName: taskName,
            description: description,
            isCompleted: isCompleted,
            status: status,
            completedByMe: completedByMe,
            completedByOther: completedByOther,
            completedBy: completedBy,
            completedByName: completedByName,
            completedAt: completedAt,
            notes: notes,
            managerComment: managerComment,
            approvedByName: approvedByName,
            approvedAt: approvedAt,
            canToggle: canToggle,
            syncState: syncState,
            localUpdatedAt: localUpdatedAt,
            serverUpdatedAt: serverUpdatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String localId,
            Value<int?> serverId = const Value.absent(),
            required int tenantId,
            required int userId,
            Value<int?> branchId = const Value.absent(),
            required String taskName,
            Value<String?> description = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<bool> completedByMe = const Value.absent(),
            Value<bool> completedByOther = const Value.absent(),
            Value<int?> completedBy = const Value.absent(),
            Value<String?> completedByName = const Value.absent(),
            Value<String?> completedAt = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> managerComment = const Value.absent(),
            Value<String?> approvedByName = const Value.absent(),
            Value<String?> approvedAt = const Value.absent(),
            Value<bool> canToggle = const Value.absent(),
            Value<String> syncState = const Value.absent(),
            required DateTime localUpdatedAt,
            Value<DateTime?> serverUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TasksTableCompanion.insert(
            localId: localId,
            serverId: serverId,
            tenantId: tenantId,
            userId: userId,
            branchId: branchId,
            taskName: taskName,
            description: description,
            isCompleted: isCompleted,
            status: status,
            completedByMe: completedByMe,
            completedByOther: completedByOther,
            completedBy: completedBy,
            completedByName: completedByName,
            completedAt: completedAt,
            notes: notes,
            managerComment: managerComment,
            approvedByName: approvedByName,
            approvedAt: approvedAt,
            canToggle: canToggle,
            syncState: syncState,
            localUpdatedAt: localUpdatedAt,
            serverUpdatedAt: serverUpdatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TasksTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TasksTableTable,
    TasksTableData,
    $$TasksTableTableFilterComposer,
    $$TasksTableTableOrderingComposer,
    $$TasksTableTableAnnotationComposer,
    $$TasksTableTableCreateCompanionBuilder,
    $$TasksTableTableUpdateCompanionBuilder,
    (
      TasksTableData,
      BaseReferences<_$AppDatabase, $TasksTableTable, TasksTableData>
    ),
    TasksTableData,
    PrefetchHooks Function()>;
typedef $$AttendanceTableTableCreateCompanionBuilder = AttendanceTableCompanion
    Function({
  required String localId,
  Value<int?> serverId,
  required int tenantId,
  required int userId,
  required String date,
  Value<String?> clockIn,
  Value<String?> clockOut,
  Value<String> status,
  Value<String?> calculatedStatus,
  Value<bool> isLate,
  Value<bool> isEarly,
  Value<String> totalHours,
  Value<double> totalHoursNumeric,
  Value<String?> breakHours,
  Value<double> breakHoursNumeric,
  Value<String?> overtimeHours,
  Value<double> overtimeHoursNumeric,
  Value<double> overtimeAmount,
  Value<String?> notes,
  Value<String?> checkInLocationJson,
  Value<String?> checkOutLocationJson,
  Value<String?> checkInBranchJson,
  Value<String?> checkOutBranchJson,
  Value<String?> shiftJson,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<double?> accuracy,
  Value<String> syncState,
  required DateTime localUpdatedAt,
  Value<DateTime?> serverUpdatedAt,
  Value<int> rowid,
});
typedef $$AttendanceTableTableUpdateCompanionBuilder = AttendanceTableCompanion
    Function({
  Value<String> localId,
  Value<int?> serverId,
  Value<int> tenantId,
  Value<int> userId,
  Value<String> date,
  Value<String?> clockIn,
  Value<String?> clockOut,
  Value<String> status,
  Value<String?> calculatedStatus,
  Value<bool> isLate,
  Value<bool> isEarly,
  Value<String> totalHours,
  Value<double> totalHoursNumeric,
  Value<String?> breakHours,
  Value<double> breakHoursNumeric,
  Value<String?> overtimeHours,
  Value<double> overtimeHoursNumeric,
  Value<double> overtimeAmount,
  Value<String?> notes,
  Value<String?> checkInLocationJson,
  Value<String?> checkOutLocationJson,
  Value<String?> checkInBranchJson,
  Value<String?> checkOutBranchJson,
  Value<String?> shiftJson,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<double?> accuracy,
  Value<String> syncState,
  Value<DateTime> localUpdatedAt,
  Value<DateTime?> serverUpdatedAt,
  Value<int> rowid,
});

class $$AttendanceTableTableFilterComposer
    extends Composer<_$AppDatabase, $AttendanceTableTable> {
  $$AttendanceTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localId => $composableBuilder(
      column: $table.localId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serverId => $composableBuilder(
      column: $table.serverId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clockIn => $composableBuilder(
      column: $table.clockIn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clockOut => $composableBuilder(
      column: $table.clockOut, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get calculatedStatus => $composableBuilder(
      column: $table.calculatedStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isLate => $composableBuilder(
      column: $table.isLate, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isEarly => $composableBuilder(
      column: $table.isEarly, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get totalHours => $composableBuilder(
      column: $table.totalHours, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalHoursNumeric => $composableBuilder(
      column: $table.totalHoursNumeric,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get breakHours => $composableBuilder(
      column: $table.breakHours, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get breakHoursNumeric => $composableBuilder(
      column: $table.breakHoursNumeric,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get overtimeHours => $composableBuilder(
      column: $table.overtimeHours, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get overtimeHoursNumeric => $composableBuilder(
      column: $table.overtimeHoursNumeric,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get overtimeAmount => $composableBuilder(
      column: $table.overtimeAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get checkInLocationJson => $composableBuilder(
      column: $table.checkInLocationJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get checkOutLocationJson => $composableBuilder(
      column: $table.checkOutLocationJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get checkInBranchJson => $composableBuilder(
      column: $table.checkInBranchJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get checkOutBranchJson => $composableBuilder(
      column: $table.checkOutBranchJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shiftJson => $composableBuilder(
      column: $table.shiftJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get accuracy => $composableBuilder(
      column: $table.accuracy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncState => $composableBuilder(
      column: $table.syncState, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnFilters(column));
}

class $$AttendanceTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AttendanceTableTable> {
  $$AttendanceTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localId => $composableBuilder(
      column: $table.localId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serverId => $composableBuilder(
      column: $table.serverId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clockIn => $composableBuilder(
      column: $table.clockIn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clockOut => $composableBuilder(
      column: $table.clockOut, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get calculatedStatus => $composableBuilder(
      column: $table.calculatedStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isLate => $composableBuilder(
      column: $table.isLate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isEarly => $composableBuilder(
      column: $table.isEarly, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get totalHours => $composableBuilder(
      column: $table.totalHours, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalHoursNumeric => $composableBuilder(
      column: $table.totalHoursNumeric,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get breakHours => $composableBuilder(
      column: $table.breakHours, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get breakHoursNumeric => $composableBuilder(
      column: $table.breakHoursNumeric,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get overtimeHours => $composableBuilder(
      column: $table.overtimeHours,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get overtimeHoursNumeric => $composableBuilder(
      column: $table.overtimeHoursNumeric,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get overtimeAmount => $composableBuilder(
      column: $table.overtimeAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get checkInLocationJson => $composableBuilder(
      column: $table.checkInLocationJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get checkOutLocationJson => $composableBuilder(
      column: $table.checkOutLocationJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get checkInBranchJson => $composableBuilder(
      column: $table.checkInBranchJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get checkOutBranchJson => $composableBuilder(
      column: $table.checkOutBranchJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shiftJson => $composableBuilder(
      column: $table.shiftJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get accuracy => $composableBuilder(
      column: $table.accuracy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncState => $composableBuilder(
      column: $table.syncState, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$AttendanceTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttendanceTableTable> {
  $$AttendanceTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<int> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get clockIn =>
      $composableBuilder(column: $table.clockIn, builder: (column) => column);

  GeneratedColumn<String> get clockOut =>
      $composableBuilder(column: $table.clockOut, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get calculatedStatus => $composableBuilder(
      column: $table.calculatedStatus, builder: (column) => column);

  GeneratedColumn<bool> get isLate =>
      $composableBuilder(column: $table.isLate, builder: (column) => column);

  GeneratedColumn<bool> get isEarly =>
      $composableBuilder(column: $table.isEarly, builder: (column) => column);

  GeneratedColumn<String> get totalHours => $composableBuilder(
      column: $table.totalHours, builder: (column) => column);

  GeneratedColumn<double> get totalHoursNumeric => $composableBuilder(
      column: $table.totalHoursNumeric, builder: (column) => column);

  GeneratedColumn<String> get breakHours => $composableBuilder(
      column: $table.breakHours, builder: (column) => column);

  GeneratedColumn<double> get breakHoursNumeric => $composableBuilder(
      column: $table.breakHoursNumeric, builder: (column) => column);

  GeneratedColumn<String> get overtimeHours => $composableBuilder(
      column: $table.overtimeHours, builder: (column) => column);

  GeneratedColumn<double> get overtimeHoursNumeric => $composableBuilder(
      column: $table.overtimeHoursNumeric, builder: (column) => column);

  GeneratedColumn<double> get overtimeAmount => $composableBuilder(
      column: $table.overtimeAmount, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get checkInLocationJson => $composableBuilder(
      column: $table.checkInLocationJson, builder: (column) => column);

  GeneratedColumn<String> get checkOutLocationJson => $composableBuilder(
      column: $table.checkOutLocationJson, builder: (column) => column);

  GeneratedColumn<String> get checkInBranchJson => $composableBuilder(
      column: $table.checkInBranchJson, builder: (column) => column);

  GeneratedColumn<String> get checkOutBranchJson => $composableBuilder(
      column: $table.checkOutBranchJson, builder: (column) => column);

  GeneratedColumn<String> get shiftJson =>
      $composableBuilder(column: $table.shiftJson, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get accuracy =>
      $composableBuilder(column: $table.accuracy, builder: (column) => column);

  GeneratedColumn<String> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<DateTime> get localUpdatedAt => $composableBuilder(
      column: $table.localUpdatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt, builder: (column) => column);
}

class $$AttendanceTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AttendanceTableTable,
    AttendanceTableData,
    $$AttendanceTableTableFilterComposer,
    $$AttendanceTableTableOrderingComposer,
    $$AttendanceTableTableAnnotationComposer,
    $$AttendanceTableTableCreateCompanionBuilder,
    $$AttendanceTableTableUpdateCompanionBuilder,
    (
      AttendanceTableData,
      BaseReferences<_$AppDatabase, $AttendanceTableTable, AttendanceTableData>
    ),
    AttendanceTableData,
    PrefetchHooks Function()> {
  $$AttendanceTableTableTableManager(
      _$AppDatabase db, $AttendanceTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttendanceTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttendanceTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttendanceTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> localId = const Value.absent(),
            Value<int?> serverId = const Value.absent(),
            Value<int> tenantId = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<String?> clockIn = const Value.absent(),
            Value<String?> clockOut = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> calculatedStatus = const Value.absent(),
            Value<bool> isLate = const Value.absent(),
            Value<bool> isEarly = const Value.absent(),
            Value<String> totalHours = const Value.absent(),
            Value<double> totalHoursNumeric = const Value.absent(),
            Value<String?> breakHours = const Value.absent(),
            Value<double> breakHoursNumeric = const Value.absent(),
            Value<String?> overtimeHours = const Value.absent(),
            Value<double> overtimeHoursNumeric = const Value.absent(),
            Value<double> overtimeAmount = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> checkInLocationJson = const Value.absent(),
            Value<String?> checkOutLocationJson = const Value.absent(),
            Value<String?> checkInBranchJson = const Value.absent(),
            Value<String?> checkOutBranchJson = const Value.absent(),
            Value<String?> shiftJson = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<double?> accuracy = const Value.absent(),
            Value<String> syncState = const Value.absent(),
            Value<DateTime> localUpdatedAt = const Value.absent(),
            Value<DateTime?> serverUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AttendanceTableCompanion(
            localId: localId,
            serverId: serverId,
            tenantId: tenantId,
            userId: userId,
            date: date,
            clockIn: clockIn,
            clockOut: clockOut,
            status: status,
            calculatedStatus: calculatedStatus,
            isLate: isLate,
            isEarly: isEarly,
            totalHours: totalHours,
            totalHoursNumeric: totalHoursNumeric,
            breakHours: breakHours,
            breakHoursNumeric: breakHoursNumeric,
            overtimeHours: overtimeHours,
            overtimeHoursNumeric: overtimeHoursNumeric,
            overtimeAmount: overtimeAmount,
            notes: notes,
            checkInLocationJson: checkInLocationJson,
            checkOutLocationJson: checkOutLocationJson,
            checkInBranchJson: checkInBranchJson,
            checkOutBranchJson: checkOutBranchJson,
            shiftJson: shiftJson,
            latitude: latitude,
            longitude: longitude,
            accuracy: accuracy,
            syncState: syncState,
            localUpdatedAt: localUpdatedAt,
            serverUpdatedAt: serverUpdatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String localId,
            Value<int?> serverId = const Value.absent(),
            required int tenantId,
            required int userId,
            required String date,
            Value<String?> clockIn = const Value.absent(),
            Value<String?> clockOut = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> calculatedStatus = const Value.absent(),
            Value<bool> isLate = const Value.absent(),
            Value<bool> isEarly = const Value.absent(),
            Value<String> totalHours = const Value.absent(),
            Value<double> totalHoursNumeric = const Value.absent(),
            Value<String?> breakHours = const Value.absent(),
            Value<double> breakHoursNumeric = const Value.absent(),
            Value<String?> overtimeHours = const Value.absent(),
            Value<double> overtimeHoursNumeric = const Value.absent(),
            Value<double> overtimeAmount = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> checkInLocationJson = const Value.absent(),
            Value<String?> checkOutLocationJson = const Value.absent(),
            Value<String?> checkInBranchJson = const Value.absent(),
            Value<String?> checkOutBranchJson = const Value.absent(),
            Value<String?> shiftJson = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<double?> accuracy = const Value.absent(),
            Value<String> syncState = const Value.absent(),
            required DateTime localUpdatedAt,
            Value<DateTime?> serverUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AttendanceTableCompanion.insert(
            localId: localId,
            serverId: serverId,
            tenantId: tenantId,
            userId: userId,
            date: date,
            clockIn: clockIn,
            clockOut: clockOut,
            status: status,
            calculatedStatus: calculatedStatus,
            isLate: isLate,
            isEarly: isEarly,
            totalHours: totalHours,
            totalHoursNumeric: totalHoursNumeric,
            breakHours: breakHours,
            breakHoursNumeric: breakHoursNumeric,
            overtimeHours: overtimeHours,
            overtimeHoursNumeric: overtimeHoursNumeric,
            overtimeAmount: overtimeAmount,
            notes: notes,
            checkInLocationJson: checkInLocationJson,
            checkOutLocationJson: checkOutLocationJson,
            checkInBranchJson: checkInBranchJson,
            checkOutBranchJson: checkOutBranchJson,
            shiftJson: shiftJson,
            latitude: latitude,
            longitude: longitude,
            accuracy: accuracy,
            syncState: syncState,
            localUpdatedAt: localUpdatedAt,
            serverUpdatedAt: serverUpdatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AttendanceTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AttendanceTableTable,
    AttendanceTableData,
    $$AttendanceTableTableFilterComposer,
    $$AttendanceTableTableOrderingComposer,
    $$AttendanceTableTableAnnotationComposer,
    $$AttendanceTableTableCreateCompanionBuilder,
    $$AttendanceTableTableUpdateCompanionBuilder,
    (
      AttendanceTableData,
      BaseReferences<_$AppDatabase, $AttendanceTableTable, AttendanceTableData>
    ),
    AttendanceTableData,
    PrefetchHooks Function()>;
typedef $$TodayAttendanceTableTableCreateCompanionBuilder
    = TodayAttendanceTableCompanion Function({
  required int tenantId,
  required int userId,
  required String date,
  Value<bool> isClockedIn,
  Value<bool> canClockIn,
  Value<bool> canClockOut,
  Value<int?> attendanceId,
  Value<String?> clockIn,
  Value<String?> clockOut,
  Value<String> totalHours,
  Value<double> totalHoursNumeric,
  Value<String?> breakHours,
  Value<String?> overtimeHours,
  Value<String> status,
  Value<bool> isWorkingDay,
  Value<bool> isHoliday,
  Value<String?> holidayName,
  Value<bool> isOnLeave,
  Value<bool> isHalfDayLeave,
  Value<String?> leaveTitle,
  Value<String?> checkInLocationJson,
  Value<String?> checkInBranchJson,
  Value<String?> shiftJson,
  Value<String?> workingDaysMapJson,
  required DateTime fetchedAt,
  Value<int> rowid,
});
typedef $$TodayAttendanceTableTableUpdateCompanionBuilder
    = TodayAttendanceTableCompanion Function({
  Value<int> tenantId,
  Value<int> userId,
  Value<String> date,
  Value<bool> isClockedIn,
  Value<bool> canClockIn,
  Value<bool> canClockOut,
  Value<int?> attendanceId,
  Value<String?> clockIn,
  Value<String?> clockOut,
  Value<String> totalHours,
  Value<double> totalHoursNumeric,
  Value<String?> breakHours,
  Value<String?> overtimeHours,
  Value<String> status,
  Value<bool> isWorkingDay,
  Value<bool> isHoliday,
  Value<String?> holidayName,
  Value<bool> isOnLeave,
  Value<bool> isHalfDayLeave,
  Value<String?> leaveTitle,
  Value<String?> checkInLocationJson,
  Value<String?> checkInBranchJson,
  Value<String?> shiftJson,
  Value<String?> workingDaysMapJson,
  Value<DateTime> fetchedAt,
  Value<int> rowid,
});

class $$TodayAttendanceTableTableFilterComposer
    extends Composer<_$AppDatabase, $TodayAttendanceTableTable> {
  $$TodayAttendanceTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isClockedIn => $composableBuilder(
      column: $table.isClockedIn, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get canClockIn => $composableBuilder(
      column: $table.canClockIn, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get canClockOut => $composableBuilder(
      column: $table.canClockOut, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get attendanceId => $composableBuilder(
      column: $table.attendanceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clockIn => $composableBuilder(
      column: $table.clockIn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clockOut => $composableBuilder(
      column: $table.clockOut, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get totalHours => $composableBuilder(
      column: $table.totalHours, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalHoursNumeric => $composableBuilder(
      column: $table.totalHoursNumeric,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get breakHours => $composableBuilder(
      column: $table.breakHours, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get overtimeHours => $composableBuilder(
      column: $table.overtimeHours, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isWorkingDay => $composableBuilder(
      column: $table.isWorkingDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isHoliday => $composableBuilder(
      column: $table.isHoliday, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get holidayName => $composableBuilder(
      column: $table.holidayName, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isOnLeave => $composableBuilder(
      column: $table.isOnLeave, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isHalfDayLeave => $composableBuilder(
      column: $table.isHalfDayLeave,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get leaveTitle => $composableBuilder(
      column: $table.leaveTitle, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get checkInLocationJson => $composableBuilder(
      column: $table.checkInLocationJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get checkInBranchJson => $composableBuilder(
      column: $table.checkInBranchJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shiftJson => $composableBuilder(
      column: $table.shiftJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get workingDaysMapJson => $composableBuilder(
      column: $table.workingDaysMapJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
      column: $table.fetchedAt, builder: (column) => ColumnFilters(column));
}

class $$TodayAttendanceTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TodayAttendanceTableTable> {
  $$TodayAttendanceTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isClockedIn => $composableBuilder(
      column: $table.isClockedIn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get canClockIn => $composableBuilder(
      column: $table.canClockIn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get canClockOut => $composableBuilder(
      column: $table.canClockOut, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get attendanceId => $composableBuilder(
      column: $table.attendanceId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clockIn => $composableBuilder(
      column: $table.clockIn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clockOut => $composableBuilder(
      column: $table.clockOut, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get totalHours => $composableBuilder(
      column: $table.totalHours, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalHoursNumeric => $composableBuilder(
      column: $table.totalHoursNumeric,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get breakHours => $composableBuilder(
      column: $table.breakHours, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get overtimeHours => $composableBuilder(
      column: $table.overtimeHours,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isWorkingDay => $composableBuilder(
      column: $table.isWorkingDay,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isHoliday => $composableBuilder(
      column: $table.isHoliday, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get holidayName => $composableBuilder(
      column: $table.holidayName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isOnLeave => $composableBuilder(
      column: $table.isOnLeave, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isHalfDayLeave => $composableBuilder(
      column: $table.isHalfDayLeave,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get leaveTitle => $composableBuilder(
      column: $table.leaveTitle, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get checkInLocationJson => $composableBuilder(
      column: $table.checkInLocationJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get checkInBranchJson => $composableBuilder(
      column: $table.checkInBranchJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shiftJson => $composableBuilder(
      column: $table.shiftJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get workingDaysMapJson => $composableBuilder(
      column: $table.workingDaysMapJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
      column: $table.fetchedAt, builder: (column) => ColumnOrderings(column));
}

class $$TodayAttendanceTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TodayAttendanceTableTable> {
  $$TodayAttendanceTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get isClockedIn => $composableBuilder(
      column: $table.isClockedIn, builder: (column) => column);

  GeneratedColumn<bool> get canClockIn => $composableBuilder(
      column: $table.canClockIn, builder: (column) => column);

  GeneratedColumn<bool> get canClockOut => $composableBuilder(
      column: $table.canClockOut, builder: (column) => column);

  GeneratedColumn<int> get attendanceId => $composableBuilder(
      column: $table.attendanceId, builder: (column) => column);

  GeneratedColumn<String> get clockIn =>
      $composableBuilder(column: $table.clockIn, builder: (column) => column);

  GeneratedColumn<String> get clockOut =>
      $composableBuilder(column: $table.clockOut, builder: (column) => column);

  GeneratedColumn<String> get totalHours => $composableBuilder(
      column: $table.totalHours, builder: (column) => column);

  GeneratedColumn<double> get totalHoursNumeric => $composableBuilder(
      column: $table.totalHoursNumeric, builder: (column) => column);

  GeneratedColumn<String> get breakHours => $composableBuilder(
      column: $table.breakHours, builder: (column) => column);

  GeneratedColumn<String> get overtimeHours => $composableBuilder(
      column: $table.overtimeHours, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isWorkingDay => $composableBuilder(
      column: $table.isWorkingDay, builder: (column) => column);

  GeneratedColumn<bool> get isHoliday =>
      $composableBuilder(column: $table.isHoliday, builder: (column) => column);

  GeneratedColumn<String> get holidayName => $composableBuilder(
      column: $table.holidayName, builder: (column) => column);

  GeneratedColumn<bool> get isOnLeave =>
      $composableBuilder(column: $table.isOnLeave, builder: (column) => column);

  GeneratedColumn<bool> get isHalfDayLeave => $composableBuilder(
      column: $table.isHalfDayLeave, builder: (column) => column);

  GeneratedColumn<String> get leaveTitle => $composableBuilder(
      column: $table.leaveTitle, builder: (column) => column);

  GeneratedColumn<String> get checkInLocationJson => $composableBuilder(
      column: $table.checkInLocationJson, builder: (column) => column);

  GeneratedColumn<String> get checkInBranchJson => $composableBuilder(
      column: $table.checkInBranchJson, builder: (column) => column);

  GeneratedColumn<String> get shiftJson =>
      $composableBuilder(column: $table.shiftJson, builder: (column) => column);

  GeneratedColumn<String> get workingDaysMapJson => $composableBuilder(
      column: $table.workingDaysMapJson, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$TodayAttendanceTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TodayAttendanceTableTable,
    TodayAttendanceTableData,
    $$TodayAttendanceTableTableFilterComposer,
    $$TodayAttendanceTableTableOrderingComposer,
    $$TodayAttendanceTableTableAnnotationComposer,
    $$TodayAttendanceTableTableCreateCompanionBuilder,
    $$TodayAttendanceTableTableUpdateCompanionBuilder,
    (
      TodayAttendanceTableData,
      BaseReferences<_$AppDatabase, $TodayAttendanceTableTable,
          TodayAttendanceTableData>
    ),
    TodayAttendanceTableData,
    PrefetchHooks Function()> {
  $$TodayAttendanceTableTableTableManager(
      _$AppDatabase db, $TodayAttendanceTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TodayAttendanceTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TodayAttendanceTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TodayAttendanceTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> tenantId = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<bool> isClockedIn = const Value.absent(),
            Value<bool> canClockIn = const Value.absent(),
            Value<bool> canClockOut = const Value.absent(),
            Value<int?> attendanceId = const Value.absent(),
            Value<String?> clockIn = const Value.absent(),
            Value<String?> clockOut = const Value.absent(),
            Value<String> totalHours = const Value.absent(),
            Value<double> totalHoursNumeric = const Value.absent(),
            Value<String?> breakHours = const Value.absent(),
            Value<String?> overtimeHours = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<bool> isWorkingDay = const Value.absent(),
            Value<bool> isHoliday = const Value.absent(),
            Value<String?> holidayName = const Value.absent(),
            Value<bool> isOnLeave = const Value.absent(),
            Value<bool> isHalfDayLeave = const Value.absent(),
            Value<String?> leaveTitle = const Value.absent(),
            Value<String?> checkInLocationJson = const Value.absent(),
            Value<String?> checkInBranchJson = const Value.absent(),
            Value<String?> shiftJson = const Value.absent(),
            Value<String?> workingDaysMapJson = const Value.absent(),
            Value<DateTime> fetchedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TodayAttendanceTableCompanion(
            tenantId: tenantId,
            userId: userId,
            date: date,
            isClockedIn: isClockedIn,
            canClockIn: canClockIn,
            canClockOut: canClockOut,
            attendanceId: attendanceId,
            clockIn: clockIn,
            clockOut: clockOut,
            totalHours: totalHours,
            totalHoursNumeric: totalHoursNumeric,
            breakHours: breakHours,
            overtimeHours: overtimeHours,
            status: status,
            isWorkingDay: isWorkingDay,
            isHoliday: isHoliday,
            holidayName: holidayName,
            isOnLeave: isOnLeave,
            isHalfDayLeave: isHalfDayLeave,
            leaveTitle: leaveTitle,
            checkInLocationJson: checkInLocationJson,
            checkInBranchJson: checkInBranchJson,
            shiftJson: shiftJson,
            workingDaysMapJson: workingDaysMapJson,
            fetchedAt: fetchedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int tenantId,
            required int userId,
            required String date,
            Value<bool> isClockedIn = const Value.absent(),
            Value<bool> canClockIn = const Value.absent(),
            Value<bool> canClockOut = const Value.absent(),
            Value<int?> attendanceId = const Value.absent(),
            Value<String?> clockIn = const Value.absent(),
            Value<String?> clockOut = const Value.absent(),
            Value<String> totalHours = const Value.absent(),
            Value<double> totalHoursNumeric = const Value.absent(),
            Value<String?> breakHours = const Value.absent(),
            Value<String?> overtimeHours = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<bool> isWorkingDay = const Value.absent(),
            Value<bool> isHoliday = const Value.absent(),
            Value<String?> holidayName = const Value.absent(),
            Value<bool> isOnLeave = const Value.absent(),
            Value<bool> isHalfDayLeave = const Value.absent(),
            Value<String?> leaveTitle = const Value.absent(),
            Value<String?> checkInLocationJson = const Value.absent(),
            Value<String?> checkInBranchJson = const Value.absent(),
            Value<String?> shiftJson = const Value.absent(),
            Value<String?> workingDaysMapJson = const Value.absent(),
            required DateTime fetchedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              TodayAttendanceTableCompanion.insert(
            tenantId: tenantId,
            userId: userId,
            date: date,
            isClockedIn: isClockedIn,
            canClockIn: canClockIn,
            canClockOut: canClockOut,
            attendanceId: attendanceId,
            clockIn: clockIn,
            clockOut: clockOut,
            totalHours: totalHours,
            totalHoursNumeric: totalHoursNumeric,
            breakHours: breakHours,
            overtimeHours: overtimeHours,
            status: status,
            isWorkingDay: isWorkingDay,
            isHoliday: isHoliday,
            holidayName: holidayName,
            isOnLeave: isOnLeave,
            isHalfDayLeave: isHalfDayLeave,
            leaveTitle: leaveTitle,
            checkInLocationJson: checkInLocationJson,
            checkInBranchJson: checkInBranchJson,
            shiftJson: shiftJson,
            workingDaysMapJson: workingDaysMapJson,
            fetchedAt: fetchedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TodayAttendanceTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $TodayAttendanceTableTable,
        TodayAttendanceTableData,
        $$TodayAttendanceTableTableFilterComposer,
        $$TodayAttendanceTableTableOrderingComposer,
        $$TodayAttendanceTableTableAnnotationComposer,
        $$TodayAttendanceTableTableCreateCompanionBuilder,
        $$TodayAttendanceTableTableUpdateCompanionBuilder,
        (
          TodayAttendanceTableData,
          BaseReferences<_$AppDatabase, $TodayAttendanceTableTable,
              TodayAttendanceTableData>
        ),
        TodayAttendanceTableData,
        PrefetchHooks Function()>;
typedef $$TargetsTableTableCreateCompanionBuilder = TargetsTableCompanion
    Function({
  required String localId,
  Value<int?> serverId,
  required int tenantId,
  required int userId,
  required String title,
  required String targetType,
  required double targetValue,
  required double achievedValue,
  required double progress,
  Value<String?> unit,
  Value<String?> startDate,
  Value<String?> endDate,
  required String status,
  Value<String?> notes,
  Value<String> syncState,
  required DateTime fetchedAt,
  Value<int> rowid,
});
typedef $$TargetsTableTableUpdateCompanionBuilder = TargetsTableCompanion
    Function({
  Value<String> localId,
  Value<int?> serverId,
  Value<int> tenantId,
  Value<int> userId,
  Value<String> title,
  Value<String> targetType,
  Value<double> targetValue,
  Value<double> achievedValue,
  Value<double> progress,
  Value<String?> unit,
  Value<String?> startDate,
  Value<String?> endDate,
  Value<String> status,
  Value<String?> notes,
  Value<String> syncState,
  Value<DateTime> fetchedAt,
  Value<int> rowid,
});

class $$TargetsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TargetsTableTable> {
  $$TargetsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localId => $composableBuilder(
      column: $table.localId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serverId => $composableBuilder(
      column: $table.serverId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetType => $composableBuilder(
      column: $table.targetType, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get targetValue => $composableBuilder(
      column: $table.targetValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get achievedValue => $composableBuilder(
      column: $table.achievedValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get progress => $composableBuilder(
      column: $table.progress, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncState => $composableBuilder(
      column: $table.syncState, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
      column: $table.fetchedAt, builder: (column) => ColumnFilters(column));
}

class $$TargetsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TargetsTableTable> {
  $$TargetsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localId => $composableBuilder(
      column: $table.localId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serverId => $composableBuilder(
      column: $table.serverId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetType => $composableBuilder(
      column: $table.targetType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get targetValue => $composableBuilder(
      column: $table.targetValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get achievedValue => $composableBuilder(
      column: $table.achievedValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get progress => $composableBuilder(
      column: $table.progress, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncState => $composableBuilder(
      column: $table.syncState, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
      column: $table.fetchedAt, builder: (column) => ColumnOrderings(column));
}

class $$TargetsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TargetsTableTable> {
  $$TargetsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<int> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get targetType => $composableBuilder(
      column: $table.targetType, builder: (column) => column);

  GeneratedColumn<double> get targetValue => $composableBuilder(
      column: $table.targetValue, builder: (column) => column);

  GeneratedColumn<double> get achievedValue => $composableBuilder(
      column: $table.achievedValue, builder: (column) => column);

  GeneratedColumn<double> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$TargetsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TargetsTableTable,
    TargetsTableData,
    $$TargetsTableTableFilterComposer,
    $$TargetsTableTableOrderingComposer,
    $$TargetsTableTableAnnotationComposer,
    $$TargetsTableTableCreateCompanionBuilder,
    $$TargetsTableTableUpdateCompanionBuilder,
    (
      TargetsTableData,
      BaseReferences<_$AppDatabase, $TargetsTableTable, TargetsTableData>
    ),
    TargetsTableData,
    PrefetchHooks Function()> {
  $$TargetsTableTableTableManager(_$AppDatabase db, $TargetsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TargetsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TargetsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TargetsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> localId = const Value.absent(),
            Value<int?> serverId = const Value.absent(),
            Value<int> tenantId = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> targetType = const Value.absent(),
            Value<double> targetValue = const Value.absent(),
            Value<double> achievedValue = const Value.absent(),
            Value<double> progress = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<String?> startDate = const Value.absent(),
            Value<String?> endDate = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> syncState = const Value.absent(),
            Value<DateTime> fetchedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TargetsTableCompanion(
            localId: localId,
            serverId: serverId,
            tenantId: tenantId,
            userId: userId,
            title: title,
            targetType: targetType,
            targetValue: targetValue,
            achievedValue: achievedValue,
            progress: progress,
            unit: unit,
            startDate: startDate,
            endDate: endDate,
            status: status,
            notes: notes,
            syncState: syncState,
            fetchedAt: fetchedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String localId,
            Value<int?> serverId = const Value.absent(),
            required int tenantId,
            required int userId,
            required String title,
            required String targetType,
            required double targetValue,
            required double achievedValue,
            required double progress,
            Value<String?> unit = const Value.absent(),
            Value<String?> startDate = const Value.absent(),
            Value<String?> endDate = const Value.absent(),
            required String status,
            Value<String?> notes = const Value.absent(),
            Value<String> syncState = const Value.absent(),
            required DateTime fetchedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              TargetsTableCompanion.insert(
            localId: localId,
            serverId: serverId,
            tenantId: tenantId,
            userId: userId,
            title: title,
            targetType: targetType,
            targetValue: targetValue,
            achievedValue: achievedValue,
            progress: progress,
            unit: unit,
            startDate: startDate,
            endDate: endDate,
            status: status,
            notes: notes,
            syncState: syncState,
            fetchedAt: fetchedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TargetsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TargetsTableTable,
    TargetsTableData,
    $$TargetsTableTableFilterComposer,
    $$TargetsTableTableOrderingComposer,
    $$TargetsTableTableAnnotationComposer,
    $$TargetsTableTableCreateCompanionBuilder,
    $$TargetsTableTableUpdateCompanionBuilder,
    (
      TargetsTableData,
      BaseReferences<_$AppDatabase, $TargetsTableTable, TargetsTableData>
    ),
    TargetsTableData,
    PrefetchHooks Function()>;
typedef $$TenantLocationsTableTableCreateCompanionBuilder
    = TenantLocationsTableCompanion Function({
  required int id,
  required int tenantId,
  required String locationName,
  Value<String?> address,
  required double latitude,
  required double longitude,
  required double radiusMeters,
  Value<bool> isActive,
  required DateTime fetchedAt,
  Value<int> rowid,
});
typedef $$TenantLocationsTableTableUpdateCompanionBuilder
    = TenantLocationsTableCompanion Function({
  Value<int> id,
  Value<int> tenantId,
  Value<String> locationName,
  Value<String?> address,
  Value<double> latitude,
  Value<double> longitude,
  Value<double> radiusMeters,
  Value<bool> isActive,
  Value<DateTime> fetchedAt,
  Value<int> rowid,
});

class $$TenantLocationsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TenantLocationsTableTable> {
  $$TenantLocationsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get locationName => $composableBuilder(
      column: $table.locationName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get radiusMeters => $composableBuilder(
      column: $table.radiusMeters, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
      column: $table.fetchedAt, builder: (column) => ColumnFilters(column));
}

class $$TenantLocationsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TenantLocationsTableTable> {
  $$TenantLocationsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get locationName => $composableBuilder(
      column: $table.locationName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get radiusMeters => $composableBuilder(
      column: $table.radiusMeters,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
      column: $table.fetchedAt, builder: (column) => ColumnOrderings(column));
}

class $$TenantLocationsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TenantLocationsTableTable> {
  $$TenantLocationsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get locationName => $composableBuilder(
      column: $table.locationName, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get radiusMeters => $composableBuilder(
      column: $table.radiusMeters, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$TenantLocationsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TenantLocationsTableTable,
    TenantLocationsTableData,
    $$TenantLocationsTableTableFilterComposer,
    $$TenantLocationsTableTableOrderingComposer,
    $$TenantLocationsTableTableAnnotationComposer,
    $$TenantLocationsTableTableCreateCompanionBuilder,
    $$TenantLocationsTableTableUpdateCompanionBuilder,
    (
      TenantLocationsTableData,
      BaseReferences<_$AppDatabase, $TenantLocationsTableTable,
          TenantLocationsTableData>
    ),
    TenantLocationsTableData,
    PrefetchHooks Function()> {
  $$TenantLocationsTableTableTableManager(
      _$AppDatabase db, $TenantLocationsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TenantLocationsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TenantLocationsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TenantLocationsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> tenantId = const Value.absent(),
            Value<String> locationName = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<double> latitude = const Value.absent(),
            Value<double> longitude = const Value.absent(),
            Value<double> radiusMeters = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> fetchedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TenantLocationsTableCompanion(
            id: id,
            tenantId: tenantId,
            locationName: locationName,
            address: address,
            latitude: latitude,
            longitude: longitude,
            radiusMeters: radiusMeters,
            isActive: isActive,
            fetchedAt: fetchedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int id,
            required int tenantId,
            required String locationName,
            Value<String?> address = const Value.absent(),
            required double latitude,
            required double longitude,
            required double radiusMeters,
            Value<bool> isActive = const Value.absent(),
            required DateTime fetchedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              TenantLocationsTableCompanion.insert(
            id: id,
            tenantId: tenantId,
            locationName: locationName,
            address: address,
            latitude: latitude,
            longitude: longitude,
            radiusMeters: radiusMeters,
            isActive: isActive,
            fetchedAt: fetchedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TenantLocationsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $TenantLocationsTableTable,
        TenantLocationsTableData,
        $$TenantLocationsTableTableFilterComposer,
        $$TenantLocationsTableTableOrderingComposer,
        $$TenantLocationsTableTableAnnotationComposer,
        $$TenantLocationsTableTableCreateCompanionBuilder,
        $$TenantLocationsTableTableUpdateCompanionBuilder,
        (
          TenantLocationsTableData,
          BaseReferences<_$AppDatabase, $TenantLocationsTableTable,
              TenantLocationsTableData>
        ),
        TenantLocationsTableData,
        PrefetchHooks Function()>;
typedef $$PayrollRecordsTableTableCreateCompanionBuilder
    = PayrollRecordsTableCompanion Function({
  required int id,
  required int tenantId,
  required int userId,
  required int month,
  required int year,
  required double netSalary,
  required double grossSalary,
  required double deductions,
  required double allowances,
  required String status,
  Value<String?> payslipUrl,
  Value<String?> detailsJson,
  required DateTime fetchedAt,
  Value<DateTime?> expiresAt,
  Value<int> rowid,
});
typedef $$PayrollRecordsTableTableUpdateCompanionBuilder
    = PayrollRecordsTableCompanion Function({
  Value<int> id,
  Value<int> tenantId,
  Value<int> userId,
  Value<int> month,
  Value<int> year,
  Value<double> netSalary,
  Value<double> grossSalary,
  Value<double> deductions,
  Value<double> allowances,
  Value<String> status,
  Value<String?> payslipUrl,
  Value<String?> detailsJson,
  Value<DateTime> fetchedAt,
  Value<DateTime?> expiresAt,
  Value<int> rowid,
});

class $$PayrollRecordsTableTableFilterComposer
    extends Composer<_$AppDatabase, $PayrollRecordsTableTable> {
  $$PayrollRecordsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get month => $composableBuilder(
      column: $table.month, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get netSalary => $composableBuilder(
      column: $table.netSalary, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get grossSalary => $composableBuilder(
      column: $table.grossSalary, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get deductions => $composableBuilder(
      column: $table.deductions, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get allowances => $composableBuilder(
      column: $table.allowances, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payslipUrl => $composableBuilder(
      column: $table.payslipUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get detailsJson => $composableBuilder(
      column: $table.detailsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
      column: $table.fetchedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnFilters(column));
}

class $$PayrollRecordsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PayrollRecordsTableTable> {
  $$PayrollRecordsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get month => $composableBuilder(
      column: $table.month, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get netSalary => $composableBuilder(
      column: $table.netSalary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get grossSalary => $composableBuilder(
      column: $table.grossSalary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get deductions => $composableBuilder(
      column: $table.deductions, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get allowances => $composableBuilder(
      column: $table.allowances, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payslipUrl => $composableBuilder(
      column: $table.payslipUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get detailsJson => $composableBuilder(
      column: $table.detailsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
      column: $table.fetchedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnOrderings(column));
}

class $$PayrollRecordsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PayrollRecordsTableTable> {
  $$PayrollRecordsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<double> get netSalary =>
      $composableBuilder(column: $table.netSalary, builder: (column) => column);

  GeneratedColumn<double> get grossSalary => $composableBuilder(
      column: $table.grossSalary, builder: (column) => column);

  GeneratedColumn<double> get deductions => $composableBuilder(
      column: $table.deductions, builder: (column) => column);

  GeneratedColumn<double> get allowances => $composableBuilder(
      column: $table.allowances, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get payslipUrl => $composableBuilder(
      column: $table.payslipUrl, builder: (column) => column);

  GeneratedColumn<String> get detailsJson => $composableBuilder(
      column: $table.detailsJson, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);
}

class $$PayrollRecordsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PayrollRecordsTableTable,
    PayrollRecordsTableData,
    $$PayrollRecordsTableTableFilterComposer,
    $$PayrollRecordsTableTableOrderingComposer,
    $$PayrollRecordsTableTableAnnotationComposer,
    $$PayrollRecordsTableTableCreateCompanionBuilder,
    $$PayrollRecordsTableTableUpdateCompanionBuilder,
    (
      PayrollRecordsTableData,
      BaseReferences<_$AppDatabase, $PayrollRecordsTableTable,
          PayrollRecordsTableData>
    ),
    PayrollRecordsTableData,
    PrefetchHooks Function()> {
  $$PayrollRecordsTableTableTableManager(
      _$AppDatabase db, $PayrollRecordsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PayrollRecordsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PayrollRecordsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PayrollRecordsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> tenantId = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<int> month = const Value.absent(),
            Value<int> year = const Value.absent(),
            Value<double> netSalary = const Value.absent(),
            Value<double> grossSalary = const Value.absent(),
            Value<double> deductions = const Value.absent(),
            Value<double> allowances = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> payslipUrl = const Value.absent(),
            Value<String?> detailsJson = const Value.absent(),
            Value<DateTime> fetchedAt = const Value.absent(),
            Value<DateTime?> expiresAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PayrollRecordsTableCompanion(
            id: id,
            tenantId: tenantId,
            userId: userId,
            month: month,
            year: year,
            netSalary: netSalary,
            grossSalary: grossSalary,
            deductions: deductions,
            allowances: allowances,
            status: status,
            payslipUrl: payslipUrl,
            detailsJson: detailsJson,
            fetchedAt: fetchedAt,
            expiresAt: expiresAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int id,
            required int tenantId,
            required int userId,
            required int month,
            required int year,
            required double netSalary,
            required double grossSalary,
            required double deductions,
            required double allowances,
            required String status,
            Value<String?> payslipUrl = const Value.absent(),
            Value<String?> detailsJson = const Value.absent(),
            required DateTime fetchedAt,
            Value<DateTime?> expiresAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PayrollRecordsTableCompanion.insert(
            id: id,
            tenantId: tenantId,
            userId: userId,
            month: month,
            year: year,
            netSalary: netSalary,
            grossSalary: grossSalary,
            deductions: deductions,
            allowances: allowances,
            status: status,
            payslipUrl: payslipUrl,
            detailsJson: detailsJson,
            fetchedAt: fetchedAt,
            expiresAt: expiresAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PayrollRecordsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PayrollRecordsTableTable,
    PayrollRecordsTableData,
    $$PayrollRecordsTableTableFilterComposer,
    $$PayrollRecordsTableTableOrderingComposer,
    $$PayrollRecordsTableTableAnnotationComposer,
    $$PayrollRecordsTableTableCreateCompanionBuilder,
    $$PayrollRecordsTableTableUpdateCompanionBuilder,
    (
      PayrollRecordsTableData,
      BaseReferences<_$AppDatabase, $PayrollRecordsTableTable,
          PayrollRecordsTableData>
    ),
    PayrollRecordsTableData,
    PrefetchHooks Function()>;
typedef $$DashboardSnapshotsTableTableCreateCompanionBuilder
    = DashboardSnapshotsTableCompanion Function({
  required int tenantId,
  required int userId,
  required String snapshotType,
  required String dataJson,
  required DateTime fetchedAt,
  required DateTime expiresAt,
  Value<int> rowid,
});
typedef $$DashboardSnapshotsTableTableUpdateCompanionBuilder
    = DashboardSnapshotsTableCompanion Function({
  Value<int> tenantId,
  Value<int> userId,
  Value<String> snapshotType,
  Value<String> dataJson,
  Value<DateTime> fetchedAt,
  Value<DateTime> expiresAt,
  Value<int> rowid,
});

class $$DashboardSnapshotsTableTableFilterComposer
    extends Composer<_$AppDatabase, $DashboardSnapshotsTableTable> {
  $$DashboardSnapshotsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get snapshotType => $composableBuilder(
      column: $table.snapshotType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dataJson => $composableBuilder(
      column: $table.dataJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
      column: $table.fetchedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnFilters(column));
}

class $$DashboardSnapshotsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DashboardSnapshotsTableTable> {
  $$DashboardSnapshotsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get snapshotType => $composableBuilder(
      column: $table.snapshotType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dataJson => $composableBuilder(
      column: $table.dataJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
      column: $table.fetchedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnOrderings(column));
}

class $$DashboardSnapshotsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DashboardSnapshotsTableTable> {
  $$DashboardSnapshotsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get snapshotType => $composableBuilder(
      column: $table.snapshotType, builder: (column) => column);

  GeneratedColumn<String> get dataJson =>
      $composableBuilder(column: $table.dataJson, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);
}

class $$DashboardSnapshotsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DashboardSnapshotsTableTable,
    DashboardSnapshotsTableData,
    $$DashboardSnapshotsTableTableFilterComposer,
    $$DashboardSnapshotsTableTableOrderingComposer,
    $$DashboardSnapshotsTableTableAnnotationComposer,
    $$DashboardSnapshotsTableTableCreateCompanionBuilder,
    $$DashboardSnapshotsTableTableUpdateCompanionBuilder,
    (
      DashboardSnapshotsTableData,
      BaseReferences<_$AppDatabase, $DashboardSnapshotsTableTable,
          DashboardSnapshotsTableData>
    ),
    DashboardSnapshotsTableData,
    PrefetchHooks Function()> {
  $$DashboardSnapshotsTableTableTableManager(
      _$AppDatabase db, $DashboardSnapshotsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DashboardSnapshotsTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$DashboardSnapshotsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DashboardSnapshotsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> tenantId = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<String> snapshotType = const Value.absent(),
            Value<String> dataJson = const Value.absent(),
            Value<DateTime> fetchedAt = const Value.absent(),
            Value<DateTime> expiresAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DashboardSnapshotsTableCompanion(
            tenantId: tenantId,
            userId: userId,
            snapshotType: snapshotType,
            dataJson: dataJson,
            fetchedAt: fetchedAt,
            expiresAt: expiresAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int tenantId,
            required int userId,
            required String snapshotType,
            required String dataJson,
            required DateTime fetchedAt,
            required DateTime expiresAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              DashboardSnapshotsTableCompanion.insert(
            tenantId: tenantId,
            userId: userId,
            snapshotType: snapshotType,
            dataJson: dataJson,
            fetchedAt: fetchedAt,
            expiresAt: expiresAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DashboardSnapshotsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $DashboardSnapshotsTableTable,
        DashboardSnapshotsTableData,
        $$DashboardSnapshotsTableTableFilterComposer,
        $$DashboardSnapshotsTableTableOrderingComposer,
        $$DashboardSnapshotsTableTableAnnotationComposer,
        $$DashboardSnapshotsTableTableCreateCompanionBuilder,
        $$DashboardSnapshotsTableTableUpdateCompanionBuilder,
        (
          DashboardSnapshotsTableData,
          BaseReferences<_$AppDatabase, $DashboardSnapshotsTableTable,
              DashboardSnapshotsTableData>
        ),
        DashboardSnapshotsTableData,
        PrefetchHooks Function()>;
typedef $$UserProfilesTableTableCreateCompanionBuilder
    = UserProfilesTableCompanion Function({
  required int userId,
  required int tenantId,
  required String name,
  required String email,
  Value<String?> employeeCode,
  required String role,
  Value<String?> department,
  Value<String?> designation,
  Value<String?> branchName,
  Value<String?> avatarUrl,
  required String loginType,
  Value<String?> rawUserJson,
  Value<String?> rawEmployeeJson,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$UserProfilesTableTableUpdateCompanionBuilder
    = UserProfilesTableCompanion Function({
  Value<int> userId,
  Value<int> tenantId,
  Value<String> name,
  Value<String> email,
  Value<String?> employeeCode,
  Value<String> role,
  Value<String?> department,
  Value<String?> designation,
  Value<String?> branchName,
  Value<String?> avatarUrl,
  Value<String> loginType,
  Value<String?> rawUserJson,
  Value<String?> rawEmployeeJson,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$UserProfilesTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTableTable> {
  $$UserProfilesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get employeeCode => $composableBuilder(
      column: $table.employeeCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get department => $composableBuilder(
      column: $table.department, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get designation => $composableBuilder(
      column: $table.designation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get branchName => $composableBuilder(
      column: $table.branchName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatarUrl => $composableBuilder(
      column: $table.avatarUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get loginType => $composableBuilder(
      column: $table.loginType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rawUserJson => $composableBuilder(
      column: $table.rawUserJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rawEmployeeJson => $composableBuilder(
      column: $table.rawEmployeeJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$UserProfilesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTableTable> {
  $$UserProfilesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get employeeCode => $composableBuilder(
      column: $table.employeeCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get department => $composableBuilder(
      column: $table.department, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get designation => $composableBuilder(
      column: $table.designation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get branchName => $composableBuilder(
      column: $table.branchName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
      column: $table.avatarUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get loginType => $composableBuilder(
      column: $table.loginType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rawUserJson => $composableBuilder(
      column: $table.rawUserJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rawEmployeeJson => $composableBuilder(
      column: $table.rawEmployeeJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$UserProfilesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTableTable> {
  $$UserProfilesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get employeeCode => $composableBuilder(
      column: $table.employeeCode, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get department => $composableBuilder(
      column: $table.department, builder: (column) => column);

  GeneratedColumn<String> get designation => $composableBuilder(
      column: $table.designation, builder: (column) => column);

  GeneratedColumn<String> get branchName => $composableBuilder(
      column: $table.branchName, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<String> get loginType =>
      $composableBuilder(column: $table.loginType, builder: (column) => column);

  GeneratedColumn<String> get rawUserJson => $composableBuilder(
      column: $table.rawUserJson, builder: (column) => column);

  GeneratedColumn<String> get rawEmployeeJson => $composableBuilder(
      column: $table.rawEmployeeJson, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserProfilesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserProfilesTableTable,
    UserProfilesTableData,
    $$UserProfilesTableTableFilterComposer,
    $$UserProfilesTableTableOrderingComposer,
    $$UserProfilesTableTableAnnotationComposer,
    $$UserProfilesTableTableCreateCompanionBuilder,
    $$UserProfilesTableTableUpdateCompanionBuilder,
    (
      UserProfilesTableData,
      BaseReferences<_$AppDatabase, $UserProfilesTableTable,
          UserProfilesTableData>
    ),
    UserProfilesTableData,
    PrefetchHooks Function()> {
  $$UserProfilesTableTableTableManager(
      _$AppDatabase db, $UserProfilesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> userId = const Value.absent(),
            Value<int> tenantId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String?> employeeCode = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String?> department = const Value.absent(),
            Value<String?> designation = const Value.absent(),
            Value<String?> branchName = const Value.absent(),
            Value<String?> avatarUrl = const Value.absent(),
            Value<String> loginType = const Value.absent(),
            Value<String?> rawUserJson = const Value.absent(),
            Value<String?> rawEmployeeJson = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserProfilesTableCompanion(
            userId: userId,
            tenantId: tenantId,
            name: name,
            email: email,
            employeeCode: employeeCode,
            role: role,
            department: department,
            designation: designation,
            branchName: branchName,
            avatarUrl: avatarUrl,
            loginType: loginType,
            rawUserJson: rawUserJson,
            rawEmployeeJson: rawEmployeeJson,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int userId,
            required int tenantId,
            required String name,
            required String email,
            Value<String?> employeeCode = const Value.absent(),
            required String role,
            Value<String?> department = const Value.absent(),
            Value<String?> designation = const Value.absent(),
            Value<String?> branchName = const Value.absent(),
            Value<String?> avatarUrl = const Value.absent(),
            required String loginType,
            Value<String?> rawUserJson = const Value.absent(),
            Value<String?> rawEmployeeJson = const Value.absent(),
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              UserProfilesTableCompanion.insert(
            userId: userId,
            tenantId: tenantId,
            name: name,
            email: email,
            employeeCode: employeeCode,
            role: role,
            department: department,
            designation: designation,
            branchName: branchName,
            avatarUrl: avatarUrl,
            loginType: loginType,
            rawUserJson: rawUserJson,
            rawEmployeeJson: rawEmployeeJson,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserProfilesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserProfilesTableTable,
    UserProfilesTableData,
    $$UserProfilesTableTableFilterComposer,
    $$UserProfilesTableTableOrderingComposer,
    $$UserProfilesTableTableAnnotationComposer,
    $$UserProfilesTableTableCreateCompanionBuilder,
    $$UserProfilesTableTableUpdateCompanionBuilder,
    (
      UserProfilesTableData,
      BaseReferences<_$AppDatabase, $UserProfilesTableTable,
          UserProfilesTableData>
    ),
    UserProfilesTableData,
    PrefetchHooks Function()>;
typedef $$EntityMappingsTableTableCreateCompanionBuilder
    = EntityMappingsTableCompanion Function({
  required String localId,
  required int serverId,
  required String entityType,
  required int tenantId,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$EntityMappingsTableTableUpdateCompanionBuilder
    = EntityMappingsTableCompanion Function({
  Value<String> localId,
  Value<int> serverId,
  Value<String> entityType,
  Value<int> tenantId,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$EntityMappingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $EntityMappingsTableTable> {
  $$EntityMappingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localId => $composableBuilder(
      column: $table.localId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serverId => $composableBuilder(
      column: $table.serverId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$EntityMappingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $EntityMappingsTableTable> {
  $$EntityMappingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localId => $composableBuilder(
      column: $table.localId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serverId => $composableBuilder(
      column: $table.serverId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tenantId => $composableBuilder(
      column: $table.tenantId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$EntityMappingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $EntityMappingsTableTable> {
  $$EntityMappingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<int> get tenantId =>
      $composableBuilder(column: $table.tenantId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$EntityMappingsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EntityMappingsTableTable,
    EntityMappingsTableData,
    $$EntityMappingsTableTableFilterComposer,
    $$EntityMappingsTableTableOrderingComposer,
    $$EntityMappingsTableTableAnnotationComposer,
    $$EntityMappingsTableTableCreateCompanionBuilder,
    $$EntityMappingsTableTableUpdateCompanionBuilder,
    (
      EntityMappingsTableData,
      BaseReferences<_$AppDatabase, $EntityMappingsTableTable,
          EntityMappingsTableData>
    ),
    EntityMappingsTableData,
    PrefetchHooks Function()> {
  $$EntityMappingsTableTableTableManager(
      _$AppDatabase db, $EntityMappingsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntityMappingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntityMappingsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntityMappingsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> localId = const Value.absent(),
            Value<int> serverId = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<int> tenantId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EntityMappingsTableCompanion(
            localId: localId,
            serverId: serverId,
            entityType: entityType,
            tenantId: tenantId,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String localId,
            required int serverId,
            required String entityType,
            required int tenantId,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              EntityMappingsTableCompanion.insert(
            localId: localId,
            serverId: serverId,
            entityType: entityType,
            tenantId: tenantId,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$EntityMappingsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EntityMappingsTableTable,
    EntityMappingsTableData,
    $$EntityMappingsTableTableFilterComposer,
    $$EntityMappingsTableTableOrderingComposer,
    $$EntityMappingsTableTableAnnotationComposer,
    $$EntityMappingsTableTableCreateCompanionBuilder,
    $$EntityMappingsTableTableUpdateCompanionBuilder,
    (
      EntityMappingsTableData,
      BaseReferences<_$AppDatabase, $EntityMappingsTableTable,
          EntityMappingsTableData>
    ),
    EntityMappingsTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$OfflineOperationsTableTableManager get offlineOperations =>
      $$OfflineOperationsTableTableManager(_db, _db.offlineOperations);
  $$TasksTableTableTableManager get tasksTable =>
      $$TasksTableTableTableManager(_db, _db.tasksTable);
  $$AttendanceTableTableTableManager get attendanceTable =>
      $$AttendanceTableTableTableManager(_db, _db.attendanceTable);
  $$TodayAttendanceTableTableTableManager get todayAttendanceTable =>
      $$TodayAttendanceTableTableTableManager(_db, _db.todayAttendanceTable);
  $$TargetsTableTableTableManager get targetsTable =>
      $$TargetsTableTableTableManager(_db, _db.targetsTable);
  $$TenantLocationsTableTableTableManager get tenantLocationsTable =>
      $$TenantLocationsTableTableTableManager(_db, _db.tenantLocationsTable);
  $$PayrollRecordsTableTableTableManager get payrollRecordsTable =>
      $$PayrollRecordsTableTableTableManager(_db, _db.payrollRecordsTable);
  $$DashboardSnapshotsTableTableTableManager get dashboardSnapshotsTable =>
      $$DashboardSnapshotsTableTableTableManager(
          _db, _db.dashboardSnapshotsTable);
  $$UserProfilesTableTableTableManager get userProfilesTable =>
      $$UserProfilesTableTableTableManager(_db, _db.userProfilesTable);
  $$EntityMappingsTableTableTableManager get entityMappingsTable =>
      $$EntityMappingsTableTableTableManager(_db, _db.entityMappingsTable);
}
