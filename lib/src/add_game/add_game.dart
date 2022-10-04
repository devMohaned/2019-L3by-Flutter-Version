//import 'package:flutter/material.dart';
//import 'package:flutter_games_exchange/src/database/game_sql_database.dart';
//import 'package:flutter_games_exchange/src/models/game.dart';
//import 'package:flutter_games_exchange/src/providers/add_game_provider.dart';
//
//class AddGameScreen extends StatelessWidget {
//  String flag;
//
//  AddGameScreen(this.flag);
//
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    AddGameBloc _bloc = AddGameProvider.of(context);
////    getItems(_bloc);
//
//    return page(context, _bloc);
//  }
//
//  page(BuildContext context, AddGameBloc _bloc) {
//    return WillPopScope(
//      onWillPop: () {
//        unselectAllGames(context, _bloc);
//        return new Future(() => false);
//      },
//      child: Scaffold(
//        appBar: buildAppBar(context, _bloc),
//        body: buildList(_bloc),
//
//      ),
//    );
//  }
//
//  Widget searchField(_bloc) {
//    TextField(
//      onChanged: (value) {
//        getItemsByName(_bloc, value);
//      },
//      decoration: InputDecoration(border: InputBorder.none, hintText: 'Search'),
//    );
//  }
//
//  Widget buildAppBar(BuildContext context, AddGameBloc _bloc) {
//    return AppBar(
//      title: StreamBuilder<bool>(
//        stream: _bloc.isIconifiedStream,
//        builder: (BuildContext context, AsyncSnapshot snapshot) {
//          if (snapshot.hasData) {
//            if (snapshot.data) {
//              return flag == 'o'
//                  ? const Text('Select Your Games')
//                  : const Text('Choose Your Wishes');
//            }
//            return searchView(_bloc);
//          }
//          return flag == 'o'
//              ? const Text('Select Your Games')
//              : const Text('Choose Your Wishes');
//        },
//      ),
//
//      /*
//          *
//          * _bloc.isIconifiedLastValue()
//          ? flag == 'o' ? const Text('Select Your Games') : searchView(_bloc)
//          : flag == 'o' ? const Text('Choose Your Wishes') : searchView(_bloc),
//          * */
//
//      /*
//      *
//       flag == 'o'
//          ? const Text('Select Your Games')
//          : const Text('Choose Your Wishes'),
//      *
//      * */
//
//      actions: <Widget>[
//        // action button
//        new StreamBuilder<bool>(
//          stream: _bloc.isIconifiedStream,
//          builder: (BuildContext context, AsyncSnapshot snapshot) {
//            if (snapshot.hasData) {
//              if (snapshot.data) {
//                return new IconButton(
//                  icon: Icon(Icons.search),
//                  onPressed: () {
//                    _bloc.changeIsIconifiedStream(false);
//                  },
//                );
//              }
//              return new IconButton(
//                icon: Icon(Icons.close),
//                onPressed: () {
//                  _bloc.changeIsIconifiedStream(true);
//                },
//              );
//            }
//            return new IconButton(
//              icon: Icon(Icons.search),
//              onPressed: () {
//                _bloc.changeIsIconifiedStream(false);
//              },
//            );
//          },
//        ),
//        IconButton(
//          icon: Icon(Icons.check),
//          onPressed: () {
//            _bloc.sendGamesToServer(flag);
//            unselectAllGames(context, _bloc);
//          },
//        ),
//      ],
//    );
//  }
//
//  Widget searchView(AddGameBloc _bloc) {
//    return new StreamBuilder<String>(
////        initialData: '',
//        stream: _bloc.filterGameStream,
//        builder: (BuildContext context, AsyncSnapshot<String> snapShot) {
//          return TextField(
//            onChanged: (value) => getItemsByName(_bloc, value),
//            style: new TextStyle(
//              color: Colors.white,
//            ),
//            decoration: new InputDecoration(
//                prefixIcon: new Icon(Icons.search, color: Colors.white),
//                hintText: "Search",
//                hintStyle: new TextStyle(color: Colors.white)),
//          );
//        });
//  }
//
//  Widget buildList(bloc) {
////    return ListView.builder(
//    ///*
////      itemCount: items.length,
////*/
////      itemBuilder: (context, index) {
////        return new StreamBuilder<List<Game>>(
////          stream: bloc.gameListStream,
////          builder: (BuildContext context, AsyncSnapshot<List<Game>> snapShot) {
////            if (snapShot.hasData) {
////              Game game = snapShot.data[index];
////
////
////
////              TextTheme textTheme = Theme.of(context).textTheme;
////              return new InkWell(
////                onTap: () {
////                  updateGame(bloc, game);
////                  bloc.changeGameListStream(snapShot.data);
////                },
////                child: new Container(
////                  margin: const EdgeInsets.symmetric(
////                      horizontal: 10.0, vertical: 5.0),
////                  padding: const EdgeInsets.symmetric(
////                      horizontal: 15.0, vertical: 10.0),
////                  decoration: new BoxDecoration(
////                    color: Colors.grey.shade200.withOpacity(0.5),
////                    borderRadius: new BorderRadius.circular(15.0),
////                  ),
////                  child: new IntrinsicHeight(
////                    child: new Row(
////                      crossAxisAlignment: CrossAxisAlignment.stretch,
////                      children: <Widget>[
////                        new Expanded(
////                          child: new Text(
////                            game.game_name,
////                            style: textTheme.title,
////                            textAlign: TextAlign.start,
////                          ),
////                        ),
////                        new Checkbox(
////                          value: game.is_selected,
////                          onChanged: (bool value) {
////                            updateGame(bloc, game);
////                            bloc.changeGameListStream(snapShot.data);
////                          },
////                        ),
////                      ],
////                    ),
////                  ),
////                ),
////              );
////            } else {
////              if (snapShot.hasError) {
////                return new Container(
////                  child: new Center(child: new Text('Cannot find games.')),
////                );
////              }
////              return Container(
////                margin:
////                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
////                padding: const EdgeInsets.symmetric(
////                    horizontal: 15.0, vertical: 10.0),
////                decoration: new BoxDecoration(
////                  color: Colors.grey.shade300,
////                  borderRadius: new BorderRadius.circular(15.0),
////                ),
////                height: 60,
////              );
////            }
////          },
////        );
////      },
////    );
//
//
//
//        return FutureBuilder(
//          future: getItems(bloc),
//          builder: (BuildContext context, AsyncSnapshot<List<Game>> snapshot) {
//            switch (snapshot.connectionState) {
//              case ConnectionState.none:
//              case ConnectionState.waiting:
//                return loadingItems();
//              default:
//                if (snapshot.hasError) {
//                  return new Center(child: Text('Error: ${snapshot.error}'));
//                } else {
//                  List<Game> games = snapshot.data;
//                  if (games.length == 0) {
//                    return new Center(child: Text('No Games Found'));
//                  }
//
//                  return new StreamBuilder<List<Game>>(
//                    stream: bloc.filteredGameList,
//                    builder:
//                        (BuildContext context,
//                        AsyncSnapshot<List<Game>> snapShot) {
//                      List<Game> streamedGames = snapShot.data;
//                      if (snapShot.hasData) {
//                        if (streamedGames.length == 0) {
//                          return new Center(child: Text('No Games Found'));
//                        }
//
//                        return ListView.builder(
//                            itemCount: streamedGames.length,
//                            itemBuilder: (context, index) {
//                              TextTheme textTheme = Theme
//                                  .of(context)
//                                  .textTheme;
//                              Game game = streamedGames[index];
//                              return new InkWell(
//                                onTap: () {
//                                  updateGame(bloc, game);
//                                  bloc.changeGameListStream(snapshot.data);
//                                },
//                                child: new Container(
//                                  margin: const EdgeInsets.symmetric(
//                                      horizontal: 10.0, vertical: 5.0),
//                                  padding: const EdgeInsets.symmetric(
//                                      horizontal: 15.0, vertical: 10.0),
//                                  decoration: new BoxDecoration(
//                                    color: Colors.grey.shade200.withOpacity(0.5),
//                                    borderRadius: new BorderRadius.circular(15.0),
//                                  ),
//                                  child: new IntrinsicHeight(
//                                    child: new Row(
//                                      crossAxisAlignment:
//                                      CrossAxisAlignment.stretch,
//                                      children: <Widget>[
//                                        new Expanded(
//                                          child: new Text(
//                                            game.game_name,
//                                            style: textTheme.title,
//                                            textAlign: TextAlign.start,
//                                          ),
//                                        ),
//                                        new Checkbox(
//                                          value: game.is_selected,
//                                          onChanged: (bool value) {
//                                            updateGame(bloc, game);
//                                            bloc.changeGameListStream(
//                                                snapshot.data);
//                                          },
//                                        ),
//                                      ],
//                                    ),
//                                  ),
//                                ),
//                              );
//                            });
//                      } else {
//                        if (snapShot.hasError) {
//                          print('Errorr ${snapShot.error.toString()}');
//                          return new Container(
//                            child:
//                            new Center(child: new Text('Cannot find games.')),
//                          );
//                        }
//
////                    return Container(
////                      margin: const EdgeInsets.symmetric(
////                          horizontal: 10.0, vertical: 5.0),
////                      padding: const EdgeInsets.symmetric(
////                          horizontal: 15.0, vertical: 10.0),
////                      decoration: new BoxDecoration(
////                        color: Colors.grey.shade300,
////                        borderRadius: new BorderRadius.circular(15.0),
////                      ),
////                      height: 60,
////                    );
//                        return Container();
//                      }
//                    },
//                  );
//                }
//            }
//          },
//        );
//
//
//
//
//
//    /*  return new StreamBuilder<List<Game>>(
//          stream: bloc.gameListStream,
//          builder: (BuildContext context, AsyncSnapshot<List<Game>> snapShot) {
//            if (snapShot.hasData) {
//              List<Game> games = snapShot.data;
//              if(games.length == 0)
//                {
//                  return Text('No Games Found');
//                }
//
//              return ListView.builder(
//      itemCount: games.length,
//                itemBuilder: (context, index)
//              {
//                TextTheme textTheme = Theme
//                    .of(context)
//                    .textTheme;
//                Game game = games[index];
//                return new InkWell(
//                  onTap: () {
//                    updateGame(bloc, game);
//                    bloc.changeGameListStream(snapShot.data);
//                  },
//                  child: new Container(
//                    margin: const EdgeInsets.symmetric(
//                        horizontal: 10.0, vertical: 5.0),
//                    padding: const EdgeInsets.symmetric(
//                        horizontal: 15.0, vertical: 10.0),
//                    decoration: new BoxDecoration(
//                      color: Colors.grey.shade200.withOpacity(0.5),
//                      borderRadius: new BorderRadius.circular(15.0),
//                    ),
//                    child: new IntrinsicHeight(
//                      child: new Row(
//                        crossAxisAlignment: CrossAxisAlignment.stretch,
//                        children: <Widget>[
//                          new Expanded(
//                            child: new Text(
//                              game.game_name,
//                              style: textTheme.title,
//                              textAlign: TextAlign.start,
//                            ),
//                          ),
//                          new Checkbox(
//                            value: game.is_selected,
//                            onChanged: (bool value) {
//                              updateGame(bloc, game);
//                              bloc.changeGameListStream(snapShot.data);
//                            },
//                          ),
//                        ],
//                      ),
//                    ),
//                  ),
//                );
//              });
//            }else {
//              if (snapShot.hasError) {
//                return new Container(
//                  child: new Center(child: new Text('Cannot find games.')),
//                );
//              }
//              return Container(
//                margin:
//                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
//                padding: const EdgeInsets.symmetric(
//                    horizontal: 15.0, vertical: 10.0),
//                decoration: new BoxDecoration(
//                  color: Colors.grey.shade300,
//                  borderRadius: new BorderRadius.circular(15.0),
//                ),
//                height: 60,
//              );
//            }
//          },
//        );*/
//  }
//
//  Future<List<Game>> getItems(AddGameBloc _bloc) async {
//    SQLDatabase database = SQLDatabase();
//    database.openDb();
//    List<Game> games = await database.getGames();
//    _bloc.changeGameListStream(games);
//    return games;
//  }
//
//  Future<List<Game>> getItemsByName(AddGameBloc _bloc, String gameName) async {
//    SQLDatabase database = SQLDatabase();
//    database.openDb();
//    List<Game> games = await database.getGamesByName(gameName);
//    _bloc.changeFilterGameStream(gameName);
//    return games;
//  }
//
//  updateGame(AddGameBloc bloc, Game game) async {
//    game.flag = this.flag;
//    game.is_selected = !game.is_selected;
//    SQLDatabase database = SQLDatabase();
//    database.openDb();
//    database.updateGame(game);
//    updateAddedGames(bloc, game);
//  }
//
//  unselectAllGames(BuildContext context, AddGameBloc _bloc) async {
//    SQLDatabase database = SQLDatabase();
//    database.openDb();
////   await database.unselectAllGames();
//    for (Game game in addedGames) {
//      game.flag = '';
//      game.is_selected = false;
//      database.updateGame(game);
//    }
//    addedGames.clear();
//    addedGamesString.clear();
//    Navigator.pop(context);
//  }
//
//  List<String> addedGamesString = new List<String>();
//  List<Game> addedGames = new List<Game>();
//
//  void updateAddedGames(AddGameBloc bloc, Game game) {
//    if (game.is_selected) {
//      addedGamesString.add(game.game_name);
//      addedGames.add(game);
//    } else {
//      if (addedGamesString.contains(game.game_name)) {
//        addedGames.removeAt(addedGamesString.indexOf(game.game_name));
//        addedGamesString.remove(game.game_name);
//      }
//    }
//    bloc.changeAddedGamesStream(addedGames);
//  }
//
//  Widget loadingItems() {
//    return Column(
//      children: <Widget>[
//        loadingItem(),
//        loadingItem(),
//        loadingItem(),
//      ],
//    );
//  }
//
//  Widget loadingItem() {
//   return Container(
//      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
//      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
//      decoration: new BoxDecoration(
//        color: Colors.grey.shade300,
//        borderRadius: new BorderRadius.circular(15.0),
//      ),
//      height: 60,
//    );
//  }
//
//
//}

