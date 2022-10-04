import 'package:flutter/material.dart';
import 'package:flutter_games_exchange/bloc/homepage_bloc.dart';
import 'package:flutter_games_exchange/models/game.dart';
import 'package:flutter_games_exchange/models/message.dart';
import 'package:flutter_games_exchange/models/room.dart';
import 'package:flutter_games_exchange/models/user.dart';
import 'package:flutter_games_exchange/network/http/http_requests.dart';
import 'package:flutter_games_exchange/src/utils/constants.dart';
import 'package:flutter_games_exchange/src/utils/location_utils.dart';
import 'package:flutter_games_exchange/styles/text_styles.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';

class MessageScreen extends StatefulWidget {
  String room_id,
      common_user_id,
      common_user_name,
      common_user_profile_image,
      common_user_token,
      from_notification,
      my_firebase_uid;

  int location, district;
  int game_owner_common_games_count;

  List<String> my_games, my_wishes;
  List<Game> game_owner_games, game_owner_wishes;

  MessageScreen(
      this.room_id,
      this.common_user_id,
      this.common_user_name,
      this.common_user_profile_image,
      this.common_user_token,
      this.from_notification,
      this.my_firebase_uid,
      this.location,
      this.district,
      this.game_owner_common_games_count,
      this.my_games,
      this.my_wishes,
      this.game_owner_games,
      this.game_owner_wishes);

  @override
  MessageScreenState createState() => MessageScreenState(
      room_id,
      common_user_id,
      common_user_name,
      common_user_profile_image,
      common_user_token,
      from_notification,
      my_firebase_uid,
      location,
      district,
      game_owner_common_games_count,
      my_games,
      my_wishes,
      game_owner_games,
      game_owner_wishes);
}

class MessageScreenState extends State<MessageScreen> {
  String room_id,
      common_user_id,
      common_user_name,
      common_user_profile_image,
      common_user_token,
      from_notification,
      my_firebase_uid;

  int location, district;
  int game_owner_common_games_count;

  List<String> my_games, my_wishes;
  List<Game> game_owner_games, game_owner_wishes;

  MessageScreenState(
      this.room_id,
      this.common_user_id,
      this.common_user_name,
      this.common_user_profile_image,
      this.common_user_token,
      this.from_notification,
      this.my_firebase_uid,
      this.location,
      this.district,
      this.game_owner_common_games_count,
      this.my_games,
      this.my_wishes,
      this.game_owner_games,
      this.game_owner_wishes);

  @override
  void initState() {
    getMessages();
  }

  final TextEditingController textEditingController =
      new TextEditingController();

