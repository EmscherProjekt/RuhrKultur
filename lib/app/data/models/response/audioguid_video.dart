class AudioGuideVideo {
  int id;
  String title;
  String thumbnail;
  String videoUrl;
  int viewCount;
  int likeCount;
  int unlikeCount;
  String createdAt;
  String updatedAt;

  AudioGuideVideo({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.videoUrl,
    required this.viewCount,
    required this.likeCount,
    required this.unlikeCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AudioGuideVideo.fromJson(Map<String, dynamic> json) {
    return AudioGuideVideo(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'] ?? '',
      thumbnail: json['thumbnailUrl'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      viewCount: json['viewCount'] is int ? json['viewCount'] : int.tryParse(json['viewCount'].toString()) ?? 0,
      likeCount: json['likeCount'] is int ? json['likeCount'] : int.tryParse(json['likeCount'].toString()) ?? 0,
      unlikeCount: json['unlikeCount'] is int ? json['unlikeCount'] : int.tryParse(json['unlikeCount'].toString()) ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}