import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

import 'package:ruhrkultur/app/controllers/audioguid_controller.dart';

class MusicPlayerPage extends StatefulWidget {
  final String musicId;

  MusicPlayerPage({required this.musicId});

  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  AudioController controller = Get.put(AudioController());
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    print("MusicPlayerPage");
    print(widget.musicId);
    _playMusic(widget.musicId);
  }

  Future<void> _playMusic(String musicId) async {
    //TODO: Server Kaufen bzw host möglichkeit für datein finden
    String url = 'https://hffzkcvj-8080.euw.devtunnels.ms/$musicId';
    print(url);
    controller.addMediaItem("Test", "title", true, url);
    print("playMusic");
    controller.play();
    setState(() {
      _isPlaying = true;
    });
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
    controller.stop();
    Get.back();
    setState(() {
      _isPlaying = false;
    });
  }
}