  Widget _textComposerWidget() {
    return new IconTheme(
      data: new IconThemeData(color: Colors.blue),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                decoration: new InputDecoration.collapsed(
                    hintText: "Enter your message"),
                controller: textEditingController,
                onSubmitted: _handleSubmit,
              ),
            ),
            new Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => _handleSubmit(textEditingController.text),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _handleSubmit(String text) {
    if (text.trim().length > 0) {
      textEditingController.clear();
      Message chatMessage = new Message(null, my_firebase_uid, null, text,
          false, new DateTime.now().millisecondsSinceEpoch);
      setState(() {
        //used to rebuild our widget
        String pushedKey = FirebaseDatabase.instance.reference().push().key;
        FirebaseDatabase.instance
            .reference()
            .child("messages")
            .child(room_id)
            .child(pushedKey)
            .set(chatMessage.toMap());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildList();
  }

  ScrollController _scrollController = new ScrollController();
  List<Message> messages = new List();

  Widget buildList() {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          bottom: TabBar(
            tabs: [
              Tab(
                icon: SvgPicture.asset(
                  'images/vectors/chat_2.svg',
                  allowDrawingOutsideViewBox: true,
                  height: 32.0,
                  width: 32.0,
                  color: Colors.white,
                ),
              ),
              Tab(
                icon: SvgPicture.asset(
                  'images/vectors/avatar.svg',
                  allowDrawingOutsideViewBox: true,
                  height: 32.0,
                  width: 32.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${common_user_name}'),
              StreamBuilder(
                  stream: FirebaseDatabase.instance
                      .reference()
                      .child("status")
                      .child(common_user_id)
                      .onValue,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data.snapshot.value) {
                        case 0:
                          return Text('Online');
                        case 1:
                          return Container();
                      }
                    }
                    return Container();
                  }),
            ],
          ),
        ),
        body: TabBarView(children: [
          messageLayout(),
          profileLayout(),
        ]),
      ),
    );
  }

  Widget messageLayout() {
    return Column(
      children: <Widget>[
        new Flexible(
          child: new ListView.builder(
            controller: _scrollController,
            itemCount: messages.length,
            padding: new EdgeInsets.all(4.0),
            reverse: false,
            itemBuilder: (BuildContext context, int index) {
              Message message = messages[index];
              if (message.chatSenderUid != null) {
                if (message.chatSenderUid != my_firebase_uid) {
                  return Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(6.0),
                          child: CircleAvatar(
                            child:
                                Image.network('${common_user_profile_image}'),
                            radius: 24,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              decoration: new BoxDecoration(
                                color: Colors.blue[700].withOpacity(0.2),
                                //new Color.fromRGBO(255, 0, 0, 0.0),
                                borderRadius: new BorderRadius.only(
                                  topRight: const Radius.circular(40.0),
                                  bottomRight: const Radius.circular(40.0),
                                  bottomLeft: const Radius.circular(40.0),
                                ),
                              ),
                              child: Text('${message.chatText}',
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.black)),
                            ),
                            Text('${readTimestamp(message.timeStamp)}',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12.0)),
                          ],
                        )
                      ],
                    ),
                  );
                } else {
                  return Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            decoration: new BoxDecoration(
                              color: Colors.green[700].withOpacity(0.2),
                              //new Color.fromRGBO(255, 0, 0, 0.0),
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(40.0),
                                bottomRight: const Radius.circular(40.0),
                                bottomLeft: const Radius.circular(40.0),
                              ),
                            ),
                            child: Text('${message.chatText}',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.black)),
                          ),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text('${readTimestamp(message.timeStamp)}',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12.0)),
                              Icon(
                                Icons.done_all,
                                size: 18.0,
                                color: message.seen == true
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ],
                          )
                        ]),
                  );
                }
              }
              return addNewTimelineSeprator(message.timeStamp);
            },
          ),
        ),
        new Divider(
          height: 1.0,
        ),
        new Container(
          decoration: new BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          child: _textComposerWidget(),
        )
      ],
    );
  }

  String date = "2018/01/10";
  Map<String, int> hashMap = new Map();
  int seenId = 0;

  getMessages() async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.reference().child("messages").child(room_id);
    databaseReference.onChildAdded.listen((Event data) {
      DataSnapshot dataSnapshot = data.snapshot;
      Message message = Message.fromMap(dataSnapshot.value);
      String currentDate = getDateUntilDay(message.timeStamp);
      if (date != currentDate) {
        Message timeLineMessage =
            new Message(null, null, null, null, false, message.timeStamp);
        messages.add(timeLineMessage);
        //         addNewTimelineSeprator(message.timeStamp);
        date = currentDate;
        seenId++;
      }
      addNewMessage(dataSnapshot.key, message);
      checkSeenity(dataSnapshot.key, message);
      scrollToBottom();
      setState(() {});
    });

    databaseReference.onChildChanged.listen((Event data) {
      DataSnapshot dataSnapshot = data.snapshot;
      if (hashMap.containsKey(dataSnapshot.key)) {
        int changedId = hashMap[dataSnapshot.key];

        Message message = Message.fromMap(dataSnapshot.value);
        setState(() {
          messages[changedId].seen = message.seen;
        });
      }
    });
  }

  int last_sent = 0;

  void addNewMessage(String dataSnapShotKey, Message message) {
    last_sent = message.timeStamp;
    if (message.chatSenderUid != my_firebase_uid) {
      setState(() {
        messages.add(message);
      });
    } else {
      addMessageAsMe(dataSnapShotKey, message);
    }
    seenId++;
  }

  void addMessageAsMe(String dataSnapShotKey, Message message) {
    hashMap.putIfAbsent(dataSnapShotKey, () => seenId);
    setState(() {
      messages.add(message);
    });
  }

  void checkSeenity(String dataSnapShotKey, Message message) {
    if (message.chatSenderUid != my_firebase_uid) {
      if (!message.seen) {
        addSeenToDatabase(dataSnapShotKey);
      }
    }
  }

  void addSeenToDatabase(String dataSnapShotKey) {
    FirebaseDatabase.instance
        .reference()
        .child("messages")
        .child(room_id)
        .child(dataSnapShotKey)
        .child("seen")
        .set(true);
  }

  String getDateUntilDay(int timestamp) {
    var format = new DateFormat('yyyy/MM/dd');
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
    var time = '';
    time = format.format(date);
    return time;
  }

  Center addNewTimelineSeprator(int timeInMillseconds) {
    return Center(
      child: Container(
        child: Text(
          '${getReadableDate(timeInMillseconds)}',
          style: TextStyle(
              backgroundColor: Colors.orange[100].withOpacity(0.4),
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
        padding: EdgeInsets.all(4.0),
      ),
    );
  }

  String getReadableDate(int timeInMillseconds) {
    var now = new DateTime.now();
    var format = new DateFormat('HH:mm a');
    var date = new DateTime.fromMillisecondsSinceEpoch(timeInMillseconds);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' Day ago';
      } else {
        time = diff.inDays.toString() + ' Days ago';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' Week ago';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' Weeks ago';
      }
    }

    return time;
  }

  void scrollToBottom() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
  }

  String readTimestamp(int timestamp) {
    var now = new DateTime.now();
    var format = new DateFormat('HH:mm a');
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' Day ago';
      } else {
        time = diff.inDays.toString() + ' Days ago';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' Week ago';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' Weeks ago';
      }
    }

    return time;
  }

  Widget profileLayout() {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  child: Image.network('$common_user_profile_image'),
                  radius: 72,
                ),
              ),
              new Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '$common_user_name',
                      style: TextStyle(
                          decorationStyle: TextDecorationStyle.solid,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${LocationUtils.getDistrictFromIndex(district)}, ${LocationUtils.getEgyptLocationStringFromIndex(location)}',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    Center(
                      child: Text(
                        '${game_owner_common_games_count} Mutual Games',
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                'images/vectors/active_gamepad.svg',
                height: 32.0,
                width: 32.0,
                allowDrawingOutsideViewBox: true,
                color: Theme.of(context).primaryColor,
              ),
              Text(
                'Games',
                style: TextStyles.tradingUserTitleTextStyle,
              )
            ],
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: game_owner_games.length,
              itemBuilder: (context, index) {
                Game game = game_owner_games[index];
                return Row(
                  children: <Widget>[
                    Expanded(
                        child: Container(
                      margin: EdgeInsets.all(4.0),
                      child: Text(
                        '${game.game_name}',
                        style: isCommonGame(2, game.game_name)
                            ? TextStyles.tradingUserCommonGamesTextStyle
                            : TextStyles.tradingUserGamesTextStyle,
                      ),
                    )),
                    Container(
                      margin: EdgeInsets.all(8.0),
                      child: game.tag == 1
                          ? SvgPicture.asset(
                              'images/vectors/active_price.svg',
                              height: 32.0,
                              width: 32.0,
                              allowDrawingOutsideViewBox: true,
                            )
                          : SvgPicture.asset(
                              'images/vectors/inactive_price.svg',
                              height: 32.0,
                              width: 32.0,
                              allowDrawingOutsideViewBox: true,
                            ),
                    ),
                    Container(
                      margin: EdgeInsets.all(8.0),
                      child: game.tag == 0
                          ? SvgPicture.asset(
                              'images/vectors/active_free.svg',
                              height: 32.0,
                              width: 32.0,
                              allowDrawingOutsideViewBox: true,
                            )
                          : SvgPicture.asset(
                              'images/vectors/inactive_free.svg',
                              height: 32.0,
                              width: 32.0,
                              allowDrawingOutsideViewBox: true,
                              color: Colors.black,
                            ),
                    ),
                  ],
                ); // HERE goes your list item
              }),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  'images/vectors/active_wish.svg',
                  height: 32.0,
                  width: 32.0,
                  allowDrawingOutsideViewBox: true,
                  color: Theme.of(context).primaryColor,
                ),
                Text(
                  'Wishes',
                  style: TextStyles.tradingUserTitleTextStyle,
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: game_owner_wishes.length,
            itemBuilder: (context, index) {
              Game game = game_owner_wishes[index];
              return Row(
                  children: <Widget>[
              Expanded(
              child: Container(
                  margin: EdgeInsets.all(2.0),
                  child: Text(
                    '${game.game_name}',
                    style: isCommonGame(1, game.game_name)
                        ? TextStyles.tradingUserCommonGamesTextStyle
                        : TextStyles.tradingUserGamesTextStyle,
                  ) )),
                    Container(
                      margin: EdgeInsets.all(8.0),
                      child: game.tag == 1
                          ? SvgPicture.asset(
                        'images/vectors/active_price.svg',
                        height: 32.0,
                        width: 32.0,
                        allowDrawingOutsideViewBox: true,
                      )
                          : SvgPicture.asset(
                        'images/vectors/inactive_price.svg',
                        height: 32.0,
                        width: 32.0,
                        allowDrawingOutsideViewBox: true,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(8.0),
                      child: game.tag == 0
                          ? SvgPicture.asset(
                        'images/vectors/active_free.svg',
                        height: 32.0,
                        width: 32.0,
                        allowDrawingOutsideViewBox: true,
                      )
                          : SvgPicture.asset(
                        'images/vectors/inactive_free.svg',
                        height: 32.0,
                        width: 32.0,
                        allowDrawingOutsideViewBox: true,
                        color: Colors.black,
                      ),
                    ),
                  ],
              );
            },
          )
        ],
      ),
    );
  }

  bool isCommonGame(int state, String gameName) {
    if (state == 1) {
      if (my_games.contains(gameName)) {
        return true;
      }
      return false;
    } else if (state == 2) {
      if (my_wishes.contains(gameName)) {
        return true;
      }
      return false;
    }
  }
}
