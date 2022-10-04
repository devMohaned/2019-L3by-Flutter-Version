import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_games_exchange/database/game_sql_database.dart';

class lineReader {
  SQLDatabase sqlDatabase = new SQLDatabase();

  readLines(String fileName) {
    var config = new File(fileName);
    config.readAsLines(encoding: utf8).then(handleLines);
  }

  handleLines(List<String> lines) {
    for (var line in lines) {
      if (line.trim().length > 0) print(line);
    }
  }

  readLinesAsync(String fileName) {
    var config = new File(fileName);
    List<String> lines = config.readAsLinesSync(encoding: utf8);
    for (var line in lines) {
      if (line.trim().length > 0) {
        print(line);
      }
    }
  }
}
