// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Measure extends DataClass implements Insertable<Measure> {
  final int id;
  final int timestamp;
  final double temperature;
  final double humidity;
  final double pressure;
  final double boxTemperature;
  final bool sentToFirebase;
  Measure(
      {@required this.id,
      this.timestamp,
      this.temperature,
      this.humidity,
      this.pressure,
      this.boxTemperature,
      @required this.sentToFirebase});
  factory Measure.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final doubleType = db.typeSystem.forDartType<double>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Measure(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      timestamp:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}timestamp']),
      temperature: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}temperature']),
      humidity: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}humidity']),
      pressure: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}pressure']),
      boxTemperature: doubleType
          .mapFromDatabaseResponse(data['${effectivePrefix}box_temperature']),
      sentToFirebase: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}sent_to_firebase']),
    );
  }
  factory Measure.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Measure(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      temperature: serializer.fromJson<double>(json['temperature']),
      humidity: serializer.fromJson<double>(json['humidity']),
      pressure: serializer.fromJson<double>(json['pressure']),
      boxTemperature: serializer.fromJson<double>(json['boxTemperature']),
      sentToFirebase: serializer.fromJson<bool>(json['sentToFirebase']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<int>(timestamp),
      'temperature': serializer.toJson<double>(temperature),
      'humidity': serializer.toJson<double>(humidity),
      'pressure': serializer.toJson<double>(pressure),
      'boxTemperature': serializer.toJson<double>(boxTemperature),
      'sentToFirebase': serializer.toJson<bool>(sentToFirebase),
    };
  }

  @override
  MeasuresCompanion createCompanion(bool nullToAbsent) {
    return MeasuresCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      timestamp: timestamp == null && nullToAbsent
          ? const Value.absent()
          : Value(timestamp),
      temperature: temperature == null && nullToAbsent
          ? const Value.absent()
          : Value(temperature),
      humidity: humidity == null && nullToAbsent
          ? const Value.absent()
          : Value(humidity),
      pressure: pressure == null && nullToAbsent
          ? const Value.absent()
          : Value(pressure),
      boxTemperature: boxTemperature == null && nullToAbsent
          ? const Value.absent()
          : Value(boxTemperature),
      sentToFirebase: sentToFirebase == null && nullToAbsent
          ? const Value.absent()
          : Value(sentToFirebase),
    );
  }

  Measure copyWith(
          {int id,
          int timestamp,
          double temperature,
          double humidity,
          double pressure,
          double boxTemperature,
          bool sentToFirebase}) =>
      Measure(
        id: id ?? this.id,
        timestamp: timestamp ?? this.timestamp,
        temperature: temperature ?? this.temperature,
        humidity: humidity ?? this.humidity,
        pressure: pressure ?? this.pressure,
        boxTemperature: boxTemperature ?? this.boxTemperature,
        sentToFirebase: sentToFirebase ?? this.sentToFirebase,
      );
  @override
  String toString() {
    return (StringBuffer('Measure(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('temperature: $temperature, ')
          ..write('humidity: $humidity, ')
          ..write('pressure: $pressure, ')
          ..write('boxTemperature: $boxTemperature, ')
          ..write('sentToFirebase: $sentToFirebase')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          timestamp.hashCode,
          $mrjc(
              temperature.hashCode,
              $mrjc(
                  humidity.hashCode,
                  $mrjc(
                      pressure.hashCode,
                      $mrjc(boxTemperature.hashCode,
                          sentToFirebase.hashCode)))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Measure &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.temperature == this.temperature &&
          other.humidity == this.humidity &&
          other.pressure == this.pressure &&
          other.boxTemperature == this.boxTemperature &&
          other.sentToFirebase == this.sentToFirebase);
}

class MeasuresCompanion extends UpdateCompanion<Measure> {
  final Value<int> id;
  final Value<int> timestamp;
  final Value<double> temperature;
  final Value<double> humidity;
  final Value<double> pressure;
  final Value<double> boxTemperature;
  final Value<bool> sentToFirebase;
  const MeasuresCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.temperature = const Value.absent(),
    this.humidity = const Value.absent(),
    this.pressure = const Value.absent(),
    this.boxTemperature = const Value.absent(),
    this.sentToFirebase = const Value.absent(),
  });
  MeasuresCompanion.insert({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.temperature = const Value.absent(),
    this.humidity = const Value.absent(),
    this.pressure = const Value.absent(),
    this.boxTemperature = const Value.absent(),
    this.sentToFirebase = const Value.absent(),
  });
  MeasuresCompanion copyWith(
      {Value<int> id,
      Value<int> timestamp,
      Value<double> temperature,
      Value<double> humidity,
      Value<double> pressure,
      Value<double> boxTemperature,
      Value<bool> sentToFirebase}) {
    return MeasuresCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      pressure: pressure ?? this.pressure,
      boxTemperature: boxTemperature ?? this.boxTemperature,
      sentToFirebase: sentToFirebase ?? this.sentToFirebase,
    );
  }
}

