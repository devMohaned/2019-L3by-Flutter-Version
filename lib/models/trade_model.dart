import 'package:flutter_games_exchange/models/game.dart';
import 'package:flutter_games_exchange/src/utils/constants.dart';
import 'dart:convert';


class TradeModel {
  static String constantProfile = 'https://i.imgur.com/z6v5keo.jpg';

  int game_owner_location = 500000,
      game_owner_district = 500000,
      game_owner_common_games_count,
      game_owner_online_status;

  String my_user_id,
      game_owner_first_name,
      game_owner_last_name,
      common_user_id,
      game_owner_profile_image,
      game_owner_token;

  List<String> my_games_game_name, my_wished_game_name;
  List<Game> game_owner_wishes, game_owner_games;

  TradeModel(
      this.my_user_id,
      this.game_owner_first_name,
      this.game_owner_last_name,
      this.my_games_game_name,
      this.my_wished_game_name,
      this.common_user_id,
      this.game_owner_profile_image,
      this.game_owner_token,
      this.game_owner_wishes,
      this.game_owner_games,
      this.game_owner_location,
      this.game_owner_district,
      this.game_owner_common_games_count,
      this.game_owner_online_status);

  TradeModel.fromJson(Map<String, dynamic> json)
      : game_owner_location = json['game_owner_location'] != null
            ? int.parse(json['game_owner_location'])
            : 500000,
        game_owner_district = json['game_owner_district'] != null
            ? int.parse(json['game_owner_district'])
            : 500000,
        game_owner_common_games_count =
            json['game_owner_common_games_count'] != null
                ? json['game_owner_common_games_count'] as int
                : 0,
        game_owner_online_status = json['game_owner_online_status'] != null
            ? int.parse(json['game_owner_online_status'])
            : 0,
        my_user_id = json['my_user_id'],
        game_owner_first_name = json['game_owner_first_name'],
        game_owner_last_name = json['game_owner_last_name'],
        common_user_id = json['common_user_id'],
        game_owner_profile_image =
            /*'${Constants.PROFILE_LINK} */json['game_owner_profile_image'] != null ? '${json['game_owner_profile_image']}' : constantProfile,
        game_owner_token = json['game_owner_token'],
        my_games_game_name = json['my_games_game_name'].length > 4
            ? getMyGamesOrWishesNamesFromJson(json['my_games_game_name'])
            : new List(),
        my_wished_game_name = json['my_wished_game_name'].length > 4
            ? getMyGamesOrWishesNamesFromJson(json['my_wished_game_name'])
            : new List(),
        game_owner_wishes = json['game_owner_wishes'].length > 4
            ? getGameOwnerGamesOrWishesNamesFromJson(json['game_owner_wishes'])
            : new List(),
        game_owner_games = json['game_owner_games'].length > 4
            ? getGameOwnerGamesOrWishesNamesFromJson(json['game_owner_games'])
            :  new List();

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
