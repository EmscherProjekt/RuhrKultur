import 'package:get_storage/get_storage.dart';
import 'package:ruhrkultur/app/data/emu/cache_manager_key.dart';

mixin CacheController {

  Future<bool> saveFirstOpen(bool? firstOpen) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.FIRST_OPEN.toString(), firstOpen);
    return true;
  }

  Future<bool> getFirstOpen() async {
    final box = GetStorage();
    return box.read(CacheManagerKey.FIRST_OPEN.toString()) ?? true;
  }
  
  Future<bool> saveToken(String? token) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.TOKEN.toString(), token);
    return true;
  }

  String? getToken() {
    final box = GetStorage();
    return box.read(CacheManagerKey.TOKEN.toString());
  }

  Future<void> removeToken() async {
    final box = GetStorage();
    await box.remove(CacheManagerKey.TOKEN.toString());
  }
}


