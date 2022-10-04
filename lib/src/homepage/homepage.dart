import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_games_exchange/database/my_games_sql_database.dart';
import 'package:flutter_games_exchange/network/firebase/database_helper.dart';
import 'package:flutter_games_exchange/services/url_opener.dart';
import 'package:flutter_games_exchange/database/game_sql_database.dart';
import 'package:flutter_games_exchange/src/fragments/my_wishes.dart';
import 'package:flutter_games_exchange/src/fragments/trades.dart';
import 'package:flutter_games_exchange/src/legal/privacy_policy.dart';
import 'package:flutter_games_exchange/src/legal/terms_and_conditions.dart';
import 'package:flutter_games_exchange/src/legal/terms_of_use.dart';
import 'package:flutter_games_exchange/models/action_bar_item.dart';
import 'package:flutter_games_exchange/models/user.dart';
import 'package:flutter_games_exchange/network/firebase/auth.dart';
import 'package:flutter_games_exchange/providers/homepage_provider.dart';
import 'package:flutter_games_exchange/providers/my_games_provider.dart';
import 'package:flutter_games_exchange/providers/my_wishes_provider.dart';
import 'package:flutter_games_exchange/src/report/report.dart';
import 'package:flutter_games_exchange/src/settings/settings.dart';
import 'package:flutter_games_exchange/src/update_location/update_location.dart';
import 'package:rxdart/rxdart.dart';
import 'package:async/async.dart';
import 'dart:async';
import 'package:flutter_games_exchange/models/game.dart';
import 'package:flutter_games_exchange/src/fragments/my_games.dart';
import 'package:flutter_games_exchange/src/login/failed_register.dart';
import 'package:flutter_games_exchange/network/http/http_requests.dart';
import 'package:flutter_games_exchange/src/user_status/need_maintenance_screen.dart';
import 'package:flutter_games_exchange/src/user_status/need_update_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_games_exchange/src/messaging/rooms.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HomepageScreenApp extends StatefulWidget {
  String email;
  String firebase_uid = "";
  HomePageBloc _bloc;

  HomepageScreenApp(this.email, this.firebase_uid, this._bloc) {}

  @override
  HomepageScreenAppState createState() =>
      HomepageScreenAppState(email, firebase_uid, _bloc);
}

