class LevelRes{
  int? userID;
  int? level;

  LevelRes({this.level});

  LevelRes.fromJson(Map<String, dynamic> json) {
    level = json['level'];
  }
}
