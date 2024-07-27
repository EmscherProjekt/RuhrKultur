import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruhrkultur/app/bindings/audioguid_binding.dart';
import 'package:ruhrkultur/app/bindings/home_binding.dart';
import 'package:ruhrkultur/app/bindings/setting_view_binding.dart';
import 'package:ruhrkultur/app/routes/app_routes.dart';
import 'package:ruhrkultur/app/ui/pages/audioguid_page/audioguid_page.dart';
import 'package:ruhrkultur/app/ui/pages/home_page/home_page.dart';
import 'package:ruhrkultur/app/ui/pages/setting_view_page/setting_view_page.dart';

class NavpageController extends GetxController {
  var currentIndex = 0.obs;
  late bool isFlagEnabled;
  late bool isloadingAudio;
  RxBool isEnabled = false.obs;
  final pages = [
    AppRoutes.HOME,
    '/audioguid-view',
    AppRoutes.SETTING_VIEW,
  ];

  void changePage(int index) {
    currentIndex.value = index;
    Get.toNamed(pages[index], id: 1);
  }

  Route? onGenerateRoute(RouteSettings settings) {
    if (settings.name == AppRoutes.HOME) {
      return GetPageRoute(
        settings: settings,
        page: () => HomePage(),
        binding: HomeBinding(),
      );
    }
    if (settings.name == '/audioguid-view') {
      return GetPageRoute(
        settings: settings,
        page: () => AudioguidPage(),
        binding: AudioguidBinding(),
      );
    }

    if (settings.name == AppRoutes.SETTING_VIEW) {
      return GetPageRoute(
        settings: settings,
        page: () => SettingViewPage(),
        binding: SettingViewBinding(),
      );
    }
    return null;
  }
}