import 'package:flutter/material.dart';
import 'package:flutter_games_exchange/database/game_sql_database.dart';
import 'package:flutter_games_exchange/models/game.dart';
import 'package:flutter_games_exchange/providers/add_game_provider.dart';

class AddGameScreen extends StatefulWidget {
  String flag;
  AddGameBloc bloc;

  AddGameScreen(this.flag, this.bloc);

  @override
  AddGameScreenState createState() => AddGameScreenState(flag, bloc);
}

class AddGameScreenState extends State<AddGameScreen> {
  String flag;
  AddGameBloc bloc;

  AddGameScreenState(this.flag, this.bloc);

  @override
  void initState() {
    bloc.getItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AddGameBloc _bloc = AddGameProvider.of(context);
    return page(context, _bloc);
  }

  page(BuildContext context, AddGameBloc _bloc) {
    return WillPopScope(
      onWillPop: () {
        bloc.unselectAllGames(context, _bloc);
        return new Future(() => false);
      },
      child: Scaffold(
        appBar: buildAppBar(context, _bloc),
        body: buildList(_bloc),
      ),
    );
  }

  Widget searchField(_bloc) {
    TextField(
      onChanged: (value) {
        if(value.length > 0)
        bloc.getItemsByName(_bloc, value);
        else
          bloc.getItems();
        },
      decoration: InputDecoration(border: InputBorder.none, hintText: 'Search'),
    );
  }

