class LevelReq {
  int? level;
  String? reward;

  LevelReq({this.level, this.reward});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['level'] = this.level;
    data['reward'] = this.reward;
    return data;
  }
}
