import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_games_exchange/src/add_game/add_game.dart';
import 'package:flutter_games_exchange/providers/my_wishes_provider.dart';
import 'package:flutter_games_exchange/providers/trade_provider.dart';
import 'package:flutter_games_exchange/providers/update_location_provider.dart';
import 'package:flutter_games_exchange/providers/update_user_provider.dart';
import 'login/login.dart';
import 'utils/utils.dart';
import 'login/register.dart';
import 'login/phone.dart';
import 'homepage/homepage.dart';
import 'package:flutter_games_exchange/providers/login_provider.dart';
import 'package:flutter_games_exchange/providers/registeration_provider.dart';
import 'package:flutter_games_exchange/providers/homepage_provider.dart';
import 'package:flutter_games_exchange/providers/add_game_provider.dart';
import 'package:flutter_games_exchange/providers/homepage_provider.dart';
import 'package:flutter_games_exchange/providers/my_games_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_games_exchange/database/game_sql_database.dart';
import 'package:flutter_games_exchange/models/game.dart';

class App extends StatelessWidget with Utils {
  Widget build(BuildContext context) {
    return UpdateUserProvider(
      child: UpdateLocationProvider(
        child: TradeProvider(
          child: MyWishesProvider(
            child: MyGamesProvider(
              child: AddGameProvider(
                child: HomePageProvider(
                  child: RegisterProvider(
                    child: LoginProvider(
                      child: MaterialApp(
                        onGenerateRoute: routes,
                        title: 'Log Me In!',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Route routes(RouteSettings routeSettings) {
    String name = routeSettings.name;
    if (name == '/') {
      return MaterialPageRoute(
        builder: (context) {
          getFileLines();
          return LoginScreen();
        },
      );
    } else if (name == 'register') {
      return MaterialPageRoute(
        builder: (context) {
          final bloc = RegisterProvider.of(context);
          bloc.changeRegCanRegister(true);
          return RegisterScreen();
        },
      );
    }
//    else if (name.contains("homepage")) {
//      return MaterialPageRoute(
//        builder: (context) {
//          /*  HomePageBloc bloc = HomePageProvider.of(context);
//          String firebase_uid = routeSettings.name.replaceFirst('/?','');
//          bloc.getUserData(firebase_uid);*/
//          return HomepageScreenApp(snapshot.data.email;);
//        },
//      );
//    }
    else if (name.contains("add_game")) {
      return MaterialPageRoute(
        builder: (context) {
          AddGameBloc _bloc = AddGameProvider.of(context);
          String flag = name.substring(name.indexOf('/') + 1);
          return AddGameScreen(flag, _bloc);
        },
      );
    }
  }

  static final int GAMES_COUNT = 15584;

/*Future<List<String>>*/
  getFileLines() async {
    ByteData data = await rootBundle.load('assets/games.txt');
    String directory = (await getTemporaryDirectory()).path;
    File file = await writeToFile(data, '$directory/games.txt');
    SQLDatabase database = SQLDatabase();
    database.openDb();
    int addedCount = await database.getGamesCount();
    if (addedCount < GAMES_COUNT) {
      int count = 0;
      file.readAsLines().then((lines) => lines.forEach((l) {
            count++;
            if (count >= addedCount) {
              insertGame(database, l);
            }
          }));
    }
    /*
    return gameList;
*/
  }

  Future<File> writeToFile(ByteData data, String path) {
    ByteBuffer buffer = data.buffer;
    return File(path).writeAsBytes(buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    ));
  }

  insertGame(SQLDatabase database, String gameName) {
    Game game = new Game(gameName, "", false,0);
    database.insertGame(game);
  }
}
