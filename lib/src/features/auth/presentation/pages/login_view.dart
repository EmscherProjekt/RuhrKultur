import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ruhrkultur/src/features/auth/presentation/getX/auth_controller.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';

class LoginView extends StatelessWidget {
  final AuthController controller = Get.put(AuthController(
    loginUseCase: LoginUseCase(Get.find<AuthRepository>()),
    logoutUseCase: LogoutUseCase(Get.find<AuthRepository>()),
    authRepository: Get.find<AuthRepository>(),
  ));

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller.login(
                  emailController.text,
                  passwordController.text,
                );
              },
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller.logout();
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
