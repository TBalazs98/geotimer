import 'package:geotimer/models/alarm.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBService{

  static const String tableName = "alarm";

  static Future<Database> database() async {
    final dbpath = await getDatabasesPath();
    return openDatabase(
      join(dbpath, 'alarms.db'),
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE alarm(id INTEGER PRIMARY KEY AUTOINCREMENT, lat REAL, lon REAL, r INTEGER, city TEXT, frequency REAL, isActive INTEGER)');
      },
      version: 20,
    );
  }

  static Future<void> insert(Map<String, dynamic> data) async {
    final db = await DBService.database();
    await db.insert(
      tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );

    //await db.close();
  }

  static Future<List<Alarm>> getData() async {
    final db = await DBService.database();

    var data = await db.query(tableName);

    List<Alarm> alarmList = [];
    
    data.forEach((element) { 
      alarmList.add(Alarm.fromMap(element));
    });

    //await db.close();

    return alarmList;
  }

  static Future<void> update(Map<String, dynamic> data) async {
    final db = await DBService.database();

    await db.update(tableName, data, where: 'id = ?', whereArgs: [data['id']], conflictAlgorithm: ConflictAlgorithm.replace);

   // await db.close();
  }


  static Future<void> remove(Map<String, dynamic> data) async {
    final db = await DBService.database();

    await db.delete(tableName, where: 'id = ?',whereArgs: [data["id"]]);

   // await db.close();
  }

  static Future<void> activateAlarm(Alarm alarm) async {
    alarm.isActive = 1;

    await DBService.update(alarm.toMap());
  }

  static Future<void> deactivateAlarm(Alarm alarm) async {
    alarm.isActive = 0;

    await DBService.update(alarm.toMap());
  }

  static Future<Alarm> queryById(int id) async {
    final db = await DBService.database();

    var record = await db.rawQuery('SELECT * FROM alarm WHERE id=?', [id]);

    return Alarm.fromMap(record[0]);
  }



}