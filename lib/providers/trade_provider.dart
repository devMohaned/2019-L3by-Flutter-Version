import 'package:flutter/material.dart';
import 'package:flutter_games_exchange/bloc/trade_bloc.dart';
export 'package:flutter_games_exchange/bloc/trade_bloc.dart';

class TradeProvider extends InheritedWidget {

  final bloc = new TradeBloc();

  TradeProvider({Key key, Widget child})
      : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static TradeBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(TradeProvider) as TradeProvider).bloc;
  }

}