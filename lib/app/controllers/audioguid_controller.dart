import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ruhrkultur/app/data/models/response/audioguid.dart';
import 'package:ruhrkultur/app/data/notifiers/play_button_notifier.dart';
import 'package:ruhrkultur/app/data/notifiers/progress_notifier.dart';
import 'package:ruhrkultur/app/data/notifiers/repeat_button_notifier.dart';
import 'package:ruhrkultur/app/data/services/audio_guid_api_service.dart';
import 'package:ruhrkultur/app/data/services/service_locator.dart';
import 'package:audio_service/audio_service.dart';

class AudioController extends GetxController {
  // Audio guides
  var audioGuides = <AudioGuide>[].obs;
  var isLoading = true.obs;
  var selectedGuide = AudioGuide(
    id: 1,
    audioName: "",
    audioBeschreibung: "",
    imageUrl: "",
    audioUrl: "",
    audioGuidID: 0,
    createdAt: '',
    updatedAt: '',
    latitude: 0,
    longitude: 0,
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

  final _audioHandler = getIt<AudioHandler>();

  @override
  void onInit() {
    fetchAudioGuides();
    init();
    super.onInit();
  }

  // Fetch audio guides
  void fetchAudioGuides() async {
    try {
      isLoading(true);
      audioGuides.clear();
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
      print(audioGuides);
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
  void init() async {
    _listenToChangesInPlaylist();
    _listenToPlaybackState();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
    _listenToChangesInSong();

    _audioHandler.playbackState.listen((state) {
      if (state.processingState == AudioProcessingState.idle ||
          state.processingState == AudioProcessingState.error) {
        print("Error or idle state detected: ${state.errorMessage}");
        // Handle error or idle state
      }
    });
  }

  void _listenToChangesInPlaylist() {
    _audioHandler.queue.listen((playlist) {
      if (playlist.isEmpty) {
        playlistNotifier.value = [];
        currentSongTitleNotifier.value = '';
        currentSongImageUrlNotifier.value = '';
      } else {
        final newList = playlist.map((item) => item.title).toList();
        playlistNotifier.value = newList;
        final currentSongImageUrl =
            playlist.isNotEmpty ? playlist[0].artUri.toString() : '';
        currentSongImageUrlNotifier.value = currentSongImageUrl;
      }
      _updateSkipButtons();
    });
  }

  void _listenToPlaybackState() {
    _audioHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        playButtonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        playButtonNotifier.value = ButtonState.paused;
      } else if (processingState != AudioProcessingState.completed) {
        playButtonNotifier.value = ButtonState.playing;
      } else if (processingState == AudioProcessingState.completed) {
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
        _audioHandler.stop();
        remove();
      }
    });
  }

  void _listenToCurrentPosition() {
    AudioService.position.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  void _listenToBufferedPosition() {
    _audioHandler.playbackState.listen((playbackState) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: playbackState.bufferedPosition,
        total: oldState.total,
      );
    });
  }

  void addMediaItem(String album, String title, bool isFile, String artUri) {
    final mediaItem = MediaItem(
      id: '1',
      album: album,
      title: title,
      artUri: Uri.parse(artUri),
    );
  }

  void _listenToTotalDuration() {
    _audioHandler.mediaItem.listen((mediaItem) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: mediaItem?.duration ?? Duration.zero,
      );
    });
  }

  void _listenToChangesInSong() {
    _audioHandler.mediaItem.listen((mediaItem) {
      currentSongTitleNotifier.value = mediaItem?.title ?? '';
      _updateSkipButtons();
    });
  }

  void _updateSkipButtons() {
    final mediaItem = _audioHandler.mediaItem.value;
    final playlist = _audioHandler.queue.value;
    if (playlist.length < 2 || mediaItem == null) {
      isFirstSongNotifier.value = true;
      isLastSongNotifier.value = true;
    } else {
      isFirstSongNotifier.value = playlist.first == mediaItem;
      isLastSongNotifier.value = playlist.last == mediaItem;
    }
  }

  // Player controls
  void play() => _audioHandler.play();
  void pause() => _audioHandler.pause();
  void seek(Duration position) => _audioHandler.seek(position);
  void previous() => _audioHandler.skipToPrevious();
  void next() => _audioHandler.skipToNext();

  void repeat() {
    repeatButtonNotifier.nextState();
    final repeatMode = repeatButtonNotifier.value;
    switch (repeatMode) {
      case RepeatState.off:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
        break;
      case RepeatState.repeatSong:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
        break;
      case RepeatState.repeatPlaylist:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
        break;
    }
  }

  void shuffle() {
    final enable = !isShuffleModeEnabledNotifier.value;
    isShuffleModeEnabledNotifier.value = enable;
    if (enable) {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
    } else {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
    }
  }

  Future<void> add() async {
    if (_audioHandler.queue.value
        .any((item) => item.id == selectedGuide.value.id.toString())) {
      return; // Prevent adding the same guide multiple times
    }

    AudioGuide guide = selectedGuide.value;
    final mediaItem = MediaItem(
      id: guide.id.toString(),
      album: guide.audioBeschreibung,
      title: guide.audioName,
      artUri: Uri.parse(guide.imageUrl),
      extras: {'url': guide.audioUrl},
    );

    _audioHandler.addQueueItem(mediaItem);
  }

  Future<void> addTest(String id, String album, String title, String artUri,
      String audioUrl) async {
    final mediaItem = MediaItem(
      id: id,
      album: album,
      title: title,
      artUri: Uri.parse(artUri),
      extras: {'url': audioUrl},
    );

    _audioHandler.addQueueItem(mediaItem);
  }

  void remove() {
    final lastIndex = _audioHandler.queue.value.length - 1;
    if (lastIndex < 0) return;
    _audioHandler.removeQueueItemAt(lastIndex);
  }

  @override
  void onClose() {
    _audioHandler.customAction('dispose');
    super.onClose();
  }

  void stop() {
    _audioHandler.stop();
  }
}