class $MeasuresTable extends Measures with TableInfo<$MeasuresTable, Measure> {
  final GeneratedDatabase _db;
  final String _alias;
  $MeasuresTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _timestampMeta = const VerificationMeta('timestamp');
  GeneratedIntColumn _timestamp;
  @override
  GeneratedIntColumn get timestamp => _timestamp ??= _constructTimestamp();
  GeneratedIntColumn _constructTimestamp() {
    return GeneratedIntColumn(
      'timestamp',
      $tableName,
      true,
    );
  }

  final VerificationMeta _temperatureMeta =
      const VerificationMeta('temperature');
  GeneratedRealColumn _temperature;
  @override
  GeneratedRealColumn get temperature =>
      _temperature ??= _constructTemperature();
  GeneratedRealColumn _constructTemperature() {
    return GeneratedRealColumn(
      'temperature',
      $tableName,
      true,
    );
  }

  final VerificationMeta _humidityMeta = const VerificationMeta('humidity');
  GeneratedRealColumn _humidity;
  @override
  GeneratedRealColumn get humidity => _humidity ??= _constructHumidity();
  GeneratedRealColumn _constructHumidity() {
    return GeneratedRealColumn(
      'humidity',
      $tableName,
      true,
    );
  }

  final VerificationMeta _pressureMeta = const VerificationMeta('pressure');
  GeneratedRealColumn _pressure;
  @override
  GeneratedRealColumn get pressure => _pressure ??= _constructPressure();
  GeneratedRealColumn _constructPressure() {
    return GeneratedRealColumn(
      'pressure',
      $tableName,
      true,
    );
  }

  final VerificationMeta _boxTemperatureMeta =
      const VerificationMeta('boxTemperature');
  GeneratedRealColumn _boxTemperature;
  @override
  GeneratedRealColumn get boxTemperature =>
      _boxTemperature ??= _constructBoxTemperature();
  GeneratedRealColumn _constructBoxTemperature() {
    return GeneratedRealColumn(
      'box_temperature',
      $tableName,
      true,
    );
  }

  final VerificationMeta _sentToFirebaseMeta =
      const VerificationMeta('sentToFirebase');
  GeneratedBoolColumn _sentToFirebase;
  @override
  GeneratedBoolColumn get sentToFirebase =>
      _sentToFirebase ??= _constructSentToFirebase();
  GeneratedBoolColumn _constructSentToFirebase() {
    return GeneratedBoolColumn('sent_to_firebase', $tableName, false,
        defaultValue: Constant(false));
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        timestamp,
        temperature,
        humidity,
        pressure,
        boxTemperature,
        sentToFirebase
      ];
  @override
  $MeasuresTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'measures';
  @override
  final String actualTableName = 'measures';
  @override
  VerificationContext validateIntegrity(MeasuresCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.timestamp.present) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableValue(d.timestamp.value, _timestampMeta));
    }
    if (d.temperature.present) {
      context.handle(_temperatureMeta,
          temperature.isAcceptableValue(d.temperature.value, _temperatureMeta));
    }
    if (d.humidity.present) {
      context.handle(_humidityMeta,
          humidity.isAcceptableValue(d.humidity.value, _humidityMeta));
    }
    if (d.pressure.present) {
      context.handle(_pressureMeta,
          pressure.isAcceptableValue(d.pressure.value, _pressureMeta));
    }
    if (d.boxTemperature.present) {
      context.handle(
          _boxTemperatureMeta,
          boxTemperature.isAcceptableValue(
              d.boxTemperature.value, _boxTemperatureMeta));
    }
    if (d.sentToFirebase.present) {
      context.handle(
          _sentToFirebaseMeta,
          sentToFirebase.isAcceptableValue(
              d.sentToFirebase.value, _sentToFirebaseMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Measure map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Measure.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(MeasuresCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.timestamp.present) {
      map['timestamp'] = Variable<int, IntType>(d.timestamp.value);
    }
    if (d.temperature.present) {
      map['temperature'] = Variable<double, RealType>(d.temperature.value);
    }
    if (d.humidity.present) {
      map['humidity'] = Variable<double, RealType>(d.humidity.value);
    }
    if (d.pressure.present) {
      map['pressure'] = Variable<double, RealType>(d.pressure.value);
    }
    if (d.boxTemperature.present) {
      map['box_temperature'] =
          Variable<double, RealType>(d.boxTemperature.value);
    }
    if (d.sentToFirebase.present) {
      map['sent_to_firebase'] =
          Variable<bool, BoolType>(d.sentToFirebase.value);
    }
    return map;
  }

  @override
  $MeasuresTable createAlias(String alias) {
    return $MeasuresTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $MeasuresTable _measures;
  $MeasuresTable get measures => _measures ??= $MeasuresTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [measures];
}