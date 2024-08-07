class AudioGuide {
  final int audioGuidID;
  final String audioName;
  final String audioBeschreibung;
  final String imageUrl;
  final String audioUrl;
  final int id;
  final String createdAt;
  final String updatedAt;
  final double latitude;  // Changed to double
  final double longitude; // Changed to double

  AudioGuide({
    required this.audioGuidID,
    required this.audioName,
    required this.audioBeschreibung,
    required this.imageUrl,
    required this.audioUrl,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.latitude,
    required this.longitude,
  });

  factory AudioGuide.fromJson(Map<String, dynamic> json) {
    print(json);
    return AudioGuide(
      audioGuidID: json['audioGuidID'] is int ? json['audioGuidID'] : int.tryParse(json['audioGuidID'].toString()) ?? 0,
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      audioName: json['AudioName'] ?? '',
      audioBeschreibung: json['AudioBeschreibung'] ?? '',
      imageUrl: json['thumbnail'] ?? '',
      audioUrl: json['audioUrl'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      latitude: json['latitude'] is double ? json['latitude'] : double.tryParse(json['latitude'].toString()) ?? 0.0,
      longitude: json['longitude'] is double ? json['longitude'] : double.tryParse(json['longitude'].toString()) ?? 0.0,
    );
  }
}
