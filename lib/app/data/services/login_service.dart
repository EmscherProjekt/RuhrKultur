import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:ruhrkultur/app/config/api_information.dart';
import 'package:ruhrkultur/app/controllers/authentication_controller.dart';
import 'package:ruhrkultur/app/data/models/request/login_request_model.dart';
import 'package:ruhrkultur/app/data/models/response/login_response_model.dart';
import 'package:ruhrkultur/app/data/models/request/register_request_model.dart';
import 'package:ruhrkultur/app/data/models/response/register_respone_model.dart';

class LoginService extends GetConnect {
  final api = ApiInformation();
  final authenticationController = Get.put(AuthenticationController());

  Future<LoginResponseModel?> fetchLogin(LoginRequestModel model) async {
    print("Login Request: ${model.toJson()}");
    final url = api.baseUrl + api.auth + api.login;
    print("Login URL: $url");

    final response = await post(
      url,
      model.toJson(),
      headers: {'Content-Type': 'application/json'},
    );

    print("Login Response Status Code: ${response.statusCode}");
    print("Login Response Body: ${response.body}");

    if (response.statusCode == HttpStatus.ok && response.body != null)
     {
      print(response.body['token']);
      authenticationController.login(response.body['token']);
      authenticationController.checkLoginStatus();
      return LoginResponseModel.fromJson(response.body);
    } else {
      print("Login failed with status: ${response.statusCode}");
      return null;
    }
  }

  Future<RegisterResponseModel?> fetchRegister(RegisterRequestModel model) async {
    print("Register Request: ${model.toJson()}");
    final url = api.baseUrl + api.auth + api.register;
    print("Register URL: $url");

    final response = await post(
      url,
      model.toJson(),
      headers: {'Content-Type': 'application/json'},
    );

    print("Register Response Status Code: ${response.statusCode}");
    print("Register Response Body: ${response.body}");

    if (response.statusCode == HttpStatus.ok && response.body != null) {
      if (response.body is Map<String, dynamic>) {
        return RegisterResponseModel.fromJson(response.body);
      } else {
        return RegisterResponseModel(error: "Invalid response format", message: null);
      }
    } else {
      if (response.body != null && response.body is Map<String, dynamic>) {
        return RegisterResponseModel.fromJson(response.body);
      } else {
        return RegisterResponseModel(error: "Invalid response format", message: null);
      }
    }
  }
}