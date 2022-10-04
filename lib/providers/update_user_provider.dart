import 'package:flutter/material.dart';
import 'package:flutter_games_exchange/bloc/reg_bloc.dart';
import 'package:flutter_games_exchange/bloc/update_user_bloc.dart';
export 'package:flutter_games_exchange/bloc/reg_bloc.dart';

class UpdateUserProvider extends InheritedWidget {

  final bloc = new UpdateUserBloc();

  UpdateUserProvider({Key key, Widget child})
      : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static UpdateUserBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(UpdateUserProvider) as UpdateUserProvider).bloc;
  }

}