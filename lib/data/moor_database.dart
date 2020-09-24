import 'package:moor_flutter/moor_flutter.dart';
part 'moor_database.g.dart';

class Measures extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime().nullable().customConstraint('UNIQUE')();
  RealColumn get temperature => real().nullable()();
  RealColumn get humidity => real().nullable()();
  RealColumn get pressure => real().nullable()();
  RealColumn get boxTemperature => real().nullable()();
  BoolColumn get sentToFirebase => boolean().withDefault(Constant(false))();

  @override
  Set<Column> get primaryKey => {timestamp};
}

@UseMoor(tables: [Measures])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      // Specify the location of the database file
      : super(FlutterQueryExecutor.inDatabaseFolder(
          path: 'db.sqlite',
          // Good for debugging - prints SQL in the console
          logStatements: true,
        ));

  @override
  int get schemaVersion => 1;

  Future<List<Measure>> getAllMeasures() => select(measures).get();
  Stream<List<Measure>> watchAllMeasures() {
    return (select(measures)
      ..orderBy([(t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc)])).watch();
  }
  Future insertMeasure(Measure measure) => into(measures).insert(measure, orReplace: false);
  Future updateMeasure(Measure measure) => update(measures).replace(measure);
  Future deleteMeasure(Measure measure) => delete(measures).delete(measure);
  Future<List<Measure>> checkMeasureInDatabase(Measure measure) =>
      (select(measures)..where((m) => m.timestamp.equals(measure.timestamp)))
          .get();
  Future deleteAllMeasures() => delete(measures).go();
  
  Future<List<Measure>> getMeasuresFromDate(DateTime searchDate) {
    return (select(measures)
          ..where(
            (row) {
              final date = row.timestamp;
              return date.year.equals(searchDate.year) &
                  date.month.equals(searchDate.month) &
                  date.day.equals(searchDate.day);
            },
          )..orderBy([(t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.asc)])).get();
  }
  Future<List<DateTime>> getDistinctDays() {
    final year = measures.timestamp.year;
    final month = measures.timestamp.month;
    final day = measures.timestamp.day;
    final query = selectOnly(measures, distinct: true)..addColumns([year, month, day]);
    return query.map((row) => DateTime.utc(row.read(year),row.read(month),row.read(day))).get();  
    }
}

// Moor works by source gen. This file will all the generated code.