class HomepageScreenAppState extends State<HomepageScreenApp>
    with WidgetsBindingObserver {
  String email;
  String firebase_uid = "";
  User currentUser;
  HomePageBloc bloc;

  HomepageScreenAppState(this.email, this.firebase_uid, this.bloc) {}

  void initializeUserState() {
    WidgetsBinding.instance.addObserver(this);
    FirebaseDatabaseHelper.addOnlineListener(firebase_uid);
    bloc.getUserData(firebase_uid);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  AppLifecycleState _notification;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
      if (bloc.getCurrentUser() != null &&
          bloc.getCurrentUser().firebase_uid != null) {
        bloc.updateGameTags(bloc.getCurrentUser().firebase_uid);
      }
    });
  }

  @override
  void initState() {
    initializeUserState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    HomePageBloc _bloc = HomePageProvider.of(context);

    return _getLandingPage(_bloc);
  }

  Widget _getLandingPage(HomePageBloc _bloc) {
    return StreamBuilder<String>(
      stream: _bloc.existanceStateStream,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == 'DOES_EXIST') {
            return homePage(context, _bloc);
          } else if (snapshot.data == 'DOES_NOT_EXIST') {
            return FailedRegisterScreen(this.email);
          } else if (snapshot.data == 'NEED_UPDATE') {
            return NeedUpdateScreen();
          } else if (snapshot.data == 'NEED_MAINTENANCE') {
            return NeedMaintenanceScreen();
          } else if (snapshot.data == 'HTTP_EXCEPTION') {
            _bloc.changeHttpFailed(true);
            return spinningScreen(_bloc);
          }
        } else {
          if (snapshot.hasError) {
            _bloc.changeHttpFailed(true);
          }
          return spinningScreen(_bloc);
        }
      },
    );
  }

  Widget homePage(BuildContext context, HomePageBloc _bloc) {
    return Scaffold(
      drawer: drawer(_bloc, context),
      appBar: AppBar(title: toolbarTitle(_bloc), actions: toolbarIcons(_bloc)),
      body: Center(
        child: home(_bloc, context),
      ),
      bottomNavigationBar: bottomNavigationBar(_bloc),
    );
  }

  toolbarTitle(HomePageBloc bloc) {
    return Container(
      child: StreamBuilder<NavBarItem>(
        stream: bloc.stream,
        initialData: bloc.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapShot) {
          return _toolbarTitles.elementAt(snapShot.data.index);
        },
      ),
    );
  }

  List<Widget> _toolbarTitles = <Widget>[
    Text('My Games'),
    Text('My Wishes'),
    Text('Trade'),
  ];

  toolbarIcons(HomePageBloc bloc) {
    List<Widget> actionList = <Widget>[
      StreamBuilder<NavBarItem>(
        stream: bloc.stream,
        initialData: bloc.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapShot) {
          switch (snapShot.data.index) {
            case 0:
              return Row(
                children: <Widget>[
                  StreamBuilder<List<Game>>(
                    stream: bloc.removedGamesListStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Game>> snapshot) {
                      if (snapshot.hasData && snapshot.data.length > 0) {
                        List<Game> games = snapshot.data;
                        return Row(
                          children: <Widget>[
                            Text(
                              '${games.length}',
                              style: TextStyle(fontSize: 18.0),
                            ),
                            IconButton(
                              icon: new Icon(Icons.delete),
                              onPressed: () =>
                                  confirmRemovalOfGames(games /*,game*/, bloc),
                            ),
                            IconButton(
                              padding: EdgeInsets.only(right: 8.0),
                              icon: new Icon(Icons.cancel),
                              onPressed: () {
                                cancelRemovedGames(context);
                              },
                            ),
                          ],
                        );
                      }
                      return Container();
                    },
                  ),
                  IconButton(
                    icon: SvgPicture.asset(
                      'images/vectors/add_game.svg',
                      allowDrawingOutsideViewBox: true,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, 'add_game/o');
                    },
                  ),
                ],
              );
            case 1:
              return Row(
                children: <Widget>[
                  StreamBuilder<List<Game>>(
                    stream: bloc.removedGamesListStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Game>> snapshot) {
                      if (snapshot.hasData && snapshot.data.length > 0) {
                        List<Game> games = snapshot.data;
                        return Row(
                          children: <Widget>[
                            Text(
                              '${games.length}',
                              style: TextStyle(fontSize: 18.0),
                            ),
                            IconButton(
                              icon: new Icon(Icons.delete),
                              onPressed: () =>
                                  confirmRemovalOfGames(games /*,game*/, bloc),
                            ),
                            IconButton(
                              padding: EdgeInsets.only(right: 8.0),
                              icon: new Icon(Icons.cancel),
                              onPressed: () {
                                cancelRemovedGames(context);
                              },
                            ),
                          ],
                        );
                      }
                      return Container();
                    },
                  ),
                  IconButton(
                    icon: SvgPicture.asset(
                      'images/vectors/add_wish.svg',
                      allowDrawingOutsideViewBox: true,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, 'add_game/w');
                    },
                  )
                ],
              );

            case 2:
              return IconButton(
                icon: Icon(actions[2].icon),
                onPressed: () {},
              );
          }
          return Container();
        },
      ),
      new InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RoomsScreen(bloc),
            ),
          );
        },
        child: Stack(
          children: [
            IconButton(
              icon: SvgPicture.asset(
                'images/vectors/chat_2.svg',
                allowDrawingOutsideViewBox: true,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoomsScreen(bloc),
                  ),
                );
              },
            ),
            Align(
              child: Text(
                '1',
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    backgroundColor: Colors.red[800]),
              ),
              alignment: Alignment.topRight,
            ),
          ],
        ),
      ),
    ];
    return actionList;
  }

  static const List<ActionBarItem> actions = const <ActionBarItem>[
    const ActionBarItem(title: 'Add Game', icon: Icons.add_circle_outline),
    const ActionBarItem(title: 'Add Wish', icon: Icons.add_a_photo),
    const ActionBarItem(title: 'Trade', icon: Icons.location_on),
    const ActionBarItem(title: 'Message', icon: Icons.chat),
    const ActionBarItem(title: 'Train', icon: Icons.directions_railway),
    const ActionBarItem(title: 'Walk', icon: Icons.directions_walk),
  ];

  Widget spinningScreen(HomePageBloc _bloc) {
    return Center(
      child: Column(
        children: <Widget>[
          Container(
            width: 124,
            height: 124,
            child: new Image.asset(
              'images/app_icon_124.png',
              width: 124.0,
              height: 124.0,
              fit: BoxFit.contain,
            ),
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(24),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 24, top: 24),
            width: 48,
            height: 48,
            padding: EdgeInsets.all(8),
            child: CircularProgressIndicator(),
          ),
          StreamBuilder<bool>(
            stream: _bloc.httpFailedStream,
            initialData: false,
            builder: (BuildContext context, AsyncSnapshot<bool> snapShot) {
              if (snapShot.data) {
                return Center(
                    child: Text(
                        'Bad Internet connection, Could not connect to the server'));
              } else {
                if (snapShot.hasError) {
                  return Center(
                      child: Text(
                          'Bad Internet connection, Could not connect to the server'));
                }
                return Center(child: Text('Welcome to #1 Trading Center'));
              }
            },
          ),
        ],
      ),
    );
  }

  StreamBuilder<NavBarItem> home(HomePageBloc bloc, BuildContext context) {
    MyGamesBloc _gamesBloc = MyGamesProvider.of(context);

    List<Widget> _widgetOptions = <Widget>[
      MyGamesScreen(firebase_uid),
      MyWishesScreen(firebase_uid, _gamesBloc, bloc),
      bloc.canTrade()
          ? TradeScreen(firebase_uid, bloc)
          : UpdateLocationScreen(bloc)
    ];

    return StreamBuilder<NavBarItem>(
      stream: bloc.stream,
      initialData: bloc.defaultItem,
      builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapShot) {
        int index = snapShot.data.index;
        return Center(
          child: _widgetOptions.elementAt(index),
        );
      },
    );
  }

  StreamBuilder<NavBarItem> bottomNavigationBar(HomePageBloc bloc) {
    return StreamBuilder<NavBarItem>(
      stream: bloc.stream,
      initialData: bloc.defaultItem,
      builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapShot) {
        return BottomNavigationBar(
          fixedColor: Colors.blueAccent,
          currentIndex: snapShot.data.index,
          onTap: bloc.PickItem,
          items: [
            BottomNavigationBarItem(
              icon: snapShot.data.index == 0
                  ? SvgPicture.asset(
                      'images/vectors/active_gamepad.svg',
                      height: 32.0,
                      width: 32.0,
                      allowDrawingOutsideViewBox: true,
                      color: Theme.of(context).primaryColor,
                    )
                  : SvgPicture.asset(
                      'images/vectors/inactive_gamepad.svg',
                      height: 24.0,
                      width: 24.0,
                      allowDrawingOutsideViewBox: true,
                      color: Theme.of(context).disabledColor,
                    ),
              title: Text('My Games'),
            ),
            BottomNavigationBarItem(
              icon: snapShot.data.index == 1
                  ? SvgPicture.asset(
                      'images/vectors/active_wish.svg',
                      height: 32.0,
                      width: 32.0,
                      allowDrawingOutsideViewBox: true,
                      color: Theme.of(context).primaryColor,
                    )
                  : SvgPicture.asset(
                      'images/vectors/inactive_wish.svg',
                      height: 24.0,
                      width: 24.0,
                      allowDrawingOutsideViewBox: true,
                      color: Theme.of(context).disabledColor,
                    ),
              title: Text('My Wishes'),
            ),
            BottomNavigationBarItem(
              icon: snapShot.data.index == 2
                  ? SvgPicture.asset(
                      'images/vectors/active_handshake.svg',
                      height: 32.0,
                      width: 32.0,
                      allowDrawingOutsideViewBox: true,
                      color: Theme.of(context).primaryColor,
                    )
                  : SvgPicture.asset(
                      'images/vectors/inactive_handshake.svg',
                      height: 24.0,
                      width: 24.0,
                      allowDrawingOutsideViewBox: true,
                      color: Theme.of(context).disabledColor,
                    ),
              title: Text('Trade'),
            ),
          ],
        );
      },
    );
  }

  Drawer drawer(HomePageBloc _bloc, BuildContext context) {
    _image = _bloc.getCurrentUser().profile_image != null
        ? _bloc.getCurrentUser().profile_image
        : null;
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: new Column(
              children: <Widget>[
                InkWell(
                  child: _image == null
                      ? Icon(
                          Icons.person_pin,
                          color: Colors.white,
                          size: 54.0,
                        )
                      : CircleAvatar(
                          radius: 54.0, child: Image.network(_image)),
                  onTap: () async {
                    await pickImage(_bloc);
                  },
                ),
                StreamBuilder<User>(
                  stream: _bloc.currentUserStream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return Text(
                      '${_bloc.getCurrentUser().first_name} ${_bloc.getCurrentUser().last_name}',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    );
                  },
                )
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.lightBlue[700],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Colors.lightBlue[700],
              size: 30.0,
            ),
            title: Text('Home'),
            onTap: () {
              // Update the state of the app.
              // ...
              Navigator.pop(context);
            },
          ),
          divider(),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Colors.lightBlue[700],
              size: 30.0,
            ),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(_bloc),
                ),
              );
            },
          ),
          divider(),
          ListTile(
            leading: Icon(
              Icons.assignment,
              color: Colors.lightBlue[700],
              size: 30.0,
            ),
            title: Text('Terms Of Use'),
            onTap: () {
              goToS(TermsOfUse());
            },
          ),
          divider(),
          ListTile(
              leading: Icon(
                Icons.lock,
                color: Colors.lightBlue[700],
                size: 30.0,
              ),
              title: Text('Privacy Policy'),
              onTap: () {
                goToS(PrivacyPolicy());
              }),
          divider(),
          ListTile(
            leading: Icon(
              Icons.description,
              color: Colors.lightBlue[700],
              size: 30.0,
            ),
            title: Text('Terms & Conditions'),
            onTap: () {
              goToS(TermsAndConditions());
            },
          ),
          divider(),
          ListTile(
            leading: Icon(
              Icons.report,
              color: Colors.lightBlue[700],
              size: 30.0,
            ),
            title: Text('Report'),
            onTap: () {
              goToS(ReportScreen());
            },
          ),
          divider(),
          ListTile(
            leading: SvgPicture.asset(
              'images/vectors/facebook.svg',
              height: 30.0,
              width: 30.0,
              allowDrawingOutsideViewBox: true,
              color: Colors.lightBlue[700],
            ),
            title: Text('Contact Us'),
            onTap: () {
              // Update the state of the app.
              // ...
              Navigator.pop(context);
              UrlOpener.openFacebook(context, 'l3by.egypt');
            },
          ),
          divider(),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.lightBlue[700],
              size: 30.0,
            ),
            title: Text('Log out'),
            onTap: () async {
              clearAllGames();
              Navigator.pop(context);
              Auth auth = Auth();
              await auth.signOut();
            },
          ),
        ],
      ),
    );
  }

  Divider divider() {
    return new Divider(
      color: Colors.grey[300],
    );
  }

  void goTo(StatelessWidget target) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => target,
      ),
    );
  }

  void goToS(StatefulWidget target) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => target),
    );
  }

  void clearAllGames() {
    MyGamesSQLDatabase database = new MyGamesSQLDatabase();
    database.openDb();
    database.unselectAllGames();
    SQLDatabase database2 = SQLDatabase();
    database2.openDb();
    database2.unselectAllGames();
  }

  void confirmRemovalOfGames(
      List<Game> games,
      /*Game game,*/
      HomePageBloc _bloc) {
    /*games.add(game);
    _bloc.changeRemovedGamesStream(games);*/
    _bloc.removeGamesOrWishes();
    print('HORAI');
  }

  cancelRemovedGames(BuildContext context) {
    MyGamesBloc _myGamesBloc = MyGamesProvider.of(context);
    HomePageBloc _homePageBloc = HomePageProvider.of(context);
    List<Game> gameList = _myGamesBloc.getGames();
    List<Game> removedGames = _homePageBloc.getRemovedGames();
    for (Game game in removedGames) {
      gameList.add(game);
    }
    setState(() {
      _myGamesBloc.changeGameListStream(gameList);
//        _homePageBloc.changeRemovedGamesStream(new List<Game>());
      _homePageBloc.resetRemovedGames();
    });

    print('HORAI');
  }

  String _image;

  Future pickImage(HomePageBloc _bloc) async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 144,
        maxHeight: 144,
        imageQuality: 50);
    uploadImage(_bloc, image);
  }

  void uploadImage(HomePageBloc _bloc, File imageFile) async {
    String pushedKey = FirebaseDatabase.instance.reference().push().key;
    final StorageReference storageReference =
        FirebaseStorage().ref().child("profile_images").child(pushedKey);

    final StorageUploadTask uploadTask = storageReference.putFile(imageFile);

    final StreamSubscription<StorageTaskEvent> streamSubscription =
        uploadTask.events.listen((event) {
      // You can use this to notify yourself or your user in any kind of way.
      // For example: you could use the uploadTask.events stream in a StreamBuilder instead
      // to show your user what the current status is. In that case, you would not need to cancel any
      // subscription as StreamBuilder handles this automatically.

      // Here, every StorageTaskEvent concerning the upload is printed to the logs.
      print('EVENT ${event.type}');
    });

// Cancel your subscription when done.
    StorageTaskSnapshot snapshot = await uploadTask.onComplete;
    String url = (await snapshot.ref.getDownloadURL()).toString();
    sendImageToServer(_bloc, url);
    streamSubscription.cancel();
  }

  void sendImageToServer(HomePageBloc _bloc, String imageLink) async {
    NetworkHttpCalls httpCalls = new NetworkHttpCalls();
    await httpCalls.updateImage(firebase_uid, imageLink);
    setState(() {
      User user = _bloc.getCurrentUser();
      user.profile_image = imageLink;
      _bloc.changeCurrentUser(user);
      _image = imageLink;
    });
  }
}
