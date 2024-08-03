import 'package:permission_handler/permission_handler.dart';

Future<void> requestLocationPermission() async {
  if (await Permission.locationWhenInUse.isDenied) {
    await Permission.locationWhenInUse.request();
  }
}
