import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruhrkultur/app/controllers/audioguid_controller.dart';
import 'package:ruhrkultur/app/controllers/video_controller.dart';
import 'package:ruhrkultur/app/data/notifiers/play_button_notifier.dart';
import 'package:ruhrkultur/app/ui/pages/audioguid_page/widgets/video_card.dart';
import 'package:video_player/video_player.dart';

class AudioGuideDetailPage extends GetView<AudioController> {
  final videoController = Get.put(VideoController());

  AudioGuideDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VideoController videoDetailController = Get.find<VideoController>();

    videoDetailController
        .fetchAudioGuidesVideos(controller.selectedGuide.value.audioGuidID);
    controller.add();
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.selectedGuide.value.audioName),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Container(
        child: RefreshIndicator(
          onRefresh: () async {
            videoDetailController.fetchAudioGuidesVideos(
                controller.selectedGuide.value.audioGuidID);
            controller.add();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                if (videoController.isPlayingVideo.value &&
                    videoController.videoPlayerController != null) {
                  return AspectRatio(
                    aspectRatio: 16 / 9,
                    child: VideoPlayer(videoController.videoPlayerController!),
                  );
                } else {
                  return AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CachedNetworkImage(
                      imageUrl: controller.selectedGuide.value.imageUrl,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  );
                }
              }),
              PlayButton(),
              Expanded(
                child: DefaultTabController(
                  length: 3,
                  child: Scaffold(
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TabBar(
                          tabs: [
                            Tab(text: 'audio_page_detail_tab_content'.tr),
                            Tab(text: 'audio_page_detail_tab_media'.tr),
                            Tab(text: 'audio_page_detail_tab_sources'.tr),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              // Tab 1: Content
                              SingleChildScrollView(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        controller
                                            .selectedGuide.value.audioName,
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 10),
                                    Text(controller
                                        .selectedGuide.value.audioBeschreibung),
                                  ],
                                ),
                              ),
                              // Tab 2: Media
                              SingleChildScrollView(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Audio Files:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text("Currently not available"),
                                    SizedBox(height: 10),
                                    Text('Images:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: 1,
                                      itemBuilder: (context, index) {
                                        return Text(controller
                                            .selectedGuide.value.imageUrl);
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    Text('Videos:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Obx(() {
                                      print(videoDetailController
                                          .audioGuidsVideos.length);
                                      if (videoDetailController
                                          .audioGuidsVideos.isEmpty) {
                                        return Text("No videos available");
                                      } else {
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: videoDetailController
                                              .audioGuidsVideos.length,
                                          itemBuilder: (context, index) {
                                            final video = videoDetailController
                                                .audioGuidsVideos[index];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  videoController.playVideo(
                                                      video.videoUrl);
                                                },
                                                child: VideoCard(video: video),
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    }),
                                  ],
                                ),
                              ),
                              // Tab 3: Sources
                              SingleChildScrollView(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Licenses:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text("Currently not available"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlayButton extends StatelessWidget {
  PlayButton({super.key});

  @override
  Widget build(BuildContext context) {
    AudioController controller = Get.find<AudioController>();
    return ValueListenableBuilder<ButtonState>(
      valueListenable: controller.playButtonNotifier,
      builder: (_, value, __) {
        switch (value) {
          case ButtonState.loading:
            return Container(
              margin: const EdgeInsets.all(8.0),
              width: 32.0,
              height: 32.0,
              child: const CircularProgressIndicator(),
            );
          case ButtonState.paused:
            return IconButton(
              icon: const Icon(Icons.play_arrow),
              iconSize: 32.0,
              onPressed: controller.play,
            );
          case ButtonState.playing:
            return IconButton(
              icon: const Icon(Icons.pause),
              iconSize: 32.0,
              onPressed: controller.pause,
            );
        }
      },
    );
  }
}
