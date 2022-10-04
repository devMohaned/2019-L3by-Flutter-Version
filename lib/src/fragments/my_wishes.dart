import 'package:flutter/material.dart';
import 'package:flutter_games_exchange/database/game_sql_database.dart';
import 'package:flutter_games_exchange/models/game.dart';
import 'package:flutter_games_exchange/providers/homepage_provider.dart';
import 'package:flutter_games_exchange/network/http/http_requests.dart';
import 'package:flutter_games_exchange/database/my_games_sql_database.dart';
import 'package:flutter_games_exchange/providers/my_games_provider.dart';
import 'package:flutter_games_exchange/providers/my_wishes_provider.dart';
import 'package:flutter_svg/svg.dart';

class MyWishesScreen extends StatelessWidget {
  List<Game> items = new List();

  String firebase_uid;
  MyGamesBloc myGamesBloc;
  HomePageBloc myHomePageBloc;

  MyWishesScreen(this.firebase_uid, this.myGamesBloc, this.myHomePageBloc);

  @override
  Widget build(BuildContext context) {
    MyWishesBloc _bloc = MyWishesProvider.of(context);
    return buildList(_bloc);
  }

  Widget buildList(MyWishesBloc bloc) {
    return RefreshIndicator(
        child: FutureBuilder(
          future: bloc.getItemsLocally(firebase_uid),
          builder: (BuildContext context, AsyncSnapshot<List<Game>> snapshot) {
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
                  List<Game> games = snapshot.data;
                  if (games.length == 0) {
                    return new Center(child: Text('No Games Found'));
                  }

                  return new StreamBuilder<List<Game>>(
                    stream: bloc.wishListStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Game>> snapShot) {
                      List<Game> streamedGames = snapShot.data;
                      if (snapShot.hasData) {
                        if (streamedGames.length == 0) {
                          return new Center(child: Text('No Games Found'));
                        }

                        return ListView.builder(
                            itemCount: streamedGames.length,
                            itemBuilder: (context, index) {
                              TextTheme textTheme = Theme.of(context).textTheme;
                              Game game = streamedGames[index];

                              return new Dismissible(
                                background:
                                    Container(color: Colors.grey.shade300),
                                onDismissed: (direction) => bloc.removeGame(
                                    streamedGames, game, context),
                                key: Key(game.game_name),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5.0),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 10.0),
                                  decoration: new BoxDecoration(
                                    borderRadius:
                                        new BorderRadius.circular(15.0),
                                  ),
                                  child: new IntrinsicHeight(
                                    child: new Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        new Expanded(
                                          child: new Text(
                                            game.game_name,
                                            style: textTheme.title,
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                        InkWell(
                                          child: Container(
                                            margin: EdgeInsets.all(8.0),
                                            child: game.tag == 1
                                                ? SvgPicture.asset(
                                                    'images/vectors/active_price.svg',
                                                    height: 32.0,
                                                    width: 32.0,
                                                    allowDrawingOutsideViewBox:
                                                        true,
                                                  )
                                                : SvgPicture.asset(
                                                    'images/vectors/inactive_price.svg',
                                                    height: 32.0,
                                                    width: 32.0,
                                                    allowDrawingOutsideViewBox:
                                                        true,
                                                  ),
                                          ),
                                          onTap: () {
                                            bloc.updateGame(context, game, 1,
                                                game.game_name);
                                          },
                                        ),
                                        InkWell(
                                          child: Container(
                                            margin: EdgeInsets.all(8.0),
                                            child: game.tag == 0
                                                ? SvgPicture.asset(
                                                    'images/vectors/active_free.svg',
                                                    height: 32.0,
                                                    width: 32.0,
                                                    allowDrawingOutsideViewBox:
                                                        true,
                                                  )
                                                : SvgPicture.asset(
                                                    'images/vectors/inactive_free.svg',
                                                    height: 32.0,
                                                    width: 32.0,
                                                    allowDrawingOutsideViewBox:
                                                        true,
                                                    color: Colors.black,
                                                  ),
                                          ),
                                          onTap: () {
                                            bloc.updateGame(context, game, 0,
                                                game.game_name);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      } else {
                        if (snapShot.hasError) {
                          print('Errorr ${snapShot.error.toString()}');
                          return new Container(
                            child: new Center(
                                child: new Text('Cannot find games.')),
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
        ),
        onRefresh: () => bloc.getItemsFromNetwork(firebase_uid));
  }
}
