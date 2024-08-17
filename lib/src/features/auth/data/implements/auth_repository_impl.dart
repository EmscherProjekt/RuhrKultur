import 'package:hive_flutter/hive_flutter.dart';
import 'package:ruhrkultur/src/features/auth/domain/entities/user.dart';
import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final HiveInterface hive;
  final PocketBase pb;

  AuthRepositoryImpl(this.pb, {required this.hive});

  var isAuthenticated = false.obs;

  @override
  Future<User?> login(String email, String password) async {
    try {
      final authResponse = await pb.admins.authWithPassword(email, password);
      isAuthenticated.value = pb.authStore.isValid;

      // Speichere den Benutzer lokal in Hive
      final userModel = UserModel(
        id: authResponse.admin!.id,
        email: authResponse.admin!.email,
        token: authResponse.token,
      );
      final box = await hive.openBox<UserModel>('user');
      await box.put('currentUser', userModel);

      return userModel.toEntity(); // Gebe den Benutzer zurück
    } catch (e) {
      isAuthenticated.value = false;
      print("Login failed: $e");
      return null;
    }
  }

  @override
  Future<void> logout() async {
    final box = await hive.openBox<UserModel>('user');
    await box.delete('currentUser');
    isAuthenticated.value = false;
  }

  @override
  Future<User?> getCurrentUser() async {
    final box = await hive.openBox<UserModel>('user');
    final userModel = box.get('currentUser');
    return userModel?.toEntity();
  }
}
