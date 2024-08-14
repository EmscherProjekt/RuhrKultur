import 'package:ruhrkultur/src/features/auth/domain/entities/user.dart';
import 'package:ruhrkultur/src/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<User?> call(String email, String password) {
    return repository.login(email, password);
  }
}

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<void> call() {
    return repository.logout();
  }
}
