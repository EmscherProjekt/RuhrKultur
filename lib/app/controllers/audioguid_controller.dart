import 'package:get/get.dart';
import 'package:ruhrkultur/app/data/models/audioguid/audioguid.dart';
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
    title: "",
    description: "",
    audioGuidAudios: [],
    audioGuidImages: [],
    audioGuidLizenzen: [],
    audioGuidVideos: [],
    audioGuidLocations: [],
  ).obs;

  @override
  void onInit() {
    fetchAudioGuidesSafe();
    super.onInit();
  }

  void fetchAudioGuides() async {
    try {
      isLoading(true);
      var guides = await ApiService.fetchAudioGuides();
      if (guides != null) {
        audioGuides.assignAll(guides);
      }
    } finally {
      isLoading(false);
    }
  }
  void fetchAudioGuidesSafe() async {
    try {
      isLoading(true);
      var guides = await ApiService.fetchAudioGuidesSafe();
      if (guides != null) {
        audioGuides.assignAll(guides);
      }
    } finally {
      isLoading(false);
    }
  }
  void setSelectedGuide(AudioGuide guide) {
    selectedGuide.value = guide;
  }
}
