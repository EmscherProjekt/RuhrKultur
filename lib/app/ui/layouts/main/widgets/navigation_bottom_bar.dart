import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruhrkultur/app/controllers/navigation_controller.dart';
import 'package:ruhrkultur/app/routes/app_routes.dart';
import 'package:ruhrkultur/app/ui/pages/audioguid_page/audioguid_page.dart';
import 'package:ruhrkultur/app/ui/pages/home_page/home_page.dart';
import 'package:ruhrkultur/app/ui/pages/setting_view_page/setting_view_page.dart';

class NavigationBottomBar extends GetView<NavigationController> {
  NavigationBottomBar({Key? key}) : super(key: key);
  final NavigationController navigationController =
      Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: navigationController,
      builder: (_) => Scaffold(
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (int index) {
              navigationController.changePageIndex(index);
            },
            indicatorColor: Colors.amber,
            selectedIndex: navigationController.currentIndex.value,
            destinations: <Widget>[
              NavigationDestination(
                selectedIcon: const Icon(Icons.home),
                icon: const Icon(Icons.home_outlined),
                label: 'navigation_bar_home'.tr,
              ),
              NavigationDestination(
                selectedIcon: const Icon(Icons.audiotrack),
                icon: const Icon(Icons.audiotrack_outlined),
                label: 'AudioGuid',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.settings),
                icon: const Icon(Icons.settings_outlined),
                label: 'navigation_bar_settings'.tr,
              ),
            ],
          ),
          body: <Widget>[
            // New AudioGuid
           HomePage(),
            AudioguidPage(),
           SettingViewPage(),
          ][navigationController.currentIndex.value]),
    );
  }
}
