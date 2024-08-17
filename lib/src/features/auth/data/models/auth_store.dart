import 'package:hive/hive.dart';

part 'auth_store.g.dart';

@HiveType(typeId: 1)
class AuthStore extends HiveObject {
  @HiveField(0)
  final String data;

  AuthStore({required this.data});

   Future<void> saveinHive(AuthStore authStore) async {
    final box = await Hive.openBox<AuthStore>('authStore');
    await box.put('authStore', authStore);
  }

  static Future<AuthStore?> get() async {
    final box = await Hive.openBox<AuthStore>('authStore');
    return box.get('authStore');
  }

   Future<void> delete() async {
    final box = await Hive.openBox<AuthStore>('authStore');
    await box.delete('authStore');
  }
}
