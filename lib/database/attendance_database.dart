import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../helper/const.dart';

class AttendanceDatabase {
  AttendanceDatabase._internal();
  static final AttendanceDatabase _db = AttendanceDatabase._internal();
  static AttendanceDatabase get instance => _db;
  static Database? _database;
  Future<Database> get database async
  {
    if (_database != null) {
      return _database!;
    }
    _database = await _createDataBase();
    return _database!;
  }
  Future<Database> _createDataBase() async
  {
    return openDatabase(
      join(await getDatabasesPath(),databaseName),
      onCreate: (db, version) {
        // db.execute('CREATE TABLE $workPlaceTableName ($workPlaceIdColumn INTEGER PRIMARY KEY AUTOINCREMENT ,'
        //     '$workPlaceNameColumn TEXT UNIQUE)');
        db.execute(
            'CREATE TABLE $attendanceTableName ($attendanceIdColumn INTEGER PRIMARY KEY AUTOINCREMENT ,'
                '$attendanceDateColumn TEXT UNIQUE ,$monthColumn INTEGER ,$checkInColumn TEXT,$checkOutColumn TEXT,'
                '$attendanceSymbolColumn TEXT)');
        // db.execute(
        //     'CREATE TABLE $workTableName ($workTableIdColumn INTEGER PRIMARY KEY AUTOINCREMENT ,'
        //         '$workTableSymbolColumn TEXT,$workTableWorkingHoursColumn INTEGER ,$workTableDateColumn TEXT'
        //         '$workPlaceIdColumn INTEGER FOREIGN KEY REFERENCES $workPlaceTableName($workPlaceIdColumn) )');
        },
      version: 1,
    );
  }

}
//$workPlaceIdColumn INTEGER , FOREIGN KEY ($workPlaceIdColumn) REFERENCES $workPlaceTableName($workPlaceIdColumn)