import 'package:get/get.dart';
import 'package:ruhrkultur/app/data/services/audio_guid_api_service.dart';
import 'package:video_player/video_player.dart';
import 'package:ruhrkultur/app/data/models/response/audioguid_video.dart';

class VideodetailpageController extends GetxController {
  var audioGuidsVideos = <AudioGuideVideo>[].obs;
  var isLoading = true.obs;
  var selectedVideo = AudioGuideVideo(
    id: 1,
    title: "",
    thumbnail: "",
    videoUrl: "",
    viewCount: 0,
    likeCount: 0,
    unlikeCount: 0,
    createdAt: '',
    updatedAt: '',
  ).obs;

  late VideoPlayerController controller;
  var isSwitched = true.obs;
  late Future<void> initializeVideoPlayerFuture;
  late int playBackTime;
  late Duration newCurrentPosition;

  @override
  void onInit() {
    super.onInit();
  }
void addVideo(int audioGuidID){
  ApiService.fetchAudioGuidesVideos(audioGuidID);
}

  void toggleSwitch(bool value) {
    isSwitched.value = value;
  }

  void togglePlayPause() {
    controller.value.isPlaying ? controller.pause() : controller.play();
    update();
  }

  Future<void> startPlay(AudioGuideVideo videoItem) async {
    await controller.pause();
    controller = VideoPlayerController.networkUrl(Uri.parse(
        "https://cdn.pixabay.com/video/2020/04/08/35427-407130886_large.mp4"), videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: true))
      ..addListener(() {
        playBackTime = controller.value.position.inSeconds;
        update();
      })
      ..initialize().then((_) {
        controller.seekTo(newCurrentPosition);
        controller.play();
        update();
      });

    selectedVideo.value = videoItem;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
