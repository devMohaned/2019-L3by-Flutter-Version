import 'package:flutter/material.dart';
import 'package:flutter_games_exchange/bloc/homepage_bloc.dart';
import 'package:flutter_games_exchange/src/messaging/messaging.dart';
import 'package:flutter_games_exchange/models/room.dart';
import 'package:flutter_games_exchange/models/user.dart';
import 'package:flutter_games_exchange/network/http/http_requests.dart';
import 'package:flutter_games_exchange/src/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';

class RoomsScreen extends StatefulWidget {
  HomePageBloc _homePageBloc;

  RoomsScreen(this._homePageBloc);

  @override
  RoomsScreenState createState() => RoomsScreenState(_homePageBloc);
}

class RoomsScreenState extends State<RoomsScreen> {
  HomePageBloc _homePageBloc;

  RoomsScreenState(this._homePageBloc);

  ScrollController _scrollController = new ScrollController();
  bool isLoading = false;
  List<Room> rooms = new List<Room>();
  int currentSearchIndex = 0;

  @override
  void initState() {
    currentSearchIndex = 0;
    this.getItemsFromNetwork(0, Constants.ROOM_LIMIT);
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getItemsFromNetwork(currentSearchIndex * Constants.ROOM_LIMIT,
            currentSearchIndex * Constants.ROOM_LIMIT + Constants.ROOM_LIMIT);
      }
    });
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildList();
  }

  Widget buildList() {
    User currentUser = _homePageBloc.getCurrentUser();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Chat With'),
      ),
      body: RefreshIndicator(
        child: ListView.builder(
            controller: _scrollController,
            itemCount: rooms.length + 1,
            itemBuilder: (context, index) {
              if (index == rooms.length) {
                return _buildProgressIndicator();
              } else {
                TextTheme textTheme = Theme.of(context).textTheme;
                Room room = rooms[index];

                return new InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessageScreen(
                            room.room_id,
                            room.room_sender_id == currentUser.firebase_uid
                                ? room.room_reciever_id
                                : room.room_sender_id,
                            '${room.first_name} ${room.last_name}',
                            room.profile_image,
                            room.token,
                            'no',
                            currentUser.firebase_uid,
                            room.location,
                            room.district,
                            room.game_owner_common_games_count,
                            room.my_games,
                            room.my_wishes,
                            room.game_owner_games,
                            room.game_owner_wishes),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10.0),
                    decoration: new BoxDecoration(
                      color: Colors.grey.shade200.withOpacity(0.3),
                      borderRadius: new BorderRadius.circular(5.0),
                    ),
                    child: new IntrinsicHeight(
                      child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            new Container(
                              margin: const EdgeInsets.only(
                                  top: 4.0, bottom: 4.0, right: 10.0),
                              child: new CircleAvatar(
                                backgroundImage:
                                    new NetworkImage('${room.profile_image}'),
                                radius: 20.0,
                              ),
                            ),
                            new Expanded(
                              child: new Container(
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    new Text(
                                        '${room.first_name} ${room.last_name}',
                                        style: textTheme.subhead),
                                    new Row(
                                      children: <Widget>[
                                        new Text('${room.last_text}',
                                            style: textTheme.caption),
                                        Icon(
                                          Icons.done_all,
                                          size: 18.0,
                                          color: room.seen == true
                                              ? Colors.green
                                              : Colors.grey,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            new Container(
                              margin: new EdgeInsets.symmetric(horizontal: 5.0),
                              child:
                                  new Text('${readTimestamp(room.last_sent)}'),
                            ),
                          ]),
                    ),
                  ),
                );
              }
            }),
        onRefresh: () {
          currentSearchIndex = 0;
          getItemsFromNetwork(0, Constants.ROOM_LIMIT);
        },
      ),
    );
  }

  Future<void> getItemsFromNetwork(int startingLimit, int endingLimit) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      User currentUser = _homePageBloc.getCurrentUser();
      NetworkHttpCalls networkHttpCalls = new NetworkHttpCalls();
      List<Room> newRooms = await networkHttpCalls.getRooms(
          currentUser.firebase_uid, startingLimit, endingLimit);

      String lastText = "No Messages Found";
      bool isSeen = false;

      String currentFirebaseUid = _homePageBloc.getCurrentUser().firebase_uid;
      for (Room room in newRooms) {
        await FirebaseDatabase.instance
            .reference()
            .child('messages')
            .child(room.room_id)
            .orderByKey()
            .limitToLast(1)
            .once()
            .then((DataSnapshot snapshot) {
          Map<dynamic, dynamic> ds = snapshot.value;
          String key = ds.keys.first;

          FirebaseDatabase.instance
              .reference()
              .child('messages')
              .child(room.room_id)
              .child(key)
              .once()
              .then((DataSnapshot snapshot) {
            Map<dynamic, dynamic> datasnapshot = snapshot.value;
            setState(() {
              lastText = datasnapshot['chatText'];
              room.last_text = lastText;
            });

            if (datasnapshot['chatSenderUid'] == currentFirebaseUid) {
              setState(() {
                room.seen = datasnapshot['seen'];
              });
            }
            setState(() {
              room.last_sent = int.parse('${datasnapshot['timeStamp']}');
            });
          });
        });
      }

      setState(() {
        isLoading = false;
        rooms.addAll(newRooms);
      });
    }
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
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return time;
  }
}
