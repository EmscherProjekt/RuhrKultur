import 'package:get/get.dart';
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
    _initializeController();
  }

  void _initializeController() {
    controller = VideoPlayerController.asset(selectedVideo.value.videoUrl)
      ..initialize().then((_) {
        controller.play();
        update();
      });
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
    controller = VideoPlayerController.asset(videoItem.videoUrl)
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
