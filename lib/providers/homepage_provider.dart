import 'package:flutter/material.dart';
import 'package:flutter_games_exchange/bloc/homepage_bloc.dart';
export 'package:flutter_games_exchange/bloc/homepage_bloc.dart';

class HomePageProvider extends InheritedWidget {

  final bloc = new HomePageBloc();

  HomePageProvider({Key key, Widget child})
      : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static HomePageBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(HomePageProvider) as HomePageProvider).bloc;
  }

}