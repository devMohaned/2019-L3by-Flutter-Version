import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_games_exchange/bloc/homepage_bloc.dart';
import 'package:flutter_games_exchange/src/messaging/messaging.dart';
import 'package:flutter_games_exchange/models/game.dart';
import 'package:flutter_games_exchange/models/message.dart';
import 'package:flutter_games_exchange/models/room.dart';
import 'package:flutter_games_exchange/models/trade_model.dart';
import 'package:flutter_games_exchange/models/user.dart';
import 'package:flutter_games_exchange/network/http/http_requests.dart';
import 'package:flutter_games_exchange/src/utils/location_utils.dart';
import 'package:flutter_games_exchange/styles/text_styles.dart';
import 'package:flutter_svg/svg.dart';

class TradingUserScreen extends StatelessWidget {
  TradeModel tradeModel;
  HomePageBloc homePageBloc;

  TradingUserScreen(this.tradeModel, this.homePageBloc);

  @override
  Widget build(BuildContext context) {
    return buildList(context);
  }

  Widget buildList(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => addRoom(context),
        child: Icon(Icons.chat_bubble, color: Colors.white),
      ),
      appBar: getToolbar(),
      body: ListView(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  child:
                      Image.network('${tradeModel.game_owner_profile_image}'),
                  radius: 72,
                ),
              ),
              new Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${tradeModel.game_owner_first_name} ${tradeModel.game_owner_last_name}',
                      style: TextStyle(
                          decorationStyle: TextDecorationStyle.solid,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${LocationUtils.getDistrictFromIndex(tradeModel.game_owner_district)}, ${LocationUtils.getEgyptLocationStringFromIndex(tradeModel.game_owner_location)}',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    Center(
                      child: Text(
                        '${tradeModel.game_owner_common_games_count} Mutual Games',
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                'images/vectors/active_gamepad.svg',
                height: 32.0,
                width: 32.0,
                allowDrawingOutsideViewBox: true,
                color: Theme.of(context).primaryColor,
              ),
              Text(
                '${tradeModel.game_owner_first_name}\'s Games',
                style: TextStyles.tradingUserTitleTextStyle,
              )
            ],
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: tradeModel.game_owner_games.length,
              itemBuilder: (context, index) {
                Game game = tradeModel.game_owner_games[index];
                return Row(
                    children: <Widget>[
                Expanded(
                child: Container(
                  margin: EdgeInsets.all(4.0),
                  child: Text(
                    '${game.game_name}',
                    style: isCommonGame(2, game.game_name)
                        ? TextStyles.tradingUserCommonGamesTextStyle
                        : TextStyles.tradingUserGamesTextStyle,
                  ),
                )),
                      Container(
                        margin: EdgeInsets.all(8.0),
                        child: game.tag == 1
                            ? SvgPicture.asset(
                          'images/vectors/active_price.svg',
                          height: 32.0,
                          width: 32.0,
                          allowDrawingOutsideViewBox: true,
                        )
                            : SvgPicture.asset(
                          'images/vectors/inactive_price.svg',
                          height: 32.0,
                          width: 32.0,
                          allowDrawingOutsideViewBox: true,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(8.0),
                        child: game.tag == 0
                            ? SvgPicture.asset(
                          'images/vectors/active_free.svg',
                          height: 32.0,
                          width: 32.0,
                          allowDrawingOutsideViewBox: true,
                        )
                            : SvgPicture.asset(
                          'images/vectors/inactive_free.svg',
                          height: 32.0,
                          width: 32.0,
                          allowDrawingOutsideViewBox: true,
                          color: Colors.black,
                        ),
                      ),
                    ],
                );  // HERE goes your list item
              }),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  'images/vectors/active_wish.svg',
                  height: 32.0,
                  width: 32.0,
                  allowDrawingOutsideViewBox: true,
                  color: Theme.of(context).primaryColor,
                ),
                Text(
                  '${tradeModel.game_owner_first_name}\'s Wishes',
                  style: TextStyles.tradingUserTitleTextStyle,
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: tradeModel.game_owner_wishes.length,
            itemBuilder: (context, index) {
              Game game = tradeModel.game_owner_wishes[index];
              return Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '${game.game_name}',
                      style: isCommonGame(1, game.game_name)
                          ? TextStyles.tradingUserCommonGamesTextStyle
                          : TextStyles.tradingUserGamesTextStyle,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8.0),
                    child: game.tag == 1
                        ? SvgPicture.asset(
                            'images/vectors/active_price.svg',
                            height: 32.0,
                            width: 32.0,
                            allowDrawingOutsideViewBox: true,
                          )
                        : SvgPicture.asset(
                            'images/vectors/inactive_price.svg',
                            height: 32.0,
                            width: 32.0,
                            allowDrawingOutsideViewBox: true,
                          ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8.0),
                    child: game.tag == 0
                        ? SvgPicture.asset(
                            'images/vectors/active_free.svg',
                            height: 32.0,
                            width: 32.0,
                            allowDrawingOutsideViewBox: true,
                          )
                        : SvgPicture.asset(
                            'images/vectors/inactive_free.svg',
                            height: 32.0,
                            width: 32.0,
                            allowDrawingOutsideViewBox: true,
                            color: Colors.black,
                          ),
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
  }

  Widget getToolbar() {
    return AppBar(
      automaticallyImplyLeading: true,
      title: Text('Trading'),
    );
  }

  void addRoom(BuildContext context) async {
    User currentUser = homePageBloc.getCurrentUser();
    String room_id = FirebaseDatabase.instance.reference().push().key;
    String room_sender_id = tradeModel.my_user_id;
    String room_reciever_id = tradeModel.common_user_id;

    Room room = new Room(room_id, room_sender_id, room_reciever_id, 0);

    NetworkHttpCalls networkHttpCalls = new NetworkHttpCalls();
    String responseRoomId = await networkHttpCalls.addRoom(room);
    print('ressss ${responseRoomId}');
    if (responseRoomId == 'inserted') {
      await sendMessage(room_id, currentUser, context);
    } else {
      print('$responseRoomId nnnnnnnnnnnn');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MessageScreen(
              responseRoomId,
              tradeModel.common_user_id,
              '${tradeModel.game_owner_first_name} ${tradeModel.game_owner_last_name}',
              tradeModel.game_owner_profile_image,
              tradeModel.game_owner_token,
              'no',
              currentUser.firebase_uid,
              tradeModel.game_owner_location,
              tradeModel.game_owner_district,
              tradeModel.game_owner_common_games_count,
              tradeModel.my_games_game_name,
              tradeModel.my_wished_game_name,
              tradeModel.game_owner_games,
              tradeModel.game_owner_wishes),
        ),
      );
    }
  }

  Future sendMessage(
      String roomId_PushedKey, User currentUser, BuildContext context) async {
    int timeInMilliSeconds = new DateTime.now().millisecondsSinceEpoch;
    String chatText = 'Trade?';
    Message message = new Message(
        roomId_PushedKey,
        currentUser.firebase_uid,
        '${currentUser.first_name} ${currentUser.last_name}',
        chatText,
        false,
        timeInMilliSeconds);
    await FirebaseDatabase.instance
        .reference()
        .child("messages")
        .child(roomId_PushedKey)
        .child(roomId_PushedKey)
        .set(message.toMap());

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessageScreen(
            roomId_PushedKey,
            tradeModel.common_user_id,
            '${tradeModel.game_owner_first_name} ${tradeModel.game_owner_last_name}',
            tradeModel.game_owner_profile_image,
            tradeModel.game_owner_token,
            'no',
            currentUser.firebase_uid,
            tradeModel.game_owner_location,
            tradeModel.game_owner_district,
            tradeModel.game_owner_common_games_count,
            tradeModel.my_games_game_name,
            tradeModel.my_wished_game_name,
            tradeModel.game_owner_games,
            tradeModel.game_owner_wishes),
      ),
    );
  }

  bool isCommonGame(int state, String gameName) {
    if (state == 1) {
      if (tradeModel.my_games_game_name.contains(gameName)) {
        return true;
      }
      return false;
    } else if (state == 2) {
      if (tradeModel.my_wished_game_name.contains(gameName)) {
        return true;
      }
      return false;
    }
  }
}
