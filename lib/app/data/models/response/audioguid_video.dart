class AudioGuideVideo {
  final int id;
  final String title;
  final String description;
  final String videoUrl;

  AudioGuideVideo({
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.id,
  });

  factory AudioGuideVideo.fromJson(Map<String, dynamic> json) {
    return AudioGuideVideo(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
    );
  }
}
