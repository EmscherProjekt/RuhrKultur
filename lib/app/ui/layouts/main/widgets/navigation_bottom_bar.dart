import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruhrkultur/app/controllers/navigation_controller.dart';
import 'package:ruhrkultur/app/ui/pages/audioguid_page/audioguid_page.dart';
import 'package:ruhrkultur/app/ui/pages/home_page/home_page.dart';
import 'package:ruhrkultur/app/ui/pages/setting_view_page/setting_view_page.dart';

class NavigationBottomBar extends GetView<NavigationController> {
  NavigationBottomBar({Key? key}) : super(key: key);
  final NavigationController navigationController =
      Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
