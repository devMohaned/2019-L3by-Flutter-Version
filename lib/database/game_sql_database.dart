import 'dart:async';
import 'package:flutter_games_exchange/models/game.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLDatabase {
  Future<Database> openDb() async {
    final Database database = await openDatabase(
      // Set the path to the database.
      join(await getDatabasesPath(), 'game-database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          "CREATE TABLE games_table (room_id INTEGER PRIMARY KEY, game_name TEXT, flag TEXT, is_selected INTEGER, tag INTEGER DEFAULT(0))",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    return database;
  }

  Future<void> insertGame(Game game) async {
    final Database db = await openDb();
    await db.insert(
      'games_table',
      game.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<Game>> getGames() async {
    final Database db = await openDb();
    final List<Map<String, dynamic>> maps = await db.query('games_table',
        columns: ['room_id', 'game_name', 'is_selected','tag'],
        orderBy: 'game_name ASC');
    return List.generate(
      maps.length,
      (i) {
        return Game.fromMap(maps[i]);
      },
    );
  }

  Future<void> updateGame(Game game) async {
    // Get a reference to the database.
    final db = await openDb();
    await db.update(
      'games_table',
      game.toMap(),
      where: "room_id = ?",
      whereArgs: [game.room_id],
    );
  }



  Future<void> deleteGame(int room_id) async {
    final db = await openDb();
    await db.delete(
      'games_table',
      where: "room_id = ?",
      whereArgs: [room_id],
    );
  }

  Future<void> insertDummyGame() async {
    final game = Game(
      'Dummy Game',
      'w',
      false,
      0
    );
//    await insertGame(game);
  }

  Future<int> getGamesCount() async {
    final Database db = await openDb();
    int count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM games_table'));
    return count;
  }

  void unselectAllGames() async {
    final Database db = await openDb();
    List<Map<String, dynamic>> map = await db.rawQuery(
        'UPDATE games_table SET flag = \'\', is_selected = 0 WHERE flag != \'\' OR is_selected = 1');
  }



  getGamesByName(String gameName) async {
    final Database db = await openDb();
    final List<Map<String, dynamic>> maps = await db.query('games_table',
        where: 'game_name LIKE ?',
        whereArgs: ['%$gameName%'],
        orderBy: 'game_name ASC');
    return List.generate(
      maps.length,
      (i) {
        return Game.fromMap(maps[i]);
      },
    );
  }
/*
  *
  closeDatabase() async {
    database.close();
  }
*/
}
