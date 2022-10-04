import 'package:flutter/material.dart';
import 'package:flutter_games_exchange/database/my_games_sql_database.dart';
import 'package:flutter_games_exchange/providers/homepage_provider.dart';
import 'package:flutter_games_exchange/providers/my_wishes_provider.dart';
import 'dart:async';
import 'package:flutter_games_exchange/src/utils/validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_games_exchange/network/firebase/auth.dart';
import 'package:flutter_games_exchange/models/game.dart';
import 'package:flutter_games_exchange/network/http/http_requests.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyWishesBloc extends Object with Validators {
  final BehaviorSubject<List<Game>> _wishList = BehaviorSubject<List<Game>>.seeded(new List<Game>());

  Stream<List<Game>> get wishListStream => _wishList.stream;

  Function(List<Game>) get changeWishListStream => _wishList.sink.add;



  dispose() {
    // Dispose
    _wishList.close();
  }

  List<Game> getGames() => _wishList.value;

  Future<List<Game>> getItemsLocally(String firebase_uid) async {
    MyGamesSQLDatabase database = new MyGamesSQLDatabase();
    database.openDb();
    List<Game> games = await database.getGames("w");
    if (games.length > 0) {
      changeWishListStream(games);
      print('games ${games.toString()}');

      return games;
    }
    return await getItemsFromNetwork(firebase_uid);


  }

  Future<List<Game>> getItemsFromNetwork(String firebase_uid) async {
    NetworkHttpCalls networkHttpCalls = new NetworkHttpCalls();
    List<Game> games = await networkHttpCalls.getGames(firebase_uid, "w");
    changeWishListStream(games);
    updateGamesToDatabase(games, "w");
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
    changeWishListStream(games);
    removedGames.add(game);
    _homePageBloc.changeRemovedGamesStream(removedGames);
  }


  List<Game> updatedWishes = new List();
  bool updateGame(BuildContext context,Game game, int tag, String gameName) {
    if(game.tag != tag) {
      HomePageBloc _homePageBloc = HomePageProvider.of(context);
      List<Game> obtainedGames = getGames();
      for (Game loopedgame in updatedWishes) {
        int i = 0;
        if (loopedgame.game_name == gameName) {
          loopedgame.tag = tag;
          updatedWishes[i] = loopedgame;
          _homePageBloc.changeUpdatedWishesStream(updatedWishes);

          int gameIndex = obtainedGames.indexOf(game);
          game.tag = tag;
          obtainedGames[gameIndex] = game;
          changeWishListStream(obtainedGames);

          return true;
        }
        i++;
      }

      int gameIndex = obtainedGames.indexOf(game);
      game.tag = tag;
      obtainedGames[gameIndex] = game;
      changeWishListStream(obtainedGames);
      updatedWishes.add(game);
      _homePageBloc.changeUpdatedWishesStream(updatedWishes);
      return true;
    }
  }

}
