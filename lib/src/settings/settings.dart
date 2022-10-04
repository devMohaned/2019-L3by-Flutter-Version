import 'package:flutter/material.dart';
import 'package:flutter_games_exchange/bloc/homepage_bloc.dart';
import 'package:flutter_games_exchange/models/user.dart';
import 'package:flutter_games_exchange/src/settings/update_user.dart';
import 'package:flutter_games_exchange/src/utils/location_utils.dart';
import 'package:flutter_games_exchange/styles/container_styles.dart';
import 'package:flutter_games_exchange/styles/text_styles.dart';
import 'package:flutter_games_exchange/styles/widgets.dart';

class SettingsScreen extends StatefulWidget {
  HomePageBloc _homePageBloc;

  SettingsScreen(this._homePageBloc);

  @override
  SettingsScreenState createState() {
    // TODO: implement createState
    return SettingsScreenState(_homePageBloc);
  }
}

class SettingsScreenState extends State<SettingsScreen> {

  HomePageBloc _homePageBloc;


  SettingsScreenState(this._homePageBloc);

  @override
  Widget build(BuildContext context) {
    return buildList(context);
  }

  Widget buildList(BuildContext context) {
    User currentUser = _homePageBloc.getCurrentUser();
    return Scaffold(
      appBar: getToolbar(context),
      body: ListView(
        children: <Widget>[
          Icon(
            Icons.videogame_asset,
            size: 64.0,
          ),
          Card(
            margin: EdgeInsets.all(4.0),
            child: new Row(
              children: <Widget>[
                ContainerStyles.getSettingsIconContainer(Icons.person),
                TextWidgets.getExpandedSettingsText(
                    '${currentUser.first_name} ${currentUser.last_name}'),
              ],
            ),
          ),
          Card(
            margin: EdgeInsets.all(4.0),
            child: new Row(
              children: <Widget>[
                ContainerStyles.getSettingsIconContainer(Icons.email),
                TextWidgets.getExpandedSettingsText('${currentUser.email}'),
              ],
            ),
          ),
          Card(
            margin: EdgeInsets.all(4.0),
            child: new Row(
              children: <Widget>[
                ContainerStyles.getSettingsIconContainer(Icons.location_city),
                TextWidgets.getExpandedSettingsText(
                    '${LocationUtils.getEgyptLocationStringFromIndex(currentUser.location)}'),
              ],
            ),
          ),
          Card(
            margin: EdgeInsets.all(4.0),
            child: new Row(
              children: <Widget>[
                ContainerStyles.getSettingsIconContainer(Icons.location_on),
                TextWidgets.getExpandedSettingsText(
                    '${LocationUtils.getDistrictFromIndex(currentUser.district)}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar getToolbar(BuildContext _context) {
    return AppBar(
      automaticallyImplyLeading: true,
      title: Text('Settings'),
      actions: <Widget>[
        InkWell(
          child: Icon(Icons.edit),
          onTap: () {
            Navigator.push(
              _context,
              MaterialPageRoute(
                builder: (_context) {
                  User currentUser = _homePageBloc.getCurrentUser();
                  return UpdateUserScreen(
                      _homePageBloc,
                      currentUser.first_name,
                      currentUser.last_name,
                      currentUser.location,
                      currentUser.district);
                },
              ),
            );
          },
        )
      ],
    );
  }
}
