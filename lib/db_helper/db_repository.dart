import 'package:sqflite/sqflite.dart';
import 'db_connection.dart';

class DbRepository {
  final DbConnection _dbConnection = DbConnection();
  Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _dbConnection.setDatabase();
      return _database;
    }
  }

  insertData(table, data) async {
    var connection = await database;
    return await connection?.insert(table, data);
  }

  readAllData(table) async {
    var connection = await database;
    return await connection?.query(table);
  }

  readDataById(table, id) async {
    var connection = await database;
    return await connection?.query(table, where: 'id=?', whereArgs: [id]);
  }

  updateData(table, data) async {
    var connection = await database;
    return await connection?.update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }

  deleteDataById(table, id) async {
    var connection = await database;
    return await connection?.rawDelete("delete from $table where id=$id");
  }

  deleteAllData(table) async {
    var connection = await database;
    return await connection?.delete("$table");
  }

  closeDb() {
    _database!.close();
  }
}
