class AudioguidVideoReq {
  int? id;
  String? title;
  String? description;
  String? videoUrl;


  AudioguidVideoReq({this.id, this.title, this.description, this.videoUrl});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['videoUrl'] = this.videoUrl;
    

    return data;
  }
}