import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
