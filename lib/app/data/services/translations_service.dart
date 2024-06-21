
import 'package:get/get.dart';
import 'package:ruhrkultur/app/translation/language/ar_AR.dart';
import 'package:ruhrkultur/app/translation/language/de_DE.dart';
import 'package:ruhrkultur/app/translation/language/en_US.dart';
import 'package:ruhrkultur/app/translation/language/fr_FR.dart';
import 'package:ruhrkultur/app/translation/language/ru_RU.dart';
import 'package:ruhrkultur/app/translation/language/tr_TR.dart';
import 'package:ruhrkultur/app/translation/language/uk_UA.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'de_DE': deDE().message,
        'en_US': enUS().message,
        'ru_RU': ruRU().message,
        'tr_TR': trTr().message,
        'uk_UA': ukUA().message,
        'fr_FR': frFr().message,
        'ar_AR': arAR().message,
      };
}
