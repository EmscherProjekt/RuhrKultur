class AudioGuide {
  final String audioName;
  final String audioBeschreibung;
  final String imageUrl;
  final String audioUrl;
  final String title;
  final String description;
  final List<String> audioGuidAudios;
  final List<String> audioGuidImages;
  final List<String> audioGuidLizenzen;
  final List<String> audioGuidVideos;
  final List<Map<String, double>> audioGuidLocations;
  final int id;

  AudioGuide({
    required this.audioName,
    required this.audioBeschreibung,
    required this.imageUrl,
    required this.audioUrl,
    required this.title,
    required this.description,
    required this.audioGuidAudios,
    required this.audioGuidImages,
    required this.audioGuidLizenzen,
    required this.audioGuidVideos,
    required this.audioGuidLocations,
    required this.id,
  });

  factory AudioGuide.fromJson(Map<String, dynamic> json) {
    return AudioGuide(
      id: json['id'] ?? 0,
      audioName: "https://ruhrkulturerlebnis.de/" +json['AudioName'] ?? '',
      audioBeschreibung: json['AudioBeschreibung'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      audioUrl: json['audioUrl'] ?? '',
      title: json['content']['title'] ?? '',
      description: json['content']['description'] ?? '',
      audioGuidAudios:
          (json['content']['audioGuidAudios'] as List<dynamic>? ?? [])
              .map<String>((audio) => audio['audio_url'])
              .toList(),
      audioGuidImages:
          (json['content']['audioGuidImages'] as List<dynamic>? ?? [])
              .map<String>((image) => image['image_url'])
              .toList(),
      audioGuidLizenzen:
          (json['content']['audioGuidLizenzen'] as List<dynamic>? ?? [])
              .map<String>((license) => license['license_name'])
              .toList(),
      audioGuidVideos:
          (json['content']['audioGuidVideos'] as List<dynamic>? ?? [])
              .map<String>((video) => video['video_url'])
              .toList(),
      audioGuidLocations:
          (json['content']['audioGuidLocations'] as List<dynamic>? ?? [])
              .map<Map<String, double>>((location) => {
                    'latitude': (location['latitude'] as num).toDouble(),
                    'longitude': (location['longitude'] as num).toDouble(),
                  })
              .toList(),
    );
  }
}