  Widget buildAppBar(BuildContext context, AddGameBloc _bloc) {
    return AppBar(
      title: StreamBuilder<bool>(
        stream: _bloc.isIconifiedStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data) {
              return flag == 'o'
                  ? const Text('Select Your Games')
                  : const Text('Choose Your Wishes');
            }
            return searchView(_bloc);
          }
          return flag == 'o'
              ? const Text('Select Your Games')
              : const Text('Choose Your Wishes');
        },
      ),
      actions: <Widget>[
        // action button
        new StreamBuilder<bool>(
          stream: _bloc.isIconifiedStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data) {
                return new IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _bloc.changeIsIconifiedStream(false);
                  },
                );
              }
              return new IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  _bloc.changeIsIconifiedStream(true);
                  bloc.getItems();
                },
              );
            }
            return new IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                _bloc.changeIsIconifiedStream(false);
              },
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.check),
          onPressed: () async {
            await _bloc.sendGamesToServer(flag);
            bloc.unselectAllGames(context, _bloc);
          },
        ),
      ],
    );
  }

  Widget searchView(AddGameBloc _bloc) {
    return
           TextField(
            onChanged: (value) => bloc.getItemsByName(_bloc, value),
            style: new TextStyle(
              color: Colors.white,
            ),
            decoration: new InputDecoration(
                prefixIcon: new Icon(Icons.search, color: Colors.white),
                hintText: "Search",
                hintStyle: new TextStyle(color: Colors.white)),
          );
  }

  Widget buildList(AddGameBloc _bloc) {
    return new StreamBuilder<List<Game>>(
      stream: _bloc.gameListStream,
      builder: (BuildContext context, AsyncSnapshot<List<Game>> snapshot) {
        List<Game> streamedGames = snapshot.data;
        if (snapshot.hasData) {
          if (streamedGames.length == 0) {
            return new Center(child: Text('No Games Found'));
          }

          return ListView.builder(
              itemCount: streamedGames.length,
              itemBuilder: (context, index) {
                TextTheme textTheme = Theme.of(context).textTheme;
                Game game = streamedGames[index];
                return new InkWell(
                  onTap: () {
                    bloc.updateGame(bloc, game,flag);
                    setState(() {
                      bloc.changeGameListStream(snapshot.data);
                    });
                  },
                  child: new Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10.0),
                    decoration: new BoxDecoration(
                      color: Colors.grey.shade200.withOpacity(0.5),
                      borderRadius: new BorderRadius.circular(15.0),
                    ),
                    child: new IntrinsicHeight(
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          new Expanded(
                            child: new Text(
                              game.game_name,
                              style: textTheme.title,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          new Checkbox(
                            value: game.is_selected,
                            onChanged: (bool value) {
                              bloc.updateGame(bloc, game,flag);
                              setState(() {
                                bloc.changeGameListStream(snapshot.data);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        } else {
          if (snapshot.hasError) {
            print('Errorr ${snapshot.error.toString()}');
            return new Container(
              child: new Center(child: new Text('Cannot find games.')),
            );
          }

          return Container(
            child: new Center(
                child:
                new CircularProgressIndicator(),
              ),
          );
        }
      },
    );
  }






  Widget loadingItems() {
    return Column(
      children: <Widget>[
        loadingItem(),
        loadingItem(),
        loadingItem(),
      ],
    );
  }

  Widget loadingItem() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      decoration: new BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: new BorderRadius.circular(15.0),
      ),
      height: 60,
    );
  }


}
