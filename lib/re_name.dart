import 'package:get/get.dart';
import 'package:ruhrkultur/src/features/auth/presentation/pages/login_view.dart';

import 'src/core/config/config.dart';
import 'package:flutter/material.dart';
import 'src/core/routes/routes.dart';

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginView(),
    );
  }
}
