import 'package:flutter/material.dart';
import 'package:flutter_games_exchange/bloc/update_location_bloc.dart';
export 'package:flutter_games_exchange/bloc/update_location_bloc.dart';

class UpdateLocationProvider extends InheritedWidget {

  final bloc = new UpdateLocationBloc();

  UpdateLocationProvider({Key key, Widget child})
      : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static UpdateLocationBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(UpdateLocationProvider) as UpdateLocationProvider).bloc;
  }

}