import 'package:flutter/material.dart';
import 'package:flutter_games_exchange/bloc/reg_bloc.dart';
export 'package:flutter_games_exchange/bloc/reg_bloc.dart';

class RegisterProvider extends InheritedWidget {

  final bloc = new RegisterationBloc();

  RegisterProvider({Key key, Widget child})
      : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static RegisterationBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(RegisterProvider) as RegisterProvider).bloc;
  }

}