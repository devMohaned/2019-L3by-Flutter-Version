import 'package:flutter/material.dart';
import 'package:flutter_games_exchange/bloc/login_bloc.dart';
export 'package:flutter_games_exchange/bloc/login_bloc.dart';

class LoginProvider extends InheritedWidget {

  final bloc = new LoginBloc();

  LoginProvider({Key key, Widget child})
      : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static LoginBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(LoginProvider) as LoginProvider).bloc;
  }

}