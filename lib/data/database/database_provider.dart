import 'package:john_parking/shared/utils/custom_logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../shared/utils/constants.dart';

class DatabaseProvider {
  Database? _database;

  Future<Database> get database async {
    _database ??= await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    final localDatabaseDirectory = await getDatabasesPath();

    final String path = join(localDatabaseDirectory, ConstantsApp.databaseName);

    final database = await openDatabase(
      path,
      version: ConstantsApp.databaseVersion,
      onCreate: onCreate,
    );
    return database;
  }

  void onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${ConstantsApp.tableVacancy}(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ${ConstantsApp.columnDescriptionVacancy} TEXT,
        ${ConstantsApp.columnLicensePlateVacancy} TEXT,
        ${ConstantsApp.columnEntryTimeVacancy} INTEGER,
        ${ConstantsApp.columnDepartureTimeVacancy} INTEGER,
        ${ConstantsApp.columnParkingSpaceIdVacancy} INTEGER)
      ''');

    await db.execute('''
        CREATE TABLE ${ConstantsApp.tableParkingSpace}(
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          ${ConstantsApp.columnVacancyIdVacancy} integer,
          FOREIGN KEY(${ConstantsApp.columnVacancyIdVacancy}) REFERENCES ${ConstantsApp.tableVacancy}(id)
            ON DELETE NO ACTION ON UPDATE NO ACTION)
      ''');

    await db.transaction((txn) async {
      final batch = txn.batch();
      for (var i = 0; i < 50; i++) {
        batch.insert(ConstantsApp.tableParkingSpace, {'${ConstantsApp.tableVacancy}Id': null});
      }
      await batch.commit();

      LoggerApp.success('CREATED DABATASE WITH SUCCESSFUL');
    });
  }
}
