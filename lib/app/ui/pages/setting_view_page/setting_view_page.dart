import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:about/about.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:in_app_update/in_app_update.dart';

class SettingViewPage extends StatefulWidget {
  const SettingViewPage({super.key});

  @override
  State<SettingViewPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingViewPage> {
  late String appName;
  late String packageName;
  late String version;
  late String buildNumber;

  AppUpdateInfo? _updateInfo;
  bool _flexibleUpdateAvailable = false;
  @override
  void initState() {
    super.initState();
    InAppUpdate.installUpdateListener;
    initPackageInfo();
    // Initialize your variables here
  }

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
        print(info.toString());
      });
    }).catchError((e) {
      showSnack(e.toString());
    });
  }

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }

  Future<void> initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    appName = info.appName;
    packageName = info.packageName;
    version = info.version;
    buildNumber = info.buildNumber;
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('settings_pacht_notes_modal_titel'.tr),
          content: Material(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Update Info",
                  style: TextStyle(fontSize: 20),
                ),
                Gap(5),
                Text(_updateInfo.toString(), style: TextStyle(fontSize: 15)),
                Gap(10),
                Text("Demnächst", style: TextStyle(fontSize: 20)),
                Gap(5),
                Text(
                    "Einstellungs möglichkeit ob Bugs Automatich gemeldet werden",
                    style: TextStyle(fontSize: 15)),
                Gap(10),
                Text("Neu", style: TextStyle(fontSize: 20)),
                Gap(5),
                Text("App Reportet jetzt Ganz Anyome Fehler an uns.",
                    style: TextStyle(fontSize: 15)),
                // Add more languages here
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLanguageSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('settings_language_modal_titel'.tr),
          content: Material(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text('settings_language_deDE'.tr),
                  onTap: () {
                    setState(() {
                      Get.updateLocale(const Locale('de', 'DE'));
                    });
                    Get.back();
                  },
                ),
                ListTile(
                  title: Text('settings_language_enUS'.tr),
                  onTap: () {
                    setState(() {
                      Get.updateLocale(const Locale('en', 'US'));
                    });
                    Get.back();
                  },
                ),
                ListTile(
                  title: Text('settings_language_ruRU'.tr),
                  onTap: () {
                    setState(() {
                      Get.updateLocale(const Locale('ru', 'RU'));
                    });
                    Get.back();
                  },
                ),
                ListTile(
                  title: Text('settings_language_trTR'.tr),
                  onTap: () {
                    setState(() {
                      Get.updateLocale(const Locale('tr', 'TR'));
                    });
                    Get.back();
                  },
                ),
                ListTile(
                  title: Text('settings_language_ukUA'.tr),
                  onTap: () {
                    ;
                    setState(() {
                      Get.updateLocale(const Locale('uk', 'UA'));
                    });
                    Get.back();
                  },
                ),
                ListTile(
                  title: Text('settings_language_frFR'.tr),
                  onTap: () {
                    setState(() {
                      Get.updateLocale(const Locale('fr', 'FR'));
                    });
                    Get.back();
                  },
                ),
                ListTile(
                  title: Text('settings_language_arAR'.tr),
                  onTap: () {
                    setState(() {
                      Get.updateLocale(const Locale('ar', 'AR'));
                    });
                    Get.back();
                  },
                ),
                // Add more languages here
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildSettingsPage(context),
    );
  }

  Widget _buildSettingsPage(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          _SingleSection(
            title: 'settings_genral'.tr,
            children: [
              _CustomListTile(
                  title: "App info",
                  icon: CupertinoIcons.device_phone_portrait,
                  onTap: () {
                    showAboutPage(
                      context: context,
                      values: {
                        'version': version,
                        'year': DateTime.now().year.toString(),
                      },
                      applicationName: appName,
                      applicationVersion: version,
                      applicationLegalese:
                          'Copyright © Rodrigo Helwig, {{ year }}',
                      applicationDescription:
                          Text('settings_about_page__description'.tr),
                      children: const <Widget>[
                        LicensesPageListTile(
                          icon: Icon(Icons.favorite),
                        ),
                      ],
                      applicationIcon: const SizedBox(
                        width: 100,
                        height: 100,
                        child: Image(
                          image: AssetImage('assets/image/logo.png'),
                        ),
                      ),
                    );
                  }),
              _CustomListTile(
                title: 'settings_language'.tr,
                icon: Icons.language,
                onTap: () {
                  _showLanguageSelectionDialog();
                },
              ),
              _CustomListTile(
                title: 'settings_pacht_notes'.tr,
                icon: Icons.new_releases,
                onTap: () {
                  _showUpdateDialog();
                },
              ),
              _CustomListTile(
                title: "Auf Update prüfen",
                icon: Icons.new_releases,
                onTap: () {
                  checkForUpdate();
                },
              ),
              /*    _CustomListTile(
                  title: 'Log out',
                  icon: Icons.logout,
                  onTap: () {
                    AuthenticationController().logOut();
                    Get.offNamed(AppRoutes.SPLASH_VIEW);
                  }),
                  */
            ],
          ),
        ],
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final Widget? widget;
  final Function()? onTap;

  const _CustomListTile(
      {Key? key,
      required this.title,
      required this.icon,
      this.onTap, this.trailing, this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      onTap: onTap,
      trailing: trailing ?? const Icon(CupertinoIcons.forward, size: 18),
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SingleSection({
    Key? key,
    required this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title.toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .headlineLarge!
                .copyWith(fontSize: 12),
          ),
        ),
        Container(
          width: double.infinity,
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}
