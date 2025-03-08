import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/mylocation.dart';
import '../models/mypraytime.dart';
import '../models/praytimes_vm.dart';

class DBService {
  Future<Database> initializeDatabase() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'praytimes.db'),
      onCreate: (db, version) {
        createTables(db);
      },
      version: 6,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion != newVersion) {
          await upgradeTables(db);
        }
      },
    );
    return database;
  }

  Future<void> createTables(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS praytimetable (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          townId INTEGER,
          today TEXT,
          fajr TEXT,
          sunrise TEXT,
          dhuhr TEXT,
          asr TEXT,
          maghrib TEXT,
          isha TEXT,
          shapeMoonUrl TEXT,
          astronomicalSunset TEXT,
          astronomicalSunrise TEXT,
          hijriDateShort TEXT,
          hijriDateShortIso8601 TEXT,
          hijriDateLong TEXT,
          hijriDateLongIso8601 TEXT,
          qiblaTime TEXT,
          gregorianDateShort TEXT,
          gregorianDateShortIso8601 TEXT,
          gregorianDateLong TEXT,
          gregorianDateLongIso8601 TEXT,
          greenwichMeanTimeZone INTEGER
        )""");
    await database.execute("""CREATE TABLE IF NOT EXISTS locationtable (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          townId INTEGER,
          townName TEXT
        )""");
    await database.execute("""CREATE TABLE IF NOT EXISTS dailytable (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          verse TEXT,
          verseSource TEXT,
          hadith TEXT,
          hadithSource TEXT,
          pray TEXT,
          praySource TEXT
        )""");
    await database.execute("""CREATE TABLE IF NOT EXISTS suntimetable (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          sunrise TEXT,
          sunset TEXT,
          solarNoon TEXT,
          dayLength INTEGER,
          civilTwilightBegin TEXT,
          civilTwilightEnd TEXT,
          nauticalTwilightBegin TEXT,
          nauticalTwilightEnd TEXT,
          astronomicalTwilightBegin TEXT,
          astronomicalTwilightEnd TEXT
        )""");
  }

  Future<void> upgradeTables(Database database) async {
    final box = GetStorage();
    await box.erase();
    await database.execute("DROP TABLE IF EXISTS praytimetable");
    await database.execute("DROP TABLE IF EXISTS locationtable");
    await database.execute("DROP TABLE IF EXISTS dailytable");
    await database.execute("DROP TABLE IF EXISTS suntimetable");
  }

  // PRAYTIME
  Future<int> insertPrayTime(MyPraytime model) async {
    try {
      final Database db = await initializeDatabase();
      int result = await db.insert(
        'praytimetable',
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return result;
    } catch (e) {
      throw ('Bir sorun oluştu $e');
    }
  }

  Future<List<MyPraytime>> getPrayTimes(int townId) async {
    try {
      final Database db = await initializeDatabase();
      final List<Map<String, dynamic>> queryResult = await db.query(
        'praytimetable',
        where: "townId = ?",
        whereArgs: [townId],
      );
      if (queryResult.isEmpty) {
        return [];
      }
      return queryResult.map((e) => MyPraytime.fromMap(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> deletePrayTimes() async {
    final Database db = await initializeDatabase();
    try {
      await db.delete('praytimetable');
    } catch (e) {
      throw ('Bir sorun oluştu $e');
    }
  }

  Future<void> deletePrayTime(int id) async {
    final Database db = await initializeDatabase();
    try {
      await db.delete('praytimetable', where: "id = ?", whereArgs: [id]);
    } catch (e) {
      throw ('Bir sorun oluştu $e');
    }
  }

  Future<void> deletePrayTimesBy(int townId) async {
    final Database db = await initializeDatabase();
    try {
      await db.delete('praytimetable', where: "townId = ?", whereArgs: [townId]);
    } catch (e) {
      throw ('Bir sorun oluştu $e');
    }
  }

  //DAILY
  Future<int> insertDaily(DailyVM model) async {
    try {
      final Database db = await initializeDatabase();
      int result = await db.insert(
        'dailytable',
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return result;
    } catch (e) {
      throw ('Bir sorun oluştu $e');
    }
  }

  Future<DailyVM> getDaily() async {
    try {
      final Database db = await initializeDatabase();
      final List<Map<String, dynamic>> queryResult = await db.query('dailytable');
      var result = queryResult.map((e) => DailyVM.fromMap(e)).toList();
      return result[0];
    } catch (e) {
      throw ('Bir sorun oluştu $e');
    }
  }

  Future<void> deleteDailies() async {
    final Database db = await initializeDatabase();
    try {
      await db.delete('dailytable');
    } catch (e) {
      throw ('Bir sorun oluştu $e');
    }
  }

  // MYLOCATION
  Future<int> insertLocation(MyLocation model) async {
    try {
      final Database db = await initializeDatabase();
      int result = await db.insert(
        'locationtable',
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return result;
    } catch (e) {
      throw ('Bir sorun oluştu $e');
    }
  }

  Future<List<MyLocation>> getLocations() async {
    try {
      final Database db = await initializeDatabase();
      final List<Map<String, dynamic>> queryResult = await db.query('locationtable');
      return queryResult.map((e) => MyLocation.fromMap(e)).toList();
    } catch (e) {
      throw ('Bir sorun oluştu $e');
    }
  }

  Future<void> deleteLocations() async {
    try {
      final Database db = await initializeDatabase();
      await db.delete('locationtable');
    } catch (e) {
      throw ('Bir sorun oluştu $e');
    }
  }

  Future<void> deleteLocationsBy(int townId) async {
    try {
      final Database db = await initializeDatabase();
      await db.delete('locationtable', where: "townId = ?", whereArgs: [townId]);
    } catch (e) {
      throw ('Bir sorun oluştu $e');
    }
  }

  void closeDB() async {
    final Database db = await initializeDatabase();
    db.close();
  }
}
