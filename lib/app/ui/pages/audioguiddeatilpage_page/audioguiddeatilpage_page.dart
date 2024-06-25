import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruhrkultur/app/controllers/audio_player_controller.dart';
import 'package:ruhrkultur/app/controllers/audioguid_controller.dart';
import 'package:ruhrkultur/app/data/models/response/audioguid.dart';
import 'package:ruhrkultur/app/data/notifiers/play_button_notifier.dart';
import 'package:ruhrkultur/app/data/services/service_locator.dart';

class AudioguiddeatilpagePage extends GetView<AudioGuideController> {
  AudioguiddeatilpagePage({Key? key}) : super(key: key);
  void onInit() {}

  @override
  Widget build(BuildContext context) {
    AudioGuideController controller = Get.find();
    AudioGuide guide = controller.selectedGuide.value;
    final PageManager pageManager = PageManager();
    pageManager.stop();
    pageManager.remove();
    pageManager.add();

    return Scaffold(
      appBar: AppBar(
        title: Text(guide.audioName),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: CachedNetworkImage(
              imageUrl: guide.imageUrl,
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
                                Text(guide.audioName,
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 10),
                                Text(guide.audioBeschreibung),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: guide.imageUrl.length,
                                  itemBuilder: (context, index) {
                                    return Text(guide.imageUrl[index]);
                                  },
                                ),
                                SizedBox(height: 10),
                                Text('Videos:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text('Currently not available',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                /*   ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: guide.audioGuidVideos.length,
                                  itemBuilder: (context, index) {
                                    return Text(guide.audioGuidVideos[index]);
                                  },
                                ), */
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
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
    );
  }
}

class PlayButton extends StatelessWidget {
  PlayButton({super.key});

  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<ButtonState>(
      valueListenable: pageManager.playButtonNotifier,
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
              onPressed: pageManager.play,
            );
          case ButtonState.playing:
            return IconButton(
              icon: const Icon(Icons.pause),
              iconSize: 32.0,
              onPressed: pageManager.pause,
            );
        }
      },
    );
  }
}
