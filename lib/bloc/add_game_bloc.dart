import 'package:flutter/material.dart';
import 'package:flutter_games_exchange/database/game_sql_database.dart';
import 'dart:async';
import 'package:flutter_games_exchange/src/utils/validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_games_exchange/network/firebase/auth.dart';
import 'package:flutter_games_exchange/models/game.dart';
import 'package:flutter_games_exchange/network/http/http_requests.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_games_exchange/database/my_games_sql_database.dart';

class AddGameBloc extends Object with Validators {

  final BehaviorSubject<List<Game>> _gameList = BehaviorSubject<List<Game>>();

  Stream<List<Game>> get gameListStream => _gameList.stream;

  Function(List<Game>) get changeGameListStream => _gameList.sink.add;


  final BehaviorSubject<List<Game>> _addedGames = BehaviorSubject<List<Game>>();

  Stream<List<Game>> get addedGamesListStream => _addedGames.stream;

  Function(List<Game>) get changeAddedGamesStream => _addedGames.sink.add;

  final BehaviorSubject<bool> _isIconified = BehaviorSubject<bool>.seeded(true);

  Stream<bool> get isIconifiedStream => _isIconified.stream;

  Function(bool) get changeIsIconifiedStream => _isIconified.sink.add;

  bool isIconifiedLastValue() => _isIconified.value;

  final BehaviorSubject<bool> _isLoaded = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get isLoadedStream => _isLoaded.stream;

  Function(bool) get changeIsLoadedStream => _isLoaded.sink.add;

  bool isLoadedLastValue() {
    return _isLoaded.value;
  }

  dispose() {
    // Dispose - LOGIN
    _gameList.close();
    _addedGames.close();
    _isIconified.close();
  }

  void sendGamesToServer(String flag) async {
    List<Game> addedGames = _addedGames.value;
    List jsonList = Game.encondeToJson(addedGames);
    print(jsonList.toString());
    String games = jsonList.toString();

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String firebase_uid = user.uid;

    NetworkHttpCalls httpCalls = new NetworkHttpCalls();
    bool addedGameCorrectly = await httpCalls.addGame(addedGames,games, firebase_uid, flag);
    if (addedGameCorrectly) {
     await addToLocalDatabase(addedGames, flag);
    }
  }

  void addToLocalDatabase(List<Game> addedGames, String flag) async {
  
  }

  void getItems(/*AddGameBloc _bloc*/) async {
    SQLDatabase database = SQLDatabase();
    database.openDb();
    await database.getGames().then((list) {
        changeGameListStream(list);
        print('HEEEEEEEEEe ${list.toString()}');

    }, onError: (obj) {
      print('ERRORRRRRRRR');
      return Container(
        color: Colors.blue,
      );
    });
  }

  void getItemsByName(AddGameBloc _bloc, String gameName) async {
    SQLDatabase database = SQLDatabase();
    database.openDb();
    await database.getGamesByName(gameName).then((list) {
        changeGameListStream(list);
    }, onError: (obj) {
      return Center(
        child: Text('No Games Found'),
      );
    });

  }

  updateGame(AddGameBloc bloc, Game game, String flag) async {
    game.is_selected = !game.is_selected;
    SQLDatabase database = SQLDatabase();
    database.openDb();
    database.updateGame(game);
    updateAddedGames(bloc, game);
  }

  unselectAllGames(BuildContext context, AddGameBloc _bloc) async {
    SQLDatabase database = SQLDatabase();
    database.openDb();
    for (Game game in addedGames) {
      game.flag = '';
      game.is_selected = false;
      database.updateGame(game);
    }
    addedGames.clear();
    addedGamesString.clear();
    Navigator.pop(context);
  }

  List<String> addedGamesString = new List<String>();
  List<Game> addedGames = new List<Game>();

  void updateAddedGames(AddGameBloc bloc, Game game) {
    if (game.is_selected) {
      addedGamesString.add(game.game_name);
      addedGames.add(game);
    } else {
      if (addedGamesString.contains(game.game_name)) {
        addedGames.removeAt(addedGamesString.indexOf(game.game_name));
        addedGamesString.remove(game.game_name);
      }
    }
    bloc.changeAddedGamesStream(addedGames);
  }
}
