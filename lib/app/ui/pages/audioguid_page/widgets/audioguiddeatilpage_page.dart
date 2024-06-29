import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruhrkultur/app/controllers/audioguid_controller.dart';
import 'package:ruhrkultur/app/controllers/videodetailpage_controller.dart';
import 'package:ruhrkultur/app/data/notifiers/play_button_notifier.dart';
import 'package:ruhrkultur/app/ui/pages/audioguid_page/widgets/video_card.dart';

class AudioguiddeatilpagePage extends GetView<AudioController> {
  AudioguiddeatilpagePage({Key? key});
  void onInit() {}

  @override
  Widget build(BuildContext context) {
    AudioController controller = Get.find<AudioController>();
    VideodetailpageController videoController =
        Get.find<VideodetailpageController>();
    videoController.addVideo(controller.selectedGuide.value.audioGuidID);

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
            videoController
                .addVideo(controller.selectedGuide.value.audioGuidID);
            controller.add();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: CachedNetworkImage(
                  imageUrl: controller.selectedGuide.value.imageUrl,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
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
                                    Text(
                                      "Currently not available",
                                    ),
                                    /*  ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: guide.audioGuidAudios.length,
                                      itemBuilder: (context, index) {
                                        return Text(guide.audioGuidAudios[index]);
                                      },
                                    ), */
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
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: videoController
                                          .audioGuidsVideos.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: ListView.builder(
                                            itemCount:
                                                videoController.audioGuidsVideos
                                                    .length,
                                            itemBuilder: (context, index) {
                                              final videos =
                                                  videoController.audioGuidsVideos[
                                                      index];
                                              return GestureDetector(
                                                onTap: () {
                                                  print(videos);
                                                },
                                                child: VideoCard(
                                                  video: videos,
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              // Tab 3: Quellen
                              SingleChildScrollView(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Licenses:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text("Currently not available"),
                                    /*         ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: guide.audioGuidLizenzen.length,
                                      itemBuilder: (context, index) {
                                        return Text(guide.audioGuidLizenzen[index]);
                                      },
                                    ), */
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

  Widget getBody() {
    AudioController controller = Get.find<AudioController>();
    var guide = controller.selectedGuide.value;

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount:
          1, // Change this to the actual number of videos if you have a list of videos
      itemBuilder: (context, index) {
        // Replace the static content with dynamic data if available
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
                    image:
                        AssetImage('assets/image/default_account_avatar.png'),
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
