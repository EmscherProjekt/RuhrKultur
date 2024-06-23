class AudioGuide {
  final String audioName;
  final String audioBeschreibung;
  final String imageUrl;
  final String audioUrl;

  final int id;

  AudioGuide({
    required this.audioName,
    required this.audioBeschreibung,
    required this.imageUrl,
    required this.audioUrl,
    required this.id,
  });

  factory AudioGuide.fromJson(Map<String, dynamic> json) {
    return AudioGuide(
      id: json['id'] ?? 0,
      audioName: json['AudioName'] ?? '',
      audioBeschreibung: json['AudioBeschreibung'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      audioUrl: json['audioUrl'] ?? '',
    );
  }
}
