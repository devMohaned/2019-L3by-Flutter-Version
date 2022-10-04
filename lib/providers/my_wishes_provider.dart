import 'package:flutter/material.dart';
import 'package:flutter_games_exchange/bloc/my_wishes_bloc.dart';
export 'package:flutter_games_exchange/bloc/my_wishes_bloc.dart';

class MyWishesProvider extends InheritedWidget {

  final bloc = new MyWishesBloc();

  MyWishesProvider({Key key, Widget child})
      : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static MyWishesBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(MyWishesProvider) as MyWishesProvider).bloc;
  }

}