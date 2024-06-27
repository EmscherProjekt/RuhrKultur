import 'package:permission_handler/permission_handler.dart';

Future<bool> requestLocationPermission() async {
  if (await Permission.location.isDenied) {
    await Permission.location.request();
  }
}