import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbConnection {
  Future<Database> setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'prayertimes_db.db');
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
    return database;
  }

  Future<void> _createDatabase(Database database, int version) async {
    String sql =
        "CREATE TABLE prayertimes (id INTEGER PRIMARY KEY AUTOINCREMENT,shapeMoonUrl TEXT, fajr TEXT, sunrise TEXT, dhuhr TEXT, asr TEXT, maghrib TEXT, isha TEXT, astronomicalSunset TEXT, astronomicalSunrise TEXT, hijriDateShort TEXT, hijriDateShortIso8601 TEXT, hijriDateLong TEXT, hijriDateLongIso8601 TEXT, qiblaTime TEXT, gregorianDateShort TEXT, gregorianDateShortIso8601 TEXT, gregorianDateLong TEXT, gregorianDateLongIso8601 TEXT, greenwichMeanTimeZone INTEGER)";
    await database.execute(sql);
  }
}
