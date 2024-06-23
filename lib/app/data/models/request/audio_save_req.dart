class AudioSaveReq {
  int? userid;
  int? audioGuidID;
  int? postID;

  AudioSaveReq({this.userid, this.audioGuidID, this.postID});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userID'] = this.userid;
    data['audioGuidID'] = this.audioGuidID;
    data['postID'] = this.postID;
    return data;
  }
}
