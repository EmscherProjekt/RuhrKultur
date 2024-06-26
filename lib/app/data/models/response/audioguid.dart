class AudioGuide {
  final int audioGuidID;
  final String audioName;
  final String audioBeschreibung;
  final String imageUrl;
  final String audioUrl;

  final int id;

  AudioGuide({
    required this.audioGuidID,
    required this.audioName,
    required this.audioBeschreibung,
    required this.imageUrl,
    required this.audioUrl,
    required this.id,
  });

  factory AudioGuide.fromJson(Map<String, dynamic> json) {
    return AudioGuide(
      audioGuidID: json['audioGuidID'] ?? 0,
      id: json['id'] ?? 0,
      audioName: json['AudioName'] ?? '',
      audioBeschreibung: json['AudioBeschreibung'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      audioUrl: json['audioUrl'] ?? '',
    );
  }
}
