import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class MusicPlayerPage extends StatefulWidget {
  final String musicId;

  MusicPlayerPage({required this.musicId});

  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _playMusic(widget.musicId);
  }

  Future<void> _playMusic(String musicId) async {
    String localFilePath = await _getLocalFilePath(musicId);

    if (await _fileExists(localFilePath)) {
      // Wenn die Datei lokal existiert, spiele sie ab
      _audioPlayer.play(localFilePath, isLocal: true);
    } else {
      // Andernfalls lade sie herunter und spiele sie ab
      String downloadedFilePath = await _downloadMusicFile(musicId);
      _audioPlayer.play(downloadedFilePath, isLocal: true);
    }

    setState(() {
      _isPlaying = true;
    });
  }

  Future<String> _getLocalFilePath(String musicId) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    return '${appDocDir.path}/$musicId.mp3';
  }

  Future<bool> _fileExists(String path) async {
    return File(path).exists();
  }

  Future<String> _downloadMusicFile(String musicId) async {
    // URL zum Herunterladen der Musikdatei
    String url = 'https://yourserver.com/music/$musicId.mp3';
    String localFilePath = await _getLocalFilePath(musicId);

    // Lade die Datei herunter und speichere sie lokal
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      File file = File(localFilePath);
      await file.writeAsBytes(response.bodyBytes);
    } else {
      throw Exception('Failed to load music file');
    }
    return localFilePath;
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Music Player')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _isPlaying ? 'Playing Music...' : 'Stopped',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isPlaying ? _stopMusic : null,
              child: Text('Stop Music'),
            ),
          ],
        ),
      ),
    );
  }

  void _stopMusic() {
    _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
    });
  }
}
