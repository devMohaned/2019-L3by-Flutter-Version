import 'dart:convert';

import 'package:flutter_games_exchange/models/game.dart';
import 'package:flutter_games_exchange/src/utils/constants.dart';

class Room {
  String firebase_uid,
      first_name,
      last_name,
      online_status,
      profile_image,
      token,last_text;
  String room_id, room_sender_id, room_reciever_id;
  int last_sent;
  int location, district;
  int game_owner_common_games_count;


  List<String> my_games, my_wishes;
  List<Game> game_owner_games, game_owner_wishes;

  bool seen = false;

  Room(
      this.room_id, this.room_sender_id, this.room_reciever_id, this.last_sent);

  Room.fromJson(Map<String, dynamic> json)
      : room_id = json['room_id'],
        room_sender_id = json['room_sender_id'],
        room_reciever_id = json['room_reciever_id'],
        last_sent = int.parse(json['last_sent']),
        firebase_uid = json['firebase_uid'],
        first_name = json['first_name'],
        last_name = json['last_name'],
        online_status = json['online_status'],
        profile_image = /*'${Constants.PROFILE_LINK} */ '${json['profile_image']}',
        token = json['token'],
        location = json['location'] != null
            ? int.parse(json['location'])
            : 500000,
        district = json['district'] != null
            ? int.parse(json['district'])
            : 500000,
        game_owner_common_games_count = json['game_owner_common_games_count'],
        my_games = json['my_games'].length > 4
            ? getMyGamesOrWishesNamesFromJson(json['my_games'])
            : new List(),
        my_wishes = json['my_wishes'].length > 4
            ? getMyGamesOrWishesNamesFromJson(json['my_wishes'])
            : new List(),
        game_owner_wishes = json['game_owner_wishes'].length > 4
            ? getGameOwnerGamesOrWishesNamesFromJson(json['game_owner_wishes'])
            : new List(),
        game_owner_games = json['game_owner_games'].length > 4
            ? getGameOwnerGamesOrWishesNamesFromJson(json['game_owner_games'])
            :  new List();




  Map<String, dynamic> toMap() {
    return {
      'room_id': room_id,
      'room_sender_id': room_sender_id,
      'room_reciever_id': room_reciever_id,
      'room_created_by': room_sender_id,
    };
  }


  static List<String> getMyGamesOrWishesNamesFromJson(String json) {
    Iterable l = jsonDecode(json);
    List<String> gameNames = l.map((model) => '${model['game_name']}'
    ).toList();
    return gameNames;
  }

  static List<Game> getGameOwnerGamesOrWishesNamesFromJson(String json) {
    Iterable l = jsonDecode(json);
    List<Game> gamess = l.map((model) => Game.fromJson(model)).toList();
    return gamess;
  }
}
