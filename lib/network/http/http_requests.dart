import 'dart:convert';
import 'package:flutter_games_exchange/bloc/homepage_bloc.dart';
import 'package:flutter_games_exchange/database/my_games_sql_database.dart';
import 'package:flutter_games_exchange/models/room.dart';
import 'package:flutter_games_exchange/models/trade_model.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_games_exchange/models/user.dart';
import 'package:flutter_games_exchange/models/game.dart';

class NetworkHttpCalls {
  // http://
  final String _url = "http://139.162.182.101";
  final int _port = 80;
  BuildContext context;

  NetworkHttpCalls(/*this.context*/);

  Future<http.Response> addUser(User user) async {
    Map<String, dynamic> userMap = user.toMap();
    http.Response response = await http.post(
        '$_url/flutter/pc/add_user.php?api_key=com_trade_api_key',
        body: userMap,
        encoding: utf8);
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      print('${response.statusCode} Done');
      return response;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<User> getUserData(String firebase_uid) async {
    http.Response response;
    try {
      response = await http.get(
          '$_url/flutter/pc/get_user_data.php?api_key=com_trade_api_key&firebase_uid=$firebase_uid');
    } catch (socketException) {
      return User.dummyUser();
    }

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
//      print('User Obtained Successfully');
      Map<String, dynamic> decodedJson = json.decode(response.body);
      print('body ${decodedJson.toString()}');
      print('bodyy ${decodedJson['location']} ++ ${decodedJson['district']}');
      return User.fromJson(decodedJson);
    } else {
      // If that response was not OK, throw an error.
//      print('User Was Not Obtained Correctly');
      return User.dummyUser();
//      throw Exception('Failed to load post');
    }
  }

  Future<bool> addGame(List<Game> addedGames, String games, String firebase_uid,
      String flag) async {
    final response = await http.get(
        '$_url/flutter/pc/add_games.php?api_key=com_trade_api_key&firebase_uid=$firebase_uid&games=$games&flag=$flag');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      MyGamesSQLDatabase database = new MyGamesSQLDatabase();
      await database.openDb();
      for (Game game in addedGames) {
        game.flag = flag;
        game.is_selected = true;
        await database.insertGame(game);
      }
      return true;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<List<Game>> getGames(String firebase_uid, String flag) async {
    final response = await http.get(
        '$_url/flutter/pc/get_games.php?api_key=com_trade_api_key&firebase_uid=$firebase_uid&flag=$flag');
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      Iterable body = json.decode(response.body);
      print('BODY $body');
      if (body != null) {
        List<Game> games = body.map((model) => Game.fromJson(model)).toList();
        print('Games ${games.toString()}');
        return games;
      }
      return new List();
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<bool> removeGames(
      List<Game> removedGames, String games, String firebase_uid) async {
    final response = await http.get(
        '$_url/flutter/pc/remove_game.php?api_key=com_trade_api_key&firebase_uid=$firebase_uid&games=$games');
    print(
        '$_url/flutter/pc/remove_game.php?api_key=com_trade_api_key&firebase_uid=$firebase_uid&games=$games');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      MyGamesSQLDatabase database = new MyGamesSQLDatabase();
      await database.openDb();
      for (Game game in removedGames) {
        await database.deleteGame(game);
      }
      return true;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<bool> updateLocationAndDistrict(
      String firebase_uid, int location, int district) async {
    final response = await http.get(
        '$_url/flutter/pc/update_location_and_district.php?api_key=com_trade_api_key&firebase_uid=$firebase_uid&location=$location&district=$district');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return true;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to update Location & District');
    }
  }

  Future<List<TradeModel>> getTrades(
      String firebase_uid,
      int location,
      int district,
      String platform,
      int starting_limit,
      int ending_limit) async {
    var finalDistrict;
    district == 500000 ? finalDistrict = "null" : finalDistrict = district;
    final response = await http.get(
        '$_url/flutter/pc/get_trades.php?api_key=com_trade_api_key&firebase_uid=$firebase_uid&location=$location&district=$finalDistrict&platform=$platform&starting_limit=$starting_limit&ending_limit=$ending_limit');
    print(
        '$_url/flutter/pc/get_trades.php?api_key=com_trade_api_key&firebase_uid=$firebase_uid&location=$location&district=$finalDistrict&platform=$platform&starting_limit=$starting_limit&ending_limit=$ending_limit');
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      Iterable body = json.decode(response.body);
      print('BODY TRADE $body');
      List<TradeModel> trades = body.map((model) {
        print('${model.toString()}');
        if (model['my_games_game_name'] != null) {
          print('My Games game name ${model['my_games_game_name']}');
        } else {
          print('My Games game name null}');
        }
        return TradeModel.fromJson(model);
      }).toList();
      print('Trades ${trades.toString()}');

      return trades;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load trades');
    }
  }

  Future<String> addRoom(Room room) async {
    print('ressss roooom ${room.toMap().toString()}');
    Map<String, dynamic> roomMap = room.toMap();
    http.Response response = await http.post(
        '$_url/flutter/pc/add_room.php?api_key=com_trade_api_key',
        body: roomMap,
        encoding: utf8);
    print('ressss roooom ${roomMap.toString()}');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      print('${response.statusCode} Done');
      return response.body;
    } else {
      // If that response was not OK, throw an error.
      print(' COULD NOT ADD');
      throw Exception('Failed to load post');
    }
  }

