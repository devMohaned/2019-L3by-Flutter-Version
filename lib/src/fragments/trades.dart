import 'package:flutter/material.dart';
import 'package:flutter_games_exchange/database/game_sql_database.dart';
import 'package:flutter_games_exchange/models/game.dart';
import 'package:flutter_games_exchange/models/trade_model.dart';
import 'package:flutter_games_exchange/models/user.dart';
import 'package:flutter_games_exchange/providers/homepage_provider.dart';
import 'package:flutter_games_exchange/providers/trade_provider.dart';
import 'package:flutter_games_exchange/network/http/http_requests.dart';
import 'package:flutter_games_exchange/src/trade/trading_user.dart';
import 'package:flutter_games_exchange/src/utils/location_utils.dart';
import 'package:flutter_svg/svg.dart';

class TradeScreen extends StatefulWidget {
  List<TradeModel> tradeList = new List<TradeModel>();
  List<Game> items = new List();

  String firebase_uid;
  HomePageBloc _homePageBloc;

  TradeScreen(this.firebase_uid, this._homePageBloc);

  @override
  State createState() {
    return TradeScreenState(firebase_uid,_homePageBloc);
  }


}

class TradeScreenState extends State<TradeScreen> {
  List<TradeModel> tradeList = new List<TradeModel>();
  List<Game> items = new List();

  String firebase_uid;
  HomePageBloc _homePageBloc;

  TradeScreenState(this.firebase_uid, this._homePageBloc);


  @override
  void initState() {
    getItemsFromNetwork();
  }

  @override
  Widget build(BuildContext context) {
    TradeBloc _bloc = TradeProvider.of(context);
    return buildList(_bloc);
  }

  Widget buildList(bloc) {
    return RefreshIndicator(
        child:/* FutureBuilder(
          future: getItemsFromNetwork(bloc),
          builder:
              (BuildContext context, AsyncSnapshot<List<TradeModel>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return new Center(
                  child: CircularProgressIndicator(),
                );
              default:
                if (snapshot.hasError) {
                  return new Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<TradeModel> trades = snapshot.data;
                  if (trades.length == 0) {
                    return new Center(child: Text('No Trades Found'));
                  }

                  return new StreamBuilder<List<TradeModel>>(
                    stream: bloc.tradeListStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<TradeModel>> snapShot) {
                      List<TradeModel> streamedTrades = snapShot.data;
                      if (snapShot.hasData) {
                        if (streamedTrades.length == 0) {
                          return new Center(child: Text('No Trades Found'));
                        }*/

                         ListView.builder(
                            itemCount: tradeList.length,
                            itemBuilder: (context, index) {
                              TextTheme textTheme = Theme.of(context).textTheme;
                              TradeModel trade = tradeList[index];

                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 10.0),
                                decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TradingUserScreen(
                                            trade, _homePageBloc),
                                      ),
                                    );
                                  },
                                  child: new Card(
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Flexible(
                                              flex: 1,
                                              child: new Column(
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.all(8.0),
                                                    child:  SvgPicture.asset(
                                                      'images/vectors/active_gamepad.svg',
                                                      height: 32.0,
                                                      width: 32.0,
                                                      allowDrawingOutsideViewBox: true,
                                                      color: Theme.of(context).primaryColor,
                                                    ),
                                                  ),
                                                  Text(
                                                      '${trade.game_owner_games.length}')
                                                ],
                                              ),
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: trade.game_owner_profile_image != null ? Image.network('${trade.game_owner_profile_image}') :  CircleAvatar(child: Container(color: Colors.blue),radius: 54.0,)
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: new Column(
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.all(8.0),
                                                    child:  SvgPicture.asset(
                                                      'images/vectors/active_wish.svg',
                                                      height: 32.0,
                                                      width: 32.0,  allowDrawingOutsideViewBox: true,
                                                      color: Colors.redAccent,
                                                    ),
                                                  ),
                                                  Text(
                                                      '${trade.game_owner_wishes.length}')
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Center(
                                          child: Container(
                                            margin:
                                                EdgeInsets.only(bottom: 4.0),
                                            child: Text(
                                              '${trade.game_owner_first_name} ${trade.game_owner_last_name}',
                                              style: TextStyle(
                                                  decorationStyle:
                                                      TextDecorationStyle.solid,
                                                  fontSize: 18.0),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Container(
                                            margin:
                                                EdgeInsets.only(bottom: 4.0),
                                            child: Text(
                                              '${LocationUtils.getDistrictFromIndex(trade.game_owner_district)}, ${LocationUtils.getEgyptLocationStringFromIndex(trade.game_owner_location)}',
                                              style: TextStyle(
                                                  decorationStyle:
                                                      TextDecorationStyle.solid,
                                                  fontSize: 16.0),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Container(
                                            margin:
                                                EdgeInsets.only(bottom: 4.0),
                                            child: Text(
                                              '${trade.game_owner_common_games_count} Mutual Games',
                                              style: TextStyle(
                                                  decorationStyle:
                                                      TextDecorationStyle.solid,
                                                  fontSize: 14.0),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }), onRefresh: () => getItemsFromNetwork());
                     /* } else {
                        if (snapShot.hasError) {
                          print('Errorr ${snapShot.error.toString()}');
                          return new Container(
                            child: new Center(
                                child: new Text('Cannot find trades.')),
                          );
                        } else {
                          return Container(
                            child: new Center(
                              child: new CircularProgressIndicator(),
                            ),
                          );
                        }
                      }
                    },
                  );
                }
            }
          },
        ),*/
//        onRefresh: () => getItemsFromNetwork(bloc));
  }

  Future<List<TradeModel>> getItemsFromNetwork() async {
      User currentUser = _homePageBloc.getCurrentUser();
      NetworkHttpCalls networkHttpCalls = new NetworkHttpCalls();
      List<TradeModel> trades = await networkHttpCalls.getTrades(
          firebase_uid,
          currentUser.location,
          /*currentUser.district*/ 500000,
          currentUser.platform,
          0,
          20);
      tradeList = trades;
      setState(() {});
      return trades;

  }
}
