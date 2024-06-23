import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruhrkultur/app/controllers/audioguid_controller.dart';
import 'package:ruhrkultur/app/ui/pages/audioguiddeatilpage_page/audioguiddeatilpage_page.dart';
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

    return Center(
      child: RefreshIndicator(
        onRefresh: () async {
          await _loadData();
        },
        child: Obx(
          () {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            } else if (controller.audioGuides.isEmpty) {
              return Center(
                  child: Center(
                child: Column(
                  children: [
                    Text("No data found."),
                    TextButton(
                        onPressed: () {
                          _loadData();
                        },
                        child: Text("No data found, tap to reload.")),
                  ],
                ),
              ));
            } else {
              return ListView.builder(
                itemCount: controller.audioGuides.length,
                itemBuilder: (context, index) {
                  final guide = controller.audioGuides[index];
                 return  Card(
                    elevation: 12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: guide.imageUrl,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            height: 180,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        ListTile(
                          title: Text(
                            guide.audioName,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            guide.audioBeschreibung,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor: Colors.white),
                                    onPressed: () {
                                      
                                    },
                                    child: const Text(
                                      "Merken",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor: Colors.red),
                                    onPressed: () {
                                      controller.setSelectedGuide(guide);
                                      
                                      Get.to(() => AudioguiddeatilpagePage());
                                    },
                                    child: const Text(
                                      "Zum Guid",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
