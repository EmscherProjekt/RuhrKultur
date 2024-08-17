import 'package:get/get.dart';
import 'package:ruhrkultur/src/features/auth/domain/usecases/login_usecase.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final AuthRepository authRepository;

  final Rxn<User> currentUser = Rxn<User>();

  AuthController({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.authRepository,
  });

  Future<void> login(String email, String password) async {
    final user = await loginUseCase(email, password);
    if (user != null) {
      currentUser.value = user;
      Get.snackbar('Success', 'Login successful');
    } else {
      Get.snackbar('Error', 'Invalid credentials');
    }
  }

  Future<void> logout() async {
    await logoutUseCase();
    currentUser.value = null;
    Get.snackbar('Success', 'Logged out successfully');
  }

  @override
  void onInit() {
    super.onInit();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    final user = await authRepository.getCurrentUser();
    if (user != null) {
      currentUser.value = user;
    }
  }
}
