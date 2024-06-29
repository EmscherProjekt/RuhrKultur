import 'package:get/get.dart';
import 'package:ruhrkultur/app/data/models/response/audioguid_video.dart';
import 'package:ruhrkultur/app/data/services/audio_guid_api_service.dart';
import 'package:video_player/video_player.dart';
class VideoController extends GetxController {
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

  var isPlayingVideo = false.obs;
  VideoPlayerController? videoPlayerController;
//TODO New Video Player with Better Player
  // Fetch audio guides
  void fetchAudioGuidesVideos(int audioId) async {
    try {
      isLoading(true);
      audioGuidsVideos.clear();
      var video = await ApiService.fetchAudioGuidesVideos(audioId);
      
      audioGuidsVideos.assignAll(video);
      audioGuidsVideos.forEach((element) {
        print(element.title);
      });
    } finally {
      isLoading(false);
    }
  }


  void playVideo(String videoUrl) {

    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
      ..initialize().then((_) {
        videoPlayerController?.play();
        isPlayingVideo.value = true;
        videoPlayerController?.addListener(() {
          if (videoPlayerController!.value.position == videoPlayerController!.value.duration) {
            stopVideo();
          }
        });
      });
  }

  void stopVideo() {
    videoPlayerController?.dispose();
    videoPlayerController = null;
    isPlayingVideo.value = false;
  }

  @override
  void onClose() {
    videoPlayerController?.dispose();
    super.onClose();
  }
}
