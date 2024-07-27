import 'package:get/get.dart';
import 'package:ruhrkultur/app/ui/test/pages/qr.dart';
import '../bindings/funktion_aktivert_binding.dart';
import '../ui/pages/funktion_aktivert_page/funktion_aktivert_page.dart';
import 'package:ruhrkultur/app/ui/pages/home_page/home_page.dart';
import '../bindings/navpage_binding.dart';
import '../ui/pages/navpage_page/navpage_page.dart';
import '../bindings/setting_view_binding.dart';
import '../ui/pages/setting_view_page/setting_view_page.dart';
import '../bindings/audioguiddeatilpage_binding.dart';
import '../ui/pages/audioguid_page/widgets/audioguiddeatilpage_page.dart';
import '../bindings/audioguid_binding.dart';
import '../ui/pages/audioguid_page/audioguid_page.dart';
import '../bindings/onboard_view_binding.dart';
import '../ui/pages/onboard_view_page/onboard_view_page.dart';
import '../bindings/splash_view_binding.dart';
import '../ui/pages/splash_view_page/splash_view_page.dart';
import '../bindings/login_view_binding.dart';
import '../ui/pages/login_view_page/login_view_page.dart';
import '../bindings/home_binding.dart';
import '../ui/pages/unknown_route_page/unknown_route_page.dart';
import 'app_routes.dart';

const _defaultTransition = Transition.native;

class AppPages {
  static final unknownRoutePage = GetPage(
    name: AppRoutes.UNKNOWN,
    page: () => const UnknownRoutePage(),
    transition: _defaultTransition,
  );

  static final List<GetPage> pages = [
    unknownRoutePage,
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomePage(),
      binding: HomeBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.LOGIN_VIEW,
      page: () => LoginViewPage(),
      binding: LoginViewBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.SPLASH_VIEW,
      page: () => SplashViewPage(),
      binding: SplashViewBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.ONBOARD_VIEW,
      page: () => OnboardViewPage(),
      binding: OnboardViewBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.AUDIOGUID_VIEW,
      page: () => AudioguidPage(),
      binding: AudioguidBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.AUDIOGUIDDEATILPAGE,
      page: () {
        return AudioGuideDetailPage();
      },
      binding: AudioguiddeatilpageBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.SETTING_VIEW,
      page: () => const SettingViewPage(),
      binding: SettingViewBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.NAVPAGE,
      page: () => const NavpagePage(),
      binding: NavpageBinding(),
      transition: _defaultTransition,
    ),
    GetPage(
      name: AppRoutes.FUNKTION_AKTIVERT,
      page: () => QRViewPage(),
      transition: _defaultTransition,
    ),
  ];
}