  Future<List<Room>> getRooms(
      String firebase_uid, int starting_limit, int ending_limit) async {
    final response = await http.get(
        '$_url/flutter/pc/get_rooms.php?api_key=com_trade_api_key&firebase_uid=$firebase_uid&starting_limit=$starting_limit&ending_limit=$ending_limit');
    print( '$_url/flutter/pc/get_rooms.php?api_key=com_trade_api_key&firebase_uid=$firebase_uid&starting_limit=$starting_limit&ending_limit=$ending_limit');
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      Iterable body = json.decode(response.body);
      print('BODY TRADE $body');
      if(body != null) {
        List<Room> rooms = body.map((model) {
          print('${model.toString()}');
          return Room.fromJson(model);
        }).toList();
        print('Trades ${rooms.toString()}');

        return rooms;
      }
      return new List<Room>();
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load trades');
    }
  }

  updateUser(String first_name, String last_name, int location, int district,
      String firebase_uid, HomePageBloc _homePageBloc) async {
    final response = await http.get(
        '$_url/flutter/pc/update_user.php?api_key=com_trade_api_key&first_name=$first_name&last_name=$last_name&location=$location&district=$district&firebase_uid=$firebase_uid');
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      _homePageBloc.changeCurrentUser(await getUserData(firebase_uid));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<http.Response> updateImage(String firebase_uid, String imageLink) async {
    Map<String, dynamic> map = {
      "file_name": '$imageLink',
      "firebase_uid": '$firebase_uid'
    };
    print(map.toString());

    http.Response response = await http.post(
        '$_url/flutter/pc/update_profile_image_url.php?api_key=com_trade_api_key',
        body: map,
        encoding: utf8);
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      print('${response.statusCode} Doneeeeeeeeeeeee');
      print('${response.body.toString()} Doneeeeeeeeeeeee');
      return response;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  // If 0, then user's online
  // if 1 then user's offline
  Future<http.Response> setOnlineStatus(String firebase_uid, int status) async {
    Map<String, dynamic> map = {
      "online_status": '$status',
      "firebase_uid": '$firebase_uid'
    };

    http.Response response = await http.post(
        '$_url/flutter/pc/add_online_status.php?api_key=com_trade_api_key',
        body: map,
        encoding: utf8);
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      print('${response.statusCode} Done');
      return response;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  updateGameTags(String json, String firebase_uid) async {
    Map<String, dynamic> map = {
      "games": '$json',
      "firebase_uid": '$firebase_uid'
    };

    http.Response response = await http.post(
        '$_url/flutter/pc/update_game_tags.php?api_key=com_trade_api_key',
        body: map,
        encoding: utf8);
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      print('${response.statusCode} Done \n $json \n ${response.body}');
      return true;
    } else {
      // If that response was not OK, throw an error.
      return false;
      throw Exception('Failed to load post');
    }

  }
}
