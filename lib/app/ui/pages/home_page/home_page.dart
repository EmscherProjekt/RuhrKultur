import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruhrkultur/app/ui/layouts/main/widgets/navigation_bottom_bar.dart';
import '../../layouts/main/main_layout.dart';

import '../../../controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
      HomePage ({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Hallo"),
    );
  }
}
