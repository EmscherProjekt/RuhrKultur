class PostReq {
  String? title;
  String? images;
  String? videos;
  String? music;

  PostReq({this.title, this.images, this.videos, this.music});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['images'] = this.images;
    data['videos'] = this.videos;
    data['music'] = this.music;
    return data;
  }
}
