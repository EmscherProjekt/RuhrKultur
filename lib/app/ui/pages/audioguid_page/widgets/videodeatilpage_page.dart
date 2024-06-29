import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruhrkultur/app/controllers/videodetailpage_controller.dart';
import 'package:ruhrkultur/app/data/models/response/audioguid_video.dart';
import 'package:video_player/video_player.dart';

class VideoDetailScreen extends StatelessWidget {
  final VideodetailpageController controller = Get.put(VideodetailpageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1b1c1e),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Obx(() {
              if (controller.controller.value.isInitialized) {
                return Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: controller.controller.value.aspectRatio,
                      child: VideoPlayer(controller.controller),
                    ),
                    AspectRatio(
                      aspectRatio: controller.controller.value.aspectRatio,
                      child: Center(
                        child: IconButton(
                          icon: Icon(
                            controller.controller.value.isPlaying
                                ? null
                                : Icons.play_arrow,
                            size: 60,
                            color: Colors.white,
                          ),
                          onPressed: controller.togglePlayPause,
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(controller.selectedVideo.value.thumbnail),
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              }
            }),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  controller.selectedVideo.value.title,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.8),
                                    fontWeight: FontWeight.w500,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_drop_down_sharp,
                                  color: Colors.white.withOpacity(0.7),
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text(
                            '${controller.selectedVideo.value.viewCount} views - ${controller.selectedVideo.value.createdAt}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.thumb_up_alt_outlined,
                                    color: Colors.white.withOpacity(0.5),
                                    size: 26,
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    controller.selectedVideo.value.likeCount.toString(),
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.4),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.thumb_down_outlined,
                                    color: Colors.white.withOpacity(0.5),
                                    size: 26,
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    controller.selectedVideo.value.unlikeCount.toString(),
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.4),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.share,
                                    color: Colors.white.withOpacity(0.5),
                                    size: 26,
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "Share",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.4),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.download_done_sharp,
                                    color: Colors.white.withOpacity(0.5),
                                    size: 26,
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "Download",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.4),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.plus_one,
                                    color: Colors.white.withOpacity(0.5),
                                    size: 26,
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "Save",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.4),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Divider(color: Colors.white.withOpacity(0.1)),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: NetworkImage(controller.selectedVideo.value.thumbnail),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        controller.selectedVideo.value.title,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          height: 1.3,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        '${controller.selectedVideo.value.viewCount} Subscribers',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.4),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Text(
                                "SUBSCRIBE",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Divider(color: Colors.white.withOpacity(0.1)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Up next",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.4),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "Autoplay",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.4),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Obx(() {
                                    return Switch(
                                      value: controller.isSwitched.value,
                                      onChanged: controller.toggleSwitch,
                                    );
                                  }),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Column(
                            children: List.generate(
                              controller.audioGuidsVideos.length,
                              (index) {
                                return GestureDetector(
                                  onTap: () {
                                    controller.startPlay(controller.audioGuidsVideos[index]);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: (MediaQuery.of(context).size.width - 50) / 2,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            image: DecorationImage(
                                              image: AssetImage("assets/image/default_account_avatar.png"),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          child: Stack(
                                            children: <Widget>[
                                              Positioned(
                                                bottom: 10,
                                                right: 12,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black.withOpacity(0.8),
                                                    borderRadius: BorderRadius.circular(3),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(3.0),
                                                    child: Text(
                                                      controller.audioGuidsVideos[index].videoUrl,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white.withOpacity(0.4),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                controller.audioGuidsVideos[index].title,
                                                style: TextStyle(
                                                  color: Colors.white.withOpacity(0.9),
                                                  fontWeight: FontWeight.w500,
                                                  height: 1.3,
                                                  fontSize: 14,
                                                ),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                controller.audioGuidsVideos[index].title,
                                                style: TextStyle(
                                                  color: Colors.white.withOpacity(0.4),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                controller.audioGuidsVideos[index].viewCount.toString(),
                                                style: TextStyle(
                                                  color: Colors.white.withOpacity(0.4),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                overflow: TextOverflow.ellipsis,
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
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
