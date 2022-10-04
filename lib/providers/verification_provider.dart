import 'package:flutter/material.dart';
import 'package:flutter_games_exchange/bloc/verification_bloc.dart';

class Provider extends InheritedWidget {

  final bloc = new VerificationBloc();

  Provider({Key key, Widget child})
      : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static VerificationBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(Provider) as Provider).bloc;
  }

}