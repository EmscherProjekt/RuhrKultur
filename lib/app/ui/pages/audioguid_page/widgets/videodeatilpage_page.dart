import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ruhrkultur/app/controllers/audioguid_controller.dart';

import 'package:video_player/video_player.dart';

class VideoDetailScreen extends StatefulWidget {
  VideoDetailScreen({Key? key});
  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailScreen> {
  bool isSwitched = true;

  // for video player
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  late int _playBackTime;
  //The values that are passed when changing quality
  late Duration newCurrentPosition;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("idget.videoUrl")
      ..initialize().then((_) {
        setState(() {
          _controller.play();
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1b1c1e),
      body: getBody(),
    );
  }

  Widget getBody() {
    AudioController controller = Get.find<AudioController>();
    var guide = controller.selectedGuide.value;

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: 1, // Adjust this to the actual number of videos if you have a list of videos
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                showAboutDialog(context: Get.context!);
                // Get.toNamed(Routes.VIDEOPLAYER);
              },
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage('assets/image/default_account_avatar.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(guide.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        guide.audioName,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        guide.audioBeschreibung,
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.more_vert,
                  color: Colors.white.withOpacity(0.4),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Add more items here as needed
          ],
        );
      },
    );
  }
}
