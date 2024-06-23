
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rive/rive.dart';
import 'package:ruhrkultur/app/data/services/service_locator.dart';
import 'app/data/services/dependency_injection.dart';
import 'app/data/services/theme_service.dart';
import 'app/data/services/translations_service.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/ui/layouts/main/main_layout.dart';
import 'app/ui/theme/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DependecyInjection.init();
  await GetStorage.init();
  await RiveFile.initialize();
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

   return ScreenUtilInit(
      builder: (_,__) {
        return GetMaterialApp(
          title: 'Ruhkultur',
          debugShowCheckedModeBanner: false,
          theme: Themes().lightTheme,
          darkTheme: Themes().darkTheme,
          themeMode: ThemeService.instance.themeMode,
          translations: AppTranslations(),
          locale: Get.deviceLocale,
          fallbackLocale: const Locale('en'),
          initialRoute: AppRoutes.SPLASH_VIEW,
          unknownRoute: AppPages.unknownRoutePage,
          getPages: AppPages.pages,
          builder: (_, child) {
            return MainLayout(child: child!);
          },
        );
      },
     //! Must change it to true if you want to use the ScreenUtil
      designSize: const Size(411, 823),
    );
  }
}
