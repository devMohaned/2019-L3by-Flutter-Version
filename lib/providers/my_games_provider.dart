import 'package:flutter/material.dart';
import 'package:flutter_games_exchange/bloc/my_games_bloc.dart';
export 'package:flutter_games_exchange/bloc/my_games_bloc.dart';

class MyGamesProvider extends InheritedWidget {

  final bloc = new MyGamesBloc();

  MyGamesProvider({Key key, Widget child})
      : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static MyGamesBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(MyGamesProvider) as MyGamesProvider).bloc;
  }

}