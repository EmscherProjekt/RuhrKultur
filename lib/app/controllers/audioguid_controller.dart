import 'package:get/get.dart';
import 'package:ruhrkultur/app/data/models/response/audioguid.dart';
import 'package:ruhrkultur/app/data/services/audio_guid_api_service.dart';

class AudioGuideController extends GetxController {
  var audioGuides = <AudioGuide>[].obs;
  var isLoading = true.obs;
  var selectedGuide = AudioGuide(
    id: 1,
    audioName: "",
    audioBeschreibung: "",
    imageUrl: "",
    audioUrl: "",
  ).obs;

  @override
  void onInit() {
    fetchAudioGuidesSafe();
    super.onInit();
  }

  void setlevel() {
    ApiService.setLevel(1);
  }

  void fetchAudioGuides() async {
    try {
      isLoading(true);
      var guides = await ApiService.fetchAudioGuides();
      audioGuides.assignAll(guides);
    } finally {
      isLoading(false);
    }
  }

  void fetchAudioGuidesSafe() async {
    try {
      isLoading(true);
      var guides = await ApiService.fetchAudioGuidesSafe();
      audioGuides.assignAll(guides);
    } finally {
      isLoading(false);
    }
  }

  void setSelectedGuide(AudioGuide guide) {
    selectedGuide.value = guide;
  }
}
