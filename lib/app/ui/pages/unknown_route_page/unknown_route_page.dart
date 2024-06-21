import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/unknown_route_controller.dart';

class UnknownRoutePage extends GetView<UnknownRouteController> {
  const UnknownRoutePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Audio"),
    );
  }
}
