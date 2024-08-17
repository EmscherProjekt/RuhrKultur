import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:ruhrkultur/app/controllers/audioguid_controller.dart';
import 'package:ruhrkultur/app/ui/pages/audioguid_page/widgets/audioguid_card.dart';
import 'package:ruhrkultur/app/ui/test/pages/music.dart';

class AudioguidPage extends GetView<AudioController> {
  AudioguidPage({Key? key}) : super(key: key);

  final _flashOnController = TextEditingController(text: 'Flash on');
  final _flashOffController = TextEditingController(text: 'Flash off');
  final _cancelController = TextEditingController(text: 'Cancel');

  final double _aspectTolerance = 0.00;

  final bool _useAutoFocus = true;
  final bool _autoEnableFlash = false;

  void onInit() {}

  /*Future<void> _loadData() async {
    print("loadData");
    await Get.find<AudioController>().fetchAudioGuides();
   
  }

  Future<void> _loadDataSafe() async {
    await Get.find<AudioController>().fetchAudioGuidesSafe();
  }
*/
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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("audio_page_title".tr),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () => Get.find<AudioController>().fetchAudioGuides(),
            ),
            IconButton(
              icon: const Icon(Icons.camera),
              tooltip: 'audio_page_tooltip_scan'.tr,
              onPressed: _scan,
            ),
          ],
        ),
        body: Container(
            child: Scaffold(
          body: SingleChildScrollView(
            child: Center(
              child: RefreshIndicator(
                onRefresh: () async {
                  _showError("Refreshed");
                  return Future.value();
                },
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else if (controller.audioGuides.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("audio_page_no_data_found".tr,
                              style: TextStyle(fontSize: 20)),
                          TextButton(
                            onPressed:
                                Get.find<AudioController>().fetchAudioGuides,
                            child: Text("audio_page_no_data_found_info".tr,
                                style: TextStyle(fontSize: 20)),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView.builder(
                        itemCount: controller.audioGuides.length,
                        itemBuilder: (context, index) {
                          final audioGuide = controller.audioGuides[index];
                          return GestureDetector(
                            onTap: () {
                              print(audioGuide);
                            },
                            child: AudioguidCard(
                              audioGuide: audioGuide,
                            ),
                          );
                        },
                      ),
                    );
                  }
                }),
              ),
            ),
          ),
        )),
      ),
    );
  }

  Future<void> _scan() async {
    try {
      final ScanResult result = await BarcodeScanner.scan(
        options: ScanOptions(
          strings: {
            'cancel': _cancelController.text,
            'flash_on': _flashOnController.text,
            'flash_off': _flashOffController.text,
          },
          autoEnableFlash: _autoEnableFlash,
          android: AndroidOptions(
            useAutoFocus: _useAutoFocus,
            aspectTolerance: _aspectTolerance,
          ),
        ),
      );

      if (result.type == ResultType.Barcode) {
        _handleQRCode(result.rawContent);
      } else if (result.type == ResultType.Error) {
        _showError(result.rawContent);
      }
    } on PlatformException catch (e) {
      _showError(e.code == BarcodeScanner.cameraAccessDenied
          ? 'The user did not grant the camera permission!'
          : 'Unknown error: $e');
    }
  }

  void _handleQRCode(String code) {
    if (code.isNotEmpty) {
      Get.to(() => MusicPlayerPage(musicId: code));
    } else {
      _showError("No QR code data found.");
    }
  }

  void _showError(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
