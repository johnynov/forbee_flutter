import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'moor_database.g.dart';


class Measures extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get timestamp => integer().nullable()();
  RealColumn get temperature => real().nullable()();
  RealColumn get humidity => real().nullable()();
  RealColumn get pressure => real().nullable()();
  RealColumn get boxTemperature => real().nullable()();
  BoolColumn get sentToFirebase => boolean().withDefault(Constant(false))();
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
    Stream<List<Measure>> watchAllMeasures() => select(measures).watch();
    Future insertMeasure(Measure measure) => into(measures).insert(measure);
    Future updateMeasure(Measure measure) => update(measures).replace(measure);
    Future deleteMeasure(Measure measure) => delete(measures).delete(measure);

}
// Moor works by source gen. This file will all the generated code.