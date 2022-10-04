import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_games_exchange/database/game_sql_database.dart';
import 'package:flutter_games_exchange/database/my_games_sql_database.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_games_exchange/network/http/http_requests.dart';
import 'package:flutter_games_exchange/models/user.dart';
import 'package:flutter_games_exchange/models/game.dart';

enum NavBarItem {
  GAMES,
  WISHES,
  TRADE
}

class HomePageBloc extends Object {

  final BehaviorSubject<List<Game>> _updatedGames = BehaviorSubject<
      List<Game>>.seeded(new List<Game>());

  Stream<List<Game>> get updatedGamesListStream => _updatedGames.stream;

  Function(List<Game>) get changeUpdatedGamesStream => _updatedGames.sink.add;

  List<Game> getUpdatedGames() => _updatedGames.value;


  final BehaviorSubject<List<Game>> _updatedWishes = BehaviorSubject<
      List<Game>>.seeded(new List<Game>());

  Stream<List<Game>> get updatedWishesListStream => _updatedWishes.stream;

  Function(List<Game>) get changeUpdatedWishesStream => _updatedWishes.sink.add;

  List<Game> getUpdatedWishes() => _updatedWishes.value;


  final BehaviorSubject<List<Game>> _removedGames = BehaviorSubject<
      List<Game>>.seeded(new List<Game>());

  Stream<List<Game>> get removedGamesListStream => _removedGames.stream;

  Function(List<Game>) get changeRemovedGamesStream => _removedGames.sink.add;

  List<Game> getRemovedGames() => _removedGames.value;


  final BehaviorSubject<bool> _httpFailed = BehaviorSubject<bool>();

  Stream<bool> get httpFailedStream => _httpFailed.stream;

  Function(bool) get changeHttpFailed => _httpFailed.sink.add;

  final BehaviorSubject<String> _existanceState = BehaviorSubject<String>();

  Stream<String> get existanceStateStream => _existanceState.stream;

  Function(String) get changeExistanceState => _existanceState.sink.add;


  final BehaviorSubject<User> _currentUser = BehaviorSubject<User>();

  Stream<User> get currentUserStream => _currentUser.stream;

  Function(User) get changeCurrentUser => _currentUser.sink.add;


  final BehaviorSubject<bool> _hasLocation = BehaviorSubject<bool>();

  Stream<bool> get currentHasLocationStream => _hasLocation.stream;

  Function(bool) get changeHasLocation => _hasLocation.sink.add;


  final BehaviorSubject<bool> _hasDistrict = BehaviorSubject<bool>();

  Stream<bool> get currentHasDistrictStream => _hasDistrict.stream;

  Function(bool) get changeHasDistrict => _hasDistrict.sink.add;


  Stream<bool> get hasLocationAndDistrict =>
      Observable.combineLatest2(
          _hasLocation,
          _hasDistrict,
              (hasLoc, hasDistrict) => true).asBroadcastStream();


  NavBarItem defaultItem = NavBarItem.GAMES;
  final BehaviorSubject<NavBarItem> _navBar = BehaviorSubject<NavBarItem>();

  Stream<NavBarItem> get stream => _navBar.stream;

  Function(NavBarItem) get changeIndex => _navBar.sink.add;

  NavBarItem getUpdatedItem() {
    final validNavBar = _navBar.value;
    return validNavBar;
  }

  void PickItem(int selectedIndex) {
    resetRemovedGames();
    updateGameTags(_currentUser.value.firebase_uid);
    switch (selectedIndex) {
      case 0:
        changeIndex(NavBarItem.GAMES);
        break;
      case 1:
        changeIndex(NavBarItem.WISHES);
        break;
      case 2:
        changeIndex(NavBarItem.TRADE);
        break;
    }
  }


  void dispose() {
//    _navBarController.close();
    _existanceState.close();
    _navBar.close();
    _removedGames.close();
  }

  void getUserData(String firebase_uid) async {
    NetworkHttpCalls httpCalls = new NetworkHttpCalls(/*context*/);
    User user = await httpCalls.getUserData(firebase_uid);
    changeExistanceState('${user.user_state}');
    changeCurrentUser(user);
  }


  void removeGamesOrWishes() async
  {
    List<Game> removedGames = _removedGames.value;
    List jsonList = Game.encondeToJson(removedGames);
    String games = jsonList.toString();

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String firebase_uid = user.uid;

    NetworkHttpCalls httpCalls = new NetworkHttpCalls();
    bool removedGamesCorrectly = await httpCalls.removeGames(
        removedGames, games, firebase_uid);
    if (removedGamesCorrectly) {
      resetRemovedGames();
    }
  }

  void resetRemovedGames() {
    List<Game> removedGames = _removedGames.value;
    removedGames.clear();
    changeRemovedGamesStream(removedGames);
  }

  bool canTrade() {
    User user = _currentUser.value;
    if ( user.location != null &&
        user.district != null && (user.district != 500000 || user.location != 500000)) {
      return true;
    } else {
      return false;
    }
  }

    User getCurrentUser() {
      return _currentUser.value;
    }


  void updateGameTags(String firebase_uid) async {
    if(_updatedGames.value.length > 0)
    {
      List<Game> updatedGames = new List<Game>();
      updatedGames.addAll(_updatedGames.value);
      var json = Game.encondeToJson(updatedGames);
      NetworkHttpCalls httpCalls = new NetworkHttpCalls(/*context*/);
      bool isSuccessfully = await httpCalls.updateGameTags(json.toString(),firebase_uid);
      if(!isSuccessfully)
      {
        changeUpdatedGamesStream(updatedGames);
      }else{
        MyGamesSQLDatabase database = MyGamesSQLDatabase();
        database.openDb();
        print('ssss ${updatedGames.toString()}');
        for(Game updatedGame in updatedGames) {
          database.updateGame(updatedGame);
          print('AFTER UPDATE ${updatedGame.toString()}');
        }
        updatedGames.clear();
        List<Game> list = _updatedGames.value;
        list.clear();
        changeUpdatedGamesStream(list);

      }
    }

    if(_updatedWishes.value.length > 0)
    {
      List<Game> updatedWishes = new List<Game>();
      updatedWishes.addAll(_updatedWishes.value);
      var json = Game.encondeToJson(updatedWishes);
      NetworkHttpCalls httpCalls = new NetworkHttpCalls(/*context*/);
      bool isSuccessfully = await httpCalls.updateGameTags(json.toString(),firebase_uid);
      if(!isSuccessfully)
      {
        changeUpdatedWishesStream(updatedWishes);
      }else{
        MyGamesSQLDatabase database = MyGamesSQLDatabase();
        database.openDb();
        print('ssss ${updatedWishes.toString()}');
        for(Game updatedGame in updatedWishes) {
          database.updateGame(updatedGame);
          print('AFTER UPDATE ${updatedGame.toString()}');
        }
        updatedWishes.clear();
        List<Game> list = _updatedWishes.value;
        list.clear();
        changeUpdatedWishesStream(list);

      }
    }

  }

  }