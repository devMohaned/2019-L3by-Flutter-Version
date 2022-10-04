import 'package:flutter/material.dart';
import 'package:flutter_games_exchange/bloc/add_game_bloc.dart';
export 'package:flutter_games_exchange/bloc/add_game_bloc.dart';

class AddGameProvider extends InheritedWidget {

  final bloc = new AddGameBloc();

  AddGameProvider({Key key, Widget child})
      : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static AddGameBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(AddGameProvider) as AddGameProvider).bloc;
  }

}