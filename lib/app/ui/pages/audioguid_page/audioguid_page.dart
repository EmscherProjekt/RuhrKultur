import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:ruhrkultur/app/controllers/audioguid_controller.dart';
import 'package:ruhrkultur/app/ui/pages/audioguid_page/widgets/audioguid_card.dart';

class AudioguidPage extends GetView<AudioController> {
  AudioguidPage({Key? key}) : super(key: key);

  void onInit() {
    _loadData();
  }

  Future<void> _loadData() async {}

  @override
  Widget build(BuildContext context) {
    AudioController controller = Get.find<AudioController>();
    return ResponsiveBreakpoints(
      breakpoints: [
        Breakpoint(start: 0, end: 480, name: MOBILE),
        Breakpoint(start: 481, end: 1200, name: TABLET),
        Breakpoint(start: 1201, end: double.infinity, name: DESKTOP),
      ],
      child: Scaffold(
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
                          controller.audioGuides[index];
                          return AudioguidCard();
                        }),
                  );
                }
              }),
            ),
          ),
        ),
      ),
    );
  }
}
