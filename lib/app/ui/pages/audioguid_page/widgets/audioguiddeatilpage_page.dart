import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruhrkultur/app/controllers/audioguid_controller.dart';
import 'package:ruhrkultur/app/data/notifiers/play_button_notifier.dart';

class AudioguiddeatilpagePage extends GetView<AudioController> {
  AudioguiddeatilpagePage({Key? key});
  void onInit() {}

  @override
  Widget build(BuildContext context) {
    AudioController controller = Get.find<AudioController>();

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
      body: Column(
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
                                Text(controller.selectedGuide.value.audioName,
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
                                  itemCount: 1,
                                  itemBuilder: (context, index) {
                                    return Text(controller
                                        .selectedGuide.value.imageUrl);
                                  },
                                ),
                                SizedBox(height: 10),
                                Text('Videos:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                getBody(),
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

  Widget getBody() {
    AudioController controller = Get.find<AudioController>();
    var guide = controller.selectedGuide.value;

    // Get context
    var size = MediaQuery.of(Get.context!).size;
    return GestureDetector(
      onTap: () {
        showAboutDialog(context: Get.context!);
        // Get.toNamed(Routes.VIDEOPLAYER);
      },
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: InkWell(
                        onTap: () {
                          showAboutDialog(context: Get.context!);
                        },
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                  image: AssetImage(
                                    'assets/image/default_account_avatar.png',
                                  ),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
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
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            width: size.width - 180,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  guide.audioName,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      height: 1.3),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: size.width - 180,
                                      child: Text(
                                        guide.audioBeschreibung,
                                        softWrap: true,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            height: 1.5),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Icon(
                            Icons.more_vert,
                            color: Colors.white.withOpacity(0.4),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ],
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
