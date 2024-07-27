import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruhrkultur/app/controllers/navigation_controller.dart';


class NavigationBottomBar extends GetView<NavigationController> {
  NavigationBottomBar({Key? key}) : super(key: key);
  final NavigationController navigationController =
      Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
