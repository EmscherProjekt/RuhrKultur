import 'package:audio_service/audio_service.dart';
import 'package:ruhrkultur/app/controllers/audioguid_controller.dart';

import 'audio_handler.dart';

import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // services
  getIt.registerSingleton<AudioHandler>(await initAudioService());

  // page state
  getIt.registerLazySingleton<AudioController>(() => AudioController());
}
