import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../data/models/user_model.dart';
import 'package:pocketbase/pocketbase.dart';

class AuthService extends GetxService {
  late final Box<UserModel> _userBox;
  late final PocketBase pb;

  @override
  Future<void> onInit() async {
    super.onInit();
    // Initialize the user box here
    _userBox = Get.find<Box<UserModel>>(tag: 'user');

    // Listen to auth store changes
    pb.authStore.onChange.listen(_handleAuthChange);
  }

  void _handleAuthChange(AuthStoreEvent e) {
    if (e.token != null && e.model != null) {
      _userBox.put('currentUser', UserModel(id: e.model!.id, email: e.model!.email, token: e.token!));
    } else {
      _userBox.delete('currentUser');
    }
  }

  // Additional methods for managing authentication could be added here
}
