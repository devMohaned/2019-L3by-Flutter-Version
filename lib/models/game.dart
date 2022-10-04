class Game {
  int room_id;
  int tag = 0;
  String game_name, flag;
  bool is_selected;

  Game(this.game_name, this.flag, this.is_selected,this.tag);

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'room_id': room_id,
      'game_name': game_name,
      'flag': flag,
      'is_selected': is_selected == true ? 1 : 0,
      'tag': tag
    };
  }

  Game.fromMap(Map<String, dynamic> map) {
    room_id = map['room_id'];
    game_name = map['game_name'];
    flag = map['flag'];
    is_selected = map['is_selected'] == 1;
    tag = map['tag'];
  }

  Game.fromJson(Map<String, dynamic> json)
      : game_name = json['game_name'],
        flag = json['flag'],
        is_selected = true,
        tag = int.parse(json['tag']);

  Map<String, dynamic> toJson() =>
      {'\"game_name\"': "\"$game_name\"", '\"flag\"': "\"$flag\"", '\"tag\"': "\"$tag\""};

  static List encondeToJson(List<Game> list) {
    List jsonList = List();
    list.map((item) => jsonList.add(item.toJson())).toList();
    return jsonList;
  }

  static String getJsonInString(List<Game> list) {
    List jsonList = List();
    return list.map((item) => jsonList.add(item.toJson())).toString();
  }

  @override
  String toString() {
    return 'Room: $room_id & Name: $game_name & Is_Selected: $is_selected & flag: $flag & tag $tag';
  }
}
