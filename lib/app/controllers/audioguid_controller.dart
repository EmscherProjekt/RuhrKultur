import 'dart:async';
import 'dart:math';
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
    fetchAudioGuidesSafe();
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
      } else {
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

  void play() {
    try {
      _audioHandler.play();
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  void pause() {
    try {
      _audioHandler.pause();
    } catch (e) {
      print("Error pausing audio: $e");
    }
  }

  void seek(Duration position) {
    try {
      _audioHandler.seek(position);
    } catch (e) {
      print("Error seeking audio: $e");
    }
  }

  void previous() {
    try {
      _audioHandler.skipToPrevious();
    } catch (e) {
      print("Error skipping to previous audio: $e");
    }
  }

  void next() {
    try {
      _audioHandler.skipToNext();
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
          _audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
          break;
        case RepeatState.repeatSong:
          _audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
          break;
        case RepeatState.repeatPlaylist:
          _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
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
        _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
      } else {
        _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
      }
    } catch (e) {
      print("Error setting shuffle mode: $e");
    }
  }

  Future<void> add() async {
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

      _audioHandler.addQueueItem(mediaItem);
    } catch (e) {
      print("Error adding media item: $e");
    }
  }

  Future<void> addTest(String id, String album, String title, String artUri,
      String audioUrl) async {
    try {
      final mediaItem = MediaItem(
        id: id,
        album: album,
        title: title,
        artUri: Uri.parse(artUri),
        extras: {'url': audioUrl},
      );

      _audioHandler.addQueueItem(mediaItem);
    } catch (e) {
      print("Error adding test media item: $e");
    }
  }

  void remove() {
    try {
      final lastIndex = _audioHandler.queue.value.length - 1;
      if (lastIndex < 0) return;
      _audioHandler.removeQueueItemAt(lastIndex);
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
    try {
      _audioHandler.customAction('dispose');
    } catch (e) {
      print("Error disposing audio handler: $e");
    }
    super.dispose();
  }

  void stop() {
    try {
      _audioHandler.stop();
    } catch (e) {
      print("Error stopping audio: $e");
    }
  }
}
