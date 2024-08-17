library dependency_injection;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:ruhrkultur/src/features/auth/data/models/user_model.dart';

import '../../features/auth/data/implements/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';

class DependencyInjection {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    final appDocDir = await getApplicationDocumentsDirectory();

    await Hive.initFlutter(appDocDir.path);

    Hive.registerAdapter(UserModelAdapter());

    final pb = PocketBase('https://pocket.ruhrkulturerlebnis.de/');

    final hive = Hive;
    Get.put<AuthRepository>(AuthRepositoryImpl(pb, hive: hive));
  }
}
