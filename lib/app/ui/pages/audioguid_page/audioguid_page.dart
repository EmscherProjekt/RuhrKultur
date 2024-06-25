import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruhrkultur/app/controllers/audioguid_controller.dart';
import 'package:ruhrkultur/app/ui/layouts/main/widgets/navigation_bottom_bar.dart';
import 'package:ruhrkultur/app/ui/pages/audioguid_page/widgets/audioguid_card.dart';
import 'package:ruhrkultur/app/ui/pages/audioguid_page/audioguiddeatilpage_page/audioguiddeatilpage_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AudioguidPage extends GetView {
  AudioguidPage({Key? key}) : super(key: key);

  void onInit() {
    _loadData();
  }

  Future<void> _loadData() async {
    Get.find<AudioGuideController>().fetchAudioGuidesSafe();
  }

  @override
  Widget build(BuildContext context) {
    AudioGuideController controller = Get.put(AudioGuideController());

    return Scaffold(

      body: Container(
        child: Center(
          child: RefreshIndicator(
            onRefresh: () async {
              await _loadData();
            },
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              } else if (controller.audioGuides.isEmpty) {
                return Center(
                    child: Center(
                  child: Column(
                    children: [
                      Text("audio_page_no_data_found".tr,
                          style: TextStyle(fontSize: 20)),
                      TextButton(
                          onPressed: () {
                            _loadData();
                          },
                          child: Text("audio_page_no_data_found_info".tr,
                              style: TextStyle(fontSize: 20))),
                    ],
                  ),
                ));
              } else {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                      itemCount: controller.audioGuides.length,
                      itemBuilder: (context, index) {
                        final guide = controller.audioGuides[index];
                        return AudioguidCard(
                          audioGuideController: controller,
                          audioGuide: guide,
                        );
                      }),
                );
              }
            }),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBottomBar(),
    );
  }
}
