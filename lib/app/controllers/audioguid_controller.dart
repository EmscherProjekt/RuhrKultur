import 'package:audio_service/audio_service.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ruhrkultur/app/data/models/response/audioguid.dart';
import 'package:ruhrkultur/app/data/notifiers/play_button_notifier.dart';
import 'package:ruhrkultur/app/data/notifiers/progress_notifier.dart';
import 'package:ruhrkultur/app/data/notifiers/repeat_button_notifier.dart';
import 'package:ruhrkultur/app/data/services/audio_guid_api_service.dart';

class AudioController extends GetxController {
  // Audio guides
  var audioGuides = <AudioGuide>[].obs;
  var isLoading = true.obs;
  var selectedGuide = AudioGuide(
    audioGuidID: 0,
    id: 0,
    audioName: "",
    audioBeschreibung: "",
    imageUrl: "",
    audioUrl: "",
  ).obs;

  // Audio player notifiers
  final currentSongImageUrlNotifier = ValueNotifier<String>('');
  final currentSongTitleNotifier = ValueNotifier<String>('');
  final playlistNotifier = ValueNotifier<List<String>>([]);
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void onInit() {
    fetchAudioGuides();
    init();
    super.onInit();
  }

  // Fetch audio guides
  Future<void> fetchAudioGuides() async {
    try {
      isLoading(true);
      var guides = await ApiService.fetchAudioGuides();
      audioGuides.assignAll(guides);
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchAudioGuidesSafe() async {
    try {
      isLoading(true);
      var guides = await ApiService.fetchAudioGuidesSafe();
      audioGuides.assignAll(guides);
    } finally {
      isLoading(false);
    }
  }

  void setSelectedGuide(AudioGuide guide) {
    if (selectedGuide.value.id == guide.id) {
      return; // Prevent setting the same guide multiple times
    }
    selectedGuide.value = guide;
  }

  // Audio player initialization
  void init() {
    _listenToChangesInPlaylist();
    _listenToPlaybackState();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
    _listenToChangesInSong();
    _audioPlayer.playbackEventStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        AwesomeDialog(
          context: Get.context!,
          animType: AnimType.scale,
          dialogType: DialogType.success,
          title: 'Fertig',
          desc: "Sie haben diesen Audio Guides gehört!",
          btnOkOnPress: () {
            Get.back();
          },
        ).show();
        _audioPlayer.stop();
        remove();
      }
    });
  }

  void _listenToChangesInPlaylist() {
    _audioPlayer.sequenceStateStream.listen((sequenceState) {
      if (sequenceState?.sequence.isEmpty ?? true) {
        playlistNotifier.value = [];
        currentSongTitleNotifier.value = '';
        currentSongImageUrlNotifier.value = '';
      } else {
        final newList = sequenceState!.sequence.map((item) => (item.tag as MediaItem).title).toList();
        playlistNotifier.value = newList;
        final currentSongImageUrl = sequenceState.sequence.isNotEmpty
            ? (sequenceState.sequence.first.tag as MediaItem).artUri.toString()
            : '';
        currentSongImageUrlNotifier.value = currentSongImageUrl;
      }
      _updateSkipButtons();
    });
  }

  void _listenToPlaybackState() {
    _audioPlayer.playingStream.listen((isPlaying) {
      if (_audioPlayer.processingState == ProcessingState.loading ||
          _audioPlayer.processingState == ProcessingState.buffering) {
        playButtonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        playButtonNotifier.value = ButtonState.paused;
      } else if (_audioPlayer.processingState != ProcessingState.completed) {
        playButtonNotifier.value = ButtonState.playing;
      }
    });
  }

  void _listenToCurrentPosition() {
    _audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  void _listenToBufferedPosition() {
    _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });
  }

  void _listenToTotalDuration() {
    _audioPlayer.durationStream.listen((duration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: duration ?? Duration.zero,
      );
    });
  }

  void _listenToChangesInSong() {
    _audioPlayer.currentIndexStream.listen((index) {
      if (index != null) {
        final mediaItem = _audioPlayer.sequence![index].tag as MediaItem;
        currentSongTitleNotifier.value = mediaItem.title;
        _updateSkipButtons();
      }
    });
  }

  void _updateSkipButtons() {
    final playlist = _audioPlayer.sequence;
    final currentIndex = _audioPlayer.currentIndex;
    if (playlist == null || playlist.isEmpty || currentIndex == null) {
      isFirstSongNotifier.value = true;
      isLastSongNotifier.value = true;
    } else {
      isFirstSongNotifier.value = currentIndex == 0;
      isLastSongNotifier.value = currentIndex == playlist.length - 1;
    }
  }

  void play() {
    try {
      _audioPlayer.play();
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  void pause() {
    try {
      _audioPlayer.pause();
    } catch (e) {
      print("Error pausing audio: $e");
    }
  }

  void seek(Duration position) {
    try {
      _audioPlayer.seek(position);
    } catch (e) {
      print("Error seeking audio: $e");
    }
  }

  void previous() {
    try {
      _audioPlayer.seekToPrevious();
    } catch (e) {
      print("Error skipping to previous audio: $e");
    }
  }

  void next() {
    try {
      _audioPlayer.seekToNext();
    } catch (e) {
      print("Error skipping to next audio: $e");
    }
  }

  void repeat() {
    repeatButtonNotifier.nextState();
    final repeatMode = repeatButtonNotifier.value;
    try {
      switch (repeatMode) {
        case RepeatState.off:
          _audioPlayer.setLoopMode(LoopMode.off);
          break;
        case RepeatState.repeatSong:
          _audioPlayer.setLoopMode(LoopMode.one);
          break;
        case RepeatState.repeatPlaylist:
          _audioPlayer.setLoopMode(LoopMode.all);
          break;
      }
    } catch (e) {
      print("Error setting repeat mode: $e");
    }
  }

  void shuffle() {
    final enable = !isShuffleModeEnabledNotifier.value;
    isShuffleModeEnabledNotifier.value = enable;

    try {
      if (enable) {
        _audioPlayer.setShuffleModeEnabled(true);
      } else {
        _audioPlayer.setShuffleModeEnabled(false);
      }
    } catch (e) {
      print("Error setting shuffle mode: $e");
    }
  }

  Future<void> add() async {
    if (_audioPlayer.sequence?.any((item) => item.tag.id == selectedGuide.value.id.toString()) ?? false) {
      print("Guide already in queue");
      return; // Prevent adding the same guide multiple times
    }

    try {
      AudioGuide guide = selectedGuide.value;
      print(guide.audioName);
      print(guide.audioUrl);
      final mediaItem = MediaItem(
        id: guide.id.toString(),
        album: guide.audioBeschreibung,
        title: guide.audioName,
        artUri: Uri.parse(guide.imageUrl),
        extras: {'url': guide.audioUrl},
      );
      remove();
      _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(guide.audioUrl), tag: mediaItem));
    } catch (e) {
      print("Error adding media item: $e");
    }
  }

  Future<void> addTest(String id, String album, String title, String artUri, String audioUrl) async {
    try {
      final mediaItem = MediaItem(
        id: id,
        album: album,
        title: title,
        artUri: Uri.parse(artUri),
        extras: {'url': audioUrl},
      );

      _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(audioUrl), tag: mediaItem));
    } catch (e) {
      print("Error adding test media item: $e");
    }
  }

  void remove() {
    try {
      _audioPlayer.stop();
    } catch (e) {
      print("Error removing media item: $e");
    }
  }

  @override
  void onClose() {
    dispose();
    super.onClose();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void stop() {
    try {
      _audioPlayer.stop();
    } catch (e) {
      print("Error stopping audio: $e");
    }
  }
}
