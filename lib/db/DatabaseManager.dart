import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:app/utils/lib.dart';
import 'package:app/db/lib.dart';

class DatabaseManager {

  static Database? _database;
  static const String _TAG = "DatabaseManager";
  Logger _logger = Logger.getInstance;

  static DatabaseManager? _instance;
  DatabaseManager._();
  factory DatabaseManager() => getInstance;

  static DatabaseManager get getInstance {
    if (_instance == null) {
      _instance = new DatabaseManager._();
    }
    return _instance!;
  }

  Future<Database?> get openDb async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    return await getApplicationDocumentsDirectory().then((directory) async => await openDatabase(join(directory.path, DBConstants.DB_NAME), version: DBConstants.dbVersion, onCreate: _onCreate));
  }

  Future _onCreate(Database db, int version) async {
    db.transaction((txn) async => {
      //txn.execute("CREATE TABLE '${TableManager.USERS}' ( 'id' TEXT NOT NULL, 'name' TEXT NOT NULL )"),
      txn.execute("CREATE TABLE '${TableManager.MOVIES}' ( 'id' INTEGER PRIMARY KEY AUTOINCREMENT, 'name' TEXT NOT NULL, 'director' TEXT NOT NULL, 'poster' TEXT NOT NULL )")
    });
  }

  Future<int?> insert(String tableName, Map<String, dynamic> row) async {
    return await getInstance.openDb.then((db) async => await db?.insert(tableName, row, conflictAlgorithm: ConflictAlgorithm.abort)).catchError((error) {
      _logger.e(_TAG, "insertMovie()", message: error.toString());
      return null;
    });
  }

  Future rawQuery(String query) async {
    return await getInstance.openDb.then((db) async => await db?.rawQuery(query)).catchError((error) {
      _logger.e(_TAG, "rawQuery()", message: error.toString());
      return null;
    });
  }

  Future<List<Map<String, dynamic>>?> getAll(String tableName, {int? limit, int? offset}) async {
    return await getInstance.openDb.then((db) async => await db?.query(tableName, distinct: true, limit: limit, offset: offset)).catchError((error) {
      _logger.e(_TAG, "getAllMovies()", message: error.toString());
      return null;
    });
  }

  Future<int?> update(String tableName, Map<String, dynamic> row) async {
    return await getInstance.openDb.then((db) async => await db?.update(tableName, row, where: 'id = ?', whereArgs: [row[0]])).catchError((error) {
      _logger.e(_TAG, "update()", message: error.toString());
      return null;
    });
  }

  Future<int?> delete(String tableName, String poster) async {
    return await getInstance.openDb.then((db) async => await db?.delete(tableName, where: 'poster = ?', whereArgs: [poster])).catchError((error) {
      _logger.e(_TAG, "delete()", message: error.toString());
      return null;
    });
  }

  Future<bool?> databaseExists() async {
    return await getApplicationDocumentsDirectory().then((directory) async {
      return await databaseFactory.databaseExists(join(directory.path, DBConstants.DB_NAME));
    }).catchError((error) {
      _logger.e(_TAG, "databaseExists()", message: error.toString());
      return false;
    });
  }

  Future<void> clearDatabase() async {
    await getInstance.openDb.then((db) => db?.transaction((txn) async {
      var batch = txn.batch.call();
      batch.delete(TableManager.MOVIES);
      batch.delete(TableManager.USERS);
      await batch.commit();
    })).catchError((error) {
      _logger.e(_TAG, "clearDatabase()", message: error.toString());
      return null;
    });
  }

}