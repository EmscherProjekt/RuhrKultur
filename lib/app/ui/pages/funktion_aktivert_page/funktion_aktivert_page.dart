import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../layouts/main/main_layout.dart';

import '../../../controllers/funktion_aktivert_controller.dart';

class FunktionAktivertPage extends GetView<FunktionAktivertController> {
      const FunktionAktivertPage ({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MainLayout(
        child: Text('FunktionAktivert'),
      );
  }
}
