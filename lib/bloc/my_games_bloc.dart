import 'package:flutter/material.dart';
import 'package:flutter_games_exchange/database/my_games_sql_database.dart';
import 'package:flutter_games_exchange/providers/homepage_provider.dart';
import 'package:flutter_games_exchange/providers/my_games_provider.dart';
import 'dart:async';
import 'package:flutter_games_exchange/src/utils/validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_games_exchange/network/firebase/auth.dart';
import 'package:flutter_games_exchange/models/game.dart';
import 'package:flutter_games_exchange/network/http/http_requests.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyGamesBloc extends Object with Validators {
  final BehaviorSubject<List<Game>> _gameList = BehaviorSubject<List<Game>>.seeded(new List<Game>());

  Stream<List<Game>> get gameListStream => _gameList.stream;

  Function(List<Game>) get changeGameListStream => _gameList.sink.add;



  dispose() {
    // Dispose
    _gameList.close();
  }

  List<Game> getGames() => _gameList.value;

  Future<List<Game>> getItemsLocally(String firebase_uid) async {
    MyGamesSQLDatabase database = new MyGamesSQLDatabase();
    database.openDb();
    List<Game> games = await database.getGames("o");
    if (games.length > 0) {
      changeGameListStream(games);
      print('games ${games.toString()}');

      return games;
    }
    return await getItemsFromNetwork(firebase_uid);
  }

  Future<List<Game>> getItemsFromNetwork(String firebase_uid) async {
    NetworkHttpCalls networkHttpCalls = new NetworkHttpCalls();
    List<Game> games = await networkHttpCalls.getGames(firebase_uid, "o");
    changeGameListStream(games);
    updateGamesToDatabase(games, "o");
    return games;
  }

  void updateGamesToDatabase(List<Game> games, String flag) {
    MyGamesSQLDatabase database = new MyGamesSQLDatabase();
    database.openDb();
    database.syncGames(games, flag);
  }

  List<Game> removedGames = new List();

  void removeGame(List<Game> games, Game game, BuildContext context) {
    HomePageBloc _homePageBloc = HomePageProvider.of(context);
    games.remove(game);
    changeGameListStream(games);
    removedGames.add(game);
    _homePageBloc.changeRemovedGamesStream(removedGames);
  }



  List<Game> updatedGames = new List();
  bool updateGame(BuildContext context,Game game, int tag, String gameName) {
    if(game.tag != tag) {
      HomePageBloc _homePageBloc = HomePageProvider.of(context);
      List<Game> obtainedGames = getGames();
      for (Game loopedgame in updatedGames) {
        int i = 0;
        if (loopedgame.game_name == gameName) {
          loopedgame.tag = tag;
          updatedGames[i] = loopedgame;
          _homePageBloc.changeUpdatedGamesStream(updatedGames);

          int gameIndex = obtainedGames.indexOf(game);
          game.tag = tag;
          obtainedGames[gameIndex] = game;
          changeGameListStream(obtainedGames);

          return true;
        }
        i++;
      }

      int gameIndex = obtainedGames.indexOf(game);
      game.tag = tag;
      obtainedGames[gameIndex] = game;
      changeGameListStream(obtainedGames);
      updatedGames.add(game);
      _homePageBloc.changeUpdatedGamesStream(updatedGames);
      return true;
    }
  }





}
